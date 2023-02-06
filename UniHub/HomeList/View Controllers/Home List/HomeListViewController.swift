//
//  HomeListViewController.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import UIKit
import Combine
import Network
import RxSwift
import RxCocoa

class HomeListViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    private var viewModel: UniversitiesListViewModel2!
    private let disposeBag = DisposeBag()

    private var connectionEstablished: Bool = true
    private var networkHandler = NetworkHandler.sharedInstance()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(
            HomeListCollectionViewCell.self,
            forCellWithReuseIdentifier: "reuseID"
        )
        return cv
    }()
    private(set) lazy var dataSource = makeDataSource()
    
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
        // Registering our cell class with the collection view
        // and assigning our diffable data source to it:
        self.collectionView.delegate = self
        self.collectionView.rx.modelSelected(University.self).subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            guard let selectedWebPage = model.webPages.first else {
                self.displayAlert(withMessage: "Unable to load webpage. Please try again later or contact Customer Support.")
                return
            }
            let vc = WKWebViewController(withWebPage: selectedWebPage)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)

        setupViews()

        self.viewModel = UniversitiesListViewModel2()
        self.viewModel.universityList.bind(to: collectionView.rx.items) { collectionView, index, model in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! HomeListCollectionViewCell
            cell.nameString = model.name
            cell.locationString = model.country
            cell.domainsList = model.domains
            
            return cell
        }.disposed(by: disposeBag)
        
        self.activityIndicatorView.isHidden = false
        self.viewModel.fetchUniversities(completion: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicatorView.isHidden = true
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusDidChange(status: networkHandler.currentStatus)
        networkHandler.removeObserver(observer: self)
    }

    @objc func refreshPressed(sender: UIButton!) {
        self.refreshButton.showLoading()
        self.viewModel.fetchUniversities(completion: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicatorView.isHidden = true
            }
        })
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

extension HomeListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
}

// Utility function for displaying a UIAlertController view for invalid URL selection
extension HomeListViewController {
    func displayAlert(withMessage message: String) {
        let alert = createAlert(withMessage: message)
        self.present(alert, animated: true, completion: nil)
    }
}

// NetworkHandlerObserver conforming function for actions taken after network status has changed
extension HomeListViewController: NetworkHandlerObserver {
    
    ///Update UI elements displayed depending on network connection
    func statusDidChange(status: NWPath.Status) {
//        let count = viewModel.getViewModelListCount()
        if status == .satisfied {
            self.connectionEstablished = true
            self.collectionView.isHidden = false
            self.connectionWarningMessageView.isHidden = true
            self.refreshButton.isHidden = true
        } else {
            self.connectionEstablished = false
//            if count == 0 {
//                self.collectionView.isHidden = true
//                self.connectionWarningMessageView.isHidden = false
//                self.refreshButton.isHidden = false
//            }
        }
    }
}

