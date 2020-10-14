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
    
    /// Once domainsList is assigned a value build a list string and load it into the domainsLabel
    var domainsList: [String]! {
        didSet {
            let domainsString = domainsList.joined(separator: "\n")
            domainsLabel.text = domainsString
            
        }
    }
    
    /// UILabel for displaying View Model name data
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.systemPurple
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    /// Content Container View for containing main cell contents
    let cellMainContentsContainerView: CellMainContentsContainerView = {
       let view = CellMainContentsContainerView()
        view.backgroundColor = UIColor.systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Content Container View for containing View Model location data
    let locationLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// UILabel for displaying View Model location data
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        label.layer.cornerRadius = label.frame.height / 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Content Container View for containing View Model domains data & custom UIViews
    let domainsLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Custom Colour Bar UIView for list of domains
    let colourBarView: ColourBarView = {
        let view = ColourBarView()
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// UILabel for displaying View Model domains data
    let domainsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.label
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 25
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
        contentView.addSubview(cellMainContentsContainerView)
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -15).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        
        locationLabelContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        locationLabelContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        locationLabelContainerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7.5).isActive = true
        locationLabelContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1).isActive = true
        
        /// Views constrained to the cell's Location Label Container View
        locationLabelContainerView.addSubview(locationLabel)
        locationLabel.leadingAnchor.constraint(equalTo: locationLabelContainerView.leadingAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationLabelContainerView.topAnchor).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: locationLabelContainerView.bottomAnchor).isActive = true
        let maximumWidth: CGFloat = 200.0
        locationLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maximumWidth).isActive = true
        
        cellMainContentsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellMainContentsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellMainContentsContainerView.topAnchor.constraint(equalTo: locationLabelContainerView.bottomAnchor, constant: 5).isActive = true
        cellMainContentsContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        /// Views constrained to the cell's Main Content Container View
        cellMainContentsContainerView.addSubview(domainsLabelContainerView)
        domainsLabelContainerView.leadingAnchor.constraint(equalTo: cellMainContentsContainerView.leadingAnchor, constant: 15).isActive = true
        domainsLabelContainerView.trailingAnchor.constraint(equalTo: cellMainContentsContainerView.trailingAnchor, constant: -15).isActive = true
        domainsLabelContainerView.topAnchor.constraint(equalTo: cellMainContentsContainerView.topAnchor, constant: 15).isActive = true
        domainsLabelContainerView.bottomAnchor.constraint(equalTo: cellMainContentsContainerView.bottomAnchor, constant: -15).isActive = true
        
        /// Views constrained to the cell's Domains Label Container View
        domainsLabelContainerView.addSubview(colourBarView)
        domainsLabelContainerView.addSubview(domainsLabel)
        colourBarView.leadingAnchor.constraint(equalTo: domainsLabelContainerView.leadingAnchor, constant: -5).isActive = true
        colourBarView.topAnchor.constraint(equalTo: domainsLabelContainerView.topAnchor, constant: 15).isActive = true
        colourBarView.bottomAnchor.constraint(equalTo: domainsLabel.bottomAnchor).isActive = true
        colourBarView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        domainsLabel.leadingAnchor.constraint(equalTo: colourBarView.trailingAnchor, constant: 10).isActive = true
        domainsLabel.trailingAnchor.constraint(equalTo: domainsLabelContainerView.trailingAnchor).isActive = true
        domainsLabel.topAnchor.constraint(equalTo: domainsLabelContainerView.topAnchor, constant: 15).isActive = true
        
    }
}
