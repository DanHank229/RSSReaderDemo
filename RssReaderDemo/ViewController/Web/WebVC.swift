//
//  WebVC.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/11/24.
//  Copyright © 2020 9s. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: URL?
    
    init(url: URL) {
        Debug.println(msg: "init WebVC")
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Debug.println(msg: "de WebVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webLink()
    }
    
    func webLink() {
        guard let url = self.url else { return }
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
}

// Custom Web Function.
extension WebVC: WKNavigationDelegate {
    // Loading Fail, Wait or Reload.
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        Debug.println(msg: "Loading Fail.")
    }
    // Loading Success.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    // Loading Finish.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
