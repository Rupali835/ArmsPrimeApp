//
//  NotificationViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 08/08/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import SwiftyJSON
import MoEngage
import Branch

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    var badgeCount : Int!
    let application = UIApplication.shared
    var isLogin = false
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    @IBOutlet weak var allowLabel: UILabel!
    @IBOutlet weak var skipView: UIView!
    @IBOutlet weak var allowView: UIView!
    @IBOutlet weak var skipLabel: UILabel!
    @IBOutlet weak var notifMsgLabel: UILabel!
    @IBOutlet weak var notifHeaderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        allowView.layer.cornerRadius = 4
    }
    
    class func sharedInstance() -> NotificationViewController {
        struct Static {
            static let sharedInstance = NotificationViewController()
        }
        return Static.sharedInstance
    }
    
    @IBAction func yesButtonAction(_ sender: Any) {
        
        //       Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: self)
        } else {
            MoEngage.sharedInstance().registerForRemoteNotificationForBelowiOS10(withCategories: nil)
        }
        //
        if #available(iOS 10.0, *) {
            
            //            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
                    DispatchQueue.main.async {
                        self.application.applicationIconBadgeNumber = self.badgeCount ?? 0
                    }
            })
            
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            DispatchQueue.main.async {
                self.application.applicationIconBadgeNumber = self.badgeCount ?? 0
            }
            application.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        application.registerForRemoteNotifications()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .fade//CATransitionType.push
        //        transition.subtype = CATransitionSubtype.fromRight
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        //        self.present(vc, animated: false, completion: nil)
        
        let resultViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(resultViewController, animated: false)
        
    }
    
    
    @IBAction func skipButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .fade//CATransitionType.push
        //        transition.subtype =  CATransitionSubtype.fromRight
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        //        self.present(vc, animated: false, completion: nil)
        
        let resultViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(resultViewController, animated: false)
        //        self.present(resultViewController, animated: false, completion: nil)
    }
    
}

