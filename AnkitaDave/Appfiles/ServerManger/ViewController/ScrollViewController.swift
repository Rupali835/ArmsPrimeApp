//
//  ScrollViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 09/07/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Alamofire_SwiftyJSON
import FirebaseAnalytics
import LocalAuthentication
import Firebase
import FirebaseCore

class ScrollViewController: BaseViewController ,UIScrollViewDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var guidImageScroll: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var facebookWidth: NSLayoutConstraint!
    @IBOutlet weak var googleWidth: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    var pageControl = UIPageControl()
    var imagesArray = ["Guid-Screen-1.jpg", "Guid-Screen-2.jpg", "Guid-Screen-3.jpg","Guid-Screen-4.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageControl()
        guidImageScroll.delegate = self
        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        self.navigationController?.isNavigationBarHidden = true
        //        var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        //        scrollView.isPagingEnabled = true
        //        scrollView.alwaysBounceVertical = false
        
        for i in 0..<imagesArray.count {
            //            var xOrigin: CGFloat = i * guidImageScroll.frame.size.width
            
            
            //            if UIDevice().userInterfaceIdiom == .phone {
            //                switch UIScreen.main.nativeBounds.height {
            //                case 1136:
            //                    print("IPHONE 5,5S,5C")
            //                case 1334:
            //                    print("IPHONE 6,7,8 IPHONE 6S,7S,8S ")
            //                case 1920, 2208:
            //                    print("IPHONE 6PLUS, 6SPLUS, 7PLUS, 8PLUS")
            //                case 2436:
            //                    print("IPHONE X, IPHONE XS")
            //                case 2688:
            //                    print("IPHONE XS_MAX")
            //                case 1792:
            //                    print("IPHONE XR")
            //                default:
            //                    print("UNDETERMINED")
            //                }
            //            }
            
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    let xOrigin = view.frame.width * CGFloat(i)
                    let imageView = UIImageView(frame: CGRect(x: xOrigin, y: -20, width: view.frame.size.width, height: 517))
                    imageView.image = UIImage(named: imagesArray[i])
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    guidImageScroll.addSubview(imageView)
                    
                    
                case 1334:
                    print("iPhone 6/6S/7/8")
                    
                    let xOrigin = view.frame.width * CGFloat(i)
                    let imageView = UIImageView(frame: CGRect(x: xOrigin, y: -20, width: view.frame.size.width, height: 617))
                    imageView.image = UIImage(named: imagesArray[i])
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    guidImageScroll.addSubview(imageView)
                    
                    
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    
                    let xOrigin = view.frame.width * CGFloat(i)
                    let imageView = UIImageView(frame: CGRect(x: xOrigin, y: -20, width: view.frame.size.width, height: 685))
                    imageView.image = UIImage(named: imagesArray[i])
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    guidImageScroll.addSubview(imageView)
                    
                case 2436:
                    print("iPhone X")
                    let xOrigin = view.frame.width * CGFloat(i)
                    let imageView = UIImageView(frame: CGRect(x: xOrigin, y: -20, width: view.frame.size.width, height: 703))
                    imageView.image = UIImage(named: imagesArray[i])
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    guidImageScroll.addSubview(imageView)
                    
                case 2688:
                    print("IPHONE XS_MAX")
                    let xOrigin = view.frame.width * CGFloat(i)
                    let imageView = UIImageView(frame: CGRect(x: xOrigin, y: -20, width: view.frame.size.width, height: 785))
                    imageView.image = UIImage(named: imagesArray[i])
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    guidImageScroll.addSubview(imageView)
                    
                case 1792:
                    print("IPHONE XR")
                    let xOrigin = view.frame.width * CGFloat(i)
                    let imageView = UIImageView(frame: CGRect(x: xOrigin, y: -20, width: view.frame.size.width, height: 785))
                    imageView.image = UIImage(named: imagesArray[i])
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    guidImageScroll.addSubview(imageView)
                    
                default:
                    print("unknown")
                    
                }
            } else {
                
                let xOrigin = view.frame.width * CGFloat(i)
                let imageView = UIImageView(frame: CGRect(x: xOrigin, y: -20, width: view.frame.size.width, height: view.frame.size.height))
                imageView.image = UIImage(named: imagesArray[i])
                imageView.contentMode = .scaleToFill
                imageView.clipsToBounds = true
                guidImageScroll.addSubview(imageView)
                
            }
            
            self.skipButton.layer.borderWidth = 1
            self.skipButton.layer.borderColor = UIColor.white.cgColor
            self.skipButton.layer.masksToBounds = false
            self.skipButton.clipsToBounds = true
            
            self.loginButton.layer.borderWidth = 1
            self.loginButton.layer.borderColor = UIColor.white.cgColor
            //            self.loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
            self.loginButton.layer.masksToBounds = false
            self.loginButton.clipsToBounds = true
            
            self.googleButton.layer.borderWidth = 1
            self.googleButton.layer.borderColor = UIColor.white.cgColor
            //            self.googleButton.layer.cornerRadius = googleButton.frame.size.height / 2
            self.googleButton.layer.masksToBounds = false
            self.googleButton.clipsToBounds = true
            
            self.facebookButton.layer.borderWidth = 1
            self.facebookButton.layer.borderColor = UIColor.white.cgColor
            //            self.facebookButton.layer.cornerRadius = facebookButton.frame.size.height / 2
            self.facebookButton.layer.masksToBounds = false
            self.facebookButton.clipsToBounds = true
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                guidImageScroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(imagesArray.count), height: 517-20)
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
                guidImageScroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(imagesArray.count), height: 617-20)
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                
                guidImageScroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(imagesArray.count), height: 685-20)
                
            case 2436:
                print("iPhone X")
                guidImageScroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(imagesArray.count), height: 703-20)
                
            case 2688:
                print("IPHONE XS_MAX")
                guidImageScroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(imagesArray.count), height: 785-20)
                
            case 1792:
                print("IPHONE XR")
                guidImageScroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(imagesArray.count), height: 785-20)
                
            default:
                print("unknown")
            }
            
        } else {
            
            guidImageScroll.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(imagesArray.count), height: self.view.frame.size.height - 20 - 40)
        }
        
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 60,width: UIScreen.main.bounds.width,height: 5))
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 65,width: UIScreen.main.bounds.width,height: 5))
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 62,width: UIScreen.main.bounds.width,height: 5))
                
            case 2436:
                print("iPhone X")
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 100,width: UIScreen.main.bounds.width,height: 5))
                
            case 2688:
                print("IPHONE XS_MAX")
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 100,width: UIScreen.main.bounds.width,height: 5))
                
            case 1792:
                print("IPHONE XR")
                pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 100,width: UIScreen.main.bounds.width,height: 5))
                
            default:
                print("unknown")
            }
        } else {
            pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 100 ,width: UIScreen.main.bounds.width,height: 5))
        }
        
        self.pageControl.numberOfPages =  imagesArray.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        self.view.addSubview(pageControl)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = guidImageScroll.contentOffset.x
        let w = guidImageScroll.bounds.size.width
        pageControl.currentPage = Int(x/w)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GlobalFunctions.screenViewedRecorder(screenName: "Home Splash Screen")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Guide_Skip", extraParamDict: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func loginLinkedClicked(_ sender: UIButton) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Guide_Login", extraParamDict: nil)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 11.0, *) {
            var vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            self.pushAnimation()
            self.navigationController?.pushViewController(vc!, animated: false)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @IBAction func facebookClicked(_ sender: UIButton) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Guide_Facebook", extraParamDict: nil)
        let fbLoginManager : LoginManager = LoginManager()
        
        let permisions = ["email","public_profile"]
        
        fbLoginManager.logIn(permissions: permisions, from: self) { (result, error) -> Void in
            
            if (error == nil) {
                
                let fbloginresult : LoginManagerLoginResult = result!
                
                if fbloginresult.grantedPermissions != nil {
                    
                    if (fbloginresult.grantedPermissions.contains("email"))
                    {
                        
                        self.getFBUserData()
                        
                    }
                    
                } else {
                    
                    print("No information available")
                    
                }
            }
        }
        
        
    }
    var facebookEmail = ""
    var facebookId = ""
    var firstName = ""
    var lastName = ""
    var profilePic = ""
    var gender = ""
    
    func getFBUserData() {
        //        self.overlayView.showOverlay(view: self.view)
        self.showLoader()
        if ((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    let currentConditions = result as! [String:Any]
                    
                    for (key, value) in currentConditions {
                        
                        if key == "id"
                        {
                            self.facebookId = value as! String
                        }
                        
                        if key == "first_name"
                        {
                            self.firstName = value as! String
                        }
                        if key == "last_name"
                        {
                            self.lastName = value as! String
                        }
                        //                        if key == "email" {
                        //                            if let facebookEmail = value as? String, facebookEmail != "" {
                        //                                self.facebookEmail = facebookEmail
                        //                            } else {
                        //                                self.facebookEmail = self.firstName + "." + self.lastName + "@facebook.com"
                        //                            }
                        //
                        //                        }
                        if key == "email" {
                                if let facebookEmail = value as? String, facebookEmail != "" {
                                                                                          self.facebookEmail = facebookEmail
                            } else {
                                //                                self.facebookEmail = self.firstName + "." + self.lastName + "@facebook.com"
                                                                                                                                                                                                                                                                                                        self.stopLoader()
                                                                                                                                                                                                                                                                                                self.showOnlyAlert(title: "Info" ,message: "Your facebook account don't have email Id, please enter email Id in your facebook account to access this app.")
                                                                                                                                                                                                                                                                                                return
                                                        }
                                                                                                                                                                                                                                                                                                                            }
                        
                        if key == "picture"
                        {
                            let dict = value as! [String: Any]
                            let data = dict["data"] as! [String: Any]
                            //                            ["data"] as! Dictionary
                            let url = data["url"] as! String
                            self.profilePic = url
                            //                            let data =
                        }
                        if key == "gender"
                        {
                            self.gender = value as! String
                        }
                    }
                    self.calltofacebook()
                    
                }
                else
                {
                    print("Error: \(error)")
                    self.stopLoader()
                }
            })
        }
    }
    
    func calltofacebook()
    {
        if Reachability.isConnectedToNetwork()
        {
            //            self.view.addSubview(progressHUD)
            //get FCM Id also
            //"password": tfPassword.text!,
            let dict = ["email": facebookEmail, "identity": "facebook", "facebook_id": facebookId, "first_name" : self.firstName , "last_name" : self.lastName, "picture" : self.profilePic, "device_id": Constants.DEVICE_ID ?? "", "segment_id": 2, "fcm_id": UserDefaults.standard.string(forKey: "fcmId") ?? "", "platform": "ios" ] as [String: Any] //streamType":"start/end (Depending on the status), "
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                
                let url = NSURL(string: Constants.App_BASE_URL + Constants.LOGIN)!
                let request = NSMutableURLRequest(url: url as URL)
                
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "ArtistId")
                request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
                
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                    if error != nil{
                        DispatchQueue.main.async {
                            self.stopLoader()
                            self.showToast(message: Constants.NO_Internet_MSG)
                        }
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        print("facebok login response json \(String(describing: json))")
                        //                        print("facebook login response json desc \(json?.description)")
                        
                        if json?.object(forKey: "error") as? Bool == true
                        {
                            DispatchQueue.main.async {
                                if let arr = json?.object(forKey: "error_messages") as? NSMutableArray {
                                    self.stopLoader()
                                    self.showToast(message: arr[0] as! String)
                                    
                                }
                            }
                        } else if (json?.object(forKey: "status_code") as? Int == 200) {
                            DispatchQueue.main.async {
                                
                                UserDefaults.standard.set("LoginSessionIn", forKey: "LoginSession")
                                UserDefaults.standard.synchronize()
                                
                                if let dictData = json?.object(forKey: "data") as? NSDictionary {
                                    if let dict = dictData.object(forKey: "customer") as? NSMutableDictionary {
                                        print("Login Successful")
                                        let customer : Customer = Customer.init(dictionary: dict)!
                                        CustomerDetails.customerData = customer
                                        CustomerDetails.badges = customer.badges
                                        if let metaData = dictData.value(forKey: "metaids") as? [String: Any] {
                                            customer.purchaseStickers =  metaData["purchase_stickers"] as? Bool
                                            DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
                                            DatabaseManager.sharedInstance.storeLikesAndPurchase(like_ids: metaData["like_content_ids"] as! [String], purchaseIds: metaData["purchase_content_ids"] as! [String], block_ids: metaData["block_content_ids"] as? [String])
                                            _ = self.getOfflineUserData()
                                        }
                                        
                                        if let Customer_Id = dict.object(forKey: "_id") as? String{
                                            CustomerDetails.custId = Customer_Id
                                        }
                                        if let Customer_Account_Link = dict.object(forKey: "account_link") as? NSMutableDictionary{
                                            CustomerDetails.account_link = Customer_Account_Link
                                        }
                                        //                                        CustomerDetails.badges = dict.object(forKey: "badges")
                                        
                                        
                                        if let customer_email = dict.object(forKey: "email") as? String{
                                            UserDefaults.standard.setValue(customer_email, forKey: "useremail")
                                            UserDefaults.standard.synchronize()
                                            CustomerDetails.email = customer_email
                                        }
                                        
                                        if let coinsxp = dictData.value(forKey: "coinsxp") as? [String: Any], let coins = coinsxp["coins"] as? Int {
                                            DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: coins)
                                            CustomerDetails.coins = coins
                                            if let commentChannelName = coinsxp["comment_channel_name"] as? String {
                                                CustomerDetails.commentChannelName = commentChannelName
                                            }
                                            if let giftChannelName = coinsxp["gift_channel_name"] as? String {
                                                CustomerDetails.giftChannelName = giftChannelName
                                            }
                                        }
                                        
                                        
                                        if let Customer_FirstName = dict.object(forKey: "first_name") as? String{
                                            UserDefaults.standard.setValue(Customer_FirstName, forKey: "username")
                                            UserDefaults.standard.synchronize()
                                            CustomerDetails.firstName = Customer_FirstName
                                        }
                                        if let Customer_LastName = dict.object(forKey: "last_name") as? String{
                                            CustomerDetails.lastName = Customer_LastName
                                        }
                                        
                                        if let Customer_MobileVerified = dict.object(forKey: "mobile_verified") as? Bool {
                                            CustomerDetails.mobile_verified = Customer_MobileVerified
                                        }
                                        
                                        if let Customer_MobileVerified = dict.object(forKey: "mobile_verified") as? Int {
                                            if Customer_MobileVerified == 0 {
                                                CustomerDetails.mobile_verified = false
                                            } else if Customer_MobileVerified == 1 {
                                                CustomerDetails.mobile_verified = true
                                            }
                                        }
                                        
                                        UserDefaults.standard.set(CustomerDetails.mobile_verified, forKey: "mobile_verified")
                                        UserDefaults.standard.synchronize()
                                        
                                        if let Customer_Token = dictData.object(forKey: "token") as? String{
                                            CustomerDetails.token = Customer_Token
                                        }
                                        if let Customer_Picture = dict.object(forKey: "picture") as? String{
                                            CustomerDetails.picture = Customer_Picture
                                        }
                                        UserDefaults.standard.set(dictData.object(forKey: "token") as? String, forKey: "token")
                                        UserDefaults.standard.synchronize()
                                        if let Customer_token = dictData.object(forKey: "token") as? String{
                                            Constants.TOKEN = Customer_token
                                        }
                                        
                                        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
                                        if notificationType == [] {
                                            print("notifications are NOT enabled")
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let vc : NotificationViewController = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
                                            self.stopLoader()
                                            self.pushAnimation()
                                            self.present(vc, animated: false, completion: nil)
                                        } else {
                                            print("notifications are enabled")
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let vc : MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                                            self.stopLoader()
                                            self.pushAnimation()
                                            self.present(vc, animated: false, completion: nil)
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        
                    } catch let error as NSError {
                        print(error)
                        self.stopLoader()
                        
                    }
                }
                task.resume()
            }
        }
        
    }
    
    public func toast(message: String, duration: Double) {
        
        let toast: UIAlertView = UIAlertView.init(title: nil, message: message, delegate: nil, cancelButtonTitle: "")
        
        toast.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toast.dismiss(withClickedButtonIndex: 0, animated: true)
        }
    }
    
    @IBAction func googleClicked(_ sender: UIButton) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Guide_G_Plus", extraParamDict: nil)
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil)
        {
            
            if Reachability.isConnectedToNetwork()
            {
                self.showLoader()
                
                let profilePicUrl = user.profile.imageURL(withDimension: 200) as? String
                let dict = ["email": user.profile.email,"first_name": user.profile.name , "profile_pic_url" : profilePicUrl, "identity": "google", "google_id": user.userID, "device_id": Constants.DEVICE_ID ?? "", "segment_id": 2, "fcm_id": UserDefaults.standard.string(forKey: "fcmId") ?? "", "platform": "ios" ] as [String: Any]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                    let url = NSURL(string: Constants.App_BASE_URL + Constants.LOGIN)!
                    let request = NSMutableURLRequest(url: url as URL)
                    
                    request.httpMethod = "POST"
                    request.httpBody = jsonData
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                    request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "ArtistId")
                    request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
                    
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                        if error != nil{
                            DispatchQueue.main.async {
                                self.stopLoader()
                                self.showToast(message: Constants.NO_Internet_MSG)
                                
                            }
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("Google login response json \(String(describing: json))")
                            //                        print("Google login response json desc \(json?.description)")
                            DispatchQueue.main.async {
                                
                                if json?.object(forKey: "error") as? Bool == true
                                {
                                    DispatchQueue.main.async {
                                        if let arr = json?.object(forKey: "error_messages") as? NSMutableArray {
                                            self.stopLoader()
                                            
                                            self.showToast(message: arr[0] as! String)
                                        }
                                    }
                                } else
                                    if (json?.object(forKey: "status_code") as? Int == 200)
                                    {
                                        
                                        UserDefaults.standard.set("LoginSessionIn", forKey: "LoginSession")
                                        UserDefaults.standard.synchronize()
                                        //                                            self.showToast(message: "Customer Login successfully")
                                        
                                        let dictData = json?.object(forKey: "data") as? NSDictionary
                                        if  let dict = dictData?.object(forKey: "customer") as? NSMutableDictionary{
                                            let customer : Customer = Customer.init(dictionary: dict)!
                                            CustomerDetails.customerData = customer
                                            CustomerDetails.badges = customer.badges
                                            if let metaData = dictData?.value(forKey: "metaids") as? [String: Any] {
                                                customer.purchaseStickers =  metaData["purchase_stickers"] as? Bool
                                                DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
                                                DatabaseManager.sharedInstance.storeLikesAndPurchase(like_ids: metaData["like_content_ids"] as! [String], purchaseIds: metaData["purchase_content_ids"] as! [String], block_ids: metaData["block_content_ids"] as? [String])
                                                _ = self.getOfflineUserData()
                                            }
                                            
                                            
                                            print("Login Successful")
                                            
                                            if let Customer_Id = dict.object(forKey: "_id") as? String{
                                                CustomerDetails.custId = Customer_Id
                                            }
                                            if let Customer_Account_Link = dict.object(forKey: "account_link") as? NSMutableDictionary{
                                                CustomerDetails.account_link = Customer_Account_Link
                                            }
                                            //                                        CustomerDetails.badges = dict.object(forKey: "badges")
                                            
                                            
                                            if let customer_email = dict.object(forKey: "email") as? String{
                                                UserDefaults.standard.setValue(customer_email, forKey: "useremail")
                                                UserDefaults.standard.synchronize()
                                                CustomerDetails.email = customer_email
                                            }
                                            
                                            if let coinsxp = dictData?.value(forKey: "coinsxp") as? [String: Any], let coins = coinsxp["coins"] as? Int {
                                                DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: coins)
                                                CustomerDetails.coins = coins
                                                if let commentChannelName = coinsxp["comment_channel_name"] as? String {
                                                    CustomerDetails.commentChannelName = commentChannelName
                                                }
                                                if let giftChannelName = coinsxp["gift_channel_name"] as? String {
                                                    CustomerDetails.giftChannelName = giftChannelName
                                                }
                                            }
                                            
                                            if let Customer_FirstName = dict.object(forKey: "first_name") as? String{
                                                UserDefaults.standard.setValue(Customer_FirstName, forKey: "username")
                                                UserDefaults.standard.synchronize()
                                                CustomerDetails.firstName = Customer_FirstName
                                            }
                                            if let Customer_LastName = dict.object(forKey: "last_name") as? String{
                                                CustomerDetails.lastName = Customer_LastName
                                            }
                                            
                                            if let Customer_MobileVerified = dict.object(forKey: "mobile_verified") as? Bool {
                                                CustomerDetails.mobile_verified = Customer_MobileVerified
                                            }
                                            
                                            if let Customer_MobileVerified = dict.object(forKey: "mobile_verified") as? Int {
                                                if Customer_MobileVerified == 0 {
                                                    CustomerDetails.mobile_verified = false
                                                } else if Customer_MobileVerified == 1 {
                                                    CustomerDetails.mobile_verified = true
                                                }
                                            }
                                            
                                            UserDefaults.standard.set(CustomerDetails.mobile_verified, forKey: "mobile_verified")
                                            UserDefaults.standard.synchronize()
                                            
                                            if let Customer_Token = dictData?.object(forKey: "token") as? String{
                                                CustomerDetails.token = Customer_Token
                                            }
                                            if let Customer_Picture = dict.object(forKey: "picture") as? String{
                                                CustomerDetails.picture = Customer_Picture
                                            }
                                            UserDefaults.standard.set(dictData?.object(forKey: "token") as? String, forKey: "token")
                                            UserDefaults.standard.synchronize()
                                            if let Customer_token = dictData?.object(forKey: "token") as? String{
                                                Constants.TOKEN = Customer_token
                                            }
                                            
                                            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
                                            if notificationType == [] {
                                                print("notifications are NOT enabled")
                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                let vc : NotificationViewController = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
                                                self.stopLoader()
                                                self.pushAnimation()
                                                self.present(vc, animated: false, completion: nil)
                                            } else {
                                                print("notifications are enabled")
                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                let vc : MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                                                self.stopLoader()
                                                self.pushAnimation()
                                                self.present(vc, animated: false, completion: nil)
                                            }
                                        }
                                        //                                        }
                                }
                            }
                        } catch let error as NSError {
                            print(error)
                            self.stopLoader()
                            
                        }
                    }
                    task.resume()
                }
                //            }
            } else
            {
                self.showToast(message: Constants.NO_Internet_MSG)
                
            }
        } else {
            print("\(error.localizedDescription)")
            
        }
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!)
    {
        // Perform any operations when the user disconnects from app here.
        // ...
        self.showLoader()
        
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        // myActivityIndicator.stopAnimating()
        
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        self.stopLoader()
    }
    
}

