//
//  AppDelegate.swift
//  AnveshiJain
//
//  Created by webwerks on 15/05/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import UserNotifications
import GoogleSignIn
import Alamofire
import SwiftyJSON
import StoreKit
import Siren
import AudioPlayerManager
import MediaPlayer
import FirebaseDynamicLinks
import SwiftyStoreKit
import SQLite
import FirebaseMessaging
import MoEngage
import Branch
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate, GIDSignInDelegate ,UNUserNotificationCenterDelegate {
    var orientationLock = UIInterfaceOrientationMask.portrait
    var window: UIWindow?
    var isLogin = false
    let gcmMessageIDKey = "gcm.message_id"
    var badgeCount : Int!
    var bucketsArray : [List]!
    let database = DatabaseManager.sharedInstance
    var buckets : [List]!
    var bucketId : String?
    var previousVC : UIViewController?
    var cont : String = " "
    var isCheckAgoraChannelExecuting = false
    var isCheckStoryExecuting = false
    var artistConfig = ArtistConfiguration.sharedInstance()
    var artistConfigLoaderHandler: ((Bool?) -> ())?
    var story: APMStory?
    var playerViewState: PlayerState?
    var shouldShowSticker = true
    weak var tabVC: CustomTabViewController? = nil
    private let screenProtecter = ScreenProtector()
    var ageDiff : Int? = 0
    //MARK:-
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.set(false, forKey: "storyStatus")
        UserDefaults.standard.set(false, forKey: "liveStatus")
        UserDefaults.standard.set("first", forKey: "relaunch")
        UserDefaults.standard.set("firstReplay", forKey: "relaunchReply")
        UserDefaults.standard.synchronize()
        mobileVerificationSetUp()
//         UIFont.overrideInitialize()
        print("device Id token: \(Constants.DEVICE_ID)")
        //        Thread.sleep(forTimeInterval: 1.0)
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.beginReceivingRemoteControlEvents()
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            }
        } catch {
            print(error)
        }
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
        AppLaunchManager.registerLaunch()
        
        let lastDate = UserDefaults.standard.value(forKey: "lastUpdateBucketDate") as? String
        //RunLoop.current.run(until: Date(timeIntervalSinceNow: 4.0))
        print("[debug] => saved default bucket date \(lastDate)")
        artistData { (status) in
            if status {
                let currentLastDate = self.artistConfig.last_updated_buckets ?? ""
                if lastDate == nil {
                    print("[debug] => last date not found")
                    //RunLoop.current.run(until: Date(timeIntervalSinceNow: 4.0))
                    self.downloadBucket()
                } else if currentLastDate != lastDate! {
                    print("[debug] => last date not match")
                    //RunLoop.current.run(until: Date(timeIntervalSinceNow: 4.0))
                    self.downloadBucket()
                } else {
                    self.getLatestContets()
                }
            } else {
                self.getLatestContets()
            }
            
         //   self.launchFirstControllers()
        }
        
        launchFirstControllers()
        
//        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
//        if !hasLoginKey {
//            do {
//                let userItem = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName)
//                if userItem.count > 0 {
//                    try userItem[0].deleteItem()
//                }
//            } catch{
//                print("Error while delete keychain item")
//            }
//        }
        self.handleInAppPurchase()
        
        FirebaseApp.configure()
        let _ = RCValues.sharedInstance
        
        Siren.shared.wail()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            //UNUserNotificationCenter.current().delegate = //NotificationViewController.sharedInstance()
            
        } else {
            
        }
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Parikshit
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        UINavigationBar.appearance().tintColor = .white

