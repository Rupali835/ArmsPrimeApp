//
//  PurchaseContentViewController.swift
//  Poonam Pandey
//
//  Created by Razrcorp  on 02/07/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import MoEngage
import NVActivityIndicatorView
protocol PurchaseContentProtocol {
    func contentPurchaseSuccessful( index : Int, contentId: String?)
}

//extension PurchaseContentProtocol {
//    func contentPurchaseSuccessful( index : Int, contentId: String?  = nil) {
//
//    }
//}

protocol PurchaseStickerProtocol {
    func StickerPurchaseSuccessful( index : Int)
}
class PurchaseContentViewController: BaseViewController {
    
    @IBOutlet weak var currentBalance: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var insufficientLabel: UILabel!
    var contentId : String?
    var coins : Int?
    var currentContent : List?
    var contentIndex = 0
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var requiredCoinslabel: UILabel!
    let database = DatabaseManager.sharedInstance
    var delegate : PurchaseContentProtocol?
    var stickerDelegate : PurchaseStickerProtocol?
    private var overlayView = LoadingOverlay.shared
    var purchaseLoader: NVActivityIndicatorView!
    @IBOutlet weak var cancelButtonWidth: NSLayoutConstraint!
    var payValid = false
    var isComingFrom = ""
    @IBOutlet weak var cancelButtonLeading: NSLayoutConstraint!
    var selectedBucketCode: String?
    var selectedBucketName: String?
    var contentName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.removeGradient()
        containerView.isHidden = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        //        self.showAnimate()
        payValid = true
        //        self.containerView.layer.cornerRadius = 10.0
        //        self.titleLabel.roundCorners(corners: [.topLeft, .topLeft], radius: 10.0)//sayali
        self.payButton.layer.cornerRadius = 5.0
        //        self.cancelButton.layer.cornerRadius = 5.0
        //        self.cancelButton.layer.borderWidth = 2.0
        //        self.cancelButton.layer.borderColor = UIColor.red.cgColor
        //_ = self.getOfflineUserData()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if let currentbalance = CustomerDetails.coins{
            self.currentBalance.text =  "\(currentbalance ?? 0)"
        }
        if let currentbalance = CustomerDetails.coins, currentbalance >= self.coins ?? 0 {
            
            let strCoins : String = "\(CustomerDetails.coins ?? 0)"
            self.currentBalance.text =  strCoins
            
        } else {
            
            self.insufficientLabel.isHidden = false
        }

        if  let currentbalance = CustomerDetails.coins, currentbalance == 0 {
            payButton.setTitle("RECHARGE", for: .normal)
            //            payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            
        } else if  CustomerDetails.coins ?? 0  < (self.coins ?? 0) {
            payButton.setTitle("RECHARGE", for: .normal)
            //            payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
        else {
            payButton.setTitle("PAY", for: .normal)
        }
        
        if isComingFrom == "DirectLine" {
            
            requiredCoinslabel.text = "This message cost \(self.coins ?? 0) coins"
            return
        }
        
        
        if isComingFrom == "private_video_call" {
            
            if let currentbalance = CustomerDetails.coins, currentbalance == 0 {
                payButton.setTitle("RECHARGE NOW", for: .normal)
                //            payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                
            } else if CustomerDetails.coins ?? 0 < (self.coins ?? 0) {
                payButton.setTitle("RECHARGE NOW", for: .normal)
                //            payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            }
            else {
                payButton.setTitle("RECHARGE NOW", for: .normal)
            }
            requiredCoinslabel.text = "Don't have enough coins?"
            requiredCoinslabel.textColor = .systemRed
            return
        }
        
        
        
        
        if isComingFrom == "Wardrobe" {
            
            requiredCoinslabel.text = "This product cost is \(self.coins ?? 0) coins"
            return
        }
        
        if isComingFrom == "stickers" {
            
            requiredCoinslabel.text = "You need to pay \(self.coins ?? 0) coins to purchase"
            //            titleLabel.text = "Purchase Stickers"
            
        }
        else if isComingFrom == "live_event_purchase" {
            requiredCoinslabel.text = "You need to pay \(self.coins ?? 0) coins to view this event"
            //            titleLabel.text = "Purchase Event"
        }
        else if isComingFrom == "call_request" {
            
            requiredCoinslabel.text = "You need to pay \(self.coins ?? 0) coins to send call request"
            
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        else {
            
            requiredCoinslabel.text = "You need to pay \(self.coins ?? 0) coins to view this content"
            //            titleLabel.text = "Purchase Content"
        }
        
        //        self.navigationItem.backBarButtonItem?.title = ""
        //        if UIDevice().userInterfaceIdiom == .phone {
        //            switch UIScreen.main.nativeBounds.height {
        //
        //            case 960:
        //                print("iPhone 4")
        //                self.cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        //                self.payButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        //
        //            case 1136:
        //                print("iPhone 5 or 5S or 5C")
        //                self.cancelButtonWidth.constant = 120
        //                // self.cancelButtonSpacing.constant = 40
        //                self.cancelButtonLeading.constant = 20
        //            case 1334:
        //                print("iPhone 6/6S/7/8")
        //
        //            case 1920, 2208:
        //                print("iPhone 6+/6S+/7+/8+")
        //            case 2436:
        //                print("iPhone X")
        //            default:
        //                print("unknown")
        //            }
        //        }
        // Do any additional setup after loading the view.
        
        purchaseLoader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        purchaseLoader.center = CGPoint(x: view.center.x, y: view.center.y-50)
        purchaseLoader.type = .ballTrianglePath // add your type
        purchaseLoader.color = .white
        self.view.addSubview(purchaseLoader)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(isComingFrom == "live_event_purchase" ? true : false, animated: false)
        
        navigationController?.setNavigationBarHidden(isComingFrom == "call_request" ? true : false, animated: false)
        
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //        self.navigationController?.navigationBar.isHidden = false
    //
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapCancel(_ sender: UITapGestureRecognizer) {
        let  payloadDict = NSMutableDictionary()
        payloadDict.setObject(isComingFrom.count != 0 ? isComingFrom : "Content", forKey: "content_type" as NSCopying)
        payloadDict.setObject(self.contentId ?? "" , forKey: "content_purchase_product_id" as NSCopying)
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Purchase_cancel", extraParamDict: payloadDict)
        self.hideContainerView()
    }
    
    func hideContainerView() {
        containerView.isHidden = true
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func payButtonTapped(_ sender: Any) {
        //        let  payloadDict = NSMutableDictionary()
        //        payloadDict.setObject(isComingFrom.count != 0 ? isComingFrom : "Content", forKey: "content_type" as NSCopying)
        //        payloadDict.setObject(self.contentId ?? "" , forKey: "content_purchase_product_id" as NSCopying)
        //        CustomMoEngage.shared.sendEventUIComponent(componentName: "Purchase_pay", extraParamDict: payloadDict)
        
        
        if isComingFrom == "private_video_call" {
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
          let purchaseViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
          self.navigationController?.pushViewController(purchaseViewController, animated: true)
          containerView.isHidden = true
          self.view.removeFromSuperview()
          self.removeFromParent()
        }
        
        
        if isComingFrom == "stickers" {
            
            if let currentbalance = CustomerDetails.coins, currentbalance >= self.coins ?? 0 {
                
                print("comming from stickers view")
                self.stickerPurchase()
            } else {
                if CustomerDetails.coins == 0 {
                    
                    if self.isComingFrom == "live_event_purchase"{
                        CustomMoEngage.shared.sendEventForContentPurchaseLive(contentName: self.contentName ?? "", contentId: self.contentId ?? "" , coins: self.coins ?? 0, status: "Failed", reason: "No coins in account")
                    } else {
                        CustomMoEngage.shared.sendEventForContentPurchase(list: currentContent, bucketCode: selectedBucketCode ?? "", bucketName: selectedBucketName ?? "", status: "Failed", reason: "No coins in account", contentId: self.contentId ?? "", coins: self.coins ?? 0)
                    }
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let purchaseViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
                    
                    purchaseViewController.hideRightBarButtons = hideRightBarButtons
                    self.navigationController?.pushViewController(purchaseViewController, animated: true)
                    self.hideContainerView()
                    
                } else {
                    self.insufficientLabel.isHidden = false
                    if self.isComingFrom == "live_event_purchase"{
                        CustomMoEngage.shared.sendEventForContentPurchaseLive(contentName: self.contentName ?? "", contentId: self.contentId ?? "" , coins: self.coins ?? 0, status: "Failed", reason: "You have insufficient balance.")
                    } else {
                        CustomMoEngage.shared.sendEventForContentPurchase(list: currentContent, bucketCode: selectedBucketCode ?? "", bucketName: selectedBucketName ?? "", status: "Failed", reason: "You have insufficient balance.", contentId: self.contentId ?? "", coins: self.coins ?? 0)
                    }
                    //                    let alert = UIAlertController(title: "", message: "You have insufficient balance. Please recharge your account!", preferredStyle: UIAlertController.Style.alert)
                    //                    alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let purchaseViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
                    
                    purchaseViewController.hideRightBarButtons = hideRightBarButtons
                    self.navigationController?.pushViewController(purchaseViewController, animated: true)
                    self.hideContainerView()
                    
                    
                }
            }
        } else {
            
            if let currentbalance = CustomerDetails.coins, currentbalance >= self.coins ?? 0 {
                
                if (payValid) {
                    if let contentId = self.contentId, let coins = self.coins{
                        
                        self.purchaseContents(contentId: contentId , coins: coins)
                        
                        payValid = false
                        
                    }
                }
                
            } else {
                if CustomerDetails.coins == 0 {
                    if self.isComingFrom == "live_event_purchase"{
                        CustomMoEngage.shared.sendEventForContentPurchaseLive(contentName: self.contentName ?? "", contentId: self.contentId ?? "" , coins: self.coins ?? 0, status: "Failed", reason: "No coins in account")
                    } else {
                        CustomMoEngage.shared.sendEventForContentPurchase(list: currentContent, bucketCode: selectedBucketCode ?? "", bucketName: selectedBucketName ?? "", status: "Failed", reason: "No coins in account", contentId: self.contentId ?? "", coins: self.coins ?? 0)
                    }
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let purchaseViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
                    
                    purchaseViewController.hideRightBarButtons = hideRightBarButtons
                    self.navigationController?.pushViewController(purchaseViewController, animated: true)
                    self.hideContainerView()
                    
                } else {
                    self.insufficientLabel.isHidden = false
                    //
                    if self.isComingFrom == "live_event_purchase"{
                        CustomMoEngage.shared.sendEventForContentPurchaseLive(contentName: self.contentName ?? "", contentId: self.contentId ?? "" , coins: self.coins ?? 0, status: "Failed", reason: "You have insufficient balance.")
                    } else {
                        CustomMoEngage.shared.sendEventForContentPurchase(list: currentContent, bucketCode: selectedBucketCode ?? "", bucketName: selectedBucketName ?? "", status: "Failed", reason: "You have insufficient balance.", contentId: self.contentId ?? "", coins: self.coins ?? 0)
                    }
                    
                    //                    let alert = UIAlertController(title: "", message: "You have insufficient balance. Please recharge your account!", preferredStyle: UIAlertController.Style.alert)
                    //                    alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let purchaseViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
                    
                    purchaseViewController.hideRightBarButtons = hideRightBarButtons
                    self.navigationController?.pushViewController(purchaseViewController, animated: true)
                    self.hideContainerView()
                }
            }
        }
    }
    
    func stickerPurchase() {
        
        if (Reachability.isConnectedToNetwork() == true) {
            self.showLoader()
            ServerManager.sharedInstance().postRequest(postData: ["v":Constants.VERSION], apiName: Constants.STICKERS_PURCHASE, extraHeader: nil) { (result) in
                
                switch result {
                case .success(let data):
                    print(data)
                    DispatchQueue.main.async {
                        
                        if (data["error"] as? Bool == true) {
                            //                            let payloadDict = NSMutableDictionary()
                            //                            payloadDict.setObject(self.contentId ?? "" , forKey: "content_purchase_product_id" as NSCopying)
                            //                            payloadDict.setObject(self.isComingFrom.count != 0 ? self.isComingFrom : "Content", forKey: "UiComponent" as NSCopying)
                            //                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseContent, action: "", status: "Failed", reason: "\(data["error"])", extraParamDict: payloadDict)
                            CustomMoEngage.shared.sendEventForContentPurchase(list: self.currentContent, bucketCode: self.selectedBucketCode ?? "", bucketName: self.selectedBucketName ?? "", status: "Failed", reason: "\(data["error"])", contentId: self.contentId ?? "", coins: self.coins ?? 0)
                            self.stopLoader()
                            self.showToast(message: "Something went wrong. Please try again!")
                            return
                            
                        } else {
                            if let coinsAfterPurchase = data["data"]["coins_after_txn"].int {
                                
                                CustomerDetails.coins = coinsAfterPurchase
                                let database = DatabaseManager.sharedInstance
                                database.updateCustomerCoins(coinsValue: coinsAfterPurchase)
                                let userDetails = self.getOfflineUserData()
                                userDetails.purchaseStickers = true
                                userDetails.coins = coinsAfterPurchase
                                DatabaseManager.sharedInstance.insertIntoCustomer(customer: userDetails)
                            }
                            //                            let payloadDict = NSMutableDictionary()
                            //                            payloadDict.setObject(self.contentId ?? "" , forKey: "content_purchase_product_id" as NSCopying)
                            //                            payloadDict.setObject(self.isComingFrom.count != 0 ? self.isComingFrom : "Content", forKey: "UiComponent" as NSCopying)
                            //                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseContent, action: "", status: "Success", reason: "", extraParamDict: payloadDict)
                            CustomMoEngage.shared.sendEventForContentPurchase(list: self.currentContent, bucketCode: self.selectedBucketCode ?? "", bucketName: self.selectedBucketName ?? "", status: "Success", reason: "", contentId: self.contentId ?? "", coins: self.coins ?? 0)
                            self.delegate?.contentPurchaseSuccessful(index: self.contentIndex, contentId: self.contentId)
                            print("Purchase Successful")
                        }
                        
                        self.stopLoader()
                        self.hideContainerView()
                    }
                    
                case .failure(let error):
                    print(error)
                    //                    let payloadDict = NSMutableDictionary()
                    //                    payloadDict.setObject(self.contentId ?? "" , forKey: "content_purchase_product_id" as NSCopying)
                    //                    payloadDict.setObject(self.isComingFrom.count != 0 ? self.isComingFrom : "Content", forKey: "UiComponent" as NSCopying)
                    //                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseContent, action: "", status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
                    CustomMoEngage.shared.sendEventForContentPurchase(list: self.currentContent, bucketCode: self.selectedBucketCode ?? "", bucketName: self.selectedBucketName ?? "", status: "Failed", reason: error.localizedDescription, contentId: self.contentId ?? "", coins: self.coins ?? 0)
                    self.stopLoader()
                    self.hideContainerView()
                }
                
                
            }
            
        } else {
            
            self.stopLoader()
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    func showPurchaseLoader() {
        
        self.purchaseLoader.startAnimating()
    }
    
    func stopPurchaseLoader()  {
        DispatchQueue.main.async {
            self.purchaseLoader.stopAnimating()
            
        }
        
    }
    func purchaseContents(contentId : String, coins : Int) {
        
        if (Reachability.isConnectedToNetwork() == true) {
            self.showPurchaseLoader()
            var apiName = ""
            var dictParams = [String:Any]()
            
            if isComingFrom == "live_event_purchase" {
                
                apiName = Constants.LIVE_EVENT_PURCHASE
                dictParams = ["entity_id" : contentId, "platform" : Constants.PLATFORM_TYPE, "artist_id": Constants.CELEB_ID]
            }
            else {
                
                apiName = Constants.CUSTOMER_PURCHASE
                dictParams = ["content_id" : contentId, "coins" : coins, "platform" : Constants.PLATFORM_TYPE,"artist_id": Constants.CELEB_ID, "v":  Constants.VERSION]
            }
            
            ServerManager.sharedInstance().postRequest(postData: dictParams, apiName: apiName, extraHeader: nil) { (result) in
                
                switch result {
                case .success(let data):
                    print(data)
                    DispatchQueue.main.async {
                        
                        self.database.insertIntoContentPurchaseTable(purchaseId: contentId)
                        //_ = self.getOfflineUserData()
                        if (data["error"] as? Bool == true) {
                            if self.isComingFrom == "live_event_purchase"{
                                CustomMoEngage.shared.sendEventForContentPurchaseLive(contentName: self.contentName ?? "", contentId: self.contentId ?? "" , coins: coins, status: "Failed", reason: "\(data["error"])")
                            } else {
                                CustomMoEngage.shared.sendEventForContentPurchase(list: self.currentContent, bucketCode: self.selectedBucketCode ?? "", bucketName: self.selectedBucketName ?? "", status: "Failed", reason: "\(data["error"])", contentId: self.contentId ?? "", coins: self.coins ?? 0)
                            }
                            
                            self.stopLoader()
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
                                if self.isComingFrom != "live_event_purchase" {
                                    self.database.createPurchaseTable()
                                    self.database.insertIntoContentPurchaseTable(purchaseId: contentId)
                                }
                            }
                            //
                            
                            if self.isComingFrom == "live_event_purchase" {
                                GlobalFunctions.savePurchaseLiveIdIntoDatabase(content_id: contentId)
                                CustomMoEngage.shared.sendEventForContentPurchaseLive(contentName: self.contentName ?? "", contentId: self.contentId ?? "" , coins: coins, status: "Success", reason: "")
                            } else {
                                CustomMoEngage.shared.sendEventForContentPurchase(list: self.currentContent, bucketCode: self.selectedBucketCode ?? "", bucketName: self.selectedBucketName ?? "", status: "Success", reason:"", contentId: self.contentId ?? "", coins: self.coins ?? 0)
                            }
                            
                            self.delegate?.contentPurchaseSuccessful(index: self.contentIndex, contentId: self.contentId)
                            print("Purchase Successful")
                        }
                        
                        self.stopPurchaseLoader()
                        self.hideContainerView()
                    }
                    
                case .failure(let error):
                    print(error)
                    if self.isComingFrom == "live_event_purchase"{
                        CustomMoEngage.shared.sendEventForContentPurchaseLive(contentName: self.contentName ?? "", contentId: self.contentId ?? "" , coins: coins, status: "Failed", reason: error.localizedDescription)
                    } else {
                        CustomMoEngage.shared.sendEventForContentPurchase(list: self.currentContent, bucketCode: self.selectedBucketCode ?? "", bucketName: self.selectedBucketName ?? "", status: "Failed", reason:error.localizedDescription, contentId: self.contentId ?? "", coins: self.coins ?? 0)
                    }
                    
                    self.stopPurchaseLoader()
                    self.hideContainerView()
                }
            }
            
        } else {
            
            self.stopPurchaseLoader()
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
    
    func removeAnimate() {
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
