//
//  ProfileViewController.swift
//  ZareenKhanConsumer
//
//  Created by Razr on 13/11/17.
//  Copyright © 2017 Razr. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation
import SDWebImage
import Alamofire
import Alamofire_SwiftyJSON
import Social
import SafariServices
import MoEngage
import Branch

class ProfileViewController: BaseViewController, ProfileDataDelegate
{
    //    @IBOutlet weak var profileBackgroundblur: UIImageView!
    //    @IBOutlet weak var walletView: UIView!
    //    @IBOutlet weak var walletLabel: UIView!
    //    @IBOutlet weak var coinView: UIView!
    @IBOutlet weak var coinsCountLabel: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ivProfilePic: UIImageView!
    @IBOutlet weak var armsIdLabel: UILabel!
    //    @IBOutlet weak var topFanView: UIView!
    //    @IBOutlet weak var dieFanView: UIView!
    //    @IBOutlet weak var loyalFanView: UIView!
    //    @IBOutlet weak var superfanView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var shareView: UIView!
    //    @IBOutlet weak var buyCoins: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var ivSuperFan: UIImageView!
    @IBOutlet weak var ivLoyalFan: UIImageView!
    @IBOutlet weak var ivDieHard: UIImageView!
    @IBOutlet weak var ivTopFan: UIImageView!
    
    @IBOutlet weak var fanTypeLabel: UILabel!
    @IBOutlet weak var accountBalHeader: UILabel!
    
    @IBOutlet weak var superFanLabel: UILabel!
    @IBOutlet weak var loyalFanLabel: UILabel!
    @IBOutlet weak var topFanLabel: UILabel!
    @IBOutlet weak var dieHardFanLabel: UILabel!
    
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var shareLabel: UILabel!
    private var overlayView = LoadingOverlay.shared
    var delegate: EditProfileViewController?
    var changePWDPopUp: ChangePasswordPopViewController!
    
    @IBOutlet weak var deactivateAccView: UIView!
    @IBOutlet weak var deactiveAccBtn: UIButton!
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let armsId = CustomerDetails.email, armsId != "" {
            self.armsIdLabel.text = "Armsprime id: \(armsId) "
        } else {
            armsIdLabel.text = nil
        }
        
        //        self.editView.layer.borderWidth = 1
        self.editView.layer.cornerRadius = 5
        self.editView.clipsToBounds = true
        
        //        self.passwordView.layer.borderWidth = 1
        self.passwordView.layer.cornerRadius = 5
        self.passwordView.clipsToBounds = true
        
        //        self.contactView.layer.borderWidth = 1
        self.contactView.layer.cornerRadius = 5
        self.contactView.clipsToBounds = true
        
        //        self.shareView.layer.borderWidth = 1
        self.shareView.layer.cornerRadius = 5
        self.shareView.clipsToBounds = true
        
        //        self.topFanView.layer.borderWidth = 1
        //        self.topFanView.layer.cornerRadius = topFanView.frame.size.width / 2
        //        self.topFanView.clipsToBounds = true
        //
        //        self.dieFanView.layer.borderWidth = 1
        //        self.dieFanView.layer.cornerRadius = dieFanView.frame.size.width / 2
        //        self.dieFanView.clipsToBounds = true
        //
        //        self.loyalFanView.layer.borderWidth = 1
        //        self.loyalFanView.layer.cornerRadius = loyalFanView.frame.size.width / 2
        //        self.loyalFanView.clipsToBounds = true
        //
        //        self.superfanView.layer.borderWidth = 1
        //        self.superfanView.layer.cornerRadius = superfanView.frame.size.width / 2
        //        self.superfanView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCoins(_:)), name: NSNotification.Name(rawValue: "updatedCoins"), object: nil)
        //        self.walletView.layer.borderWidth = 1
        //        self.walletView.layer.borderColor = UIColor.white.cgColor
        //        self.walletView.layer.cornerRadius = walletView.frame.size.width / 2
        //        self.walletView.layer.masksToBounds = false
        //        self.walletView.clipsToBounds = true
        //
        //        self.coinView.layer.borderWidth = 1
        //        self.coinView.layer.borderColor = UIColor.white.cgColor
        //        self.coinView.layer.cornerRadius = coinView.frame.size.width / 2
        //        self.coinView.layer.masksToBounds = false
        //        self.coinView.clipsToBounds = true
        
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = UIColor.white.cgColor
        self.setNavigationView(title: "PROFILE")
        self.tabBarController?.tabBar.isHidden = true
        
        self.designLayouts()
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        UIImage(named: "")?.draw(in: self.view.bounds)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        self.view.backgroundColor = UIColor(patternImage: image)
        
