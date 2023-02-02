//
//  HomeListViewController+NetworkObserver.swift
//  UniHub
//
//  Created by Chris McLearnon on 02/02/2023.
//

import UIKit
import Foundation

extension HomeListViewController {
    enum Section: Int, CaseIterable {
        case all
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, University> {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, university in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "reuseID",
                    for: indexPath
                ) as! HomeListCollectionViewCell

                cell.nameString = university.name
                cell.locationString = "\(university.country)"
                cell.domainsList = university.domains
                
                return cell
            }
        )
    }
    
    func univiersitiesDidLoad(_ list: [University]) {
        // Create snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, University>()
        // Append section
        snapshot.appendSections(Section.allCases)
        // Append universities
        snapshot.appendItems(list, toSection: .all)
        // Apply to datasource
        dataSource.apply(snapshot)
    }
}
