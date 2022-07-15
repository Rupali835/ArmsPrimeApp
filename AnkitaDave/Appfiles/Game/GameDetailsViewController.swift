//
//  GameDetailsViewController.swift
//  CollectionViewDemo
//
//  Created by Shriram on 13/06/20.
//  Copyright © 2020 Shriram. All rights reserved.
//

import UIKit
import WebKit

class GameDetailsViewController: UIViewController {

    @IBOutlet weak var web: WKWebView!

    @IBOutlet weak var labelName: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var lname = ""
    var urlName = ""
    var imageIsPortrait =  Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lname
    }

    override func viewWillAppear(_ animated: Bool) {

        setStatusBarStyle(isBlack: false)
        
        print("Orientation: \(imageIsPortrait)")
        print("urlName: \(urlName)")
        if imageIsPortrait == true{
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }else{
            
            appDelegate.orientationLock = .landscape
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        }
        self.web.layoutIfNeeded()
        self.web.layoutSubviews()
        let myURL = URL(string:urlName)
        let myRequest = URLRequest(url: myURL!)
        web.load(myRequest)
    }
    
}




