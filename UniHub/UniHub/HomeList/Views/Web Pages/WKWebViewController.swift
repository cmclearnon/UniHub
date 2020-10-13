//
//  WKWebViewController.swift
//  UniHub
//
//  Created by Chris McLearnon on 13/10/2020.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    
    private var webPage: String
    fileprivate let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.load(self.webPage)
    }
//    
//    convenience init() {
//        self.init(webPageString: nil)
//    }
    
    init(withWebPage webPageString: String) {
        self.webPage = webPageString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = webView
    }
}
