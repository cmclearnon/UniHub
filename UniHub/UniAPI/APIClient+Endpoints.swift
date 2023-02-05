//
//  APIEndpoints.swift
//  UniHub
//
//  Created by Chris McLearnon on 02/02/2023.
//

import Foundation

extension APIClient {
    struct Domains {
        static let baseURL = "https://raw.githubusercontent.com/Hipo/university-domains-list/master/world_universities_and_domains.json"
        static let testURL = "http://localhost:8080"
    }
    
    static func getAllUniversitiesURL() -> URL {
        guard let fullURL = URL(string: Domains.baseURL) else {
            let failureURL = URL(string: "")
            return failureURL!
        }
        return fullURL
    }
    
    static func getTestURL() -> URL {
        guard let fullURL = URL(string: Domains.testURL) else {
            let failureURL = URL(string: "")
            return failureURL!
        }
        return fullURL
    }
}
