//
//  UniversityViewModelTests.swift
//  UniHubTests
//
//  Created by Chris McLearnon on 15/10/2020.
//

import XCTest
@testable import UniHub

class UniversityViewModelTests: XCTestCase, UniversityViewModelEventsDelegate {
    func updateLoadingIndicator() {
        return
    }
    
    func updateUIContent(successful: Bool) {
        return
    }
    

    var testData: ModelTestData!
    var mockViewModel: UniversityViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testData = ModelTestData()
        mockViewModel = UniversityViewModel(delegate: self)
    }
    
    func test_DidChangePublisher_UniversityListHasNotBeenInitialised() throws {
        let expectedRecievedData = [University]()
        let _ = mockViewModel.didChange
            .map {
                XCTAssertEqual(expectedRecievedData, $0)
            }
    }
    
    func test_DidChangePublisher_RecieveCorrectData() throws {
        let expectedRecievedData = [testData.expectedModelInstance, testData.expectedModelInstance]
        mockViewModel.universityList = expectedRecievedData
        
        let _ = mockViewModel.didChange
            .map {
                XCTAssertEqual(expectedRecievedData, $0)
            }
    }
    
    func test_DidChangePublisher_RecieveCorrectData_MultipleUpdates() throws {
        let expectedRecievedData = [testData.expectedModelInstance, testData.expectedModelInstance]
        mockViewModel.universityList = expectedRecievedData
        
        let _ = mockViewModel.didChange
            .map {
                XCTAssertEqual(expectedRecievedData, $0)
            }
        
        mockViewModel.universityList = expectedRecievedData + [testData.expectedModelInstance]
        let _ = mockViewModel.didChange
            .map {
                XCTAssertNotEqual(expectedRecievedData, $0)
            }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockViewModel = nil
    }
}