//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        
        IQKeyboardManager.shared.enable = true
        
        self.initializeDatabase()
        
        if let option = launchOptions {
            let info = option[UIApplication.LaunchOptionsKey.remoteNotification]
            if (info != nil) {
            }}
        
        if let loginStatus = UserDefaults.standard.object(forKey: "LoginSession") as? String {
            if loginStatus == "LoginSessionIn" {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, version == "2.0" && !UserDefaults.standard.bool(forKey: "DataMigrationDone") {
                    UserDefaults.standard.set(true, forKey: "DataMigrationDone")
                    UserDefaults.standard.synchronize()
                    self.getUsersMetaData()
                } else {
                    self.getUsersMetaData()
                }
            }
        }
        
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return true
        }
        gai.tracker(withTrackingId: "UA-142153407-2")
        gai.defaultTracker.allowIDFACollection = true
        if let event = GAIDictionaryBuilder.createEvent(withCategory: "ui_action", action: "app_launched", label: "launch", value: nil).build() as? [AnyHashable : Any] {
            gai.defaultTracker.send(event)
        }
        gai.trackUncaughtExceptions = true
  //      self.getLatestContets()
        
        //MOEngage code
        CustomMoEngage.shared.configureMoEngage(appId: Constants.moEnagegAppID, application: application, launchOptions: launchOptions)
        
        /**
         comment below statment when go for production (uncomment when you are using test key of branch)
         **/
        Branch.setUseTestBranchKey(false)
        
        // listener for Branch Deep Link data
        CustomBranchHandler.shared.configureBranchIO(application: application, launchOptions: launchOptions)
        /**
         Below line of code use for to check whether branch SDK integration is properly done or not.
         **/
        //       Branch.getInstance().validateSDKIntegration() // comment this when upload for production
        
        // STOP Screen Recordning and Scrren Capture
        screenProtecter.startPreventingRecording()
       // screenProtecter.startPreventingScreenshot()
        
        return true
    }
    
    func launchFirstControllers() {
        
        if AppLaunchManager.isFirstLaunch() {
            //new changes
            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
            if notificationType == [] {
                print("notifications are NOT enabled")
                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : NotificationViewController = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
                navigationController?.navigationBar.isHidden = true
                navigationController?.pushViewController(vc, animated: false)
            } else {
                print("notifications are enabled")
                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //                if let vc : MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                //                    navigationController?.pushViewController(vc, animated: false)
                //                }
                if let vc : DobCheckerVC = storyboard.instantiateViewController(withIdentifier: "DobCheckerVC") as? DobCheckerVC {
                    vc.isNew = true
                    navigationController?.pushViewController(vc, animated: false)
                }
            }
        } else {
            
            //exising user
            
            validDOBData()
            
         
            //            if let vc : MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            //                navigationController?.pushViewController(vc, animated: false)
            //            }
        }
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    func validDOBData()
    {
        
        if let loginStatus = UserDefaults.standard.object(forKey: "LoginSession") as? String {
            if loginStatus == "LoginSessionIn" {
                
            print("User login here")
            
                if UserDefaults.standard.value(forKey: "dob") as? String != "" && UserDefaults.standard.value(forKey: "dob") as? String != nil {
                    if  let ipdate = (UserDefaults.standard.value(forKey: "dob") as? String) {
                        print(ipdate)
                        
                       // self.txtSelectDob.text = ipdate
                        // check dob year
                        //
                    //   var dipdate = "2019-Jan-22 00:00:00"
                        let dateFormatter = DateFormatter()

                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                     if let dateFromString : NSDate = dateFormatter.date(from: ipdate) as NSDate? {
                        dateFormatter.dateFormat = "dd-MMMM-yyyy" //mm-dd-yyyy
                        let datenew = dateFormatter.string(from: dateFromString as Date)

                        var diffs = Calendar.current.dateComponents([.year], from: dateFromString as Date, to: Date())
                        print(diffs.year!)
                        
                        UserDefaults.standard.setValue(diffs.year, forKey: "age_difference")
                    //    diffs.year = 10
                      //  diffs.year = 15
                        if diffs.year! < 16
                        {
                            
                            let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let vc : DobCheckerVC = storyboard.instantiateViewController(withIdentifier: "DobCheckerVC") as? DobCheckerVC {
                                vc.isNew = false
                                vc.isDobPresent = datenew
                            navigationController?.pushViewController(vc, animated: false)
                            }
                            
                            //if year is less than 12 then update dob... open datpicker
                            
                           // self.showAlertForDobButton(title: "UPDATE DOB", msg: "Please update your dob for accessing app content")
                            
                           // self.goToDobCheck(isNew: false)
                            
                        }else{
                            
                            UserDefaults.standard.setValue(diffs.year, forKey: "age_difference")
                            UserDefaults.standard.synchronize()
                            let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as? CustomTabViewController {
                            vc.age_difference = diffs.year
                            navigationController?.pushViewController(vc, animated: false)
                            }
                            
                          //  self.goToTabMenu(desc: nil, isRewardGet: false)
                         //    call homepage content
                          //  self.showAlert(message: "You are eligible for app")
                          
                        }

                     }

                    }
                    
                }else
                {
                    let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let vc : DobCheckerVC = storyboard.instantiateViewController(withIdentifier: "DobCheckerVC") as? DobCheckerVC {
                        vc.isNew = false
                        vc.isDobPresent = ""
                    navigationController?.pushViewController(vc, animated: false)
                }
                    
                }

            
            
            
            }
            else{
               
                print("user logout here")
               
                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc : LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                 
                navigationController?.pushViewController(vc, animated: false)
            }
              
                
            }
            
        }

        
      //  }

    }
    
    func handleBranchIODeepLink(param : [String: AnyObject]) {
        guard let deeplink = param["deeplink"] as? String else { return }
        //         guard let contentID = param["content_id"] as? String else { return }
        print("deep link \(deeplink) && content id \(param["content_id"] as? String)")
        goToMainVCForFirebaseCustomLink(bucketCode: deeplink, contentIDCode: param["content_id"] as? String)
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        screenProtecter.startPreventingRecording()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //screenProtecter.startPreventingScreenshot()
        screenProtecter.startPreventingRecording()


    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        screenProtecter.startPreventingRecording()
        screenProtecter.startPreventingRecording()

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
    }
    
    //MARK:- SwiftyStoreKit
    func handleInAppPurchase() {
        /* //older and original method
         SwiftyStoreKit.completeTransactions(atomically: false) { purchases in
         for purchase in purchases {
         switch purchase.transaction.transactionState {
         case .purchased, .restored:
         let downloads = purchase.transaction.downloads
         if !downloads.isEmpty {
         SwiftyStoreKit.start(downloads)
         } else if purchase.needsFinishTransaction {
         if self.isLogin {
         PurchaseHelper.shared.completeTransaction(productId: purchase.productId, transaction: purchase.transaction)
         }
         }
         print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
         
         case .failed, .purchasing, .deferred:
         break // do nothing
         }
         }
         }*/
        //added new method for testing
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                        if self.isLogin {
                            PurchaseHelper.shared.completeTransaction(productId: purchase.productId, transaction: purchase.transaction)
                        }
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
    }
    
    //MARK:- firebase dynamic link
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool{
        Branch.getInstance().continue(userActivity)
        if let incomingURL = userActivity.webpageURL {
            weak var weakSelf: AppDelegate? = self
            let handleLink = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL, completion: { (dynamicLink, error) in
                print("Firebase Your Dynamic Link parameter: \(dynamicLink)")
                /*
                 Optional(<FIRDynamicLink: 0x28358a3c0, url [http://www.armsprime.com?%20&bucket_code=photos&content_id=5ce3a9546338906240220a12], match type: unique, minimumAppVersion: N/A, match message: (null)>)
                 */
                if let dynamicLink = dynamicLink, let _ = dynamicLink.url
                {
                    //                    if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
                    //                        if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                    //                            print("user is already logged in")
                    //                        } else {
                    //                            return
                    //                        }
                    //                    } else {
                    //                        return
                    //                    }
                    
                    let strongSelf: AppDelegate? = weakSelf
                    strongSelf?.handleReceivedLink(dynamicLink)
                }
            })
            return handleLink
        }
        
        
        return false
    }
    
    func handleReceivedLink(_ dynamicLink: DynamicLink?) {
        
        print("custom Your Dynamic Link parameter: \(String(describing: dynamicLink))")
        var urlString: String? = nil
        if let anUrl = dynamicLink?.url {
            urlString = "\(anUrl)"
            
            
            let queryItems = URLComponents(string: urlString!)?.queryItems
            let bucketdIdComponent = queryItems?.filter({$0.name == "bucket_code"}).first
            let contentIdComponent = queryItems?.filter({$0.name == "content_id"}).first
            let bucketdId = bucketdIdComponent?.value
            let contentId = contentIdComponent?.value
            goToMainVCForFirebaseCustomLink(bucketCode: bucketdId ?? "", contentIDCode: contentId)
            //            if bucketdId == "social-life"  {
            //
            ////                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            ////
            ////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            ////
            ////                if let vc : SocialJunctionViewController = storyboard.instantiateViewController(withIdentifier: "SocialJunctionViewController") as? SocialJunctionViewController {
            ////
            ////                    vc.contetid = contentId ?? ""
            ////
            ////                    navigationController?.pushViewController(vc, animated: false)
            ////
            ////                    self.window?.makeKeyAndVisible()
            ////                }
            //                goToMainVCForFirebaseCustomLink(bucketCode: "social-life", contentIDCode: contentId)
            //            }
            //
            //            if bucketdId == "photos"  {
            //
            ////                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            ////
            ////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            ////
            ////                if let vc : PhotosTableViewController = storyboard.instantiateViewController(withIdentifier: "PhotosTableViewController") as? PhotosTableViewController {
            ////
            ////                    vc.contetid = contentId ?? ""
            ////
            ////                    navigationController?.pushViewController(vc, animated: false)
            ////
            ////                    self.window?.makeKeyAndVisible()
            ////                }
            //
            //                goToMainVCForFirebaseCustomLink(bucketCode: "photos", contentIDCode: contentId)
            //            }
            //
            //            if bucketdId == "videos" {
            //
            ////                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            ////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            ////
            ////
            ////                if let vc : VideosViewController = storyboard.instantiateViewController(withIdentifier: "VideosViewController") as? VideosViewController {
            ////
            ////                    vc.contetid = contentId ?? ""
            ////
            ////                    navigationController?.pushViewController(vc, animated: false)
            ////
            ////                    self.window?.makeKeyAndVisible()
            ////                }
            //
            //                 goToMainVCForFirebaseCustomLink(bucketCode: "videos", contentIDCode: contentId)
            //            }
            //
            //            //
            //            //
            //            //            if bucketdId == "shows" {
            //            //                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            //            //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            //
            //            //
            //            //                let vc : ShowViewController = storyboard.instantiateViewController(withIdentifier: "ShowViewController") as! ShowViewController
            //            //
            //            //                vc.contetid = contentId ?? ""
            //            //                vc.selectedIndexVal = 4
            //            //
            //            //                navigationController?.pushViewController(vc, animated: false)
            //            //
            //            //                self.window?.makeKeyAndVisible()
            //            //            }
            //
            //            if bucketdId == "travel" {
            ////                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            ////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            ////
            ////
            ////                let vc : TravelingViewController = storyboard.instantiateViewController(withIdentifier: "TravelingViewController") as! TravelingViewController
            ////
            ////                vc.contetid = contentId ?? ""
            ////                vc.selectedIndexVal = 3
            ////
            ////                navigationController?.pushViewController(vc, animated: false)
            ////
            ////                self.window?.makeKeyAndVisible()
            //                 goToMainVCForFirebaseCustomLink(bucketCode: "travel", contentIDCode: contentId)
            //
            //            }
            //
            //            if bucketdId == "foodgasm" {
            ////                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            ////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            ////
            ////
            ////                let vc : FoodgasmViewController = storyboard.instantiateViewController(withIdentifier: "FoodgasmViewController") as! FoodgasmViewController
            ////
            ////                vc.contetid = contentId ?? ""
            ////                vc.selectedIndexVal = 4
            ////
            ////                navigationController?.pushViewController(vc, animated: false)
            ////
            ////                self.window?.makeKeyAndVisible()
            //                 goToMainVCForFirebaseCustomLink(bucketCode: "foodgasm", contentIDCode: contentId)
            //            }
            //
            //            if bucketdId == "bodyholic" {
            ////                let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            ////                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            ////
            ////
            ////                let vc : BodyholicViewController = storyboard.instantiateViewController(withIdentifier: "BodyholicViewController") as! BodyholicViewController
            ////
            ////                vc.contetid = contentId ?? ""
            ////                vc.selectedIndexVal = 5
            ////
            ////                navigationController?.pushViewController(vc, animated: false)
            ////
            ////                self.window?.makeKeyAndVisible()
            //                goToMainVCForFirebaseCustomLink(bucketCode: "bodyholic", contentIDCode: contentId)
            //            }
            //
        }
        print("Extended URL : \(urlString ?? "")")
    }
    func goToMainVCForFirebaseCustomLink(bucketCode: String , contentIDCode: String?) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let currentNav: UINavigationController = self.window?.rootViewController as!  UINavigationController
        print("user loogged in \((self.checkIsUserLoggedIn() ? "YES": "NO")) contentID \(String(describing: contentIDCode)) current \(currentNav)  bucket [\(bucketCode) => (\(contentIDCode))]")
        let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
        
        if contentIDCode?.count != 0 {
            let bucket : BucketContentDetailsViewController = storyboard.instantiateViewController(withIdentifier: "BucketContentDetailsViewController") as! BucketContentDetailsViewController
            bucket.contedID = contentIDCode ?? ""
            bucket.bucketcodeStr = bucketCode
            
            currentNav.viewControllers = [vc]
            currentNav.pushViewController(bucket, animated: false)
        }
    }
    //    func goToMainVCForFirebaseCustomLink(bucketCode: String , contentIDCode: String?) {
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    ////        print("current controller \(self.window?.rootViewController)")
    //
    //        let currentNav: UINavigationController = self.window?.rootViewController as!  UINavigationController
    //        let vc : MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
    //        switch (bucketCode as! String).lowercased() {
    //        case "social-life":
    //            vc.selectedIndex = 0
    //            vc.tabBar.isHidden = false
    //            break
    //        case "photos":
    //            vc.selectedIndex = 1
    //            vc.tabBar.isHidden = false
    //            break
    //        case "videos":
    //            vc.selectedIndex = 2
    //           vc.tabBar.isHidden = false
    //            break
    //        case "menu":
    //            vc.selectedIndex = 3
    //            vc.tabBar.isHidden = false
    //            break
    //        case "travel":
    //            vc.selectedIndex = 3
    //            vc.tabBar.isHidden = false
    //            break
    //        case "foodgasm":
    //            vc.selectedIndex = 3
    //            vc.tabBar.isHidden = false
    //            break
    //        case "bodyholic":
    //            vc.selectedIndex = 3
    //            vc.tabBar.isHidden = false
    //            break
    //        case "wallet":
    //            vc.selectedIndex = 3
    //            vc.tabBar.isHidden = false
    //            break
    //        case "help&support":
    //            vc.selectedIndex = 3
    //            vc.tabBar.isHidden = false
    //            break
    //        case "profile":
    //            vc.selectedIndex = 3
    //            vc.tabBar.isHidden = false
    //            break
    //        case "top-fan":
    //            vc.selectedIndex = 3
    //            vc.tabBar.isHidden = false
    //            break
    //        case "live":
    //            vc.selectedIndex = 0
    //            vc.tabBar.isHidden = false
    //            break
    //        default:
    //            vc.selectedIndex = 0
    //            vc.tabBar.isHidden = false
    //            break
    //        }
    //
    //        let bucket : BucketContentDetailsViewController = storyboard.instantiateViewController(withIdentifier: "BucketContentDetailsViewController") as! BucketContentDetailsViewController
    //        bucket.contedID = contentIDCode ?? ""
    //        bucket.bucketcodeStr = bucketCode
    //
    //        if contentIDCode?.count != 0 && contentIDCode != nil {
    //        if bucketCode == "travel" {
    //            let vc2 : TravelingViewController = storyboard.instantiateViewController(withIdentifier: "TravelingViewController") as! TravelingViewController
    //            vc2.selectedIndexVal = 3
    //            currentNav.viewControllers = [vc,vc2]
    //        } else if bucketCode == "foodgasm" {
    //            let vc2 : FoodgasmViewController = storyboard.instantiateViewController(withIdentifier: "FoodgasmViewController") as! FoodgasmViewController
    //            vc2.selectedIndexVal = 4
    //            currentNav.viewControllers = [vc,vc2]
    //        } else if bucketCode == "bodyholic" {
    //            let vc2 : BodyholicViewController = storyboard.instantiateViewController(withIdentifier: "BodyholicViewController") as! BodyholicViewController
    //            vc2.selectedIndexVal = 5
    //            currentNav.viewControllers = [vc,vc2]
    //        } else {
    //            currentNav.viewControllers = [vc]
    //        }
    //            currentNav.pushViewController(bucket, animated: false)
    //        } else {
    //            if bucketCode == "wallet" && self.checkIsUserLoggedIn() {
    //                let vc2 : PurchaseCoinsViewController = storyboard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
    //                currentNav.viewControllers = [vc]
    //                currentNav.pushViewController(vc2, animated: false)
    //            } else if bucketCode == "help&support" && self.checkIsUserLoggedIn() {
    //                let vc2 : HelpAndSupportViewController = storyboard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
    //                currentNav.viewControllers = [vc]
    //                currentNav.pushViewController(vc2, animated: false)
    //            } else if bucketCode == "profile" && self.checkIsUserLoggedIn() {
    //                let vc2 : ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    //                currentNav.viewControllers = [vc]
    //                currentNav.pushViewController(vc2, animated: false)
    //            } else if bucketCode == "top-fan" && self.checkIsUserLoggedIn() {
    //                let vc2 : MyFavoriteFansViewController = storyboard.instantiateViewController(withIdentifier: "MyFavoriteFansViewController") as! MyFavoriteFansViewController
    //                vc2.selectedIndexVal = 7
    //                currentNav.viewControllers = [vc]
    //                currentNav.pushViewController(vc2, animated: false)
    //            } else if bucketCode == "foodgasm" && self.checkIsUserLoggedIn() {
    //                let vc2 : FoodgasmViewController = storyboard.instantiateViewController(withIdentifier: "FoodgasmViewController") as! FoodgasmViewController
    //                vc2.selectedIndexVal = 4
    //                currentNav.viewControllers = [vc]
    //                currentNav.pushViewController(vc2, animated: false)
    //            } else if bucketCode == "bodyholic" && self.checkIsUserLoggedIn() {
    //                let vc2 : BodyholicViewController = storyboard.instantiateViewController(withIdentifier: "BodyholicViewController") as! BodyholicViewController
    //                vc2.selectedIndexVal = 5
    //                currentNav.viewControllers = [vc]
    //                currentNav.pushViewController(vc2, animated: false)
    //            } else if bucketCode == "travel" && self.checkIsUserLoggedIn() {
    //                let vc2 : TravelingViewController = storyboard.instantiateViewController(withIdentifier: "TravelingViewController") as! TravelingViewController
    //                vc2.selectedIndexVal = 3
    //                currentNav.viewControllers = [vc]
    //                currentNav.pushViewController(vc2, animated: false)
    //            } else if bucketCode == "live" && self.checkIsUserLoggedIn() {
    //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
    //                UserDefaults.standard.set(true, forKey: "liveStatus")
    //                let vc2 = storyboard.instantiateViewController(withIdentifier: "LiveScreenViewController_New") as! LiveScreenViewController_New
    //                vc2.hidesBottomBarWhenPushed = true
    //                currentNav.pushViewController(vc2, animated: false)
    //            } else {
    //                currentNav.pushViewController(vc, animated: false)
    //            }
    //        }
    //
    //    }
    
    func checkIsUserLoggedIn() -> Bool {
        if UserDefaults.standard.object(forKey: "LoginSession") as? String == nil || UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionOut" || UserDefaults.standard.value(forKey: "LoginSession") as! String == "LoginSession"  {
            return false
        } else {
            return true
        }
    }
    
    func mobileVerificationSetUp() {
        
        let defaults = UserDefaults.standard

        if let mobile_verified = defaults.object(forKey: "mobile_verified") {
            print("App already launched : \(mobile_verified)")
        } else {
            defaults.set(false, forKey: "mobile_verified")
            defaults.synchronize()
            print("App launched first time")
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        AudioPlayerManager.shared.remoteControlReceivedWithEvent(event)
    }
    
    //MARK:- Database initialize
    func initializeDatabase() {
        
        let path = Bundle.main.path(forResource: "ConsumerDatabase", ofType : "sqlite")
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let writePath = documents + "/ConsumerDatabase.sqlite"
        print(writePath)
        if (!fileManager.fileExists(atPath : writePath)) {
            self.createDataBaseFile(path: path, location: writePath)
        } else {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, version == "2.0" && !UserDefaults.standard.bool(forKey: "DataMigrationDone") {
                do {
                    //                    try fileManager.removeItem(atPath: writePath)
                    self.createDataBaseFile(path: path, location: writePath)
                } catch {
                    print("Couldn't copy file to final location! Error:\(error.localizedDescription)")
                }
            }
            database.initDatabase(path: writePath)
            
        }
    }
    
    func createDataBaseFile(path: String?, location: String) {
        let fileManager = FileManager.default
        do {
            try fileManager.copyItem(atPath: path ?? "", toPath: location)
            database.initDatabase(path: location)
        } catch let error as NSError {
            print("Couldn't copy file to final location! Error:\(error.description)")
        }
    }
    
    func getBuketData(completion: @escaping (JSON)->()) {
        
        if Reachability.isConnectedToNetwork() == true{
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.HOME_SCREEN_DATA + Constants.artistId_platform, extraHeader: nil, closure: { (result) in
                switch result {
                case .success(let data):
                    if (data["error"] as? Bool == true) {
                        return
                        
                    } else {
                        self.buckets = [List]()
                        if (data != nil) {
                            if let arrayList =  data["data"]["list"].arrayObject {
                                for dict in arrayList{
                                    
                                    if let list : List = List.init(dictionary: (dict as? NSDictionary)!) {
                                        self.buckets.append(list)
                                        BucketValues.bucketIdArray.append(list._id ?? "")
                                    }
                                }
                                if (data["data"]["list"].arrayObject != nil) {
                                    BucketValues.bucketContentArr = NSMutableArray(array: data["data"]["list"].arrayObject!)
                                    
                                }
                                //                self.displayLayout()
                                self.addBucketListingToDatabase(bucketArray: self.buckets)
                                print(data)
                                completion(data)
                            }
                        }
                    }
                case .failure(let error):
                    print("error bucket =>\(error)")
                }
                
            })
        }
    }
    func addBucketListingToDatabase(bucketArray : [List]) {
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        database.deleteBuckets()
        
        if (database != nil) {
            database.createStatsTable()
            database.createBucketListTable()
        }
        
        for list in buckets {
            database.insertIntoBucketListTable(list: list)
        }
    }
    func downloadBucket() {
        DispatchQueue.global(qos: .background).async {
            self.getBuketData(completion: { (result) in
                if let id = result["data"]["list"][1]["_id"].string {
                    self.bucketId = id
                }
                BucketValues.bucketContentArr = NSMutableArray(array: result["data"]["list"].arrayObject!)
                //                    self.getSocialData()
                //                    self.getPhotosData()
                //                    self.getVideoData()
                self.setTabMenu()
            })
        }
    }
    func artistData(completion: @escaping (Bool)->()) {
        print(#function)
        if Reachability.isConnectedToNetwork()
        {
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.ARTIST_DATA + Constants.artistId_platform, extraHeader: nil, closure: { (result) in
                switch result {
                case .success(let data):
                    print(data)
                    
                    if (data["error"] as? Bool == true) {
                        completion(false)
                        return
                        
                    } else {
                        
                        self.artistConfig._id = data["data"]["artistconfig"]["_id"].string
                        self.artistConfig.artist_id = data["data"]["artistconfig"]["artist_id"].string
                        self.artistConfig.ios_version_name = data["data"]["artistconfig"]["ios_version_name"].string
                        self.artistConfig.ios_version_no = data["data"]["artistconfig"]["ios_version_no"].int
                        self.artistConfig.fmc_default_topic_id = data["data"]["artistconfig"]["fmc_default_topic_id"].string
                        self.artistConfig.fmc_default_topic_id_test = data["data"]["artistconfig"]["fmc_default_topic_id_test"].string
                        self.artistConfig.social_bucket_id = data["data"]["artistconfig"]["social_bucket_id"].string
                        self.artistConfig.fb_user_name = data["data"]["artistconfig"]["fb_user_name"].string
                        self.artistConfig.fb_page_url = data["data"]["artistconfig"]["fb_page_url"].string
                        self.artistConfig.fb_api_key = data["data"]["artistconfig"]["fb_api_key"].string
                        self.artistConfig.fb_api_secret = data["data"]["artistconfig"]["fb_api_secret"].string
                        self.artistConfig.twitter_user_name = data["data"]["artistconfig"]["twitter_user_name"].string
                        self.artistConfig.twitter_page_url = data["data"]["artistconfig"]["twitter_page_url"].string
                        self.artistConfig.twitter_oauth_access_token = data["data"]["artistconfig"]["twitter_oauth_access_token"].string
                        self.artistConfig.twitter_oauth_access_token_secret = data["data"]["artistconfig"]["twitter_oauth_access_token_secret"].string
                        self.artistConfig.twitter_consumer_key = data["data"]["artistconfig"]["twitter_consumer_key"].string
                        self.artistConfig.twitter_consumer_key_secret = data["data"]["artistconfig"]["twitter_consumer_key_secret"].string
                        self.artistConfig.instagram_user_name = data["data"]["artistconfig"]["instagram_user_name"].string
                        self.artistConfig.instagram_user_name = data["data"]["artistconfig"]["instagram_user_name"].string
                        self.artistConfig.last_updated_buckets = data["data"]["artistconfig"]["last_updated_buckets"].string
                        
                        self.artistConfig.channel_namespace = data["data"]["artistconfig"]["channel_namespace"].string
       //                 self.artistConfig.pubnub_publish_key = data["data"]["artistconfig"]["pubnub_publish_key"].string
   //                     self.artistConfig.pubnub_subcribe_key = data["data"]["artistconfig"]["pubnub_subcribe_key"].string
    //                    self.artistConfig.gift_channel_name = data["data"]["artistconfig"]["gift_channel_name"].arrayObject
   //                     self.artistConfig.comment_channel_name = data["data"]["artistconfig"]["comment_channel_name"].arrayObject
//
                        self.artistConfig.agora_id = data["data"]["artistconfig"]["agora_id"].string
                        
                        self.artistConfig.pn_auth_key = data["data"]["artistconfig"]["pn_auth_key"].bool
                        
                        UserDefaults.standard.setValue(self.artistConfig.last_updated_buckets, forKey: "lastUpdateBucketDate")
                        UserDefaults.standard.synchronize()
                        
                        self.artistConfig.updated_at = data["data"]["artistconfig"]["updated_at"].string
                        self.artistConfig.created_at = data["data"]["artistconfig"]["created_at"].string
                        self.artistConfig.key = data["data"]["artistconfig"]["key"].string
                        self.artistConfig.fcm_server_key = data["data"]["artistconfig"]["fcm_server_key"].string
                        self.artistConfig.domain = data["data"]["artistconfig"]["domain"].string
                        self.artistConfig.session_timeout = data["data"]["artistconfig"]["session_timeout"].bool
                        self.artistConfig.promotional_banners = data["data"]["artistconfig"]["promotional_banners"].bool
                        self.artistConfig.instagram_user_id = data["data"]["artistconfig"]["instagram_user_id"].string
                        self.artistConfig.socket_url = data["data"]["artistconfig"]["socket_url"].string
                        self.artistConfig.fb_page_id = data["data"]["artistconfig"]["fb_page_id"].string
                        self.artistConfig.fb_access_token = data["data"]["artistconfig"]["fb_access_token"].string
                        self.artistConfig.instagram_password = data["data"]["artistconfig"]["instagram_password"].string
                        self.artistConfig.first_name = data["data"]["artistconfig"]["artist"]["first_name"].string
                        self.artistConfig.last_name = data["data"]["artistconfig"]["artist"]["last_name"].string
                        
                        self.artistConfig.picture = data["data"]["artistconfig"]["artist"]["picture"].string
                        self.artistConfig.photo = data["data"]["artistconfig"]["artist"]["photo"]["thumb"].string //rupali
                        self.artistConfig.human_readable_created_date = data["data"]["artistconfig"]["artist"]["human_readable_created_date"].string
                        self.artistConfig.date_diff_for_human = data["data"]["artistconfig"]["artist"]["date_diff_for_human"].string
                        self.artistConfig.shoutout = ArtistShoutoutConfig(data: data["data"]["artistconfig"]["shoutout"].dictionaryObject)
                        self.artistConfig.static_url = StaticURLs(data: data["data"]["artistconfig"]["static_url"].dictionaryObject)
                        self.artistConfig.directLine = ArtistDirectLine(data: data["data"]["artistconfig"]["direct_line"].dictionaryObject)
                        
                        self.artistConfig.privateVideoCall = privateVideoCallConfig(data: data["data"]["artistconfig"]["private_video_call"])
                        
                        self.artistConfig.privateVideoCallURL = privateVideoCallURLConfig(data: data["data"]["artistconfig"]["private_video_call"]["intro_video"].dictionaryObject)
                        
                        self.artistConfig.privateVideoCallrateCard = PrivateVideoCallrateCardConfig(data: data["data"]["artistconfig"]["private_video_call"]["ratecard"].arrayValue)
                        
                         self.artistConfig.artistLanguage = ArtistLanguageConfig(data: data["data"]["artistconfig"]["artist_languages"].arrayValue)
                        
                        
                        self.artistConfig.oneToOne = ArtistOneToOneConfig(data: data["data"]["artistconfig"]["oneonone"].dictionaryObject)
                       
                        self.artistConfig.reported_tagsArray = ReportTagConfig(data: data["data"]["app_config"]["reported_tags"].arrayValue)
                        
                        self.artistConfig.MinimumTNCVersion = data["data"]["artistconfig"]["minimum_acceptance_policy_version"].double
                        
                        self.artistConfig.AcceptedTNCVersion = data["data"]["artistconfig"]["accepted_acceptance_policy_version"].double
                        
                       
                        completion(true)
                        self.artistConfigLoaderHandler?(true)
                    }
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            })
        }
    }
    
    
    func setTabMenu()  {
        self.bucketsArray = [List]()
        let database = DatabaseManager.sharedInstance
        
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        /* if let dbURL = GlobalFunctions.createDatabaseUrlPath() {
         database.dbPath = dbURL.path
         }*/
        self.bucketsArray = database.getBucketListing()
        
        if bucketsArray.count  == 0 {
            return
        }
        self.bucketsArray = bucketsArray.sorted(by: { $0.ordering! < $1.ordering! })
        
        var tabMenuArray = [List]()
        for list in bucketsArray {
            
            if tabMenuArray.count < 3 {
                tabMenuArray.append(list)
                //                 downloadImage(from: URL.init(string:list.photo!.medium!)!)
            } else { break }
        }
        tabMenuArray = tabMenuArray.sorted(by: { $0.ordering! < $1.ordering! })
        for index in 0 ..< tabMenuArray.count {
            getTabMenuData(bucket: tabMenuArray[index], index: index)
        }
    }
    
    func getTabMenuData(bucket:List , index:Int) {
        if Reachability.isConnectedToNetwork() == true
        {
            var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucket._id)" + "&visibility=customer" + "&page=\(1)"
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let url = URL(string: strUrl)
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
            request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                
                
                do {
                    if (data != nil) {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        print("Photo json \(String(describing: json))")
                        //need to store total val & fetch it & add to arr & load tbl view
                        
                        if json?.object(forKey: "error") as? Bool == true {
                            return
                        }
                        else if (json?.object(forKey: "status_code") as? Int == 200)
                        {
                            
                            DispatchQueue.main.async {
                                
                                if let dictData = json?.object(forKey: "data") as? NSMutableDictionary{
                                    
                                    if let photoDetailsArr = dictData.object(forKey: "list") as? NSMutableArray{
                                        
                                        self.database.createSocialJunctionTable()
                                        self.database.createStatsTable()
                                        self.database.createVideoTable()
                                        self.database.createPollTable()
                                        self.database.createSelectedPollTable()
                                        var oldDataArray : [List] = [List]()
                                        var newDataArray : [String] = [String]()
                                        
                                        for dict in photoDetailsArr{
                                            
                                            if let list : List = List.init(dictionary: (dict as? NSDictionary)!) {
                                                if (!GlobalFunctions.checkContentBlockId(id: list._id ?? "")) {
                                                    newDataArray.append(list._id ?? "")
                                                }
                                            }
                                        }
                                        
                                        oldDataArray  =  Array(self.database.getSocialJunctionFromDatabase(datatype: bucket.code ?? "" ))
                                        
                                        if (newDataArray.count > 0  && oldDataArray.count > 0) {
                                            
                                            let newContentCount =  self.compareIds(oldArray: oldDataArray, newArray: newDataArray, dataType: bucket.code ?? "")
                                            if (newContentCount > 0) {
                                                self.showTabBadgeCount(tabIndex: index, count: newContentCount)
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    func getLatestContets() {
        
        DispatchQueue.global(qos: .background).async {
            
            self.bucketsArray = [List]()
            self.bucketsArray = self.database.getBucketListing()
            self.database.addBucketColum()
            print("[debug] => fetch existing bucket data")
            if (self.bucketsArray != nil && self.bucketsArray.count > 0) {
                for list in self.bucketsArray{
                    BucketValues.bucketTitleArr.append(list.caption ?? "")
                    BucketValues.bucketIdArray.append(list._id ?? "")
                }
                //                self.getPhotosData()
                //                self.getVideoData()
                self.setTabMenu()
            }
            //            else {
            //                self.getBuketData(completion: { (result) in
            //                    if let id = result["data"]["list"][1]["_id"].string {
            //                        self.bucketId = id
            //                    }
            //                    BucketValues.bucketContentArr = NSMutableArray(array: result["data"]["list"].arrayObject!)
            ////                    self.getSocialData()
            ////                    self.getPhotosData()
            ////                    self.getVideoData()
            //                    self.setTabMenu()
            //                })
            //            }
            
            
        }
        
    }
    
    func getSocialData() {
        
        if (BucketValues.bucketContentArr != nil && BucketValues.bucketContentArr.count > 0) {
            if let dataDict = BucketValues.bucketContentArr.object(at: 0) as? NSDictionary {
                bucketId = dataDict.object(forKey: "_id") as? String
                
            }
        } else {
            self.bucketId = BucketValues.bucketIdArray[0]
        }
        if Reachability.isConnectedToNetwork() == true
        {
            if let bucketId = self.bucketId
            {
                
                var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" + "&visibility=customer" + "&page=\(1)"
                strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let url = URL(string: strUrl)
                let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "GET"
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
                
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                    
                    
                    do {
                        if (data != nil) {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("Photo json \(String(describing: json))")
                            //need to store total val & fetch it & add to arr & load tbl view
                            
                            if json?.object(forKey: "error") as? Bool == true {
                                return
                            }
                            else if (json?.object(forKey: "status_code") as? Int == 200)
                            {
                                
                                DispatchQueue.main.async {
                                    
                                    if let dictData = json?.object(forKey: "data") as? NSMutableDictionary{
                                        
                                        if let photoDetailsArr = dictData.object(forKey: "list") as? NSMutableArray{
                                            
                                            self.database.createSocialJunctionTable()
                                            self.database.createStatsTable()
                                            self.database.createVideoTable()
                                            var oldDataArray : [List] = [List]()
                                            var newDataArray : [String] = [String]()
                                            
                                            for dict in photoDetailsArr{
                                                
                                                if let list : List = List.init(dictionary: (dict as? NSDictionary)!) {
                                                    if (!GlobalFunctions.checkContentBlockId(id: list._id ?? "")) {
                                                        newDataArray.append(list._id ?? "")
                                                    }
                                                }
                                            }
                                            
                                            oldDataArray  =  Array(self.database.getSocialJunctionFromDatabase(datatype: "social" ))
                                            
                                            if (newDataArray.count > 0  && oldDataArray.count > 0) {
                                                
                                                let newContentCount =  self.compareIds(oldArray: oldDataArray, newArray: newDataArray, dataType: "social")
                                                if (newContentCount > 0) {
                                                    self.showTabBadgeCount(tabIndex: 0, count: newContentCount)
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
                task.resume()
                
            } else
            {
                print(self.bucketId)
            }
        }
    }
    
    func getPhotosData() {
        if (BucketValues.bucketContentArr.count > 0) {
            
            if let dataDict = BucketValues.bucketContentArr.object(at: 1) as? Dictionary<String, Any> {
                bucketId = dataDict["_id"] as? String
            }
        } else {
            bucketId = BucketValues.bucketIdArray[1]
        }
        if Reachability.isConnectedToNetwork() == true {
            
            if let bucketId = self.bucketId {
                //calculate per page value if gets time
                
                
                let age = UserDefaults.standard.value(forKey: "age_difference")
                
                if age != nil
                {
                    self.ageDiff = age as? Int
                }
                
                var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" + "&visibility=customer" + "&page=\(1)" + "&age_restriction=\(self.ageDiff ?? 18)"
                strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let url = URL(string: strUrl)
                let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "GET"
                //                    request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                    if error != nil{
                        print(error?.localizedDescription)
                        
                    }
                    
                    
                    do {
                        if (data != nil) {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("Photo json \(String(describing: json))")
                            //need to store total val & fetch it & add to arr & load tbl view
                            
                            if json?.object(forKey: "error") as? Bool == true
                            {
                                DispatchQueue.main.async {
                                    if let arr = json?.object(forKey: "error_messages")! as? NSMutableArray{
                                        
                                    }
                                    
                                }
                                
                            } else if (json?.object(forKey: "status_code") as? Int == 200) {
                                if let AllData = json?.object(forKey: "data") as? NSMutableDictionary
                                {
                                    let paginationData = AllData["paginate_data"] as? NSMutableDictionary
                                    
                                }
                                
                                DispatchQueue.main.async {
                                    if  let dictData = json?.object(forKey: "data") as? NSMutableDictionary{
                                        if  let photoDetailsArr = dictData["list"] as?
                                            NSMutableArray{
                                            
                                            self.database.createSocialJunctionTable()
                                            self.database.createStatsTable()
                                            self.database.createVideoTable()
                                            var oldDataArray : [List] = [List]()
                                            var newDataArray : [String] = [String]()
                                            
                                            for dict in photoDetailsArr{
                                                
                                                if let list : List = List.init(dictionary: (dict as? NSDictionary)!) {
                                                    if (!GlobalFunctions.checkContentBlockId(id: list._id ?? "")) {
                                                        newDataArray.append(list._id ?? "")
                                                    }
                                                }
                                            }
                                            
                                            oldDataArray  =  Array(self.database.getSocialJunctionFromDatabase(datatype: "album" ))
                                            
                                            if (newDataArray.count > 0  && oldDataArray.count > 0) {
                                                
                                                let newContentCount =  self.compareIds(oldArray: oldDataArray, newArray: newDataArray, dataType: "album")
                                                if (newContentCount > 0) {
                                                    self.showTabBadgeCount(tabIndex: 1, count: newContentCount)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                        
                        
                    }
                    
                }
                task.resume()
                
            }
        }
        
    }
    
    func getVideoData() {
        if (BucketValues.bucketContentArr.count > 0) {
            
            if let dataDict = BucketValues.bucketContentArr.object(at: 2) as? Dictionary<String, Any> {
                bucketId = dataDict["_id"] as? String
            }
        } else {
            bucketId = BucketValues.bucketIdArray[2]
        }
        if Reachability.isConnectedToNetwork() == true {
            
            if let bucketId = self.bucketId {
                //calculate per page value if gets time
                
                var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" + "&visibility=customer" + "&page=\(1)"
                strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let url = URL(string: strUrl)
                let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "GET"
                //                    request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                    if error != nil{
                        print(error?.localizedDescription)
                        
                        return
                    }
                    
                    
                    do {
                        if (data != nil) {
                            
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("Photo json \(String(describing: json))")
                            //need to store total val & fetch it & add to arr & load tbl view
                            
                            if json?.object(forKey: "error") as? Bool == true
                            {
                                DispatchQueue.main.async {
                                    if let arr = json?.object(forKey: "error_messages")! as? NSMutableArray{
                                        
                                    }
                                    
                                }
                                
                            } else if (json?.object(forKey: "status_code") as? Int == 200) {
                                if let AllData = json?.object(forKey: "data") as? NSMutableDictionary
                                {
                                    let paginationData = AllData["paginate_data"] as? NSMutableDictionary
                                    
                                }
                                
                                DispatchQueue.main.async {
                                    if  let dictData = json?.object(forKey: "data") as? NSMutableDictionary{
                                        if  let photoDetailsArr = dictData["list"] as? NSMutableArray{
                                            
                                            self.database.createSocialJunctionTable()
                                            self.database.createStatsTable()
                                            self.database.createVideoTable()
                                            var oldDataArray : [List] = [List]()
                                            var newDataArray : [String] = [String]()
                                            
                                            for dict in photoDetailsArr{
                                                
                                                if let list : List = List.init(dictionary: (dict as? NSDictionary)!) {
                                                    if (!GlobalFunctions.checkContentBlockId(id: list._id ?? "")) {
                                                        
                                                        newDataArray.append(list._id ?? "")
                                                        //                                        if GlobalFunctions.checkContentsLockId(list: list) == true {
                                                        //                                                self.database.insertIntoSocialTable(list:list, datatype: "album")
                                                        //                                                self.photosArray.append(list)
                                                    }
                                                }
                                                //
                                            }
                                            
                                            oldDataArray  =  Array(self.database.getSocialJunctionFromDatabase(datatype: "video" ))
                                            
                                            if (newDataArray.count > 0  && oldDataArray.count > 0) {
                                                
                                                let newContentCount =  self.compareIds(oldArray: oldDataArray, newArray: newDataArray, dataType: "video")
                                                if (newContentCount > 0) {
                                                    self.showTabBadgeCount(tabIndex: 2, count: newContentCount)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                        
                        
                    }
                    
                }
                task.resume()
                
            }
        }
        
    }
    
    func showTabBadgeCount(tabIndex : Int , count : Int) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let tabBarController = appDelegate?.window?.rootViewController?.children.last as? UITabBarController{
            
            let tbItem = tabBarController.tabBar.items?[tabIndex]
            tbItem?.badgeValue = String(format: "%i", count)
        }
    }
    
    func compareIds(oldArray : [List], newArray : [String], dataType : String) -> Int{
        
        var count = 0
        var strListArray = [String]()
        for list in oldArray{
            strListArray.append(list._id!)
            if GlobalFunctions.checkContentsLockId(list: list) == true {
                self.database.insertIntoSocialTable(list:list, datatype: dataType)
            }
        }
        if (strListArray.count > 0) {
            for id in newArray{
                if (!strListArray.contains(id)) {
                    count = count+1
                }
                
            }
        }
        return count
        
    }
    
    func getOfflineUserData() -> Customer{
        
        var customer : Customer!
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let writePath  = documents + "/ConsumerDatabase.sqlite"
        print(writePath)
        var database : DatabaseManager!
        if( !fileManager.fileExists(atPath : writePath)){
            
        }else{
            database = DatabaseManager.sharedInstance
            database.initDatabase(path: writePath)
            
            customer = database.getCustomerData()
            CustomerDetails.customerData = customer
            CustomerDetails.custId = customer._id
            CustomerDetails.firstName = customer.first_name
            CustomerDetails.coins = customer.coins
            CustomerDetails.email = customer.email
            CustomerDetails.lastName = customer.last_name
            CustomerDetails.mobileNumber = customer.mobile
            CustomerDetails.mobile_verified = UserDefaults.standard.bool(forKey: "mobile_verified")
            CustomerDetails.email_verified = UserDefaults.standard.bool(forKey: "email_verified")
            CustomerDetails.profile_completed = UserDefaults.standard.bool(forKey: "profile_completed")
            CustomerDetails.picture = customer.picture
            CustomerDetails.purchase_stickers = customer.purchaseStickers
            CustomerDetails.badges = customer.badges
            CustomerDetails.directline_room_id = customer.directline_room_id
            CustomerDetails.identity = customer.identity
            CustomerDetails.lastVisited = customer.last_visited
            CustomerDetails.status = customer.status
            CustomMoEngage.shared.setMoUserInfoUsingCustomerDetails()
            Branch.getInstance().setIdentity(customer._id)
            CustomerDetails.dob = customer.dob
            CustomerDetails.mobile_code = customer.mobile_code
            
        }
        return customer
    }
    
    func getUsersMetaData() {
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.META_ID + Constants.artistId_platform , extraHeader: nil, closure: { (result) in
            
            switch result {
                
            case .success(let data):
                print(data)
                if data["error"].boolValue{
                    //  self.showToast(message: "Something went wrong. Please try again!")
                    return
                    
                } else {
                    if  let purchaseContentIds = data["data"]["purchase_content_ids"].arrayObject, let blockContentIds = data["data"]["block_content_ids"].arrayObject{
                        //                        if let likeIds = likeContentIds as? [String]{
                        if let purchaseId = purchaseContentIds as? [String], let blockIds = blockContentIds as? [String]{
                            DatabaseManager.sharedInstance.storeLikesAndPurchase( purchaseIds: purchaseId, block_ids: blockIds)
                            let userDetails = self.getOfflineUserData()
                            userDetails.purchaseStickers = data["data"]["purchase_stickers"].bool
                            userDetails.directline_room_id = data["data"]["directline_room_id"].string
                            //                            CustomMoEngage.shared.setMoUserInfo(customer: userDetails)
                            DatabaseManager.sharedInstance.insertIntoCustomer(customer: userDetails)
                        }
                        //  }
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
        
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
                        let database = DatabaseManager.sharedInstance
                        database.updateCustomerCoins(coinsValue: coins)
                    }
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func getUserDetails() {
        
        //         self.getOfflineUserData()
        //        self.getUsersMetaData()
        
        //        if (Reachability.isConnectedToNetwork() == true) {
        //            ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.Get_User_Info, extraHeader: nil) { (result) in
        //                switch result {
        //                case .success(let data):
        //                    print(data)
        //                    print("Login Successful")
        //                    if (data["error"] as? Bool == true) {
        //                        return
        //
        //                    } else {
        //                        if let dictData = data["data"].dictionaryObject as? NSDictionary{
        //
        //                            if let customerDict = dictData["customer"] as? NSDictionary {
        //
        //                                if let customerDict = dictData["customer"] as? NSDictionary {
        //
        //                                    if let customer : Customer = Customer(dictionary: customerDict) {
        //                                        CustomerDetails.customerData = customer
        //                                        DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
        //                                        self.getUsersMetaData()
        //                                    }
        //                                }
        //
        //                                //                            if let customer : Customer = Customer(dictionary: customerDict) {
        //                                //                            CustomerDetails.customerData = customer
        //                                //                            DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
        //                                //                            if let likeIds = dictData["like_content_ids"] as? [String]{
        //                                //                                if let purchaseId = dictData["purchase_content_ids"] as? [String]{
        //                                //
        //                                //                                    DatabaseManager.sharedInstance.storeLikesAndPurchase(like_ids: likeIds, purchaseIds: purchaseId, block_ids: customerDict["block_content_ids"] as? [String])
        //                                //
        //                                //                                    _ =  self.getOfflineUserData()
        //                                //                                }
        //                                //                            }
        //                                //                            }
        //                            }
        //                        }
        //                        if let id = data["data"]["customer"]["_id"].string {
        //                            CustomerDetails.custId = id
        //                        }
        //                        if let purchase_stickers = data["data"]["customer"]["purchase_stickers"].bool {
        //                            CustomerDetails.purchase_stickers = purchase_stickers
        //                        }
        //                        if let firstName = data["data"]["customer"]["first_name"].string {
        //                            CustomerDetails.firstName = firstName
        //                        }
        //                        if let coins = data["data"]["customer"]["coins"].int {
        //                            CustomerDetails.coins = coins
        //                        }
        //                        if let mobileNumbre = data["data"]["customer"]["mobile"].string {
        //                            CustomerDetails.mobileNumber = mobileNumbre
        //                        }
        //                        if let gender = data["data"]["customer"]["gender"].string {
        //                            CustomerDetails.gender = gender
        //                        }
        //                        if let email = data["data"]["customer"]["email"].string {
        //                            CustomerDetails.email = email
        //                        }
        //                        CustomerDetails.badges = data["data"]["customer"]["badges"].object
        //                        if let lastName = data["data"]["customer"]["last_name"].string {
        //                            CustomerDetails.lastName = lastName
        //                        }
        //                        if let image = data["data"]["customer"]["picture"].string {
        //                            CustomerDetails.picture = image
        //                        }
        //                    }
        //                case .failure(let error):
        //                    print(error)
        //                }
        //            }
        //        }
    }
    
    //MARK:- Register DeviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        MoEngage.sharedInstance().setPushToken(deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        MoEngage.sharedInstance().didFailToRegisterForPush()
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        MoEngage.sharedInstance().didRegister(for: notificationSettings)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if let refreshedToken: String = Messaging.messaging().fcmToken {
            if let oldFcmTocken = UserDefaults.standard.value(forKey: "fcmId") as? String {
                if oldFcmTocken == fcmToken {
                    return
                }
            }
            print("Message Token \(String(describing: Messaging.messaging().fcmToken))")
            print("InstanceID token: \(fcmToken)")
            
            UserDefaults.standard.set(refreshedToken, forKey: "fcmId")
            UserDefaults.standard.synchronize()
            let parameter: [String: Any] = ["device_id": Constants.DEVICE_ID!, "fcm_id": fcmToken, "platform": "ios","topic_id": Constants.Fcm_Topic_Id]
            
            ServerManager.sharedInstance().postRequest(postData: parameter, apiName: Constants.Update_Device_Info, extraHeader: nil, closure: { result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            })
            
        }
    }
    
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        if let body : String = remoteMessage.appData["body"] as? String {
            print(body)
        }
        if let title : String = remoteMessage.appData["title"] as? String{
            print(title)
            print(remoteMessage.appData)
            print(remoteMessage.appData)
        }
        
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        guard let googleDidHandle = GIDSignIn.sharedInstance()?.handle(url) else { return true }

        
        let facebookDidHandle = ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            if user.profile.hasImage{
                let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
                print(" image url: ", imageUrl?.absoluteString ?? "")
            }
            // ...
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        Branch.getInstance().handleDeepLink(url)
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    
    
    // MARK: For Below iOS 10.0
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let messageID = userInfo[gcmMessageIDKey] {}
        Branch.getInstance().handlePushNotification(userInfo)
        
        MoEngage.sharedInstance().didReceieveNotificationinApplication(application, withInfo: userInfo, openDeeplinkUrlAutomatically: true)
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {}
        MoEngage.sharedInstance().didReceieveNotificationinApplication(application, withInfo: userInfo, openDeeplinkUrlAutomatically: true)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if let userInfo = notification.userInfo  {
            MoEngage.sharedInstance().didReceieveNotificationinApplication(application, withInfo: userInfo, openDeeplinkUrlAutomatically: true)
        }
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        if let identifier = identifier {
            MoEngage.sharedInstance().handleAction(withIdentifier: identifier, forRemoteNotification: userInfo)
        }
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK:- UserNotifications Framework callback method
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("App delegate didReceive")
        MoEngage.sharedInstance().userNotificationCenter(center, didReceive: response)
        completionHandler();
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.alert])
    }
    
    func handleMoEngageInAppNavigateToScreen(dict : [AnyHashable: Any]) {
        print("show mo Engage Dict \(dict)")
        //        guard (dict.userInfo?["app_extra"] as? [String : Any]) != nil else { return }
        //        let appExtraDict = dict.userInfo?["app_extra"] as! [String : Any]
        //        guard let screenName = appExtraDict["screenName"]  else { return }
        //        let screen: String  = screenName as! String
        //        switch screen.lowercased() {
        //        case "home":
        //            self.selectedIndex = 0
        //            self.tabBar.isHidden = false
        //            break
        //        case "photos":
        //            self.selectedIndex = 1
        //            self.tabBar.isHidden = false
        //            break
        //        case "videos":
        //            self.selectedIndex = 2
        //            self.tabBar.isHidden = false
        //            break
        //        case "menu":
        //            self.selectedIndex = 3
        //            self.tabBar.isHidden = false
        //            break
        //        default:
        //            self.selectedIndex = 0
        //            self.tabBar.isHidden = false
        //            break
        //        }
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

enum AppLaunchManager {
    
    // MARK: - Private Attributes
    private static let launchesCountKey = "LaunchesCount"
    
    
    // MARK: Public Enum Methods
    static func launchesCount() -> Int {
        guard let launched = UserDefaults.standard.value(forKey: launchesCountKey) as? Int else {
            return 0
        }
        return launched
    }
    
    static func registerLaunch() {
        UserDefaults.standard.setValue(launchesCount() + 1, forKey: launchesCountKey)
        UserDefaults.standard.synchronize()
    }
    
    static func isFirstLaunch() -> Bool {
        return launchesCount() <= 1
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}


// MARK: - Orientation
extension AppDelegate {

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        return self.orientationLock
    }

    func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        self.orientationLock = orientation
    }

    func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
