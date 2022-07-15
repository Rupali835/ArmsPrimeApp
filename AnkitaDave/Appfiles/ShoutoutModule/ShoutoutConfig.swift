//
//  ShoutoutConfig.swift
//  VideoGreetings
//
//  Created by Apple on 30/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

// Mark: - Configure Shoutout Module.
class ShoutoutConfig {
    static var baseUrl: String {
        return Constants.App_BASE_URL
    }
    
    static var apiKey: String {
        return Constants.API_KEY
    }
    
    static var authToken: String {
        return Constants.TOKEN
    }
    
    static var artistID: String {
        return Constants.CELEB_ID
    }
    
    static var version: String {
        return Constants.VERSION
    }
    
    static var platform: String {
        return Constants.PLATFORM_TYPE
    }
    
    static var nameOfUser: String {
        let name = CustomerDetails.firstName ?? "Name Unavailable"
        if let _ = CustomerDetails.lastName {
            //name = name + " " + lastName
        }
        
        return name
    }
    
    static var coinsToRequestVG: Int {
        return ArtistConfiguration.sharedInstance().shoutout?.greetingCoins ?? 0
    }
    
    static var currentCoins: Int {
        return CustomerDetails.coins
    }
    
    static var isShoutoutForCharity: Bool {
        return ArtistConfiguration.sharedInstance().shoutout?.donateToCharity ?? false
    }
    
    static var charityDescription: String {
        return ArtistConfiguration.sharedInstance().shoutout?.donateCharityName ?? "No Charity Found"
    }
    
    static var howItWorksVideoURL: String? {
        return ArtistConfiguration.sharedInstance().shoutout?.how_to_video?.url
    }
    
    static var vgHomeBackgroundImage: UIImage? {
        return UIImage(named: "VG_Shoutout_Background")
    }
    
    static var waitListBackgroundImage: UIImage? {
        return UIImage(named: "VG_Shoutout_Background")
    }
    
    static var proceedToPayBackgroundImage: UIImage? {
        return UIImage(named: "VG_Shoutout_Background")
    }
    
    static var artistName: String {
        return Constants.celebrityName
    }
    
    static var termsAndCondURL: String {
        return ArtistConfiguration.sharedInstance().static_url?.shoutouts ?? ""
    }
    
    static func inAppShowLoader() {
        
        if ShoutoutConfig.appActivityIndicator.superview == nil, let window = UIApplication.shared.keyWindow {
            ShoutoutConfig.appActivityIndicator.frame.size = CGSize(width: 40.0, height: 40.0)
            ShoutoutConfig.appActivityIndicator.center = window.center
            window.addSubview(ShoutoutConfig.appActivityIndicator)
        }
        
        ShoutoutConfig.appActivityIndicator.startAnimating()
    }
    
    static func inAppHideLoader() {
        ShoutoutConfig.appActivityIndicator.stopAnimating()
    }
    
    static func inAppCheckIsConntectedToInternet() -> Bool {
        if Reachability.isConnectedToNetwork() == false {
            if let topViewController = UIViewController.topViewController() {
                Alert.show(in: topViewController, title: "", message: Constants.NO_Internet_MSG, actionTitle: "Okay", cancelTitle: nil, comletionForAction: nil)
            }
            return false
        } else {
            return true
        }
    }
    
    static func inAppHandleUpdateCoins(coins: Int?) {
        if let updatedCoins = coins {
            CustomerDetails.coins = updatedCoins
            let coinDict:[String: Int] = ["updatedCoins": updatedCoins]
            DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins)
            CustomMoEngage.shared.updateMoEngageCoinAttribute()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: coinDict)
        }
    }
    
    static func isUserLoggedIn() -> Bool {
        if  UserDefaults.standard.object(forKey: "LoginSession") == nil || (UserDefaults.standard.object(forKey: "LoginSession") as? String) == "LoginSessionOut" || (UserDefaults.standard.value(forKey: "LoginSession") as? String) == "LoginSession"  {
            return false
        } else {
            return true
        }
    }
    
    private init() { }
    
    fileprivate static var appActivityIndicator = NVActivityIndicatorView(frame: CGRect.zero, type: .ballTrianglePath, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), padding: 0.0)
}

extension ShoutoutConfig {
    class InAppNavigation {
        static func toTermsAndCondition(inViewController: UIViewController) {
                    let termeAndCond = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
                    termeAndCond.navigationTitle = "Terms & Conditions"
                    termeAndCond.openUrl = ShoutoutConfig.termsAndCondURL
                    inViewController.navigationController?.pushViewController(termeAndCond, animated: true)
        }
        
        static func toPurchaseCoin(inViewController: UIViewController) {
                    let rechargeWallet = Storyboard.main.instantiateViewController(viewController: PurchaseCoinsViewController.self)
                    inViewController.navigationController?.pushViewController(rechargeWallet, animated: true)
        }
        
        static func toHelpAndSupport(inViewController: UIViewController, transactionId: String) {
                    let helpAndSupport = Storyboard.main.instantiateViewController(viewController: HelpAndSupportViewController.self)
            helpAndSupport.PurchaseId = transactionId
            helpAndSupport.isFromTransDetails = true
                    inViewController.navigationController?.pushViewController(helpAndSupport, animated: true)
        }
        
        static func toFeedback() {
            
        }
    }
}

extension ShoutoutConfig {
    class UserDefaultsManager {
        class func hasUserAcceptedShoutoutTerms() -> Bool {
            return UserDefaults.standard.value(forKey: UserDefaultsKeys.shoutoutTermsAndCondAccept) as? Bool ?? false
        }
        
        class func updateShoutoutTermsAcceptStatus(status: Bool) {
            UserDefaults.standard.set(status, forKey: UserDefaultsKeys.shoutoutTermsAndCondAccept)
            UserDefaults.standard.synchronize()
        }
        
        class func shouldShowWelcomeScreen() -> Bool {
            return UserDefaults.standard.value(forKey: UserDefaultsKeys.shoutoutWelcomeScreenVisibility) as? Bool ?? true
        }
        
        class func updateWelcomeScreenVisibility(shouldShow: Bool) {
            UserDefaults.standard.set(shouldShow, forKey: UserDefaultsKeys.shoutoutWelcomeScreenVisibility)
            UserDefaults.standard.synchronize()
        }
        
        class func hasShoutoutCoachMarkShowedBefore() -> Bool {
            return UserDefaults.standard.value(forKey: UserDefaultsKeys.hasShoutoutCoachMarkShowedBefore) as? Bool ?? false
        }
        
        class func updateShoutoutCoachMarkStatusAsShown() {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasShoutoutCoachMarkShowedBefore)
            UserDefaults.standard.synchronize()
        }
        
        class func clearShoutoutUserData() {
            for key in UserDefaultsKeys.allKeys {
                UserDefaults.standard.removeObject(forKey: key)
            }
            UserDefaults.standard.synchronize()
        }
    }
}

fileprivate struct UserDefaultsKeys {
    static let shoutoutTermsAndCondAccept: String = "shoutoutTermsAndCondAccept"
    static let shoutoutWelcomeScreenVisibility: String = "shoutoutWelcomeScreenVisibility"
    static let hasShoutoutCoachMarkShowedBefore: String = "hasShoutoutCoachMarkShowedBefore"
    
    static let allKeys: [String] = [UserDefaultsKeys.shoutoutTermsAndCondAccept, UserDefaultsKeys.shoutoutWelcomeScreenVisibility]
}