        lblUserName.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        armsIdLabel.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        editProfileButton.titleLabel!.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        accountBalHeader.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        coinsCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
        fanTypeLabel.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        superFanLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        loyalFanLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        dieHardFanLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        topFanLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        loyalFanLabel.alpha = 0.5
        dieHardFanLabel.alpha = 0.5
        topFanLabel.alpha = 0.5
        //        editView.setGradientBackground()
        //        passwordView.setGradientBackground()
        //        contactView.setGradientBackground()
        //        shareView.setGradientBackground()
        editView.backgroundColor = .clear
        passwordView.backgroundColor = .clear
        contactView.backgroundColor = .clear
        shareView.backgroundColor = .clear
        deactivateAccView.backgroundColor = .clear
        
        walletButton.titleLabel!.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        passwordButton.titleLabel!.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        contactUsButton.titleLabel!.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        shareLabel.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        deactiveAccBtn.titleLabel!.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        
        changePWDPopUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordPopViewController") as! ChangePasswordPopViewController
        
        //        self.getProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.overlayView.hideOverlayView()
        self.getCoins()

        if !self.checkIsUserLoggedIn() {
            self.coinsCountLabel.text = "0"
        } else {
            self.coinsCountLabel.text = "\(CustomerDetails.coins ?? 0)"
        }
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.getUserDetails { (result) in
            if result {
                self.designLayouts()
            }
        }
        
