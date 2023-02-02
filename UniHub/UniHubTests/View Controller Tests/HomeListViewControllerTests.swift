////
////  HomeListViewControllerTests.swift
////  UniHubUITests
////
////  Created by Chris McLearnon on 12/10/2020.
////

import XCTest
import UIKit
@testable import UniHub

class HomeListViewControllerTests: XCTestCase {

    var viewController: HomeListViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = HomeListViewController()

        _ = viewController.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewController = nil
    }

    func test_CollectionViewDataSource_LoadedWithData() throws {
        let loadedUniversities = [APIClientTestData.expectedUniversityObject]
        viewController.univiersitiesDidLoad(loadedUniversities)
        
        let cell = try XCTUnwrap(
            viewController.collectionView.dataSource?.collectionView(
                viewController.collectionView,
                cellForItemAt:IndexPath(row: 0, section: 0)
            ) as? HomeListCollectionViewCell)

        XCTAssertEqual(cell.nameLabel.text, "Marywood University")
        XCTAssertEqual(cell.domainsLabel.text, "marywood.edu")
        XCTAssertEqual(cell.locationLabel.text, "United States")
    }
}
