//
//  CellMainContentsContainerView.swift
//  UniHub
//
//  Created by Chris McLearnon on 13/10/2020.
//

import Foundation
import UIKit

class CellMainContentsContainerView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25
    }
}
