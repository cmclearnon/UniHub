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

    var testData: APIClientTestData!
    var testClient: APIClient!
    let testTimeout: TimeInterval = 10

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.testData = APIClientTestData()

        /// Setting up a mock URLProtocolMock
        URLProtocol.registerClass(URLProtocolMock.self)

        let config = URLSessionConfiguration.default
        config.protocolClasses?.insert(URLProtocolMock.self, at: 0)

        /// Create URLSession instance from URLProtocolMock & inject into APISessionDataPublisher instance
        let session = URLSession(configuration: config)

        testClient = APIClient()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.testData = nil

        /// Reset the URLProtocolMock properties
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
    }

    func test_APIClient_BaseURLConfiguration() throws {
        XCTAssertEqual(APIClient.getTestURL(), URL(string: "http://localhost:8080"))
    }

    func test_ValidResponseAndDataGetRequest() throws {
        let expectation = XCTestExpectation(description: "Valid data was received")
        let data = APIClientTestData.expectedJSONResponse.data(using: .utf8)

        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == APIClient.getAllUniversitiesURL() else {
                throw APIError.network(description: "Invalid URL")
          }

            let response = APIClientTestData.validResponse200!
            return (response, data)
        }

        testClient.fetchUniversities(completionHandler: { res in
            switch res {
            case let .success(testUniversities):
                XCTAssertFalse(testUniversities.isEmpty)
                expectation.fulfill()
            case let .failure(error):
                XCTFail("Test failed due to: \(error)")
            }
        })

        wait(for: [expectation], timeout: testTimeout)
    }

    func test_InvalidResponseStatusCode300_ValidData_throwsAPIError() throws {
        let expectation = XCTestExpectation(description: "Invalid response code was received")
        let data = APIClientTestData.expectedJSONResponse.data(using: .utf8)

        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == APIClient.getAllUniversitiesURL() else {
                throw APIError.network(description: "Invalid URL")
          }

            let response = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                           statusCode: 300,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, data)
        }

        testClient.fetchUniversities(completionHandler: { result in
            switch result {
            case .success(_):
                XCTFail("fetchUniversities() succeeded unexpectedly")
            case .failure(_):
                expectation.fulfill()
            }
        })

        wait(for: [expectation], timeout: testTimeout)
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

    func test_ValidateResponseUtility_ValidStatusCodes_NoThrow() {
        XCTAssertNoThrow(try UniHub.validateResponseV3(APIClientTestData.validResponse200!))
        XCTAssertNoThrow(try UniHub.validateResponseV3(APIClientTestData.validResponse299!))
    }

    func test_ValidateResponseUtility_InvalidStatusCodes_WillThrow() {
        XCTAssertThrowsError(try UniHub.validateResponseV3(APIClientTestData.invalidResponse300!)) { error in
            XCTAssertEqual(error as? UniHub.APIError, UniHub.APIError.statusCode(APIClientTestData.invalidResponse300!))
        }
        XCTAssertThrowsError(try UniHub.validateResponseV3(APIClientTestData.invalidResponse404!)) { error in
            XCTAssertEqual(error as? UniHub.APIError, UniHub.APIError.statusCode(APIClientTestData.invalidResponse404!))
        }
    }
}
