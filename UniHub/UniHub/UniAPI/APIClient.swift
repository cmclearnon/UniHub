//
//  APIClient.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import Foundation
import Combine

protocol APICallable {
    func listAllUniversities() -> AnyPublisher<[University], Error>
}

protocol APIDataTaskPublisher {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

class APISessionDataPublisher: APIDataTaskPublisher {
    
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        return session.dataTaskPublisher(for: request)
    }
    
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

class APIClient: APICallable {
    private static let _sharedInstance = APIClient()
    var publisher: APIDataTaskPublisher = APISessionDataPublisher()
    
    var timeoutInterval: TimeInterval = 10.0
    
    let defaultHeaders = [
        "Content-Type": "application/json",
        "cache-control": "no-cache",
    ]
    
    class func sharedInstance() -> APIClient {
        return _sharedInstance
    }
    
    private func buildGetRequest(withURL urlString: String) -> URLRequest {
        guard let url = URL(string: Domains.baseURL) else {
            fatalError("Invalid API endpoint")
        }
        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }
    
    func getUniversitiesDataTaskPublisher() -> URLSession.DataTaskPublisher {
        let request = buildGetRequest(withURL: Domains.baseURL)
        return publisher.dataTaskPublisher(for: request)
    }
//    
//    func getTestUniversitiesDataTaskPublisher() -> URLSession.DataTaskPublisher {
//        let request = buildGetRequest(withURL: Domains.testURL)
//        return publisher.dataTaskPublisher(for: request)
//    }
    
    func listAllUniversities() -> AnyPublisher<[University], Error> {
        return getRequest(withPublisher: getUniversitiesDataTaskPublisher())
    }
    
//    func listAllUniversitiesTest() -> AnyPublisher<[University], Error> {
//        return getRequest(withPublisher: getTestUniversitiesDataTaskPublisher())
//    }
    
    func getRequest<T: Decodable>(withPublisher publisher: URLSession.DataTaskPublisher) -> AnyPublisher<T, Error> {
        
        return publisher
            .tryMap { data, response in
                try validateResponse(data, response)
            }
            /// Cast error as APIError
            .mapError { error -> APIError in
                print("Network error: \(error.localizedDescription)")
                return .network(description: "Network error: \(error.localizedDescription)")
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                print("Parsing error: \(error.localizedDescription)")
                return .parsing(description: "Parsing error: \(error.localizedDescription)")
            }

            /// Use eraseToAnyPublisher to erase the return type to AnyPublisher
            /// to prevent leak of implementation details
            .eraseToAnyPublisher()
    }
}

extension APIClient {
    private struct Domains {
        static let baseURL = "https://raw.githubusercontent.com/Hipo/university-domains-list/master/world_universities_and_domains.json"
        static let testURL = "http://localhost:8080"
    }
    
    func getAllUniversitiesURL() -> URL {
        guard let fullURL = URL(string: Domains.baseURL) else {
            let failureURL = URL(string: "")
            return failureURL!
        }
        return fullURL
    }
    
    func getTestURL() -> URL {
        guard let fullURL = URL(string: Domains.testURL) else {
            let failureURL = URL(string: "")
            return failureURL!
        }
        return fullURL
    }
}
