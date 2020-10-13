//
//  HomeListCollectionViewCell.swift
//  UniHub
//
//  Created by Chris McLearnon on 12/10/2020.
//

import Foundation
import UIKit

class HomeListCollectionViewCell: UICollectionViewCell {
    
    /// Once nameString is assigned a value load string into the cell
    var nameString: String! {
        didSet {
            nameLabel.text = nameString
        }
    }
    
    var locationString: String! {
        didSet {
            locationLabel.text = locationString
        }
    }
    
    let nameLabel: CellLabel = {
        let label = CellLabel(frame: .zero)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.layer.cornerCurve = .continuous
        label.layer.masksToBounds = true
        return label
    }()
    
    let locationLabel: CellLabel = {
        let label = CellLabel()
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerCurve = .continuous
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
    
    func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        
        locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -10).isActive = true
        locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
    }
}