        if exmpleForSomeoneElseView != nil {
            exmpleForSomeoneElseView.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        GlobalFunctions.screenViewedRecorder(screenName: "View Profile Screen")
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Screen", extraParamDict: nil)
    }
    
    
    var exmpleForSomeoneElseView : UIView!
    @IBAction func forgetPassword(_ sender: UIButton) {
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            return
        }
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Change_password", extraParamDict: nil)
        if checkIsUserLoginFromEmail() {
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordPopViewController") as! ChangePasswordPopViewController
            
            self.addChild(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.exmpleForSomeoneElseView = popOverVC.view
            self.exmpleForSomeoneElseView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:self.view.frame.size.height)
            self.view.addSubview(self.exmpleForSomeoneElseView)
            popOverVC.didMove(toParent: self)
        } else {
            let msg = "You are logged in using your \(CustomerDetails.identity ?? "social") account, the ability to change password is not applicable for social accounts."
            self.showOnlyAlert(message: msg)
        }
    }
    
    func checkIsUserLoginFromEmail() -> Bool {
        if   let loginType = UserDefaults.standard.value(forKey: "logintype") as? String {
            if loginType == "email" {
                return true
            } else {
                return false
            }
        }
        return false
    }
    @IBAction func didTapReportButton(_ sender: Any) {
        
        //        UIApplication.shared.open(URL(string : "http://www.armsprime.com/contact-us.html")!, options: [:], completionHandler: { (status) in
        //
        //            self.stopLoader()
        //        })
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_ContatctUs", extraParamDict: nil)
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        //        resultViewController.navigationTitle = "Contact us"
        //        resultViewController.openUrl = "http://www.armsprime.com/contact-us.html"
        //        self.navigationController?.pushViewController(resultViewController, animated: true)
        
        
        if let url = URL(string: "mailto:info@armsprime.com") {
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "GiftSend"), object: nil)
    }
    
    @IBAction func walletButton(_ sender: UIButton) {
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            return
        }
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Wallet", extraParamDict: nil)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
        
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
   
    
    func getCoins() {
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getCoins, extraHeader: nil) { (result) in
            switch result {
            case .success(let data):
                print(data)
                if (data["error"] as? Bool == true) {
                    self.showToast(message: "Something went wrong. Please try again!")
                    //                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "CoinInfo", status: "Failed", reason:"", extraParamDict: nil)
                    return
                    
                } else {
                    if let coins = data["data"]["coins"].int {
                        //                        CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "CoinInfo", status: "Success", reason:"", extraParamDict: nil)
                        if !self.checkIsUserLoggedIn() {
                            self.coinsCountLabel.text = "0"
                            MoEngage.sharedInstance().setUserAttribute("\(0)", forKey: "wallet_balance")
                        } else {
                            self.coinsCountLabel.text = "\(CustomerDetails.coins ?? 0)"
                            MoEngage.sharedInstance().setUserAttribute(CustomerDetails.coins ?? 0, forKey: "wallet_balance")
                        }
                        
                    }
                }
            case .failure(let error):
                print(error)
                //                CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "CoinInfo", status: "Failed", reason:error.localizedDescription ?? "", extraParamDict: nil)
            }
        }
    }
    
    @IBAction func coinsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "profileToWallet", sender: nil)
    }
    
    @objc func updateCoins(_ notification: NSNotification) {
        if let coins = notification.userInfo?["updatedCoins"] as? Int {
            if !self.checkIsUserLoggedIn() {
                self.coinsCountLabel.text = "0"
            } else {
                self.coinsCountLabel.text = "\(CustomerDetails.coins ?? 0)"
            }
            CustomerDetails.coins = coins
            let database = DatabaseManager.sharedInstance
            database.updateCustomerCoins(coinsValue: CustomerDetails.coins)
            checkMobileVerification()
        }
    }
    
    func designLayouts()
    {
        //        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
        //            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
        //                editProfileButton.isHidden = false
        //
        //
        //            } else {
        //                editProfileButton.isHidden = true
        //
        //            }
        //        } else {
        //            editProfileButton.isHidden = true
        //
        //        }
        
        self.ivProfilePic.layer.borderWidth = 1.5
        self.ivProfilePic.layer.borderColor = UIColor.white.cgColor
        self.ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.width / 2
        self.ivProfilePic.layer.masksToBounds = false
        self.ivProfilePic.clipsToBounds = true
        //        self.ivProfilePic.backgroundColor = UIColor.clear
        self.ivProfilePic.image = UIImage(named: "profileph")
        
        
        
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil)
        {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn")
            {
                
                if CustomerDetails.firstName != nil && CustomerDetails.firstName != ""{
                    if CustomerDetails.lastName != nil {
                        self.lblUserName.text = CustomerDetails.firstName! + " " + CustomerDetails.lastName
                    } else {
                        self.lblUserName.text = CustomerDetails.firstName!
                    }
                    
                    self.lblUserName.text = lblUserName.text?.uppercased()
                } else {
                    if let email = CustomerDetails.email {
                        if email != "" {
                            self.lblUserName.text = email.components(separatedBy: "@")[0] as? String
                        } else {
                            self.lblUserName.text = "Username"
                        }
                        
                    }
                }
                
                if CustomerDetails.picture != nil{
                    self.ivProfilePic.sd_imageIndicator?.startAnimatingIndicator()
                    self.ivProfilePic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.ivProfilePic.sd_imageTransition = .fade
                    self.ivProfilePic.sd_setImage(with: URL(string:CustomerDetails.picture), completed: nil)
                    //                    self.profileBackgroundblur.sd_setImage(with: URL(string:CustomerDetails.picture), completed: nil)
                }
                setUserFanLevel()
                
            }
        }
        
        if self.checkIsUserLoggedIn() {
            deactivateAccView.isHidden = false
        } else {
            deactivateAccView.isHidden = true
        }
    }
    
    
    //saving the image to document can do if want
    func saveImg(image: UIImage, withFileName imgName: String, ofType extensn: String, inDirectory dirPath: String)
    {
        if (extensn.lowercased().contains("png"))
        {
            
        } else if (extensn.lowercased().contains("jpg") || (extensn.lowercased().contains("jpeg"))) {
            
        }
    }
    
    
    func sendProfileData(dict: [String : Any]) {
        
    }
    
    
    func createBody(parameters: [String: Any],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? EditProfileViewController
        {
            viewController.delegate = self
        }
    }
    
    
    
    @IBAction func buyCoins(_ sender: Any) {
        
    }
    @IBAction func btnBookmarksClicked(_ sender: UIButton)
    {
        showToast(message: "coming soon")
    }
    
    
    @IBAction func purchaseHistoryTapped(_ sender: Any) {
        
        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            return
        }
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WalletPaginationViewController") as! WalletPaginationViewController
//        self.navigationController?.pushViewController(resultViewController, animated: true)
        
        let myGreetings = Storyboard.videoGreetings.instantiateViewController(viewController: TransactionsViewController.self)
        navigationController?.pushViewController(myGreetings, animated: true)
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let editProfileVC = storyBoard.instantiateViewController(withIdentifier: "EarnMoreCoinsViewController") as! EarnMoreCoinsViewController
        editProfileVC.comingTitle = "Profile"
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    func setUserFanLevel() {
        let badgesArray = CustomerDetails.arrBadges
        //        print("=>\(CustomerDetails.badges)")
        //        print("badges array =>\(Badges.modelsFromDictionaryArray(array: CustomerDetails.customerData.badges as! NSArray))")
        var index:Int =  0
        //        for badge in badgesArray!{
        //            if badge.status == true {
        //                break
        //            }
        //            index = index + 1
        //        }
        
        switch index {
        case 0:
            ivTopFan.alpha = 0.5
            ivDieHard.alpha = 0.5
            ivLoyalFan.alpha = 0.5
            ivSuperFan.alpha = 1
            break
        case 1:
            ivTopFan.alpha = 0.5
            ivDieHard.alpha = 0.5
            ivLoyalFan.alpha = 1
            ivSuperFan.alpha = 1
            break
        case 2:
            ivTopFan.alpha = 0.5
            ivDieHard.alpha = 1
            ivLoyalFan.alpha = 1
            ivSuperFan.alpha = 1
            break
        case 3:
            ivTopFan.alpha = 1
            ivDieHard.alpha = 1
            ivLoyalFan.alpha = 1
            ivSuperFan.alpha = 1
            break
        default:
            ivTopFan.alpha = 0.5
            ivDieHard.alpha = 0.5
            ivLoyalFan.alpha = 0.5
            ivSuperFan.alpha = 1
            break
        }
    }
    
    @IBAction func didTappedOnDeactiveAcc(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let deActiveAcc = storyBoard.instantiateViewController(withIdentifier: "DeactivateAccountViewController") as! DeactivateAccountViewController
        self.navigationController?.pushViewController(deActiveAcc, animated: true)
    }
    //MARK:- App Sharing
    
    @IBAction func shareWithFacebook(_ sender: UIButton)
    {
    //        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Share_facebook", extraParamDict: nil)
    //        let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,Constants.appStoreLink], applicationActivities: nil)
    //        viewController.popoverPresentationController?.sourceView = self.view
    //
    //        self.present(viewController, animated: true, completion: nil)

            let text = Constants.celebrityAppName
            CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Share_facebook", extraParamDict: nil)

            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                vc.setInitialText(text)
                //            vc.add(UIImage(named: "placeholder_logo_small.png")!)
                vc.add(URL(string: Constants.appStoreLink))
                present(vc, animated: true)
            } else {
                var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    
    @IBAction func shareWithTwitter(_ sender: UIButton)
    {
        
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Share_Twitter", extraParamDict: nil)
        
        ShoutoutUtilities.shareOnTwitter(tweet: Constants.celebrityAppName, url: Constants.appStoreLink, inViewController: self)
    }
    
    
    @IBAction func shareWithGoogleP(_ sender: UIButton)
    {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Share_Google", extraParamDict: nil)
        let urlstring = Constants.appStoreLink
        
        let shareURL = NSURL(string: urlstring)
        
        let urlComponents = NSURLComponents(string: "https://plus.google.com/share")
        
        urlComponents!.queryItems = [NSURLQueryItem(name: "url", value: shareURL!.absoluteString) as URLQueryItem]
        
        let url = urlComponents!.url!
        
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(url: url)
            svc.delegate = self as? SFSafariViewControllerDelegate as? SFSafariViewControllerDelegate
            self.present(svc, animated: true, completion: nil)
        } else {
            showToast(message: "Please install Google+ application")
        }
    }
    
    @IBAction func shareWithWhatsApp(_ sender: UIButton)
    {

        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Share_WhatsApp", extraParamDict: nil)
        
        let message = Constants.appStoreLink
        let urlWhats = "whatsapp://send?text=\(message)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                        
                    })
                } else {
                    showToast(message: "Please install whatsapp")
                }
            } else {
                showToast(message: "Please install whatsapp")
            }
        }
    }
    
    func shareBranchLink() {
        let buo = BranchUniversalObject.init(canonicalIdentifier: "content/12345")
        buo.title = "My Content Title"
        buo.contentDescription = "My Content Description"
        buo.imageUrl = "https://lorempixel.com/400/400"
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.customMetadata["key1"] = "value1"
        
        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.channel = "facebook"
        lp.feature = "sharing"
        lp.campaign = "content 123 launch"
        lp.stage = "new user"
        lp.tags = ["one", "two", "three"]
        
        lp.addControlParam("$desktop_url", withValue: "http://example.com/desktop")
        lp.addControlParam("$ios_url", withValue: "http://example.com/ios")
        lp.addControlParam("$ipad_url", withValue: "http://example.com/ios")
        lp.addControlParam("$android_url", withValue: "http://example.com/android")
        lp.addControlParam("$match_duration", withValue: "2000")
        
        lp.addControlParam("custom_data", withValue: "yes")
        lp.addControlParam("look_at", withValue: "this")
        lp.addControlParam("nav_to", withValue: "over here")
        lp.addControlParam("random", withValue: UUID.init().uuidString)
        
        let message = "Check out this link"
        buo.showShareSheet(with: lp, andShareText: message, from: self) { (activityType, completed) in
            print(activityType ?? "")
        }
    }
}



extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}


