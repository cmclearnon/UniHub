//
//  CreateAlertViewUtilityTests.swift
//  UniHubUITests
//
//  Created by Chris McLearnon on 13/10/2020.
//

import XCTest
@testable import UniHub

class CreateAlertViewUtilityTests: XCTestCase {

    var mockViews: MockViews!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockViews = MockViews()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockViews = nil
    }
    
    func testSuccessfulAlertCreation() throws {
        let alert = UIAlertController(title: "Alert", message: "Valid", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        XCTAssertEqual(alert.title, mockViews.validAlertView.title)
        XCTAssertEqual(alert.message, mockViews.validAlertView.message)
        XCTAssertEqual(alert.actions.count, mockViews.validAlertView.actions.count)
        XCTAssertEqual(alert.actions[0].title, mockViews.validAlertView.actions[0].title)
        XCTAssertEqual(alert.actions[0].style, mockViews.validAlertView.actions[0].style)
    }
}

class MockViews {
    let validAlertView: UIAlertController = {
        let alert = UIAlertController(title: "Alert", message: "Valid", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }()
    
    let invalidAlertView: UIAlertController = {
        let alert = UIAlertController(title: "Alert", message: "Invalid", preferredStyle: UIAlertController.Style.alert)
        return alert
    }()
}
