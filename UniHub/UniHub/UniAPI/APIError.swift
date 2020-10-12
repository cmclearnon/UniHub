//
//  APIError.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import Foundation

enum APIError: Error {
    case parsing(description: String)
    case network(description: String)
    case invalidResponse(description: String)
    case statusCode(HTTPURLResponse)
}
