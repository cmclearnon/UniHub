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
    fileprivate var webView: WKWebView

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.load(self.webPage)
    }
    
    init(withWebPage webPageString: String) {
        self.webPage = webPageString
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        self.view = webView
    }
    
    func getWebView() -> WKWebView {
        return webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Did finish nagivating to: \(webPage)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let nserror = error as NSError
        if nserror.code != NSURLErrorCancelled {
            webView.loadHTMLString("Page Not Found", baseURL: URL(string: self.webPage))
        }
    }
}