extension NotificationViewController: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let messageID = notification.request.content.userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        let userInfo = notification.request.content.userInfo
        let json =  JSON(userInfo)
        let type = json["deeplink"].string
        let body = json["body"].string
        if type == "live" && body == "\(Constants.celebrityName) is Live Now"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
        }
        //        print(notification.request.content.userInfo)
        print("notification willPresent\(notification.request.content.userInfo)")
        completionHandler([.alert, .badge, .sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            navigateToScreen(payload: userInfo)
        }
        print("notification didReceive\(userInfo)")
        MoEngage.sharedInstance().userNotificationCenter(center, didReceive: response)
        Branch.getInstance().handlePushNotification(userInfo)
        if userInfo["moengage"] != nil {
            print("moengage notif")
            handleMoEngageInAppNavigateToScreen(dict: userInfo)
            //screenName
        }
        
        completionHandler()
    }
    
    
    
    func navigateToScreen(payload: [AnyHashable: Any]) {
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                print("user is already logged in test")
            } else {
                return
            }
        } else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navigationController =  UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            let json =  JSON(payload)
            let type = json["deeplink"].string
            let content_id = json["content_id"].string

            let body = json["body"].string
            if type == "live" && body == "\(Constants.celebrityName) is Live Now" {
                print("called live screen")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
                UserDefaults.standard.set(true, forKey: "liveStatus")
                UserDefaults.standard.synchronize()
                let currentNav: UINavigationController = UIApplication.shared.keyWindow?.rootViewController as!  UINavigationController
                let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
                currentNav.viewControllers = [vc]
                let vc2 = storyboard.instantiateViewController(withIdentifier: "LiveScreenViewController_New") as! LiveScreenViewController_New
                vc2.hidesBottomBarWhenPushed = true
                currentNav.pushViewController(vc2, animated: false)
                
            } else if content_id?.count != 0 && content_id != nil{
                goToMainVCForFirebasePushNotif (bucketCode: type ?? "", contentIDCode: content_id)
            }
            
        }
    }

    func goToMainVCForFirebasePushNotif (bucketCode: String , contentIDCode: String?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("current controller \(UIApplication.shared.delegate?.window??.rootViewController)")
        
        let currentNav: UINavigationController =  UIApplication.shared.delegate?.window??.rootViewController as!  UINavigationController
        
        let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
        
        if contentIDCode?.count != 0 {
            print("user loogged in \((self.checkIsUserLoggedIn() ? "YES": "NO")) contentID \(String(describing: contentIDCode)) current \(currentNav)")
            let bucket : BucketContentDetailsViewController = storyboard.instantiateViewController(withIdentifier: "BucketContentDetailsViewController") as! BucketContentDetailsViewController
            bucket.contedID = contentIDCode ?? ""
            bucket.bucketcodeStr = bucketCode
            
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(bucket, animated: false)
        }
    }
    
    func handleMoEngageInAppNavigateToScreen(dict : [AnyHashable: Any]) {
        guard (dict["app_extra"] as? [String : Any]) != nil else { return }
        let appExtraDict = dict["app_extra"] as! [String : Any]
        if appExtraDict["screenName"] != nil{
            let screenName = appExtraDict["screenName"] as? String
            navigateToRespectiveScreenMoEngage(screenName: screenName ?? "")
        } else {
            let ScreenData = appExtraDict["screenData"] as! [String : Any]
            navigateToRespectiveScreenMoEngages(screenName: ScreenData)
            guard let screenName = ScreenData["deeplink"] as? String else { return }
            if screenName == "directline" || screenName == "live" {
                return
            }
            guard let content_id = ScreenData["content_id"]  else { return }
            let id: String = content_id as! String
            goToMainVCForFirebasePushNotif (bucketCode: screenName, contentIDCode: id)
        }
    }

    func navigateToRespectiveScreenMoEngages(screenName: [String : Any]) {
        guard let screen = screenName["deeplink"]  else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let currentNav: UINavigationController = UIApplication.shared.keyWindow?.rootViewController as!  UINavigationController
        let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
        
        let screens: String  = screen as! String
        if screens == "directline"{
            let vc2 : DirectLinkViewController = storyboard.instantiateViewController(withIdentifier: "DirectLinkViewController") as! DirectLinkViewController
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(vc2, animated: false)
            return
        } else if let screenName = screenName["deeplink"]{
            let liveScreen: String  = screenName as! String
            if liveScreen == "live"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
                UserDefaults.standard.set(true, forKey: "liveStatus")
                UserDefaults.standard.synchronize()
                currentNav.viewControllers = [vc]
    
                let vc2 = storyboard.instantiateViewController(withIdentifier: "LiveScreenViewController_New") as! LiveScreenViewController_New
                vc2.hidesBottomBarWhenPushed = true
                currentNav.pushViewController(vc2, animated: false)
            }
            
        }
    }

    //MARK:- Navigate to screen
    func navigateToRespectiveScreenMoEngage(screenName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let currentNav: UINavigationController = UIApplication.shared.keyWindow?.rootViewController as!  UINavigationController
        let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
        
        var bucketIndex: Int = GlobalFunctions.findIndexOfBucketCode(code: screenName) ?? 0
        if bucketIndex > 3 {
            bucketIndex = 3
        }
        vc.selectedIndex = bucketIndex
        vc.tabBar.isHidden = false
        
        if screenName == "help&support"{
            let vc2 : HelpAndSupportViewController = storyboard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(vc2, animated: false)
        } else if screenName == "celebyte"{
            Storyboard.videoGreetings.instantiateViewController(viewController: VideoGreetingsViewController.self)
        } else if screenName == "wallet"{
            let vc2 : PurchaseCoinsViewController = storyboard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(vc2, animated: false)
        } else if screenName == "directline"{
            let vc2 : DirectLinkViewController = storyboard.instantiateViewController(withIdentifier: "DirectLinkViewController") as! DirectLinkViewController
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(vc2, animated: false)
        } else if screenName == "profile"{
            let vc2 : ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(vc2, animated: false)
        } else if screenName == "top-fan"{
            let vc2 : MyFavoriteFansViewController = storyboard.instantiateViewController(withIdentifier: "MyFavoriteFansViewController") as! MyFavoriteFansViewController
            vc2.selectedIndexVal = GlobalFunctions.findIndexOfBucketCode(code: screenName) ?? 5
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(vc2, animated: false)
        } else if screenName == "foodgasm"{
            let vc2 : FoodgasmViewController = storyboard.instantiateViewController(withIdentifier: "FoodgasmViewController") as! FoodgasmViewController
            vc2.selectedIndexVal = GlobalFunctions.findIndexOfBucketCode(code: screenName) ?? 0
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(vc2, animated: false)
        } else if screenName == "bodyholic"{
            let vc2 : BodyholicViewController = storyboard.instantiateViewController(withIdentifier: "BodyholicViewController") as! BodyholicViewController
            vc2.selectedIndexVal = GlobalFunctions.findIndexOfBucketCode(code: screenName) ?? 0
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(vc2, animated: false)
        } else if screenName == "live"{
 
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
            UserDefaults.standard.set(true, forKey: "liveStatus")
            UserDefaults.standard.synchronize()
            currentNav.viewControllers = [vc]
     
            let vc2 = storyboard.instantiateViewController(withIdentifier: "LiveScreenViewController_New") as! LiveScreenViewController_New
            vc2.hidesBottomBarWhenPushed = true
            currentNav.pushViewController(vc2, animated: false)
        } else if screenName == "story" {
            vc.navigateToStory = true
            currentNav.pushViewController(vc, animated: false)
        }
        else {
            currentNav.pushViewController(vc, animated: false)
        }

    }
  
}

