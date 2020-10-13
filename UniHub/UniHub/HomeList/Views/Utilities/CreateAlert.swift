//
//  DisplayAlert.swift
//  UniHub
//
//  Created by Chris McLearnon on 13/10/2020.
//

import Foundation
import UIKit

func createAlert(withMessage message: String) -> UIAlertController {
    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    return alert
}
