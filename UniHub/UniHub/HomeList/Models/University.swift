//
//  University.swift
//  UniHub
//
//  Created by Chris McLearnon on 12/10/2020.
//

import Foundation

struct University: Codable {
    let webPages: [String]
    let name: String?
    let alphaTwoCode: String
    let stateProvince: String?
    let domains: [String]
    let country: String
}

/// Codable Extension for decoding JSON keys into Swift properties
/// JSON snake-case does not match Swift naming conventions
extension University {
    enum CodingKeys: String, CodingKey {
        case webPages = "web_pages"
        case name = "name"
        case alphaTwoCode = "alpha_two_code"
        case stateProvince = "state-province"
        case domains = "domains"
        case country = "country"
    }
}

extension University: Equatable {
    
}
