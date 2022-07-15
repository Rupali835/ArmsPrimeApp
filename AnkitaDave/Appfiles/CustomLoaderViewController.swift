//
//  CustomLoaderViewController.swift
//  HarbhajanSingh
//
//  Created by webwerks on 11/10/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class CustomLoaderViewController: UIViewController {

    @IBOutlet weak var loaderView: UIImageView!
    var loaderIndicator: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaderView.loadGif (name: "ballB")
        loaderView.isHidden = true
        loaderIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loaderIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        loaderIndicator.type = .circleStrokeSpin // add your type
        loaderIndicator.color = .white
        self.view.addSubview(loaderIndicator)
        self.loaderIndicator.startAnimating()

    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
