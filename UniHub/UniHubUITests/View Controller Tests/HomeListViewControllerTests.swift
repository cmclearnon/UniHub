//
//  HomeListViewControllerTests.swift
//  UniHubUITests
//
//  Created by Chris McLearnon on 12/10/2020.
//

import XCTest
import UIKit
@testable import UniHub

class HomeListViewControllerTests: XCTestCase {
    
    var vcUnderTest: HomeListViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vcUnderTest = HomeListViewController()
        
        _ = vcUnderTest.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vcUnderTest = nil
    }
    
    func test_CollectionViewInstantiatedAfterViewDidLoad() throws {
        XCTAssertNotNil(vcUnderTest.getCollectionView())
    }
    
    func test_ViewControllerIsCollectionViewDelegate() throws {
        XCTAssert(vcUnderTest.conforms(to: UICollectionViewDelegate.self))
        XCTAssertNotNil(vcUnderTest.getCollectionView().delegate)
        XCTAssert(vcUnderTest.responds(to: #selector(vcUnderTest.collectionView(_:didSelectItemAt:))))
    }
    
    func test_ViewControllerConformsToCollectionViewDelegateFlowLayout() throws {
        XCTAssert(vcUnderTest.conforms(to: UICollectionViewDelegateFlowLayout.self))
        XCTAssertTrue(vcUnderTest.responds(to: #selector(vcUnderTest.collectionView(_:layout:minimumLineSpacingForSectionAt:))))
        XCTAssertTrue(vcUnderTest.responds(to: #selector(vcUnderTest.collectionView(_:layout:sizeForItemAt:))))
    }
}
