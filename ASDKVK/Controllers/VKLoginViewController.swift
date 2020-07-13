//
//  VKLoginViewController.swift
//  Geekbrains Weather
//
//  Created by user on 29.09.2018.
//  Copyright © 2018 Andrey Antropov. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class VKLoginViewController: UIViewController {
    
    let vkService = VKService()
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(vkService.request!)
    }
}

extension VKLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        // Parsing response dictionary
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        // Fetching token and user id
        guard let token = params["access_token"],
            let userId = params["user_id"],
            let id = Int(userId) else {
            decisionHandler(.allow)
            return
        }
        
        // Save data to session singleton
        Session.shared.token = token
        Session.shared.id = id
        
        showNews()
        decisionHandler(.cancel)
    }
    
    private func showNews() {
        let newsVC = NewsController(vkService: VKService())
        newsVC.modalTransitionStyle = .crossDissolve
        newsVC.modalPresentationStyle = .overFullScreen
        present(newsVC, animated: false)
    }
}
