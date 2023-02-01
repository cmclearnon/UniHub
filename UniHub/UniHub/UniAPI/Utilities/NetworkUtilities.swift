//
//  NetworkUtilities.swift
//  UniHub
//
//  Created by Chris McLearnon on 12/10/2020.
//

import Foundation
import Combine

/// Network Utility function for validating HTTP responses from requests
func validateResponse(_ data: Data, _ response: URLResponse) throws -> Data {
    guard let httpResponse = response as? HTTPURLResponse else {
        print("Response error")
        throw APIError.invalidResponse(description: "Invalid response from server")
    }
    
    guard (200..<300).contains(httpResponse.statusCode) else {
        print("Status code error")
        throw APIError.statusCode(httpResponse)
    }
    
    return data
}

func validateResponseV3(_ response: URLResponse?) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
        print("Response error")
        throw APIError.invalidResponse(description: "Invalid response from server")
    }
    
    guard (200..<300).contains(httpResponse.statusCode) else {
        print("Status code error")
        throw APIError.statusCode(httpResponse)
    }
}
