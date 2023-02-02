//
//  AppTestData.swift
//  UniHubTests
//
//  Created by Chris McLearnon on 14/10/2020.
//

import Foundation

class APIClientTestData {
    static let validResponse200 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                        statusCode: 200,
                                        httpVersion: nil,
                                        headerFields: [
                                            "Content-Type": "application/json",
                                            "cache-control": "no-cache",
                                        ])
    
    static let validResponse299 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 299,
                                             httpVersion: nil,
                                             headerFields: nil)
    
    static let invalidResponse300 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 300,
                                             httpVersion: nil,
                                             headerFields: nil)
    
    static let invalidResponse404 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 404,
                                             httpVersion: nil,
                                             headerFields: nil)
    
    static let expectedJSONResponse = """
    [
        {
            "web_pages": [
              "http://www.marywood.edu"
            ],
            "name": "Marywood University",
            "alpha_two_code": "US",
            "state-province": "Province",
            "domains": [
              "marywood.edu"
            ],
            "country": "United States"
        }
    ]
    """
    
    static let expectedUniversityObject = University(
        webPages: ["http://www.marywood.edu"],
        name: "Marywood University",
        alphaTwoCode: "US",
        stateProvince: "Province",
        domains: ["marywood.edu"],
        country: "United States"
    )
    
    /// Does not contain closing Array bracket
    static let invalidDataJSONResponse = """
    [
        {
            "web_pages": [
              "http://www.marywood.edu"
            ],
            "name": "Marywood University",
            "alpha_two_code": "US",
            "state-province": "Province",
            "domains": [
              "marywood.edu"
            ],
            "country": "United States"
        }

    """
}

class ModelTestData {
    let expectedModelInstance = University(
        webPages: ["http://www.marywood.edu"],
        name: "Marywood University",
        alphaTwoCode: "US",
        stateProvince: "Province",
        domains: ["marywood.edu"],
        country: "United States"
    )

    let validAttributeKeys = Data("""
    {
            "web_pages": [
              "http://www.marywood.edu"
            ],
            "name": "Marywood University",
            "alpha_two_code": "US",
            "state-province": "Province",
            "domains": [
              "marywood.edu"
            ],
            "country": "United States"
    }
    """.utf8)

    let invalidAttributeKeys = Data("""
    {
        "web_pages": [
          "http://www.marywood.edu"
        ],
        "name": "Marywood University",
        "alpha_two_code": "US",
        "state_province": "Province",
        "domains": [
          "marywood.edu"
        ],
        "country": "United States"
    }
    """.utf8)

    let missingAttributeKeys = Data("""
    {
        "web_pages": [
          "http://www.marywood.edu"
        ],
        "name": "Marywood University",
        "alpha_two_code": "US",
        "state_province": "Province",
        "domains": [
          "marywood.edu"
        ]
    }
    """.utf8)
}
