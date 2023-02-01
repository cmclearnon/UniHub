//
//  APIClientV2.swift
//  UniHub
//
//  Created by Chris McLearnon on 30/01/2023.
//

import Foundation
import Combine

class APIClient {
    private static let _sharedInstance = APIClient()

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
    
    func fetchUniversities(completionHandler: @escaping (Result<[University], Error>) -> Void) {
        let request = buildGetRequest(withURL: Domains.baseURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error {
                completionHandler(.failure(APIError.network(description: "Test network error: \(error)")))
            }
            
            // Validate response

            if let data, let universityList = try? JSONDecoder().decode([University].self, from: data) {
                completionHandler(.success(universityList))
            } else {
                completionHandler(.failure(APIError.parsing(description: "Test parsing error")))
            }
        })
        
        task.resume()
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
