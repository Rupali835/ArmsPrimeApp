//
//  PurchaseCionsHistoryViewController.swift
//  Poonam Pandey
//
//  Created by RazrTech2 on 08/01/19.
//  Copyright © 2019 Razrcorp. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseCionsHistoryViewController: UIViewController {

    @IBOutlet weak var updatedWalletBalanceLabel: UILabel!
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var referTitleLabel: UILabel!
    @IBOutlet weak var referDescriptionLabel: UILabel!
    @IBOutlet weak var referButton: UIButton!
    
    var updatedBalance = ""
    var packagePrice = ""
    var dateAndTime = ""
    var venderId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationView(title: "Transaction Status")
        
        let updtedcoin = updatedBalance
        self.updatedWalletBalanceLabel.text = " Updated ARMS Prime Wallet Balance \(updtedcoin)"
        let packageprice = packagePrice
        self.packagePriceLabel.text = "\(packageprice)"
        let updatedDate = dateAndTime
        self.dateAndTimeLabel.text = "\(updatedDate)"
      
        self.closeButton.layer.borderWidth = 1
        self.closeButton.layer.borderColor = UIColor.black.cgColor
        self.closeButton.layer.cornerRadius = 5
        self.closeButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkMobileVerification()
    }
    
    @IBAction func didTapReferButton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
        if #available( iOS 10.3,*) {
            SKStoreReviewController.requestReview()
        }
    }
    
    @IBAction func HelpAndSupportButtonAction(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
      
        resultViewController.venderid = self.venderId
        resultViewController.vender = true
                
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    func checkMobileVerification() {
         
         if self.checkIsUserLoggedIn() {
             if UserDefaults.standard.bool(forKey: "mobile_verified") == false{
             let isRequiredMobileVerifyPopup = RCValues.sharedInstance.bool(forKey: .verifyMobileOptionalIos)
             let isMobileVerificationMandatory = RCValues.sharedInstance.bool(forKey: .verifyMobileMandetoryIos)
             let isMobileVerified = UserDefaults.standard.bool(forKey: "mobile_verified")
             
             if  let CustomerType = UserDefaults.standard.value(forKey: "customerstatus") as? String {
                 if CustomerType == "epu" {
                     if isRequiredMobileVerifyPopup && !isMobileVerified {
                         
                         openMobileVerificationPopUp(isMandatory: isMobileVerificationMandatory)
                     }
                 }
             }
         }else if UserDefaults.standard.bool(forKey: "email_verified") == false {
             EmailOrMobilePopup()
          }
        }
     }
    
    func EmailOrMobilePopup(){
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let verifyOTPVC : VerifyEmailViewController = storyboard.instantiateViewController(withIdentifier: "VerifyEmailViewController") as! VerifyEmailViewController
            verifyOTPVC.isCommingFromEarnCoinView = true
            
            self.navigationController?.pushViewController(verifyOTPVC, animated: true)
        }
    }
    
    func openMobileVerificationPopUp(isMandatory: Bool) {
        
        DispatchQueue.main.async {
            let mobilePopUpVC = Storyboard.main.instantiateViewController(viewController: MobileVerificationViewController.self)
            mobilePopUpVC.modalPresentationStyle = .custom
            mobilePopUpVC.transitioningDelegate = self
            mobilePopUpVC.isMandatory = isMandatory
            
            if let rootVC = UIApplication.topViewController() {
                if !rootVC.isKind(of: MobileVerificationViewController.self) {
                    rootVC.present(mobilePopUpVC, animated: true)
                }
            }
        }
    }
    
    func showAnimate()
    {
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

// MARK: - UIViewControllerTransitioningDelegate
extension PurchaseCionsHistoryViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        var height: CGFloat = 425
        
        // Increase height if Device has notch
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                height += window.safeAreaInsets.bottom
            }
        }
        
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: .dark, modalHeight: height)
    }
}
