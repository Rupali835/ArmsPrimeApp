//
//  ArmsPrimeWebViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 13/07/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import WebKit

class ArmsPrimeWebViewController: BaseViewController {
    
     @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
         self.tabBarController?.tabBar.isHidden = true
        
//        self.navigationItem.title = "ARMSPRIME"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setNavigationView(title: "ARMSPRIME")
        if let url = URL(string: "http://www.armsprime.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
}
