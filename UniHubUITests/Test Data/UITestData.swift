//
//  TestData.swift
//  UniHub
//
//  Created by Chris McLearnon on 13/10/2020.
//

import Foundation
import UIKit

class UICollectionViewTestData {
    let dataset1 = [
        "test", "test"
    ]
    
    let dataset2 = [
        "test2", "test2"
    ]
    
    let dataset3 = [
        "test3", "test3"
    ]
}

class UIAlertControllerTestData {
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
