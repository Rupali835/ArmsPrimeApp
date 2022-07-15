//
//  WebviewUrlViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 24/09/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import WebKit

class WebviewUrlViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var webviewUrl = ""
    var webViewName = ""
    var pagindex = 0
    var storeDetailsArray : [List] = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = nil
        
//        self.navigationItem.title = webViewName
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setNavigationView(title: webViewName)
        if storeDetailsArray[pagindex].webview_url != "" && storeDetailsArray[pagindex].webview_url != nil {
        if let weburl = storeDetailsArray[pagindex].webview_url , let url =  URL(string: weburl) {
            webView.load((URLRequest(url: url)))
//                webView.loadRequest(URLRequest(url: url))
          }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}
