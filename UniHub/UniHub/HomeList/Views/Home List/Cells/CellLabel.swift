//
//  CellLabel.swift
//  UniHub
//
//  Created by Chris McLearnon on 12/10/2020.
//

import Foundation
import UIKit

class CellLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: insets))
    }
}
