//
//  WKWebViewController.swift
//  UniHub
//
//  Created by Chris McLearnon on 13/10/2020.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    private var webPage: String
    private var webViewIsLoading: Bool = false
    private var refreshButtonShouldHide: Bool = false
    fileprivate var webView: WKWebView

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicatorNavigationBarButtonItem()
        self.webView.load(self.webPage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    func setupRefreshNavigationBarButtonItem() {
        let rightButton = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshWebView(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func setupActivityIndicatorNavigationBarButtonItem() {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: indicator)
    }

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
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewIsLoading = true
        setupActivityIndicatorNavigationBarButtonItem()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewIsLoading = false
        setupRefreshNavigationBarButtonItem()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let nserror = error as NSError
        if nserror.code != NSURLErrorCancelled {
            webView.loadHTMLString("Page Not Found", baseURL: URL(string: self.webPage))
        }
    }
}
