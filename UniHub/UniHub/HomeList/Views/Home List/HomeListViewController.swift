//
//  HomeListViewController.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import UIKit
import Combine
import CombineDataSources

class HomeListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var viewModel: UniversityViewModel!
    private var collectionViewItemsController: CollectionViewItemsController<[[University]]>!
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HomeListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    private let connectionWarningMessageView: UILabel = {
       let lb = UILabel()
        lb.text = "Unable to load universities. Please check your internet connection and try again."
        lb.sizeToFit()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        self.viewModel = UniversityViewModel(delegate: self)
        self.collectionView.delegate = self
        self.setupDataSource()
    }
    
    func getCollectionView() -> UICollectionView {
        return collectionView
    }
    
    func getViewMode() -> UniversityViewModel {
        return viewModel
    }
}

// View hierarchy & layout setup
extension HomeListViewController {
    func setupViews() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(collectionView)
        view.addSubview(connectionWarningMessageView)
        view.addSubview(activityIndicatorView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        connectionWarningMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        connectionWarningMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        connectionWarningMessageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectionWarningMessageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        connectionWarningMessageView.isHidden = true
        
        activityIndicatorView.center = view.center
        
    }
}

// UICollectionViewDelegateFlowLayout & CombineDataSources conforming functions
extension HomeListViewController {
    
    /// Using CombineDataSources library to set up collectionView as a Subscriber to the viewModel's universityList didChange Publisher
    fileprivate func setupDataSource() {
        collectionViewItemsController = CollectionViewItemsController<[[University]]>(cellIdentifier: "Cell", cellType: HomeListCollectionViewCell.self) { (cell, indexPath, model) in
            cell.nameString = model.name
            cell.locationString = "\(model.country)"
            cell.domainsList = model.domains
        }
        
        viewModel.didChange
            .map{ $0 }
            .subscribe(collectionView.itemsSubscriber(collectionViewItemsController))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedWebPage = viewModel.universityList?[indexPath.row].webPages[0] else {
            displayAlert(withMessage: "Unable to load webpage. Please try again later or contact Customer Support.")
            return
        }
        let vc = WKWebViewController(withWebPage: selectedWebPage)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// Utility function for displaying a UIAlertController view for invalid URL selection
extension HomeListViewController {
    func displayAlert(withMessage message: String) {
        let alert = createAlert(withMessage: message)
        self.present(alert, animated: true, completion: nil)
    }
}

// UniversityViewModelEventsDelegate conforming function implementation
extension HomeListViewController: UniversityViewModelEventsDelegate {
    
    /// Update activityIndicator on viewModel event changes
    func updateLoadingIndicator() {
        if (activityIndicatorView.isAnimating == false) {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }

    /// Update collectionView on viewModel event changes
    func updateUIContent() {
        if (collectionView.isHidden == false) {
            collectionView.isHidden = true
        } else {
            collectionView.reloadData()
            collectionView.isHidden = false
        }
    }
}

