//
//  UniversityModelTests.swift
//  UniHubTests
//
//  Created by Chris McLearnon on 12/10/2020.
//

import XCTest
@testable import UniHub

class UniversityModelCodableTests: XCTestCase {
    
    var testData: ModelTestData!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testData = ModelTestData()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testData = nil
    }
    
    func testCorrectJSONDecodingIntoModel() throws {
        let decodedModel = try JSONDecoder().decode(University.self, from: testData.fixtureCorrectAttributesType)
        XCTAssertEqual(testData.expectedModelInstance, decodedModel)
    }
    
    func testIncorrectAttributeKeyDecoding() throws {
        let decodedData = try JSONDecoder().decode(University.self, from: testData.fixtureIncorrectAttributeKeyType)
        XCTAssertNotEqual(testData.expectedModelInstance.stateProvince, decodedData.stateProvince)
        XCTAssertNotEqual(testData.expectedModelInstance, decodedData)
    }
    
    func testMissingAttributeKeyDecoding() throws {
        let missingKey = "country"
        AssertThrowsKeyNotFound(missingKey: missingKey, decodingType: University.self, from: testData.fixtureMissingAttributeKey)
    }
    
    func testModelEncoding() throws {
        XCTAssertNoThrow(try JSONEncoder().encode(testData.expectedModelInstance))
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
