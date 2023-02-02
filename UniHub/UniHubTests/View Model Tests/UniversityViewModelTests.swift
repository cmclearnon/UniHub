////
////  UniversityViewModelTests.swift
////  UniHubTests
////
////  Created by Chris McLearnon on 15/10/2020.
////

import XCTest
@testable import UniHub

class UniversityViewModelTests: XCTestCase {
    var testData: ModelTestData!
    var mockViewModel: UniversityViewModel!
    
    override func setUpWithError() throws {
        testData = ModelTestData()

        /// Setting up a mock URLProtocolMock
        URLProtocol.registerClass(URLProtocolMock.self)

        let config = URLSessionConfiguration.default
        config.protocolClasses?.insert(URLProtocolMock.self, at: 0)
    }

    override func tearDownWithError() throws {
        mockViewModel = nil
    }
    
    func test_ViewModelInitialised_NoChange() throws {
        mockViewModel = UniversityViewModel(onChange: {_ in})
        XCTAssertNil(mockViewModel.universityList)
    }
    
    func test_ViewModelInitialised_OnChangeTriggered() throws {
        let expectation = XCTestExpectation(description: "ViewModel onChange closure triggered")
        let expectedUniversities = [APIClientTestData.expectedUniversityObject]

        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == APIClient.getAllUniversitiesURL() else {
                throw APIError.network(description: "Invalid URL")
          }

            let response = APIClientTestData.validResponse200!
            let data = APIClientTestData.expectedJSONResponse.data(using: .utf8)
            return (response, data)
        }

        mockViewModel = UniversityViewModel(onChange: { [weak self] _ in
            guard let self = self else {
                XCTFail("self was nil")
                return
            }

            expectation.fulfill()
            XCTAssertEqual(self.mockViewModel.universityList, expectedUniversities)
        })
        mockViewModel.fetchUniversities()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_ViewModelInitialised_ErrorFetchingUniversities() throws {
        let expectation = XCTestExpectation(description: "ViewModel onChange closure triggered")
        let expectedUniversities = [University]()

        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == APIClient.getAllUniversitiesURL() else {
                throw APIError.network(description: "Invalid URL")
          }

            let response = APIClientTestData.invalidResponse404!
            let data = APIClientTestData.expectedJSONResponse.data(using: .utf8)
            return (response, data)
        }

        mockViewModel = UniversityViewModel(onChange: { [weak self] _ in
            guard let self = self else {
                XCTFail("self was nil")
                return
            }

            expectation.fulfill()
            XCTAssertEqual(self.mockViewModel.universityList, expectedUniversities)
        })
        mockViewModel.fetchUniversities()
        
        wait(for: [expectation], timeout: 10)
    }
}
