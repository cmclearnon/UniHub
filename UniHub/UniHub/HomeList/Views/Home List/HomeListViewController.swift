//
//  HomeListViewController.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import UIKit
import Combine
import CombineDataSources
import Network

class HomeListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var viewModel: UniversityViewModel!
    private var collectionViewItemsController: CollectionViewItemsController<[[University]]>!
    private var connectionEstablished: Bool = true
    var networkHandler = NetworkHandler.sharedInstance()
    
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
    
    fileprivate let refreshButton: RefreshUIButton = {
        let button = RefreshUIButton()
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(refreshPressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusDidChange(status: networkHandler.currentStatus)
        networkHandler.addObserver(observer: self)
        if networkHandler.currentStatus == .satisfied {
            refreshButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        self.viewModel = UniversityViewModel(delegate: self)
        self.viewModel.fetchUniversityList()
        self.collectionView.delegate = self
        self.setupDataSource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusDidChange(status: networkHandler.currentStatus)
        networkHandler.removeObserver(observer: self)
    }
    
    func getCollectionView() -> UICollectionView {
        return collectionView
    }
    
    func getViewMode() -> UniversityViewModel {
        return viewModel
    }
    
    @objc func refreshPressed(sender: UIButton!) {
        self.refreshButton.showLoading()
        self.viewModel.fetchUniversityList()
        self.refreshButton.hideLoading()
    }
}

// View hierarchy & layout setup
extension HomeListViewController {
    func setupViews() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(collectionView)
        view.addSubview(connectionWarningMessageView)
        view.addSubview(activityIndicatorView)
        view.addSubview(refreshButton)
        
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
        
        refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        refreshButton.isHidden = true
        
        
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
    func updateUIContent(successful: Bool) {
        if successful == true {
            collectionView.isHidden = false
            refreshButton.isHidden = true
        } else {
            collectionView.isHidden = true
            refreshButton.isHidden = false
        }
    }
}

// NetworkHandlerObserver conforming function for actions taken after network status has changed
extension HomeListViewController: NetworkHandlerObserver {
    
    ///Update UI elements displayed depending on network connection
    func statusDidChange(status: NWPath.Status) {
        let count = viewModel.getViewModelListCount()
        if status == .satisfied {
            if count == 0 {
                self.collectionView.isHidden = true
                self.connectionWarningMessageView.isHidden = true
                self.refreshButton.isHidden = false
            } else {
                self.connectionEstablished = true
                self.collectionView.isHidden = false
                self.connectionWarningMessageView.isHidden = true
                self.refreshButton.isHidden = true
            }
        } else {
            self.connectionEstablished = false
            if count == 0 {
                self.collectionView.isHidden = true
                self.connectionWarningMessageView.isHidden = false
                self.refreshButton.isHidden = false
            }
        }
    }
}

