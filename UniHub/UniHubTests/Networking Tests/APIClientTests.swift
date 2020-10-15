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
    var testPublisher: APISessionDataPublisher!
    var testClient: APIClient!
    let testTimeout: TimeInterval = 10

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.testData = APIClientTestData()
        
        /// Setting up a mock URLProtocolMock
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        /// Create URLSession instance from URLProtocolMock & inject into APISessionDataPublisher instance
        let session = URLSession(configuration: config)
        testPublisher = APISessionDataPublisher(session: session)
        
        testClient = APIClient()
        testClient.publisher = testPublisher
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.testData = nil
        
        /// Restore the APIClient's publisher to the default
        testClient.publisher = APISessionDataPublisher()
        
        /// Reset the URLProtocolMock properties
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
    }

    func test_APIClient_BaseURLConfiguration() throws {
        XCTAssertEqual(testClient.getTestURL(), URL(string: "http://localhost:8080"))
    }
    
    func test_GetUniversitiesRequestBuilder() throws {
        let publisher = testClient.getUniversitiesDataTaskPublisher()
        let request = publisher.request
        
        XCTAssertEqual(request.url?.absoluteString, publisher.request.url?.absoluteString)
        XCTAssertEqual(request.httpMethod, publisher.request.httpMethod)
        XCTAssertEqual(request.allHTTPHeaderFields?.count, publisher.request.allHTTPHeaderFields?.count)
    }
    
    func test_ValidAPIRequest_RecieveBlock<T:Publisher>(withPublisher publisher: T?) -> (expectations:[XCTestExpectation], cancellable: AnyCancellable?) {
        XCTAssertNotNil(publisher)
        
        let expectationFinished = expectation(description: "finished")
        let expectationReceive = expectation(description: "receiveValue")
        let expectationFailure = expectation(description: "failure")
        expectationFailure.isInverted = true
        
        let cancellable = publisher?.sink (
            receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print("Test Case failure: \(error)")
                    expectationFailure.fulfill()
                case .finished:
                    expectationFinished.fulfill()
                }
        }, receiveValue: { response in
            XCTAssertNotNil(response)
            expectationReceive.fulfill()
        })
        return (expectations: [expectationFinished, expectationReceive, expectationFailure],
                cancellable: cancellable)
    }
    
    func test_FailedAPIRequest_RecieveBlock<T:Publisher>(withPublisher publisher: T?) -> (expectations:[XCTestExpectation], cancellable: AnyCancellable?) {
        XCTAssertNotNil(publisher)
        
        let expectationFinished = expectation(description: "finished")
        let expectationReceive = expectation(description: "receiveValue")
        let expectationFailure = expectation(description: "failure")
        expectationFinished.isInverted = true
        expectationReceive.isInverted = true
        
        let cancellable = publisher?.sink (
            receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print("Test Case pass: \(error)")
                    expectationFailure.fulfill()
                case .finished:
                    expectationFinished.fulfill()
                }
        }, receiveValue: { response in
            XCTAssertNotNil(response)
            expectationReceive.fulfill()
        })
        return (expectations: [expectationFinished, expectationReceive, expectationFailure],
                cancellable: cancellable)
    }
    
    func test_ValidResponseAndDataGetRequest() throws {
        let data = testData.expectedJSONResponse.data(using: .utf8)
        
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == self.testClient.getAllUniversitiesURL() else {
                throw APIError.network(description: "Invalid URL")
          }
          
            let response = self.testData.validResponse200!
            return (response, data)
        }
        
        let publisher = testClient.listAllUniversities()
        
        let validTest = test_ValidAPIRequest_RecieveBlock(withPublisher: publisher)
        wait(for: validTest.expectations, timeout: testTimeout)
        validTest.cancellable?.cancel()
    }
    
    func test_InvalidResponseStatusCode300_ValidData_throwsAPIError() throws {
        let data = testData.expectedJSONResponse.data(using: .utf8)
        
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == self.testClient.getAllUniversitiesURL() else {
                throw APIError.network(description: "Invalid URL")
          }
          
            let response = self.testData.invalidResponse300!
            return (response, data)
        }
        
        let publisher = testClient.listAllUniversities()
        
        let invalidResponseTest = test_FailedAPIRequest_RecieveBlock(withPublisher: publisher)
        wait(for: invalidResponseTest.expectations, timeout: testTimeout)
        invalidResponseTest.cancellable?.cancel()
    }
    
    func test_ValidResponse_InvalidDataFormat_throwsAPIError() throws {
        let data = testData.invalidDataJSONResponse.data(using: .utf8)
        
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == self.testClient.getAllUniversitiesURL() else {
                throw APIError.network(description: "Invalid URL")
          }
          
            let response = self.testData.validResponse200!
            return (response, data)
        }
        
        let publisher = testClient.listAllUniversities()
        
        let invalidResponseTest = test_FailedAPIRequest_RecieveBlock(withPublisher: publisher)
        wait(for: invalidResponseTest.expectations, timeout: testTimeout)
        invalidResponseTest.cancellable?.cancel()
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
    
    func test_ValidateResponseUtility_ValidStatusCodes() {
        let data200Response = try? UniHub.validateResponse(Data(), self.testData.validResponse200!)
        XCTAssertNotNil(data200Response)
        
        let data299Response = try? UniHub.validateResponse(Data(), self.testData.validResponse299!)
        XCTAssertNotNil(data299Response)
    }
    
    func test_ValidateResponseUtility_InvalidStatusCodes() {
        XCTAssertThrowsError(try UniHub.validateResponse(Data(), self.testData.invalidResponse300!))
        XCTAssertThrowsError(try UniHub.validateResponse(Data(), self.testData.invalidResponse404!))
    }
}
