//
//  CreateAlertViewUtilityTests.swift
//  UniHubUITests
//
//  Created by Chris McLearnon on 13/10/2020.
//

import XCTest
@testable import UniHub

class CreateAlertViewUtilityTests: XCTestCase {

    var testData: UIAlertControllerTestData!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testData = UIAlertControllerTestData()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testData = nil
    }
    
    func testSuccessfulAlertCreation() throws {
        let alert = UIAlertController(title: "Alert", message: "Valid", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        XCTAssertEqual(alert.title, testData.validAlertView.title)
        XCTAssertEqual(alert.message, testData.validAlertView.message)
        XCTAssertEqual(alert.actions.count, testData.validAlertView.actions.count)
        XCTAssertEqual(alert.actions[0].title, testData.validAlertView.actions[0].title)
        XCTAssertEqual(alert.actions[0].style, testData.validAlertView.actions[0].style)
    }
}
