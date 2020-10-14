//
//  APIClientTests.swift
//  UniHubTests
//
//  Created by Chris McLearnon on 12/10/2020.
//

import XCTest
import Combine
@testable import UniHub

class APIClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class APINetworkUtilitiesTests: XCTestCase {
    
    var testData: APIClientTestData!
    
    override func setUpWithError() throws {
        self.testData = APIClientTestData()
    }

    override func tearDownWithError() throws {
        self.testData = nil
    }
    
    func testValidateResponse() {
        let data200Response = try? UniHub.validateResponse(Data(), self.testData.validResponse200!)
        XCTAssertNotNil(data200Response)
        
        let data299Response = try? UniHub.validateResponse(Data(), self.testData.validResponse299!)
        XCTAssertNotNil(data299Response)
        
        XCTAssertThrowsError(try UniHub.validateResponse(Data(), self.testData.invalidResponse300!))
        XCTAssertThrowsError(try UniHub.validateResponse(Data(), self.testData.invalidResponse404!))
    }
}
