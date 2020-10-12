//
//  UniversityModelTests.swift
//  UniHubTests
//
//  Created by Chris McLearnon on 12/10/2020.
//

import XCTest
@testable import UniHub

class UniversityModelCodableTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCorrectJSONDecodingIntoModel() throws {
        let decodedModel = try JSONDecoder().decode(University.self, from: fixtureCorrectAttributesType)
        XCTAssertEqual(expectedModelInstance, decodedModel)
    }
    
    func testIncorrectAttributeKeyDecoding() throws {
        let decodedData = try JSONDecoder().decode(University.self, from: fixtureIncorrectAttributeKeyType)
        XCTAssertNotEqual(expectedModelInstance.stateProvince, decodedData.stateProvince)
        XCTAssertNotEqual(expectedModelInstance, decodedData)
    }
    
    func testMissingAttributeKeyDecoding() throws {
        let missingKey = "country"
        AssertThrowsKeyNotFound(missingKey: missingKey, decodingType: University.self, from: fixtureMissingAttributeKey)
    }
    
    func testModelEncoding() throws {
        XCTAssertNoThrow(try JSONEncoder().encode(expectedModelInstance))
    }
}

extension UniversityModelCodableTests {
    func AssertThrowsKeyNotFound<T: Decodable>(missingKey: String, decodingType: T.Type, from data: Data) {
        XCTAssertThrowsError(try JSONDecoder().decode(T.self, from: data)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(missingKey, key.stringValue)
            } else {
                XCTFail("Test expected: '.keyNotFound' but got \(error)")
            }
        }
    }
}

private let expectedModelInstance = University(
    webPages: ["http://www.marywood.edu"],
    name: "Marywood University",
    alphaTwoCode: "US",
    stateProvince: "Province",
    domains: ["marywood.edu"],
    country: "United States"
)

private let fixtureCorrectAttributesType = Data("""
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

private let fixtureIncorrectAttributeKeyType = Data("""
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

private let fixtureMissingAttributeKey = Data("""
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
