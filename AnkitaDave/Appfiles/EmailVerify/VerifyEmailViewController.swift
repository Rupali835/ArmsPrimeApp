//
//  VerifyEmailViewController.swift
//  Desiplex
//
//  Created by developer2 on 27/05/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

class VerifyEmailViewController: BaseViewController {

    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    var phone: String!
    var countryCode: String!
    var isCommingFromEarnCoinView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if isCommingFromEarnCoinView == true {
            super.setProfileImageOnBarButton(onlyLiveButton: true)
        }
        // Do any additional setup after loading the view.
        
        setLayoutAndDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setStatusBarStyle(isBlack: false)
       
        utility.setIQKeyboardManager(true, showToolbar: true)
    }
}

// MARK: - IBActions
extension VerifyEmailViewController {
    
    @IBAction func btnNextClicked() {
        
        self.view.endEditing(true)
        
        if !isValidFormData() {
            
            return
        }
        self.showLoader()
        webSendOTP()
    }
}

// MARK: - Utility Methods
extension VerifyEmailViewController {
    
    func setLayoutAndDesign() {
        view.backgroundColor = .black
        self.navigationItem.title = ""
        txtEmail.tintColor = .white
        txtEmail.keyboardAppearance = .dark
        viewEmail.backgroundColor = .clear
        txtEmail.setAttributedPlaceholder(text: stringConstants.enterEmail, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.7)])
        
        btnNext.corner = appearences.cornerRadius
        btnNext.glowEffect = true
    }
    
    func isValidFormData() -> Bool {
        
        let str = txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if str?.count == 0 {
            
            utility.alert(message: stringConstants.errEmptyEmailAddress, delegate: self, cancel: nil, completion: nil)
            return false
        }
        
        return true
    }
}

// MARK: - Navigations
extension VerifyEmailViewController {
    
    func gotoVerifyOTPScreen() {
         self.stopLoader()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifyOTPVC : VerifyOTPViewController = storyboard.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
       verifyOTPVC.isCommingFromEmailverifyOtpView = true
        verifyOTPVC.email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        verifyOTPVC.type = .email
        
        verifyOTPVC.activityType = .verify
        verifyOTPVC.isCommingFromEarnCoinView = true
        self.navigationController?.pushViewController(verifyOTPVC, animated: true)
    }
}

// MARK: - TextField Delegate Methods
extension VerifyEmailViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        do {
            
            let pattern = RegularExpression.email.rawValue
            
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                
                return false
            }
        }
        catch {
           
            print("ERROR")
        }
        
        return true
    }
}

// MARK: - Web Service Methods
extension VerifyEmailViewController {
    
    func webSendOTP() {
        
        let api = Constants.requestloginOTP
        
        var dictParams = [String: Any]()
        
        dictParams["activity"] = VerifyOTPActivityType.login.rawValue
        dictParams["identity"] = VerifyOTPType.email.rawValue
        
        if CustomBranchHandler.shared.referralCustomerID != "" {
            dictParams["referrer_customer_id"] = CustomBranchHandler.shared.referralCustomerID
        }
        
        let strEmail = txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if let emailId = strEmail {
            
            dictParams["email"] = emailId
        }
        
        if let mobile = phone {
            
            dictParams["mobile"] = mobile
        }
        
        if let phoneCode = countryCode {
            
            dictParams["mobile_code"] = phoneCode
        }
        
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
                
                self.gotoVerifyOTPScreen()
            }
            else {
                
                utility.alert(message: msg, delegate: self, cancel: nil, completion: nil)
            }
        }
    }
}
