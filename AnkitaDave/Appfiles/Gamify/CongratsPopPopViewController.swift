//
//  CongratsPopPopViewController.swift
//  AnveshiJain
//
//  Created by Macbook on 12/10/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class CongratsPopPopViewController: UIViewController {

    @IBOutlet weak var updatedBalanceLable: UILabel!
    @IBOutlet weak var addedCoinsLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var congratsView: UIView!
    var Messages = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.coinValue()
        self.addedCoinsLabel.text = Messages
    }
    
    func coinValue(){
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getCoins, extraHeader: nil) { (result) in
        switch result {
        case .success(let data):
            print(data)
            if (data["error"] as? Bool == true) {
                // self.showToast(message: "Something went wrong. Please try again!")
                return
                
            } else {
                if let coins = data["data"]["coins"].int {
                    CustomerDetails.coins = coins
                    self.updatedBalanceLable.text = "\(coins)"
                    let database = DatabaseManager.sharedInstance
                    database.updateCustomerCoins(coinsValue: coins)
                    let coinDict:[String: Int] = ["updatedCoins": coins]
                               
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatedCoins"), object: nil, userInfo: coinDict)
                }
            }
        case .failure(let error):
            print(error)
            
        }
      }
    
    }
    func hideContainerView() {
        congratsView.isHidden = true
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func NoThanksButtonAction(_ sender: UIButton) {

         hideContainerView()
    }

    func setupView(){
           dismissButton.layer.cornerRadius = 10
           dismissButton.clipsToBounds = true
       }
       
    
       @IBAction func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
          hideContainerView()
       }
}
