//
//  APIClient.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import Foundation
import Combine

protocol APICallable {
    func listAllUniversities(with url: URL?) -> AnyPublisher<[University], Error>
}

class APIClient {
    private static let _sharedInstance = APIClient()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    class func sharedInstance() -> APIClient {
        return _sharedInstance
    }
}

extension APIClient: APICallable {
    func listAllUniversities(with url: URL?) -> AnyPublisher<[University], Error> {
        return fetchData(with: url)
    }
    
    private func fetch(with endpoint: URL?) -> AnyPublisher<Data, Error> {
        print("Fetching from API...")
        /// Try to safely cast the passed in URL
        /// If fails: Return a network error as a Fail type, then erase its type to AnyPublisher
        guard let url = endpoint else {
            let error = APIError.network(description: "Badly formatted URL: \(String(describing: endpoint)) is an invalid URL.")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        /// URLSession.dataTaskPublisher for fetching Dog API data
        /// Returns either tuple (Data, URLResponse) or URLError
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) == false {
                    throw APIError.statusCode(response as! HTTPURLResponse)
                }
                return data
            }
            /// Cast error as APIError
            .mapError { error -> APIError in
                return .network(description: "Network error: \(error.localizedDescription)")
            }

            /// Use eraseToAnyPublisher to erase the return type to AnyPublisher
            /// to prevent leak of implementation details
            .eraseToAnyPublisher()
    }
    
    private func fetchData<T: Decodable>(with url: URL?) -> AnyPublisher<T, Error> {
        fetch(with: url)
            .print("Attempting to decode...")
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                return .parsing(description: "Parsing error: \(error.localizedDescription)")
            }
            .eraseToAnyPublisher()
    }
}

extension APIClient {
    private struct Domains {
        static let baseURL = "https://raw.githubusercontent.com/Hipo/university-domains-list/master/world_universities_and_domains.json"
    }
    
    func getAllUniversitiesURL() -> URL? {
        guard let fullURL = URL(string: Domains.baseURL) else {
            let failureURL = URL(string: "")
            return failureURL
        }
        return fullURL
    }
}
