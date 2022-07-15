//
//  PurchaseLiveViewController.swift
//  Kangna Sharma
//
//  Created by Rohit Mac Book on 13/11/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import UIKit
import MoEngage
import NVActivityIndicatorView
protocol PurchaseContentProtocols {
    func contentPurchaseSuccessful()
}

class PurchaseLiveViewController: BaseViewController {

    @IBOutlet weak var insufficientLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var requiredCoinslabel: UILabel!
    let database = DatabaseManager.sharedInstance
    var delegate : PurchaseContentProtocols?
    var coins : Int?
    var contentId : String?
    var payValid = false
    var purchaseLoader: NVActivityIndicatorView!
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
         view.removeGradient()
        view.backgroundColor = hexStringToUIColor(hex:Colors.darkGray.rawValue).withAlphaComponent(0.5)
        self.showAnimate()
        payValid = true
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor.red.cgColor
        self.payButton.layer.cornerRadius = payButton.layer.frame.height / 2
        self.payButton.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        requiredCoinslabel.text = "\(self.coins ?? 0)"
        if CustomerDetails.coins == 0 {
            payButton.setTitle("RECHARGE", for: .normal)
            payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            self.insufficientLabel.isHidden = false
            
        }
        else if CustomerDetails.coins  < (self.coins)! {
            payButton.setTitle("RECHARGE", for: .normal)
            payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            self.insufficientLabel.isHidden = false
        }
        else {
            payButton.setTitle("PAY", for: .normal)
            self.insufficientLabel.isHidden = true
        }
        
    }
    
    
    @IBAction func payButtonTapped(_ sender: Any) {
   
        if let currentbalance = CustomerDetails.coins, currentbalance >= self.coins ?? 0 {
            
            if (payValid) {
                if let contentId = self.contentId, let coins = self.coins{
                    
                    self.purchaseContents(contentId: contentId , coins: coins)
                    
                    payValid = false
                    
                }
            }
            
        } else {
            if CustomerDetails.coins == 0 {
               
               
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let purchaseViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
                self.navigationController?.pushViewController(purchaseViewController, animated: true)
                self.removeAnimate()
                
            } else {
                self.insufficientLabel.isHidden = false
               
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let purchaseViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
                self.navigationController?.pushViewController(purchaseViewController, animated: true)
                self.removeAnimate()
                
                
            }
       }
    }
    
     @IBAction func cancelButtonTapped(_ sender: Any) {
        removeAnimate()
    }
    
//    func showPurchaseLoader() {
//
//        self.purchaseLoader.startAnimating()
//    }
//
//    func stopPurchaseLoader()  {
//        DispatchQueue.main.async {
//            self.purchaseLoader.stopAnimating()
//
//        }
//
//    }
    
    func purchaseContents(contentId : String, coins : Int) {
        
        if (Reachability.isConnectedToNetwork() == true) {
            
            var apiName = ""
            var dictParams = [String:Any]()
        
                
                apiName = Constants.LIVE_EVENT_PURCHASE
                dictParams = ["entity_id" : contentId, "platform" : Constants.PLATFORM_TYPE, "artist_id": Constants.CELEB_ID, "v":  Constants.VERSION]
           
            
            ServerManager.sharedInstance().postRequest(postData: dictParams, apiName: apiName, extraHeader: nil) { (result) in
                
                switch result {
                case .success(let data):
                    print(data)
                    DispatchQueue.main.async {
                        
                        self.database.insertIntoContentPurchaseTable(purchaseId: contentId)
                        //_ = self.getOfflineUserData()
                        if (data["error"] as? Bool == true) {
 
                            
                            self.showToast(message: "Something went wrong. Please try again!")
                            return
                            
                        } else {
                            if let coinsAfterPurchase = data["data"]["purchase"].dictionaryObject {
                                
                                if let currentCoins = coinsAfterPurchase["coins_after_txn"] as? Int{
                                    CustomerDetails.coins = currentCoins
                                    let database = DatabaseManager.sharedInstance
                                    database.updateCustomerCoins(coinsValue: currentCoins)
                                    CustomMoEngage.shared.updateMoEngageCoinAttribute()
                                }
                               
                                    self.database.createPurchaseTable()
                                    self.database.insertIntoContentPurchaseTable(purchaseId: contentId)
                              
                            }
                            //
                                GlobalFunctions.savePurchaseLiveIdIntoDatabase(content_id: contentId)
                            
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
                            
                            
                            self.delegate?.contentPurchaseSuccessful()
                            print("Purchase Successful")
                        }
                        
                        
                        self.removeAnimate()
                    }
                    
                case .failure(let error):
                    print(error)
                   
                    
                    
                    
                    self.removeAnimate()
                }
                
                
            }
            
        } else {
            
           
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

}
