//
//  CopyToClipViewController.swift
//  HotShot
//
//  Created by webwerks on 30/08/19.
//  Copyright © 2019 com.armsprime.hotshot. All rights reserved.
//

import UIKit

class CopyToClipViewController: UIViewController {

    @IBOutlet weak var copyLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
//        popUpView.backgroundColor = hexStringToUIColor(hex: MyColors.pageBackground)
//        copyLabel.textColor = hexStringToUIColor(hex: MyColors.cardBackground)
        copyLabel.font = UIFont(name: AppFont.medium.rawValue, size: 17.0)
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    func showAnimate() {
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
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
