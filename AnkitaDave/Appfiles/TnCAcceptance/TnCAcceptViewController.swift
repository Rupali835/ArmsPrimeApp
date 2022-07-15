//
//  TnCAcceptViewController.swift
//  Producer
//
//  Created by Shriram Kadam on 07/06/21.
//  Copyright © 2021 developer2. All rights reserved.
//

import UIKit
import MessageUI

class TnCAcceptViewController: UIViewController {
    @IBOutlet weak var checkbox: UIButton!
    var isTermCond: Bool = false
    var shouldHideNavbar = true
    var isEmailVerified : Bool = false
    var isPhoneVerified : Bool = false
    var strEmailVerify: String?
    var strMinimumAccepetancePolicy: Double?
    var acceptedAcceptancePolicyVersion: Double?
    var strArtistID: String?
    var artistConfig = ArtistConfiguration.sharedInstance()

    
    var web: WebService? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        strArtistID = Constants.CELEB_ID
        setStatusBarStyle(isBlack: false)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
}

// MARK: - SetLayout
extension TnCAcceptViewController {
    
    // MARK: - Utility Methods
    func setLayoutAndDesigns() {
        
        /* self.navigationItem.title = stringConstants.titleAcceptTnc
        strMinimumAccepetancePolicy = User.getLoggedInUser()?.newAppConfig?.minimum_acceptance_policy_version
        print(strMinimumAccepetancePolicy ?? "")
        
        UIApplication.shared.isStatusBarHidden = false
        setStatusBarStyle(isBlack: true)
        
        if let minimumVersion = User.getLoggedInUser()?.newAppConfig?.minimum_acceptance_policy_version{
            strMinimumAccepetancePolicy = minimumVersion
            
            print(strMinimumAccepetancePolicy ?? "")
            
        }
        */
    }
}


extension TnCAcceptViewController{
    
    @IBAction func termsconditionsClickButton(_ sender: UIButton) {
        if checkbox.isSelected {
            checkbox.setImage(UIImage(named: "checkboxUnSelected"), for: .normal)
            isTermCond = false
        }else {
            checkbox.setImage(UIImage(named: "checkboxSelected"), for: .normal)
            isTermCond = true
        }
        checkbox.isSelected = !checkbox.isSelected
    }
    
    
    @IBAction func WebTermsConditions(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        resultViewController.navigationTitle = "Terms and conditions"
        let str = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ?? "http://armsprime.com/terms-conditions.html"
        resultViewController.openUrl = str
        self.navigationController?.pushViewController(resultViewController, animated: true)
        
       
    }
    
    @IBAction func WebPrivacyPolicy(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        resultViewController.navigationTitle = "Privacy Policy"
        let str = ArtistConfiguration.sharedInstance().static_url?.privacy_policy ?? "http://www.armsprime.com/arms-prime-privacy-policy.html"
        resultViewController.openUrl = str
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    @IBAction func WebAPMCommunityGuidelines(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        resultViewController.navigationTitle = "APM Community Guidelines"
        let str = ArtistConfiguration.sharedInstance().static_url?.ott_community_guidelines_url ?? "https://www.armsprime.com//ott-community-guidelines.html"
        resultViewController.openUrl = str
        self.navigationController?.pushViewController(resultViewController, animated: true)
        
    }
    
    @IBAction func btnVerifiedClicked() {
        
        self.view.endEditing(true)
        
        if !isValidFormData() {
            
            return
        }
        webSendOTP()
    }
    
}

extension TnCAcceptViewController{
    func isValidFormData() -> Bool {
        
        if isTermCond == false {
            utility.alert(message: stringConstants.errorEmptyTnC, delegate: self, cancel: nil, completion: nil)
            return false
        }
        
        return true
    }
}

/*
// MARK: - Web Service Methods
extension TnCAcceptViewController {
    
    func webSendOTP(){
        
       
        
        var dictParams = [String: Any]()
        
        if let version = macros.appVersion {
            
            dictParams["v"] = version
        }
        
        dictParams["product"] = "apm"
        
        dictParams["platform"] = "ios"
            
        dictParams["activity_version"] =  User.getLoggedInUser()?.newAppConfig?.minimum_acceptance_policy_version;
        
        if strArtistID == user.config?.artistId {
            
            dictParams["user_id"] = strArtistID
        }
         
        let api = webConstants.producerAcceptanceActivity
        
        let web = WebService(showInternetProblem: true, isCloud: false, loaderView: self.view)
        
        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { (status, msg, dict) in
            
            if status {
                
                guard let dictRes = dict else {
                    
                    self.showError(msg: stringConstants.somethingWentWrong)
                    
                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {
                    
                    if let arrErrors = dictRes["error_messages"] as? [String] {
                        
                        self.showError(msg: arrErrors[0])
                    }
                    else {
                        
                        self.showError(msg: stringConstants.somethingWentWrong)
                    }
                    
                    return
                }
                
//                let messages = dictRes["message"] as? String ?? ""
//                utility.alert(message: messages, delegate: self, cancel: nil, completion: nil)
                self.isEmailVerified = user.mobile_verified
                self.isPhoneVerified = user.email_verified
                self.strEmailVerify = user.verify_email
                self.strMinimumAccepetancePolicy = User.getLoggedInUser()?.newAppConfig?.minimum_acceptance_policy_version
                self.acceptedAcceptancePolicyVersion = User.getLoggedInUser()?.config?.acceptedAcceptancePolicyVersion
                
               /* if self.isEmailVerified == true && self.isPhoneVerified == true  && self.strMinimumAccepetancePolicy ?? 0 <= self.acceptedAcceptancePolicyVersion ?? 0{
                    self.goToHomeScreen() // existing flow
                }else{
                    self.goToAccountVerifiScreen()  // new flow
                }*/
                
               // self.goToHomeScreen() // existing flow
            }
            else {
                
                utility.alert(message: msg, delegate: self, cancel: nil, completion: nil)
            }
        }
    }
}
*/



// MARK: - Web Service Methods
extension TnCAcceptViewController {
    
    func webSendOTP() {
        
        let api = Constants.acceptTnC
        
        var dictParams = [String: Any]()
        
        if let version = macros.appVersion {
            
            dictParams["v"] = Constants.visiblity
        }
        
        dictParams["product"] = Constants.product
        
        dictParams["platform"] = "ios"
            
        dictParams["activity_version"] = artistConfig.MinimumTNCVersion
        
       
            
        dictParams["user_id"] = CustomerDetails.customerData._id ?? ""
        dictParams["artist_id"] = Constants.CELEB_ID
        
        
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
        
        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { (status, msg, dict) in
            
            if status {
                
                guard let dictRes = dict else {
                    
                self.showError(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {

                    if let arrErrors = dictRes["error_messages"] as? [String] {

                        self.showError(msg: arrErrors[0])
                    }
                    else {
                            
                    self.showError(msg: stringConstants.errSomethingWentWrong)
                    }

                    return
                }
                
                // alert for success
                
                //self.view.removeFromSuperview()
                self.navigationController?.popViewController(animated: false)
                
                let alert = UIAlertController(title: "Success", message: "Terms and condition accepted", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
               
               
                
               // self.gotoVerifyOTPScreen()
            }
            else {
                
                utility.alert(message: msg, delegate: self, cancel: nil, completion: nil)
            }
           
        }
    }
}
