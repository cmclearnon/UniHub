//
//  NetworkingParser.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import Foundation
import Combine

/// Generic JSON Decoding function for parsing JSON into any custom Codable Type
func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, APIError> {
    let decoder = JSONDecoder()
    
    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
}
