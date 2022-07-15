//
//  EarnMoreCoinsPopPopViewController.swift
//  AnveshiJain
//
//  Created by Macbook on 06/10/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class EarnMoreCoinsPopPopViewController: UIViewController  {
   
    
    
    @IBOutlet weak var NoThanksButton: UIButton!
    @IBOutlet weak var ShowMeHowButton: UIButton!
    @IBOutlet weak var EarnMoreCoinsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
    }
    
    @IBAction func ShowMeHowButtonAction(_ sender: UIButton) {
        
       let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
       let walletNavigate = mainstoryboad.instantiateViewController(withIdentifier: "EarnMoreCoinsViewController") as! EarnMoreCoinsViewController
       walletNavigate.hidesBottomBarWhenPushed = true
       self.navigationController?.pushViewController(walletNavigate, animated: false)
        hideContainerView()
    }
    
    func hideContainerView() {
        EarnMoreCoinsView.isHidden = true
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func NoThanksButtonAction(_ sender: UIButton) {

        let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
        let walletNavigate = mainstoryboad.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
        walletNavigate.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(walletNavigate, animated: false)
         hideContainerView()
    }

    func setupView(){
        NoThanksButton.layer.cornerRadius = 10
        NoThanksButton.clipsToBounds = true
        ShowMeHowButton.layer.cornerRadius = 10
        ShowMeHowButton.clipsToBounds = true
    }
    
 
    @IBAction func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
       hideContainerView()
    }
}
