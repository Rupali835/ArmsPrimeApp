//
//  TermsAndCondWebViewController.swift
//  VideoGreetings
//
//  Created by Apple on 04/10/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit
import WebKit

class TermsAndCondWebViewController: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    var termsCondAcceptHandler: ((Bool) -> ())?
    var webView: WKWebView!
    
    // MARK: - IBOutlets.
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        title = "Terms and Conditions".uppercased()
        NavigationBarUtils.setupNavigationBar(navigationController: navigationController)
        
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"), style: .plain, target: self, action: #selector(didTapClose))
        navigationItem.leftBarButtonItem = closeButton
        
        guard let url = URL(string: ShoutoutConfig.termsAndCondURL) else { return }
        let urlRequest = URLRequest(url: url)
        
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        
        webView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor, constant: 0.0).isActive = true
        webView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor, constant: 0.0).isActive = true
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor, constant: 0.0).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor, constant: 0.0).isActive = true
        
        webView.load(urlRequest)
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBActions.
    @IBAction func didTapCancel(_ sender: UIButton) {
        ShoutoutConfig.UserDefaultsManager.updateShoutoutTermsAcceptStatus(status: false)
        termsCondAcceptHandler?(false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapAgree(_ sender: UIButton) {
        ShoutoutConfig.UserDefaultsManager.updateShoutoutTermsAcceptStatus(status: true)
        termsCondAcceptHandler?(true)
        dismiss(animated: true, completion: nil)
    }
}
