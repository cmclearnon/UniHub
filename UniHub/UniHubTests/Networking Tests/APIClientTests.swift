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
    
    var mocks: MockData!
    
    override func setUpWithError() throws {
        self.mocks = MockData()
    }

    override func tearDownWithError() throws {
        self.mocks = nil
    }
    
    func testValidateResponse() {
        let data200Response = try? UniHub.validateResponse(Data(), self.mocks.validResponse200!)
        XCTAssertNotNil(data200Response)
        
        let data299Response = try? UniHub.validateResponse(Data(), self.mocks.validResponse299!)
        XCTAssertNotNil(data299Response)
        
        XCTAssertThrowsError(try UniHub.validateResponse(Data(), self.mocks.invalidResponse300!))
        XCTAssertThrowsError(try UniHub.validateResponse(Data(), self.mocks.invalidResponse300!))
        XCTAssertThrowsError(try UniHub.validateResponse(Data(), self.mocks.invalidResponse404!))
    }
}

class MockData {
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
