//
//  BaseViewController.swift
//  ZareenKhanConsumer
//
//  Created by Razr on 8/10/17.
//  Copyright (c) 2017 Razr. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import SwiftyJSON
import NVActivityIndicatorView
import MoEngage
import AgoraRtcKit

open class BaseViewController: UIViewController, SlideMenuDelegate {
    
    var hideRightBarButtons = false
    var loaderIndicator: NVActivityIndicatorView!
    var menuVC : MenuViewController!
    var liveButton = UIButton()
    var pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:40, position:.zero)
    var artistConfig = ArtistConfiguration.sharedInstance()
    var buckets = [List]()
    var agoraEngine: AgoraRtcEngineKit? = nil
    var availableCoinsLabel: UILabel?
    var liveIconClick: Bool = true
    var loader: CustomLoaderViewController?
    var liveData: [String: Any] = [String: Any]()
     private let screenProtecter = ScreenProtector()
    //MARK: -
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.handleLiveButtonImage), name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.liveStarted), name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.liveEnded), name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.getFirstTimeUserData), name: NSNotification.Name(rawValue: "getUserData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.testLiveStatus), name: NSNotification.Name(rawValue: "liveStatusCheck"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.liveIsStart), name: NSNotification.Name(rawValue: "liveIsOn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatedCoin(_:)), name: NSNotification.Name(rawValue: "updatedCoins"), object: nil)
        if !(self is LiveOverlayViewController || self is GiftsViewController) {
            setupNavigationBar()
        }

        
        liveButton = UIButton(type: .custom)
        self.navigationController?.isNavigationBarHidden = false
        menuVC = Storyboard.main.instantiateViewController(viewController: MenuViewController.self)
        
        let backItem = UIBarButtonItem(title: "", style: .bordered, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        self.artistConfig = ArtistConfiguration.sharedInstance()
        
        if !hideRightBarButtons {
            setProfileImageOnBarButton()
        }
        
        menuVC.delegate = self

        loaderIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loaderIndicator.center = CGPoint(x: view.center.x, y: view.center.y-50)
        loaderIndicator.type = .ballTrianglePath // add your type
        loaderIndicator.color = appearences.newTheamColor // add your color
        self.view.addSubview(loaderIndicator)
        
        setUpCustomLoader()
        checkStoryExistAtLaunch()
        
        screenProtecter.startPreventingRecording()
        let isCaptured =  UIScreen.main.isCaptured
        if isCaptured {
            screenProtecter.lockRecording()
        }
      //  checkAgoraChannelExist(navigateToLiveVC: true)

    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        checkAgoraChannelExist()
    }
    
    //MARK:- Loader
    func showLoader() {
        DispatchQueue.main.async {
            self.loaderIndicator.startAnimating()
        }
    }
    
    func stopLoader()  {
        DispatchQueue.main.async {
            self.loaderIndicator.stopAnimating()
        }
    }
    
    func showCustomLoader(window: UIWindow?) {
        
        DispatchQueue.main.async {
            if let loader = self.loader,
                let win = window {
                win.addSubview(loader.view)
            }
        }
    }
    
    func hideCustomLoader() {
        
        DispatchQueue.main.async {
            if let loader = self.loader {
                loader.view.removeFromSuperview()
            }
        }
    }
    
    func setUpCustomLoader() {
        
        loader = Storyboard.main.instantiateViewController(viewController: CustomLoaderViewController.self)
        loader?.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    func changeTabBars(hidden:Bool, animated: Bool) {
        let tabBar = self.tabBarController?.tabBar
        let offset = (hidden ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.height - (tabBar?.frame.size.height)! )
        if offset == tabBar?.frame.origin.y {return}
        print("changing origin y position")
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        UIView.animate(withDuration: duration,
                       animations: {tabBar!.frame.origin.y = offset},
                       completion:nil)
    }
    
    func changeTabBar(hidden:Bool, animated: Bool) {
        guard let tabBar = self.tabBarController?.tabBar else { return; }
        if tabBar.isHidden == hidden{ return }
        let frame = tabBar.frame
        let offset = hidden ? frame.size.height : -frame.size.height
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        tabBar.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
        }, completion: { (true) in
            tabBar.isHidden = hidden
        })
    }
    func animateDidLikeButton(_ sender : UIButton, img: UIImage = UIImage(named: "newLike") ?? UIImage()) {
        
        let anim = CABasicAnimation(keyPath: "transform")
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.duration = 0.125
        anim.repeatCount = 1
        anim.autoreverses = true
        anim.isRemovedOnCompletion = true
        anim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0))
        sender.setImage(img, for: .normal)
        sender.layer.add(anim, forKey: nil)
    }
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (newImage != nil) {
            return newImage!
        } else {
            return UIImage.init()
        }
    }
    
    func resizedImage(image: UIImage) -> UIImage? {
        if image.size.height >= 1024 && image.size.width >= 1024 {
            
            UIGraphicsBeginImageContext(CGSize(width:1024, height:1024))
            image.draw(in: CGRect(x:0, y:0, width:1024, height:1024))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
            
        }
        else if image.size.height >= 1024 && image.size.width < 1024
        {
            
            UIGraphicsBeginImageContext(CGSize(width:image.size.width, height:1024))
            image.draw(in: CGRect(x:0, y:0, width:image.size.width, height:1024))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
            
        }
        else if image.size.width >= 1024 && image.size.height < 1024
        {
            
            UIGraphicsBeginImageContext(CGSize(width:1024, height:image.size.height))
            image.draw(in: CGRect(x:0, y:0, width:1024, height:image.size.height))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
            
        }
        else
        {
            return image
        }
        
    }
    
    func artistData() {
        print(#function)
        if Reachability.isConnectedToNetwork()
        {
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.ARTIST_DATA + Constants.artistId_platform, extraHeader: nil, closure: { (result) in
                switch result {
                case .success(let data):
                    print(data)
                    
                    if (data["error"] as? Bool == true) {
                        self.showToast(message: "Something went wrong. Please try again!")
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
                        self.artistConfig.human_readable_created_date = data["data"]["artistconfig"]["artist"]["human_readable_created_date"].string
                        self.artistConfig.date_diff_for_human = data["data"]["artistconfig"]["artist"]["date_diff_for_human"].string
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func showToast(message : String) {
        DispatchQueue.main.async {
            
            //        let toastLabel = UILabel(frame: CGRect(x: 10, y: self.view.frame.size.height-120, width: self.view.frame.size.width - 20, height: 35))
            //
            //        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            //        toastLabel.textColor = UIColor.white
            //        toastLabel.textAlignment = .center;
            //        toastLabel.font = UIFont(name: "Montserrat-Light", size: 11.0)
            //        toastLabel.text = message
            //        toastLabel.alpha = 1.0
            //        toastLabel.layer.cornerRadius = 10;
            //        toastLabel.clipsToBounds  =  true
            //        self.view.addSubview(toastLabel)
            //        UIView.animate(withDuration: 7.0, delay: 0.2, options: .curveEaseOut, animations: {
            //            toastLabel.alpha = 0.0
            //        }, completion: {(isCompleted) in
            //            toastLabel.removeFromSuperview()
            //        })
            
            self.showOnlyAlert(title: "", message: message)
        }
    }
    
    @objc func liveStarted() {
        UserDefaults.standard.set(true, forKey: "liveStatus")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
    }
    
    @objc func liveEnded() {
        UserDefaults.standard.set(false, forKey: "liveStatus")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
    }
    
    @objc func testLiveStatus() {
        checkAgoraChannelExist()
    }
    
    @objc func liveIsStart() {
        self.liveStarted()
    }
    
    @objc func openLiveScreen() {
        
        if !self.checkIsUserLoggedIn() {
            if liveIconClick == true {
                loginPopPop()
            }
            return
        }
        
        if !(Reachability.isConnectedToNetwork()) {
            self.showToast(message: Constants.NO_Internet_MSG)
            return
        }
        
        checkAgoraChannelExist(navigateToLiveVC: true)
    }
    
    @objc func handleLiveButtonImage() {
        
        DispatchQueue.main.async {
            
            self.pulseEffect.removeFromSuperlayer()
            
            if UserDefaults.standard.bool(forKey: "liveStatus") {
                
                if let image = UIImage(named: "liveCeleb") {
                    let color = UIColor(patternImage: image)
                    self.liveButton.backgroundColor = color
                }
                self.pulseEffect.position = self.liveButton.center
                self.liveButton.layer.insertSublayer(self.pulseEffect, below: self.liveButton.layer)
                
            } else if UserDefaults.standard.bool(forKey: "storyStatus") {
                
                if let image = UIImage(named: "storyCeleb") {
                    let color = UIColor(patternImage: image)
                    self.liveButton.backgroundColor = color
                }
            }
        }
    }
    
    func handleLiveButton() {
        
        DispatchQueue.main.async {
            if UserDefaults.standard.bool(forKey: "liveStatus") {
                self.gotoLiveVC()
            } else if UserDefaults.standard.bool(forKey: "storyStatus") {
                self.gotoStoryVC()
            } else {
                self.gotoLiveVC()
            }
        }
    }
    
    func gotoLiveVC() {
        
        DispatchQueue.main.async {
            CustomMoEngage.shared.sendEventUIComponent(componentName: "Home_Live", extraParamDict: nil)
            
            let liveVC = Storyboard.main.instantiateViewController(viewController: LiveScreenViewController_New.self)
            liveVC.hidesBottomBarWhenPushed = true
            liveVC.isComingFromLiveButton = true
            liveVC.liveAgoraData = self.liveData
            self.pushAnimation()
            self.navigationController?.pushViewController(liveVC, animated: false)
        }
    }
    
    func gotoStoryVC() {
        
        DispatchQueue.main.async {
            if let image = UIImage(named: "storyCeleb") {
                let color = UIColor(patternImage: image)
                self.liveButton.backgroundColor = color
            }
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let story = appDelegate.story,
                let story_copy = try? story.copy() {
                
                let storyPreviewScene = APMStoryPreviewController.init(story: story_copy)
                storyPreviewScene.modalPresentationStyle = .fullScreen
                storyPreviewScene.delegate = self
                self.present(storyPreviewScene, animated: true, completion: nil)
            }
        }
    }
    
     func checkMobileVerification() {
         
         if self.checkIsUserLoggedIn() {
             let isRequiredMobileVerifyPopup = RCValues.sharedInstance.bool(forKey: .showMobileVerifyPopupIos)
             let isMobileVerificationMandatory = RCValues.sharedInstance.bool(forKey: .isMobileVerificationMandatoryIos)
             let isMobileVerified = UserDefaults.standard.bool(forKey: "mobile_verified")
             
             if  let CustomerType = UserDefaults.standard.value(forKey: "customerstatus") as? String {
             if CustomerType == "epu" {
             if isRequiredMobileVerifyPopup && !isMobileVerified {
                 openMobileVerificationPopUp(isMandatory: isMobileVerificationMandatory)
             }
                 }
             }
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
    
    @objc func getFirstTimeUserData() {
        self.getUserDetails { (result) in
            print(result)
        }
    }
    
    
    func checkIsPreventvideorecordingIos() {
        
        
        let isCaptured =  UIScreen.main.isCaptured
        if isCaptured {
            screenProtecter.lockRecording()
        }
        
        
        if self.checkIsUserLoggedIn() {
            let isRequiredMobileVerifyPopup = RCValues.sharedInstance.bool(forKey: .showMobileVerifyPopupIos)
            let isMobileVerificationMandatory = RCValues.sharedInstance.bool(forKey: .isMobileVerificationMandatoryIos)
            let isMobileVerified = UserDefaults.standard.bool(forKey: "mobile_verified")
            
            if  let CustomerType = UserDefaults.standard.value(forKey: "customerstatus") as? String {
            if CustomerType == "epu" {
            if isRequiredMobileVerifyPopup && !isMobileVerified {
                openMobileVerificationPopUp(isMandatory: isMobileVerificationMandatory)
            }
                }
            }
        }
    }
   
    
    
    
    func pushAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .fade//CATransitionType.push
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
    
    func setProfileImageOnBarButton(onlyLiveButton: Bool = false) {
        
        liveButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        liveButton.addTarget(self, action:#selector(self.openLiveScreen), for: .touchUpInside)
        
        if let image = UIImage(named: "liveCeleb") {
            
            let color = UIColor(patternImage:  image)
            liveButton.backgroundColor = color
            
            let barButton = UIBarButtonItem()
            barButton.customView = liveButton
            
            if let loginStatus = UserDefaults.standard.object(forKey: "LoginSession") as? String, loginStatus == "LoginSessionIn", onlyLiveButton == false {
                let coinsBarButton = UIBarButtonItem(customView: coinsBarButtonView())
                self.navigationItem.rightBarButtonItems = [barButton, coinsBarButton]
            } else {
                self.navigationItem.rightBarButtonItems = [barButton]
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
        }
    }
    
    func formatPoints(num: Double) ->String{
        var thousandNum = num/1000
        var millionNum = num/1000000
        if num >= 1000 && num < 1000000{
            if (floor(thousandNum) == thousandNum) {
                return("\(Int(thousandNum))k")
            }
            return("\(thousandNum.roundToPlaces(places: 1))k")
        }
        if num > 1000000{
            if (floor(millionNum) == millionNum) {
                return("\(Int(thousandNum))k")
            }
            return ("\(millionNum.roundToPlaces(places: 1))M")
        }
        else {
            if (floor(num) == num) {
                return ("\(Int(num))")
            }
            return ("\(num)")
        }
    }
    
    func getBuketData(completion: @escaping (JSON)->()) {
        
        if Reachability.isConnectedToNetwork() == true{
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.HOME_SCREEN_DATA + Constants.artistId_platform, extraHeader: nil, closure: { (result) in
                switch result {
                case .success(let data):
                    if (data["error"] as? Bool == true) {
                        self.showToast(message: "Something went wrong. Please try again!")
                        return
                        
                    } else {
                        self.buckets = [List]()
                        if (data != nil) {
                            let arrayList =  data["data"]["list"].arrayObject
                            for dict in arrayList!{
                                
                                let list : List = List(dictionary: dict as! NSDictionary)!
                                self.buckets.append(list)
                                BucketValues.bucketIdArray.append(list._id ?? "")
                                
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
                case .failure(let error):
                    print(error)
                }
                
            })
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    func addBucketListingToDatabase(bucketArray : [List]) {
        
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
   //     if (database != nil) {
            database.createStatsTable()
            database.createBucketListTable()
            database.addBucketColum()
  //      }
        
        for list in buckets {
            database.insertIntoBucketListTable(list: list)
        }
    }
    //MARK:- SidemenuView
    open func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        
        var  identifierStr: String! = ""
        if CustomerDetails.baseViewToPushIs != nil
        {
            identifierStr = CustomerDetails.baseViewToPushIs
        } else
        {
            identifierStr = "NA"
        }
        switch(index) {
        case 0:
            //            print("identifierStr \(identifierStr) \n", terminator: "")
            
            //may be we need to push VC here
            self.openViewControllerBasedOnIdentifier(identifierStr)
            
            
            break
        case 1:
            //            print("identifierStr \(identifierStr)\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier(identifierStr)
            
            break
            
        case 2:
            // print("Profile\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier(identifierStr)
            
            break
            
        case 3:
            // print("Purchase\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier(identifierStr)
            
            break
        case 4:
            // print("Purchase\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier(identifierStr)
            
            break
        case 5:
            // print("Purchase\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier(identifierStr)
            
            break
        case 6:
            // print("Purchase\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier(identifierStr)
            
            break
        case 7:
            self.openViewControllerBasedOnIdentifier(identifierStr)
            
            break
            
        case 8:
            
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func getOfflineUserData() -> Customer {
        
        var customer: Customer!
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let writePath = documents + "/ConsumerDatabase.sqlite"
        print(writePath)
        var database : DatabaseManager!
        if ( !fileManager.fileExists(atPath : writePath)) {
            
        } else {
             database = DatabaseManager.sharedInstance
                       database.initDatabase(path: writePath)
                       customer = database.getCustomerData()
                       CustomerDetails.customerData = customer
                       CustomerDetails.custId = customer._id
                       CustomerDetails.firstName = customer.first_name
                       CustomerDetails.mobile_verified = UserDefaults.standard.bool(forKey: "mobile_verified")
                       CustomerDetails.email_verified = UserDefaults.standard.bool(forKey: "email_verified")
                       CustomerDetails.profile_completed = UserDefaults.standard.bool(forKey: "profile_completed")
                       CustomerDetails.coins = customer.coins
                       CustomerDetails.email = customer.email
                       CustomerDetails.lastName = customer.last_name
                       CustomerDetails.picture = customer.picture
                       CustomerDetails.purchase_stickers = customer.purchaseStickers
                       CustomerDetails.mobileNumber = customer.mobile
                       CustomerDetails.directline_room_id = customer.directline_room_id
                       CustomerDetails.gender = customer.gender
                       CustomerDetails.badges = customer.badges
                       CustomerDetails.identity = customer.identity
                       CustomerDetails.lastVisited = customer.last_visited
                       CustomerDetails.status = customer.status
                       CustomerDetails.dob = customer.dob
                       CustomerDetails.mobile_code = customer.mobile_code
        }
        return customer
    }
    
    
    open func getUserDetails(completion: @escaping(_ result: Bool)->()) {
        
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getCoins, extraHeader: nil) { (result) in
            
            switch result {
                
            case .success(let data):
                print("Base : \(#function) => \(data)")
                
                if let error = data["error"].bool {
                    if error {
                        return
                    }
                }
                
                if let coins = data["data"]["coins"].int {
                    CustomerDetails.coins = coins
                    DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins)
                    CustomMoEngage.shared.updateMoEngageCoinAttribute()
                    self.availableCoinsLabel?.text = "\(coins)"
                }
                
                if let mobile_verified = data["data"]["mobile_verified"].bool {
                    CustomerDetails.mobile_verified = mobile_verified
                    UserDefaults.standard.set(CustomerDetails.mobile_verified, forKey: "mobile_verified")
                    UserDefaults.standard.synchronize()
                }
                
                if let mobile = data["data"]["mobile"].string {
                    if mobile != "" {
                        CustomerDetails.mobileNumber = mobile
                        DatabaseManager.sharedInstance.updateMobileNumber(mobileNumber: mobile)
                    }
                }
                
                completion(true)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    open func openViewControllerBasedOnIdentifier(_ strIdentifier: String) {
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!) {
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
}


extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

//extension BaseViewController: MOInAppDelegate{
//    //This delegate will be called when an In-App is shown. You can use this to ensure not showing alerts or pop ups of your own at the same time.
//    private func inAppShown(withCampaignID campaignID: String?) {
//        print("moengage In App called \(campaignID ?? "")")
//    }
//
//
//    // The enum InAppWidget is for the different types of widgets which can be clicked in the In-App.
//    private func inAppClicked(for widget: InAppWidget, screenName: String?, andDataDict dataDict: [AnyHashable : Any]?) {
//
//    }
//}


// MARK: -  Agora Web Service
extension BaseViewController {
    
    func loginPopPop() {
        liveIconClick = false
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPopPopViewController") as! LoginPopPopViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        popOverVC.textLabel.text = "Hey there! log in right now to connect with me"
        popOverVC.coinsView.isHidden = true
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func startAgoraEngine() {
        self.agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: artistConfig.agora_id ?? "", delegate: nil)
    }
    
    func stopAgoraEngine() {
        
    }
    
    func checkAgoraChannelExist(navigateToLiveVC: Bool = false) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if appDelegate.isCheckAgoraChannelExecuting == true { return }
            appDelegate.isCheckAgoraChannelExecuting = true
          
            //crash
            let apiName = Constants.WEB_CHECK_AGORA_CHANNEL + "\(artistConfig.agora_id ?? "")" + "/\(artistConfig.channel_namespace ?? "")"
            
            if Reachability.isConnectedToNetwork() {
                
                if navigateToLiveVC {
                    self.showCustomLoader(window: appDelegate.window)
                }
                
                ServerManager.sharedInstance().getRequestAgora(postData: nil, apiName: apiName, extraHeader: nil) { (result) in
                    
                    if navigateToLiveVC {
                        self.hideCustomLoader()
                    }
                    
                    appDelegate.isCheckAgoraChannelExecuting = false
                    
                    DispatchQueue.main.async {
                        
                        switch result {
                        case .success(let data):
                            if let dictData = data["data"].dictionaryObject {
                                
                                if let channel_exist = dictData["channel_exist"] as? Bool {
                                    
                                    if channel_exist == true {
                                        
                                        if let arrBroadcasters = dictData["broadcasters"] as? [Any] {
                                            
                                            if arrBroadcasters.count > 0 {
                                                
                                                self.liveData = dictData
                                                print("channel is live --------------->>>>")
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
                                            }
                                            else {
                                                
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                                            }
                                        }
                                        else {
                                            
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                                        }
                                    }
                                    else {
                                        
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                                    }
                                }
                                else
                                {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                                }
                            }
                            else {
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                            }
                            
                        case .failure(let error):
                            print(error)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                        }
                        
                        if navigateToLiveVC {
                            self.handleLiveButton()
                        }
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                    if navigateToLiveVC {
                        self.handleLiveButton()
                    }
                }
            }
            
        }
    }
    
    func checkStoryExistAtLaunch() {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if appDelegate.isCheckStoryExecuting == true { return }
            appDelegate.isCheckStoryExecuting = true
            
            if let bucket = GlobalFunctions.returnBucketListFormBucketCode(code: "story", isForStory: true),
                let bucketID = bucket._id {
                
                let paramters = ["bucket_id": bucketID,
                                 "is_story": true] as [String : Any]
                
                WebServiceHelper.shared.callGetMethod(endPoint: Constants.bucketContent, parameters: paramters, responseType: APMStoryResponse.self, showLoader: false, baseURL: Constants.cloud_base_url) { (response, error) in
                    
                    appDelegate.isCheckStoryExecuting = false
                    
                    if let story = response?.data,
                        let snaps = story.snaps, snaps.count > 0 {
                        appDelegate.story = story
                        
                        UserDefaults.standard.set(true, forKey: "storyStatus")
                    } else {
                        UserDefaults.standard.set(false, forKey: "storyStatus")
                    }
                    
                    UserDefaults.standard.synchronize()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
                }
            }
        }
    }
}

extension BaseViewController {
    fileprivate func coinsBarButtonView() -> UIView {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0.0, y: 0.0, width: 45.0, height: 40.0)
        
        let label = UILabel()
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        if CustomerDetails.profile_completed == true {
            imageView.image = #imageLiteral(resourceName: "armsCoin")
        }else {
            imageView.image = #imageLiteral(resourceName: "profile_completed")
        }
        
        
        if let coins = CustomerDetails.coins {
            label.text = "\(coins)"
        } else {
            label.text = "0"
        }
        //        label.text = coin
        label.font = UIFont.init(name: AppFont.bold.rawValue, size: 8)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        availableCoinsLabel = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = 1.0
        stackView.distribution  = .fill
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        let actionButton = UIButton(type: .custom)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(actionButton)
        containerView.bringSubviewToFront(actionButton)
        actionButton.addTarget(self, action: #selector(didTapCoinsBarButton), for: .touchUpInside)
        
        actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        actionButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        return containerView
    }
    
    @objc func didTapCoinsBarButton() {
        print("didTapCoinsBarButton")
        
        if CustomerDetails.profile_completed == true {
            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            let walletNavigate = mainstoryboad.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
            walletNavigate.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(walletNavigate, animated: false)
        }
    }
    
    @objc func updatedCoin(_ notification: NSNotification) {
        
        if let coins = CustomerDetails.coins {
            availableCoinsLabel?.text = "\(coins)"
            let database = DatabaseManager.sharedInstance
            database.updateCustomerCoins(coinsValue: CustomerDetails.coins)
        } else {
            availableCoinsLabel?.text = "0"
        }
        
        if notification.userInfo == nil {
            checkMobileVerification()
        }
    }
}

// MARK: - APMStoryPreviewProtocol
extension BaseViewController: APMStoryPreviewProtocol {
    
    func didTapPromotionButton(index: Int) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let story = appDelegate.story,
            let snaps = story.snaps {
            
            if index < snaps.count {
                if let promotionType = snaps[index].promotion_type {
                    
                    if promotionType != "external_url" {
                        
                        let bucketIndex: Int = GlobalFunctions.findIndexOfBucketCode(code: promotionType) ?? -1
                        
                        if bucketIndex > -1 {
                            if bucketIndex < 4 {
                                
                                if let tab = navigationController?.viewControllers.last as? CustomTabViewController {
                                    tab.tabBar.isHidden = false
                                    tab.selectedIndex = bucketIndex
                                    tab.navigationItem.title = tab.tabMenuArray[bucketIndex].caption ?? ""
                                } else if let tab = navigationController?.viewControllers.filter( { $0 is CustomTabViewController}).first as? CustomTabViewController {
                                    tab.tabBar.isHidden = false
                                    tab.selectedIndex = bucketIndex
                                    tab.navigationItem.title = tab.tabMenuArray[bucketIndex].caption ?? ""
                                    self.navigationController?.popToViewController(tab, animated: false)
                                }
                            } else {
                                
                                if let tab = navigationController?.viewControllers.last as? CustomTabViewController {
                                    tab.tabBar.isHidden = false
                                    tab.selectedIndex = 4
                                    tab.navigationItem.title = tab.tabMenuArray[4].caption ?? ""
                                } else if let tab = navigationController?.viewControllers.filter( { $0 is CustomTabViewController}).first as? CustomTabViewController {
                                    tab.tabBar.isHidden = false
                                    tab.selectedIndex = 4
                                    tab.navigationItem.title = tab.tabMenuArray[4].caption ?? ""
                                    self.navigationController?.popToViewController(tab, animated: false)
                                }
                                if promotionType == "shoutout" {
                                    let celebyteVC = ShoutoutConfig.UserDefaultsManager.shouldShowWelcomeScreen() ? Storyboard.videoGreetings.instantiateViewController(viewController: ShoutoutWelcomeViewController.self) : Storyboard.videoGreetings.instantiateViewController(viewController: VideoGreetingsViewController.self)
                                    
                                    self.navigationController?.pushViewController(celebyteVC, animated: false)
                                } else if promotionType == "directline" {
                                    let wardrobeVC = Storyboard.main.instantiateViewController(viewController: DirectLinkViewController.self)
                                    self.navigationController?.pushViewController(wardrobeVC, animated: false)
                                } else if promotionType == "wardrobe" {
                                    let wardrobeVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobeViewController.self)
                                    self.navigationController?.pushViewController(wardrobeVC, animated: false)
                                } else if promotionType == "wallet" {
                                    let walletVC = Storyboard.main.instantiateViewController(viewController: PurchaseCoinsViewController.self)
                                    self.navigationController?.pushViewController(walletVC, animated: false)
                                } else {
                                    let resultVC = Storyboard.main.instantiateViewController(viewController: TravelingViewController.self)
                                    
                                    if let list = GlobalFunctions.returnBucketListFormBucketCode(code: promotionType) {
                                        resultVC.pageList = list
                                        resultVC.selectedIndexVal = 4
                                        resultVC.navigationTittle = list.name ?? ""
                                        resultVC.selectedBucketCode = list.code
                                        
                                        self.navigationController?.pushViewController(resultVC, animated: false)
                                    }
                                }
                            }
                        }
                    } else if let url = snaps[index].promotion_value {
                        
                        let termeAndConditionsVC = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
                        termeAndConditionsVC.navigationTitle = snaps[index].webview_label ?? ""
                        termeAndConditionsVC.openUrl = url
                        
                        self.navigationController?.pushViewController(termeAndConditionsVC, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension BaseViewController: UIViewControllerTransitioningDelegate {
    
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


// MARK: UIApplication extensions

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
