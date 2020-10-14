//
//  AppTestData.swift
//  UniHubTests
//
//  Created by Chris McLearnon on 14/10/2020.
//

import Foundation

class APIClientTestData {
    let validResponse200 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                        statusCode: 200,
                                        httpVersion: nil,
                                        headerFields: nil)
    
    let validResponse299 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 299,
                                             httpVersion: nil,
                                             headerFields: nil)
    
    let invalidResponse300 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 300,
                                             httpVersion: nil,
                                             headerFields: nil)
    
    let invalidResponse404 = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                             statusCode: 404,
                                             httpVersion: nil,
                                             headerFields: nil)
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

    let fixtureCorrectAttributesType = Data("""
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

    let fixtureIncorrectAttributeKeyType = Data("""
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

    let fixtureMissingAttributeKey = Data("""
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
