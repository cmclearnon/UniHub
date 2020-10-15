//
//  WKWebViewController.swift
//  UniHub
//
//  Created by Chris McLearnon on 13/10/2020.
//

import UIKit
import WebKit
import Network

class WKWebViewController: UIViewController, WKUIDelegate {
    
    private var webPage: String
    private var webViewIsLoading: Bool = false
    private var connectionEstablished: Bool = true
    fileprivate var webView: WKWebView
    
    var networkHandler = NetworkHandler.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        statusDidChange(status: networkHandler.currentStatus)
        networkHandler.addObserver(observer: self)
        setupActivityIndicatorNavigationBarButtonItem()
        self.webView.load(self.webPage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        networkHandler.removeObserver(observer: self)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    init(withWebPage webPageString: String) {
        self.webPage = webPageString
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func refreshWebView(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    /// Set navigationItem.rightBarButtonItem to a Refresh Button
    func setupRefreshNavigationBarButtonItem() {
        let rightButton = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshWebView(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    /// Set navigationItem.rightBarButtonItem to an Activity Indicator
    func setupActivityIndicatorNavigationBarButtonItem() {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: indicator)
    }

    /// Load the VIew Controller view as the WKWebView
    override func loadView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view = webView
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupViewConstraints() {
        view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    func getWebView() -> WKWebView {
        return webView
    }
}

extension WKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewIsLoading = true
        setupActivityIndicatorNavigationBarButtonItem()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewIsLoading = false
        setupRefreshNavigationBarButtonItem()
    }
    
    /// Display HTML error message when the webpage cannot be loaded
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        setupRefreshNavigationBarButtonItem()
        let nserror = error as NSError
        
        /// Check if its a network error or an internal request error
        if connectionEstablished == true {
            if nserror.code != NSURLErrorCancelled {
                webView.loadHTMLString("<h1>Cannot Load Web Page</h1><h3>Please check your internet connection or the website URL and try again", baseURL: URL(string: webPage))
            }
        } else {
            webView.loadHTMLString("<h1>You Are Not Connected to the Internet</h1><h3>This page can't be displayed because your device is currently offline", baseURL: URL(string: webPage))
        }
    }
}

extension WKWebViewController: NetworkHandlerObserver {
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            self.connectionEstablished = true
        } else {
            self.connectionEstablished = false
        }
    }
}
