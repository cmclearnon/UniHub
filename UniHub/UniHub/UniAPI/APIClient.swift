//
//  APIClient.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import Foundation
import Combine

struct UniListResponse: Codable {
    let webPages: [String]
    let name: String?
    let alphaTwoCode: String?
    let stateProvince: String?
    let domains: [String]?
    let country: String?
}

protocol APICallable {
    func listAllUniversities() -> AnyPublisher<[UniListResponse], APIError>
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
    func listAllUniversities() -> AnyPublisher<[UniListResponse], APIError> {
        return fetch(with: getAllUniversitiesURL())
    }
    
    private func fetch<T: Decodable>(with endpoint: URL?) -> AnyPublisher<T, APIError> {
        
        /// Try to safely cast the passed in URL
        /// If fails: Return a network error as a Fail type, then erase its type to AnyPublisher
        guard let url = endpoint else {
            let error = APIError.network(description: "Badly formatted URL: \(String(describing: endpoint)) is an invalid URL.")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        /// URLSession.dataTaskPublisher for fetching Dog API data
        /// Returns either tuple (Data, URLResponse) or URLError
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            /// Cast error as APIError
            .mapError { error -> APIError in
                return .network(description: "Network error. Please check your internet connection and try again.")
            }.flatMap(maxPublishers: .max(1)) { result in
                decode(result.data)
            }
        
            /// Use eraseToAnyPublisher to erase the return type to AnyPublisher
            /// to prevent leak of implementation details
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

private extension APIClient {
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
