//
//  UICollectionViewCombineDataSourcesTests.swift
//  UniHubUITests
//
//  Created by Chris McLearnon on 13/10/2020.
//

import XCTest
import UIKit
@testable import UniHub
@testable import CombineDataSources

class UICollectionViewCombineDataSourcesTests: XCTestCase {
    
    var itemsController: CollectionViewItemsController<[[String]]>!
    var collectionView: UICollectionView!
    var testData: UICollectionViewTestData!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        itemsController = CollectionViewItemsController<[[String]]>(cellIdentifier: "Cell", cellType: UICollectionViewCell.self) { (cell, indexPath, model) in
            
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        testData = UICollectionViewTestData()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        itemsController = nil
        collectionView = nil
        testData = nil
    }
    
    func test_CollectionViewItemsSubscriberDataSource_IsInitialised() throws {
        let _ = collectionView.itemsSubscriber(itemsController)
        XCTAssertNotNil(collectionView.dataSource)
    }
    
    func test_CollectionViewRecievingDataSourceEvent() throws {
        let subscriber = collectionView.itemsSubscriber(itemsController)
        _ = subscriber.receive(testData.dataset1)
        
        XCTAssertEqual(1, collectionView.numberOfSections)
        XCTAssertEqual(2, collectionView.numberOfItems(inSection: 0))
    }
    
    func test_CollectionViewUpdatingItems_AfterMultipleDataSourceEvents() throws {
        let subscriber = collectionView.itemsSubscriber(itemsController)
        _ = subscriber.receive(testData.dataset1)
        _ = subscriber.receive(testData.dataset2 + testData.dataset3)
        
        XCTAssertEqual(1, collectionView.numberOfSections)
        XCTAssertEqual(4, collectionView.numberOfItems(inSection: 0))
        
        _ = subscriber.receive(testData.dataset3)
        
        XCTAssertEqual(2, collectionView.numberOfItems(inSection: 0))
    }
}
