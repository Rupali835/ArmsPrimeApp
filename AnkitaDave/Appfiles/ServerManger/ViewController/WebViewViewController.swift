//
//  WebViewViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 21/05/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var navigationTitle: String!
    var openUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = self.navigationTitle //"Terms & Conditions"
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.backBarButtonItem?.title = ""
        
        if Reachability.isConnectedToNetwork() {
            
            self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: AppFont.light.rawValue, size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.white]
            
            if let url = URL(string: openUrl) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
        
        if hideRightBarButtons {
            self.addBackButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func btnBackClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
