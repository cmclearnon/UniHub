////
////  UniversitiesListViewModelTests.swift
////  UniHubTests
////
////  Created by Chris McLearnon on 15/10/2020.
////

import XCTest
import RxSwift
import RxTest

@testable import UniHub

class UniversitiesListViewModelTests: XCTestCase {
    var testData: ModelTestData!
    var mockViewModel: UniversitiesListViewModel!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        testData = ModelTestData()
        disposeBag = DisposeBag()

        /// Setting up a mock URLProtocolMock
        URLProtocol.registerClass(URLProtocolMock.self)

        let config = URLSessionConfiguration.default
        config.protocolClasses?.insert(URLProtocolMock.self, at: 0)
    }

    override func tearDownWithError() throws {
        disposeBag = nil
        mockViewModel = nil
    }
    
    func test_ViewModelInitialised_OnChangeTriggered() throws {
        let expectation = XCTestExpectation(description: "ViewModel onChange closure triggered")
        let expectedUniversities = [APIClientTestData.expectedUniversityObject]
        var actualUniversities = [University]()

        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == APIClient.getAllUniversitiesURL() else {
                throw APIError.network(description: "Invalid URL")
          }

            let response = APIClientTestData.validResponse200!
            let data = APIClientTestData.expectedJSONResponse.data(using: .utf8)
            return (response, data)
        }

        mockViewModel = UniversitiesListViewModel()
        mockViewModel.universityList.subscribe(onNext: { universities in
            actualUniversities = universities
        }).disposed(by: disposeBag)
        mockViewModel.fetchUniversities(completion: { expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(expectedUniversities, actualUniversities)
    }
    
    func test_ViewModelInitialised_ErrorFetchingUniversities() throws {
        let expectation = XCTestExpectation(description: "ViewModel onChange closure triggered")
        let expectedUniversities = [University]()
        var actualUniversities = [University]()

        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == APIClient.getAllUniversitiesURL() else {
                throw APIError.network(description: "Invalid URL")
          }

            let response = APIClientTestData.invalidResponse404!
            let data = APIClientTestData.expectedJSONResponse.data(using: .utf8)
            return (response, data)
        }

        mockViewModel = UniversitiesListViewModel()
        mockViewModel.universityList.subscribe(onNext: { universities in
            actualUniversities = universities
        }).disposed(by: disposeBag)
        mockViewModel.fetchUniversities(completion: { expectation.fulfill() })
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(expectedUniversities, actualUniversities)
    }
}
