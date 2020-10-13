//
//  HomeListCollectionViewCell.swift
//  UniHub
//
//  Created by Chris McLearnon on 12/10/2020.
//

import Foundation
import UIKit

class HomeListCollectionViewCell: UICollectionViewCell {
    
    /// Once nameString is assigned a value load string into the nameLabel
    var nameString: String! {
        didSet {
            nameLabel.text = nameString
        }
    }
    
    /// Once locationString is assigned a value load string into the locationLabel
    var locationString: String! {
        didSet {
            locationLabel.text = locationString
            locationLabel.sizeToFit()
        }
    }
    
    let nameLabel: CellLabel = {
        let label = CellLabel(frame: .zero)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let cellMainContentsContainerVIew: CellMainContentsContainerView = {
       let view = CellMainContentsContainerView()
        view.backgroundColor = UIColor.systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let locationLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let locationLabel: CellLabel = {
        let label = CellLabel()
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.systemGreen
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
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
        /// Main Views constrained to the cell's Content View
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabelContainerView)
        contentView.addSubview(cellMainContentsContainerVIew)
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -15).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        
        locationLabelContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        locationLabelContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        locationLabelContainerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7.5).isActive = true
        locationLabelContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1).isActive = true
        
        cellMainContentsContainerVIew.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellMainContentsContainerVIew.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellMainContentsContainerVIew.topAnchor.constraint(equalTo: locationLabelContainerView.bottomAnchor, constant: 5).isActive = true
        cellMainContentsContainerVIew.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        /// Views constrained to the cell's Location Label Container View
        locationLabelContainerView.addSubview(locationLabel)
        locationLabel.leadingAnchor.constraint(equalTo: locationLabelContainerView.leadingAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationLabelContainerView.topAnchor).isActive = true
        
        // TODO: Dynamic label width to fit text
        let maximumWidth: CGFloat = 200.0
        locationLabel.widthAnchor.constraint(equalToConstant: maximumWidth).isActive = true
        locationLabel.sizeToFit()
        
        // TODO: Views for displaying domains list in cellMainContentsContainerView
        /// Views constrained to the cell's Main Contents Container View
    }
}
