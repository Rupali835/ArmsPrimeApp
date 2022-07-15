////
////  RegisterViewController.swift
////  ZareenKhanConsumer
////
////  Created by Razr on 09/11/17.
////  Copyright © 2017 Razr. All rights reserved.
////
//
//import UIKit
//import Foundation
//
//class RegisterViewController: BaseViewController, UITextFieldDelegate
//{
//    @IBOutlet weak var tfName: UITextField!
//    @IBOutlet weak var tfEmail: UITextField!
//    @IBOutlet weak var tfPassword: UITextField!
//    //    @IBOutlet weak var tfConfirmPassword: UITextField!
//    @IBOutlet weak var lblSignIn: UILabel!
//    @IBOutlet weak var btnRegiser: UIButton!
//    @IBOutlet weak var termsClickImageView: UIImageView!
//    @IBOutlet weak var checkbox: UIButton!
//    @IBOutlet weak var ageCheckbox: UIButton!
//    
//    @IBOutlet weak var nameView: UIView!
//    @IBOutlet weak var emailView: UIView!
//    @IBOutlet weak var passwordView: UIView!
//    @IBOutlet weak var conformPasswordView: UIView!
//    
//    @IBOutlet weak var ageCheckBoxImgView: UIImageView!
//    @IBOutlet weak var termCheckBoxImgView: UIImageView!
//    
//    @IBOutlet weak var armsprimezcheckboxImgView: UIImageView!
//    @IBOutlet weak var policybutton: UIButton!
//    @IBOutlet weak var termButton: UIButton!
//    @IBOutlet weak var eyeButton: UIButton!
//    var isChecked:Bool = false
//    
//    @IBOutlet weak var armsprimeBtn: UIButton!
//    
//    @IBOutlet weak var signUpHeaderLabel: UILabel!
//    @IBOutlet weak var alreadyAccLabel: UILabel!
//    
//    @IBOutlet weak var armsPrimeLabel: UILabel!
//    
//    @IBOutlet weak var termCondLabel: UILabel!
//    @IBOutlet weak var ageLabel: UILabel!
//    
//    @IBOutlet weak var andLabel: UILabel!
//    var isAdult : Bool = false
//    var isTermCond: Bool = false
//    //MARK:-
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //        setUpUi()
//        self.view.setGradientBackground()
//        btnRegiser.layer.cornerRadius = 4
//        
//        tfName.keyboardAppearance = .dark
//        tfEmail.keyboardAppearance = .dark
//        tfPassword.keyboardAppearance = .dark
//        //        tfConfirmPassword.keyboardAppearance = .dark
//        
//        //        self.tfName.layer.cornerRadius = tfName.layer.frame.height / 2
//        self.tfName.clipsToBounds = true
//        
//        //        self.tfEmail.layer.cornerRadius = tfEmail.layer.frame.height / 2
//        self.tfEmail.clipsToBounds = true
//        
//        //        self.tfPassword.layer.cornerRadius = tfPassword.layer.frame.height / 2
//        self.tfPassword.clipsToBounds = true
//        
//        //        self.tfConfirmPassword.layer.cornerRadius = tfConfirmPassword.layer.frame.height / 2
//        //        self.tfConfirmPassword.clipsToBounds = true
//        //
//        self.navigationItem.rightBarButtonItem = nil
//        //self.navigationController?.navigationBar.isHidden = true
//        //        tfName.setLeftPaddingPoints(5)
//        //        tfEmail.setLeftPaddingPoints(5)
//        //        tfPassword.setLeftPaddingPoints(5)
//        //        tfConfirmPassword.setLeftPaddingPoints(5)
//        
//        //        self.btnRegiser.layer.cornerRadius = 20
//        //        self.btnRegiser.clipsToBounds = true
//        
//        //        self.navigationItem.title = "REGISTER"
//        //        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
//        self.setNavigationView(title: "REGISTER")
//        self.designLayout()
//        
//        if  UserDefaults.standard.object(forKey: "LoginSession") == nil
//        {
//            UserDefaults.standard.set("LoginSession", forKey: "LoginSession")
//            UserDefaults.standard.synchronize()
//        }
//        
//        
//        
//        let attributedString = NSMutableAttributedString(string: "ALREADY HAVE AN ACCOUNT? LOGIN", attributes: [
//            .font: UIFont(name:  AppFont.regular.rawValue, size: 14.0)!,
//            .foregroundColor: BlackThemeColor.yellow
//        ])
//        attributedString.addAttributes([
//            .font: UIFont(name:  AppFont.bold.rawValue, size: 14.0)!,
//            .foregroundColor:BlackThemeColor.yellow
//        ], range: NSRange(location: 25, length: 5))
//        alreadyAccLabel.attributedText = attributedString
//        tfEmail.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
//        tfPassword.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
//        tfName.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
//        signUpHeaderLabel.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
//        btnRegiser.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 16.0)
//        ageLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
//        armsPrimeLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
//        termCondLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
//        andLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
//        
//        let yourAttributes : [NSAttributedString.Key: Any] = [
//            NSAttributedString.Key.font :UIFont(name:  AppFont.light.rawValue, size: 14.0)!,
//            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
//        
//        let attributeString1 = NSMutableAttributedString(string: "Terms of use",
//                                                         attributes: yourAttributes)
//        termButton.setAttributedTitle(attributeString1, for: .normal)
//        
//        let yourAttributes1 : [NSAttributedString.Key: Any] = [
//            NSAttributedString.Key.font :UIFont(name:  AppFont.light.rawValue, size: 14.0)!,
//            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
//        
//        let attributeString2 = NSMutableAttributedString(string: "Privacy Policy",
//                                                         attributes: yourAttributes1)
//        policybutton.setAttributedTitle(attributeString2, for: .normal)
//        
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        GlobalFunctions.screenViewedRecorder(screenName: "Register Screen")
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
//    
//    @IBAction func backButtonAction(_ sender: Any) {
//        self.pushAnimation()
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func skipButtonAction(_ sender: Any) {
//        CustomMoEngage.shared.sendEventUIComponent(componentName: "Registration_skip", extraParamDict: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
//        self.pushAnimation()
//        
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    @IBAction func eyeBtnAction(_ sender: Any) {
//        eyeButton.isSelected = !eyeButton.isSelected
//        
//        if eyeButton.isSelected {
//            tfPassword.isSecureTextEntry = false
//        } else {
//            tfPassword.isSecureTextEntry = true
//        }
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == tfName
//        {
//            if string == ""
//            {
//                return true
//            }
//            if (tfName.text?.utf16.count)! > 14
//            {
//                return false
//            }
//        } else if textField == tfEmail {
//            let cs = NSCharacterSet(charactersIn: Constants.emailIDAcceptedCharacter).inverted
//            let filtered = string.components(separatedBy: cs).joined(separator: "")
//            
//            return (string == filtered)
//        } else if textField == tfPassword {
//            let cs = NSCharacterSet(charactersIn: Constants.dontAllowSpaceCharacter)
//            let filtered = string.components(separatedBy: cs as CharacterSet).joined(separator: "")
//            return (string == filtered)
//        }
//        
//        return true
//    }
//    
//    @IBAction func ageCheckClickButton(_ sender: UIButton) {
//        
//        if ageCheckbox.isSelected {
//            ageCheckBoxImgView.image = UIImage.init(named: "check")
//            isAdult = true
//        } else {
//            ageCheckBoxImgView.image = UIImage.init(named: "uncheck")
//            isAdult = false
//        }
//        
//        ageCheckbox.isSelected = !ageCheckbox.isSelected
//    }
//    
//    @IBAction func armsPrimeBtnAction(_ sender: Any) {
//        if armsprimeBtn.isSelected {
//            armsprimezcheckboxImgView.image = UIImage.init(named: "check")
//        } else {
//            armsprimezcheckboxImgView.image = UIImage.init(named: "uncheck")
//        }
//        
//        armsprimeBtn.isSelected = !armsprimeBtn.isSelected
//    }
//    @IBAction func termsconditionsClickButton(_ sender: UIButton) {
//        
//        if checkbox.isSelected {
//            termCheckBoxImgView.image = UIImage.init(named: "check")
//            isTermCond = true
//        } else {
//            termCheckBoxImgView.image = UIImage.init(named: "uncheck")
//            isTermCond = false
//        }
//        
//        checkbox.isSelected = !checkbox.isSelected
//        
//    }
//    
//    
//    @IBAction func termsconditions(_ sender: UIButton) {
//        CustomMoEngage.shared.sendEventUIComponent(componentName: "Register_Term_n_condtn", extraParamDict: nil)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
//        resultViewController.navigationTitle = "Terms & Conditions"
//        resultViewController.openUrl = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ?? "http://www.armsprime.com/terms-conditions.html"
//        self.pushAnimation()
//        self.navigationController?.pushViewController(resultViewController, animated: false)
//    }
//    
//    func designLayout()
//    {
//        self.tfName.delegate = self
//        self.tfPassword.delegate = self
//        //        self.tfConfirmPassword.delegate = self
//        self.tfEmail.delegate = self
//        
//        let string = "Sign In"
//        let range  = (string as NSString).range(of: "Sign In")
//        let attributedString = NSMutableAttributedString(string: string)
//        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range ) //NSUnderlineStyle.patternDash
//        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.white, range: range)
//        
//        //        self.lblSignIn.attributedText = attributedString
//        
//        self.tfName.layer.borderColor = UIColor.clear.cgColor
//        self.tfName.layer.borderWidth = 1.0
//        self.tfName.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
//        self.tfName.attributedPlaceholder = NSAttributedString(string: "Name",
//                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        
//        self.tfEmail.layer.borderColor = UIColor.clear.cgColor
//        self.tfEmail.layer.borderWidth = 1.0
//        self.tfEmail.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
//        self.tfEmail.attributedPlaceholder = NSAttributedString(string: "Email",
//                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        
//        self.tfPassword.layer.borderColor = UIColor.clear.cgColor
//        self.tfPassword.layer.borderWidth = 1.0
//        self.tfPassword.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
//        self.tfPassword.attributedPlaceholder = NSAttributedString(string: "Password",
//                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        
//        //        self.tfConfirmPassword.layer.borderColor = UIColor.clear.cgColor
//        //        self.tfConfirmPassword.layer.borderWidth = 1.0
//        //        self.tfConfirmPassword.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
//        //        self.tfConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm password",
//        //                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//    }
//    
//    
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    func isValidEmail(testStr:String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: testStr)
//    }
//    
//    @IBAction func btnRegisterClicked(_ sender: UIButton)
//    {
//        if   tfEmail.isEditing || tfPassword.isEditing || tfName.isEditing //|| tfConfirmPassword.isEditing
//        {
//            tfEmail.resignFirstResponder()
//            tfPassword.resignFirstResponder()
//            tfName.resignFirstResponder()
//            //            tfConfirmPassword.resignFirstResponder()
//        }
//        
//        if checkValidation() {
//            //            if ageCheckbox.isSelected == true {
//            if isAdult {
//                //             if checkbox.isSelected == true {
//                if isTermCond {
//                    
//                    let isValidEmailFlag: Bool = isValidEmail(testStr: tfEmail.text!)
//                    
//                    if isValidEmailFlag
//                    {
//                        //                if tfPassword.text == tfConfirmPassword.text
//                        //                {
//                        let myString = (tfName.text)!
//                        let trimmedString = myString.trimmingCharacters(in: .whitespacesAndNewlines)
//                        let arr = trimmedString.components(separatedBy: " ")
//                        var  fName: String = ""
//                        var lName: String = ""
//                        if arr.count > 0
//                        {
//                            fName = arr[0]
//                            if arr.count >= 2
//                            {
//                                lName = arr[1]
//                            }
//                        }
//                        //                    callNewRegistrationApi(fName: fName, lName: lName)
//                        if Reachability.isConnectedToNetwork()
//                        {
//                            CustomMoEngage.shared.sendEventUIComponent(componentName: "Register_register", extraParamDict: nil)
//                            self.showLoader()
//                            
//                            //get FCM Id also
//                            var dict : [String: Any]
//                            if CustomBranchHandler.shared.referralCustomerID.count == 0 {
//                                dict = ["first_name": fName, "last_name": lName , "email": tfEmail.text ?? "", "password": tfPassword.text ?? "","password_confirmation": tfPassword.text ?? "", "identity": "email", "device_id": Constants.DEVICE_ID ?? "", "segment_id": 2, "fcm_id": UserDefaults.standard.string(forKey: "fcmId") ?? "", "platform": "ios" ] as [String : Any]
//                            } else {
//                                dict = ["first_name": fName, "last_name": lName , "email": tfEmail.text ?? "", "password": tfPassword.text ?? "","password_confirmation": tfPassword.text ?? "", "identity": "email", "device_id": Constants.DEVICE_ID ?? "", "segment_id": 2, "fcm_id": UserDefaults.standard.string(forKey: "fcmId") ?? "", "platform": "ios" ,"referrer_customer_id":CustomBranchHandler.shared.referralCustomerID ] as [String : Any]
//                            }
//                            
//                            
//                            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
//                                
//                                let url = NSURL(string: Constants.App_BASE_URL + Constants.REGISTER)!
//                                let request = NSMutableURLRequest(url: url as URL)
//                                
//                                request.httpMethod = "POST"
//                                request.httpBody = jsonData
//                                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                                request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
//                                request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "artistid")
//                                request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
//                                
//                                let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
//                                    if error != nil{
//                                        self.showToast(message: error?.localizedDescription ?? "The Internet connection appears to be offline.")
//                                        GlobalFunctions.trackEvent(eventScreen: "Register Screen", eventName: "Error : \(error?.localizedDescription ?? "")", eventPostTitle: "Email", eventPostCaption: "", eventId: "")
//                                        //                                    CustomMoEngage.shared.sendEventUserLogin(source: "email",action: "Register", status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: nil)
//                                        let payloadDict = NSMutableDictionary()
//                                        payloadDict.setObject("Email" , forKey: "source" as NSCopying)
//                                        CustomMoEngage.shared.sendEventSignUpLogin(eventType: .signUp, status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: payloadDict)
//                                        return
//                                    }
//                                    do {
//                                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
//                                        print("registration json \(String(describing: json))")
//                                        print("registration desc \(json?.description)")
//                                        
//                                        if json?.object(forKey: "error_messages") != nil
//                                        {
//                                            DispatchQueue.main.async {
//                                                let arr = json?.object(forKey: "error_messages")! as! NSMutableArray
//                                                self.stopLoader()
//                                                self.showToast(message: arr[0] as! String)
//                                                var errorString = "Error"
//                                                errorString = "Error : \(arr[0] as! String)"
//                                                
//                                                GlobalFunctions.trackEvent(eventScreen: "Register Screen", eventName: errorString, eventPostTitle: "Email", eventPostCaption: "", eventId: "")
//                                                //                                            CustomMoEngage.shared.sendEventUserLogin(source: "email",action: "Register", status: "Failed", reason: errorString, extraParamDict: nil)
//                                                let payloadDict = NSMutableDictionary()
//                                                payloadDict.setObject("Email" , forKey: "source" as NSCopying)
//                                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .signUp, status: "Failed", reason: errorString, extraParamDict: payloadDict)
//                                            }
//                                        } else
//                                            if (json?.object(forKey: "status_code") as? Int == 201)
//                                            {
//                                                DispatchQueue.main.async {
//                                                    GlobalFunctions.trackEvent(eventScreen: "Register Screen", eventName: "Success", eventPostTitle: "Email", eventPostCaption: "", eventId: "")
//                                                    
//                                                    if (UserDefaults.standard.object(forKey: "LoginSession") != nil || UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionOut" || UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSession")
//                                                    {
//                                                        UserDefaults.standard.set("LoginSessionIn", forKey: "LoginSession")
//                                                        UserDefaults.standard.synchronize()
//                                                        
//                                                        let dictData = json?.object(forKey: "data") as! NSDictionary
//                                                        let dict = dictData.object(forKey: "customer") as! NSDictionary
//                                                        print("Login Successful")
//                                                        let customer : Customer = Customer.init(dictionary: dict)!
//                                                        CustomerDetails.customerData = customer
//                                                        self.insertCustomerDataToDatabase(cust: customer)
//                                                        self.storeLikesAndPurchase(like_ids: dictData.value(forKey:"like_content_ids") as? [String], purchaseIds: dictData.value(forKey:"purchase_content_ids") as? [String], block_ids: dict.value(forKey:"block_content_ids") as? [String])
//                                                        
//                                                        _ = self.getOfflineUserData()
//                                                        if let Customer_Id = dict.object(forKey: "_id") as? String{
//                                                            CustomerDetails.custId = Customer_Id
//                                                        }
//                                                        if let Customer_Account_Link = dict.object(forKey: "account_link") as? NSMutableDictionary{
//                                                            CustomerDetails.account_link = Customer_Account_Link
//                                                        }
//                                                        
//                                                        if let customer_email = dict.object(forKey: "email") as? String{
//                                                            CustomerDetails.email = customer_email
//                                                        }
//                                                        if let Customer_FirstName = dict.object(forKey: "first_name") as? String{
//                                                            CustomerDetails.firstName = Customer_FirstName
//                                                        }
//                                                        if let Customer_LastName = dict.object(forKey: "last_name") as? String{
//                                                            CustomerDetails.lastName = Customer_LastName
//                                                        }
//                                                        
//                                                        if let Customer_MobileVerified = dict.object(forKey: "mobile_verified") as? Bool {
//                                                            CustomerDetails.mobile_verified = Customer_MobileVerified
//                                                        }
//                                                        
//                                                        if let Customer_MobileVerified = dict.object(forKey: "mobile_verified") as? Int {
//                                                            if Customer_MobileVerified == 0 {
//                                                                CustomerDetails.mobile_verified = false
//                                                            } else if Customer_MobileVerified == 1 {
//                                                                CustomerDetails.mobile_verified = true
//                                                            }
//                                                        }
//                                                        
//                                                        UserDefaults.standard.set(CustomerDetails.mobile_verified, forKey: "mobile_verified")
//                                                        UserDefaults.standard.synchronize()
//                                                        
//                                                        if let Customer_Token = dictData.object(forKey: "token") as? String{
//                                                            CustomerDetails.token = Customer_Token
//                                                        }
//                                                        if let Customer_Picture = dict.object(forKey: "picture") as? String{
//                                                            CustomerDetails.picture = Customer_Picture
//                                                        }
//                                                        UserDefaults.standard.set(dictData.object(forKey: "token") as? String, forKey: "token")
//                                                        UserDefaults.standard.synchronize()
//                                                        if let Customer_token = dictData.object(forKey: "token") as? String{
//                                                            Constants.TOKEN = Customer_token
//                                                        }
//                                                        CustomerDetails.identity = customer.identity
//                                                        CustomerDetails.lastVisited = customer.last_visited
//                                                        CustomerDetails.status = customer.status
//                                                        CustomMoEngage.shared.setMoUserInfo(customer: customer)
//                                                        //
//                                                        let payloadDict = NSMutableDictionary()
//                                                        payloadDict.setObject("Email" , forKey: "source" as NSCopying)
//                                                        CustomMoEngage.shared.sendEventSignUpLogin(eventType: .signUp,status: "Success", reason: "", extraParamDict: payloadDict)
//                                                        
//                                                        if let relogin = dictData.object(forKey: "re_loggedin") as? Bool{
//                                                            CustomMoEngage.shared.setMoReLogginUserAttributes(re_loggedin: relogin)
//                                                        } else {
//                                                            CustomMoEngage.shared.setMoReLogginUserAttributes(re_loggedin: false)
//                                                        }
//                                                        UserDefaults.standard.set("email", forKey: "logintype")
//                                                        UserDefaults.standard.synchronize()
//                                                        if let newUSerFlag = dictData.object(forKey: "new_user") as? Bool , let reward = dictData.object(forKey: "reward") as? NSMutableDictionary {
//                                                            if newUSerFlag {
//                                                                if let desc = reward.object(forKey: "description") as? String{
//                                                                    self.goToTabMenu(desc: desc, isRewardGet: true)
//                                                                    if let coins = reward.object(forKey: "coins") as? Int {
//                                                                        CustomerDetails.coins = coins
//                                                                        DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins)
//                                                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: ["Register": "Register"])
//                                                                    }
//                                                                } else {
//                                                                    self.goToTabMenu(desc: nil, isRewardGet: false)
//                                                                }
//                                                            } else {
//                                                                //                                                            self.goToTabMenu()
//                                                                self.goToTabMenu(desc: nil, isRewardGet: false)
//                                                            }
//                                                        } else {
//                                                            self.goToTabMenu(desc: nil, isRewardGet: false)
//                                                        }
//                                                        
//                                                    }
//                                                }
//                                        }
//                                        self.stopLoader()
//                                    } catch let error as NSError {
//                                        print(error)
//                                        self.stopLoader()
//                                        GlobalFunctions.trackEvent(eventScreen: "Register Screen", eventName: "Error : \(error.localizedDescription)", eventPostTitle: "Email", eventPostCaption: "", eventId: "")
//                                        //                                    CustomMoEngage.shared.sendEventUserLogin(source: "email",action: "Register", status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
//                                        let payloadDict = NSMutableDictionary()
//                                        payloadDict.setObject("Email" , forKey: "source" as NSCopying)
//                                        CustomMoEngage.shared.sendEventSignUpLogin(eventType: .signUp, status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
//                                    }
//                                }
//                                task.resume()
//                            }
//                        } else
//                        {
//                            self.showToast(message: Constants.NO_Internet_MSG)
//                        }
//                        
//                        //                } else
//                        //                {
//                        //                    self.showToast(message: "Password & confirm password should be same")
//                        //                }
//                    } else
//                    {
//                        
//                        self.showToast(message: "Please enter valid email Id") //wrong emial
//                    }
//                } else {
//                    self.showToast(message: "Please accept terms and conditions")
//                }
//            } else {
//                self.showToast(message: "Please kindly check 18+")
//            }
//        }
//        //            else
//        //        {
//        //            self.showToast(message: "Enter correct registration details.")
//        //        }
//    }
//    
//    func checkValidation() -> Bool {
//        if tfName.text!.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showToast(message: "Please enter name")
//            return false
//        } else if tfEmail.text!.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showToast(message: "Please enter email Id")
//            return false
//        } else if tfPassword.text!.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showToast(message: "Please enter password")
//            return false
//        } else if !GlobalFunctions.checkPasswordIsInCorrectFormat(pwd: tfPassword.text!) {
//            self.showToast(message: "Your password should be a minimum of 8 characters with at least 1 number and 1 special character.")
//            return false
//        }
//        //        else if tfConfirmPassword.text!.trimmingCharacters(in: .whitespaces).count == 0 {
//        //            self.showToast(message: "Please enter confirm password")
//        //            return false
//        //        }
//        
//        return true
//    }
//    
//    func insertCustomerDataToDatabase(cust : Customer) {
//        
//        let database = DatabaseManager.sharedInstance
//        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let writePath = documents + "/ConsumerDatabase.sqlite"
//        database.dbPath = writePath
//        
//        if (database != nil) {
//            database.createCustomerTable()
//        }
//        database.insertIntoCustomer(customer: cust)
//        
//        
//        
//    }
//    
//    func storeLikesAndPurchase(like_ids : [String]?, purchaseIds : [String]?, block_ids : [String]?) {
//        
//        let database = DatabaseManager.sharedInstance
//        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let writePath = documents + "/ConsumerDatabase.sqlite"
//        database.dbPath = writePath
//        if (database != nil) {
//            database.createContentsLikeTable()
//            
//            if (like_ids != nil && like_ids!.count > 0) {
//                
//                for var id in like_ids!{
//                    
//                    database.insertIntoContentLikesTable(likeId: id)
//                }
//                
//            }
//            
//            
//            database.createContentsPurchaseTable()
//            if (purchaseIds != nil && purchaseIds!.count > 0) {
//                
//                for var purchase in purchaseIds!{
//                    database.insertIntoContentPurchaseTable(purchaseId :purchase )
//                }
//                
//            }
//            database.createHideTable()
//            if (block_ids != nil) {
//                if (block_ids!.count > 0) {
//                    
//                    for var blockId in block_ids!{
//                        database.insertIntoHideContent(content: blockId , customer: "" )
//                    }
//                    
//                }
//            }
//        }
//        
//    }
//    
//    public func toast(message: String, duration: Double) {
//        let toast: UIAlertView = UIAlertView.init(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
//        toast.show()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            toast.dismiss(withClickedButtonIndex: 0, animated: true)
//        }
//    }
//    
//    
//    @IBAction func policyBtnAction(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
//        resultViewController.navigationTitle = "Privacy Policy"
//        resultViewController.openUrl = ArtistConfiguration.sharedInstance().static_url?.privacy_policy ?? "http://www.armsprime.com/arms-prime-privacy-policy.html"
//        self.pushAnimation()
//        self.navigationController?.pushViewController(resultViewController, animated: false)
//    }
//    @IBAction func signInLinkClicked(_ sender: UIButton)
//    {
//        self.pushAnimation()
//        self.navigationController?.popViewController(animated: false) //pushViewController(resultViewController, animated: true)
//    }
//    
//    func callNewRegistrationApi(fName: String ,lName: String)  {
//        /*
//         NAME           : Customer Registration
//         METHOD      : POST
//         URL              : {{api_url}}account/customerregister
//         HEADERS    :
//         ApiKey      (Required)
//         PARAMETERS  :
//         artist_id   (Required)
//         platform    (Optional) (android | ios | web) [Default : android]
//         identity    (Required) (email | mobile | social | facebook | google | twitter)
//         first_name  (Required)
//         last_name   (Required)
//         email       (Required)
//         mobile      (Optional) [In case of social, facebook, google & twitter] [Required in case of email & mobile]
//         mobile_country_code (Optional) [In case of social, facebook, google & twitter] [Required in case of email & mobile]
//         photo       (Optional)
//         gender      (Optional) [male, female]
//         dob         (Optional) [YYYY-MM-DD]
//         
//         RESPONSE    : {
//         "data": {
//         "info": "Email verification pending"
//         },
//         "message": "Customer registered successfully",
//         "error": false,
//         "status_code": 200
//         }
//         */
//        
//        guard Reachability.isConnectedToNetwork() else {
//            self.showToast(message: Constants.NO_Internet_Connection_MSG)
//            return
//        }
//        
//        self.showLoader()
//        
//        let dict = ["artist_id": Constants.CELEB_ID,"platform": "ios","identity": "email","first_name": fName, "last_name": lName , "email": tfEmail.text ?? "", "password": tfPassword.text ?? "", "mobile":"","mobile_country_code":"","photo":"","gender":"","dob":""] as [String: Any]
//        
//        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
//            
//            let url = NSURL(string: Constants.App_BASE_URL + Constants.REGISTER)!
//            
//            print("main Url \(url)")
//            print("input \(dict)")
//            let request = NSMutableURLRequest(url: url as URL)
//            
//            request.httpMethod = "POST"
//            request.httpBody = jsonData
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
//            
//            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//                DispatchQueue.main.async {
//                    self.stopLoader()
//                }
//                if error != nil {
//                    print("error found \(error?.localizedDescription)")
//                }
//                
//                do {
//                    print("response in string \(String(decoding: data!, as: UTF8.self))")
//                    let json = try JSONSerialization.jsonObject(with: (data)!, options: .mutableContainers) as? NSDictionary
//                    print("json \(String(describing: json))")
//                } catch let e {
//                    print("error in JSON \(e.localizedDescription)")
//                }
//            }
//            
//            task.resume()
//        }
//    }
//    
//    func showCongoPopup(msg:String) {
//        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CongratulationPopupViewController") as! CongratulationPopupViewController
//        
//        self.addChild(popOverVC)
//        popOverVC.message = msg
//        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParent: self)
//    }
//    
//    func goToTabMenu(desc: String? , isRewardGet: Bool) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
//        vc.isCommingFromRewardView = isRewardGet
//        vc.descMsg = desc
//        self.stopLoader()
//        self.pushAnimation()
//        let currentNav: UINavigationController =  UIApplication.shared.delegate?.window??.rootViewController as!  UINavigationController
//        currentNav.pushViewController(vc, animated: false)
//    }
//}
//
//extension RegisterViewController {
//    func setUpUi() {
//        nameView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .white)
//        passwordView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .white)
//        emailView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .white)
//        conformPasswordView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .white)
//        btnRegiser.layer.cornerRadius = 4
//    }
//}
