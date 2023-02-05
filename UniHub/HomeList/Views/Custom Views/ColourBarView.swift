//
//  ColourBarView.swift
//  UniHub
//
//  Created by Chris McLearnon on 13/10/2020.
//

import Foundation
import UIKit

// Custom UIView for Colour Bars
class ColourBarView: UIView {
    /// Custom cornerRadius set when called in initialisation
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
}
