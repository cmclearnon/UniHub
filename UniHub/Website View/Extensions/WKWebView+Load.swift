//
//  WKWebView+Load.swift
//  UniHub
//
//  Created by Chris McLearnon on 13/10/2020.
//

import Foundation
import UIKit
import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        print("Loading")
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        } else {
            print("Cannot load webpage")
            loadHTMLString("<strong>Page Not Found</strong>", baseURL: nil)
        }
    }
}
