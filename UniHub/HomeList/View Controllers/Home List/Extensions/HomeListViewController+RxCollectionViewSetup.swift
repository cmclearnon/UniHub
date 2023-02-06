//
//  HomeListViewController+NetworkObserver.swift
//  UniHub
//
//  Created by Chris McLearnon on 02/02/2023.
//

import UIKit
import Foundation

extension HomeListViewController {
    func bindDataToCollectionView() {
        self.viewModel.universityList.bind(to: collectionView.rx.items) { collectionView, index, model in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! HomeListCollectionViewCell
            cell.nameString = model.name
            cell.locationString = model.country
            cell.domainsList = model.domains
            
            return cell
        }.disposed(by: disposeBag)
    }
    
    func subscribeForCellSelection() {
        self.collectionView.rx.modelSelected(University.self).subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            guard let selectedWebPage = model.webPages.first else {
                self.displayAlert(withMessage: "Unable to load webpage. Please try again later or contact Customer Support.")
                return
            }
            let vc = WKWebViewController(withWebPage: selectedWebPage)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
}
