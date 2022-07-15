//
//  VerifyOTPViewController.swift
//  Desiplex
//
//  Created by developer2 on 19/05/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit
import SVPinView

class VerifyOTPViewController: BaseViewController {
    
    @IBOutlet weak var viewOTP: SVPinView!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblResendTimer: UILabel!
    @IBOutlet weak var lblResendHint: UILabel!
    @IBOutlet weak var scrViewForm: UIScrollView!
    @IBOutlet weak var viewForm: UIView!
    var isCommingFromEarnCoinView = false
    var isCommingFromEmailverifyOtpView = false
    var email: String!
    var phone: String!
    var countryCode: String!
    
    var type: VerifyOTPType!
    var activityType: VerifyOTPActivityType = .login
    var isViewOTPInitialized = false
    
    var strOTP: String? = nil
    fileprivate var requestParameters: [String: Any] = [String: Any]()

    var timerResend: Timer? = nil
    var resendTime = 30 //Seconds
    var resendCounter = 0

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white

         self.navigationItem.rightBarButtonItem = nil
        // Do any additional setup after loading the view.
        self.stopLoader()
        setLayoutAndDesign()
        
        viewOTP.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        googleaAnalytics.logScreenName(screenName: String(describing: type(of: self)))
        utility.setIQKeyboardManager(false, showToolbar: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if !isViewOTPInitialized {
//
//            isViewOTPInitialized = true
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
        stopResendTimer()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - IBAction
extension VerifyOTPViewController {
    
    @IBAction func btnResendClicked() {
        
        self.view.endEditing(true)
        
        webResendOTP()
    }
    
    @IBAction func btnVerifyClicked() {
            
        self.view.endEditing(true)

        if self.strOTP != nil {

            webVerifyOTP()
        }
        else {

        utility.showToast(msg: stringConstants.errEnterOTP, delay: 0, duration: 1.2, bottom: 80)
        }
    }
}

// MARK: - Utility Methods
extension VerifyOTPViewController {
    
    func setLayoutAndDesign() {
        view.backgroundColor = .black
        self.navigationItem.title = ""
        
        viewForm.frame = CGRect.init(x: 0, y: 0, width: macros.screenWidth, height: viewForm.frame.size.height)
        scrViewForm.contentSize = viewForm.frame.size
        scrViewForm.addSubview(viewForm)
        viewOTP.keyboardAppearance = .dark
        
        btnResend.corner = appearences.cornerRadius
        btnVerify.corner = appearences.cornerRadius
        btnVerify.glowEffect = true
        
        setupOTPView()
        
        setDetails()
        
        addKeyboardObservers()
                
        disableResendButton()
        
        startResendTimer()
        
        self.btnVerify.isEnabled = false
    }

    func setDetails() {
        
        if activityType == .login {
            
            lblTitle.text = stringConstants.titleOneTypePwd.uppercased()
        }
        else {
            
            if type == VerifyOTPType.phone {
                
                lblTitle.text = stringConstants.titleVerifyPhone.uppercased()
            }
            else {
                
                lblTitle.text = stringConstants.titleVerifyEmail.uppercased()
            }
        }
        
        var big = ""
        
        if countryCode != nil && phone != nil {
           
               big =  "+" + countryCode + " " + phone
            
        }else {
            
            big = email
        }
        
        let small = stringConstants.msgVerifyDesc
        let msg = small + " " + big
        
        let attStr = NSMutableAttributedString(string: msg)
        
        attStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.7), NSAttributedString.Key.font: fonts.regular(size: 12)], range: (msg as NSString).range(of: small))
        
        attStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: fonts.semibold(size: 14)], range: (msg as NSString).range(of: big))
        
        lblDesc.attributedText = attStr
    }
    
    func setupOTPView() {
        
        viewOTP.backgroundColor = .clear
                
        viewOTP.pinLength = 6
        viewOTP.borderLineColor = UIColor.white
        viewOTP.activeBorderLineColor = UIColor.white
        viewOTP.textColor = UIColor.white
        viewOTP.borderLineThickness = 1
        viewOTP.interSpace = 10
        viewOTP.becomeFirstResponderAtIndex = 0
        viewOTP.keyboardType = UIKeyboardType.numberPad
        viewOTP.style = .underline
        viewOTP.activeBorderLineThickness = 1
        viewOTP.fieldBackgroundColor = UIColor.clear
        viewOTP.activeFieldBackgroundColor = UIColor.clear
        viewOTP.fieldCornerRadius = 0
        viewOTP.activeFieldCornerRadius = 0
        viewOTP.font = fonts.regular(size: 20)
        viewOTP.shouldSecureText = false
        viewOTP.tintColor = .white
        viewOTP.deleteButtonAction = .deleteCurrent
        
        viewOTP.didChangeCallback = { otp in
            
            self.btnVerify.isEnabled = false
            self.strOTP = nil
        }
        
        viewOTP.didFinishCallback = { otp in
            
            self.btnVerify.isEnabled = true
            self.strOTP = otp
        }
    }
    
    func savePhoneNumber() {
        var customer : Customer!
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let writePath = documents + "/ConsumerDatabase.sqlite"
        print(writePath)
        var database : DatabaseManager!
        customer = database.getCustomerData()
        database = DatabaseManager.sharedInstance
        database.initDatabase(path: writePath)
        customer.mobile = phone
        customer.mobile_code = countryCode
        
//        user?.saveLoggedInUser()
    }
    
    func startResendTimer() {
        
        stopResendTimer()
        
        timerResend = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateResendTime), userInfo: nil, repeats: true)
    }
    
    func stopResendTimer() {
        
        if timerResend != nil {
            
            if timerResend!.isValid {
                
                timerResend?.invalidate()
                timerResend = nil
            }
        }
    }
    
    @objc func updateResendTime() {
        
        let time = resendTime - resendCounter
        
        lblResendTimer.text = utility.getTimeString(seconds: time)
        
        if resendCounter > resendTime {
            
            enableResendButton()
            
            stopResendTimer()
        }
        
        resendCounter = resendCounter + 1
    }
    
    func enableResendButton() {
        
        btnResend.setTitle(stringConstants.resend.uppercased(), for: .normal)
        btnResend.isUserInteractionEnabled = true
        lblResendTimer.isHidden = true
        lblResendHint.isHidden = true
    }
    
    func disableResendButton() {
        
        btnResend.setTitle("", for: .normal)
        btnResend.isUserInteractionEnabled = false
        lblResendTimer.isHidden = false
        lblResendTimer.text = utility.getTimeString(seconds: resendTime)
        resendCounter = 0
        lblResendHint.isHidden = false
    }
}

// MARK: - Keyboard Methods
extension VerifyOTPViewController {
    
    func addKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardHeightChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

//            cnstBtnVeirfyBottom.constant = endFrame!.size.height + 30
        }
    }
}

// MARK: - Navigations
extension VerifyOTPViewController {
    
    func goToDobCheck(isNew : Bool, user_dob: String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifyDOBVC : DobCheckerVC = storyboard.instantiateViewController(withIdentifier: "DobCheckerVC") as! DobCheckerVC
        verifyDOBVC.isNew = isNew
        verifyDOBVC.isDobPresent = user_dob
        self.navigationController?.pushViewController(verifyDOBVC, animated: true)
    }

    
    func goToTabMenu(desc: String? , isRewardGet: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let tabVC : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
               macros.appDel?.tabVC = tabVC
               tabVC.isCommingFromRewardView = isRewardGet
               tabVC.descMsg = desc
               tabVC.age_difference = 18
               self.navigationController?.pushViewController(tabVC, animated: true)
               self.navigationController?.viewControllers = [tabVC]
    }
    func goToVerifyEmailScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifyEmailVC : VerifyEmailViewController = storyboard.instantiateViewController(withIdentifier: "VerifyEmailViewController") as! VerifyEmailViewController
        verifyEmailVC.phone = phone
        verifyEmailVC.countryCode = countryCode
        
        self.navigationController?.pushViewController(verifyEmailVC, animated: true)
    }
    
    func goToEditProfileScreen() {
        
        savePhoneNumber()
        
        Notifications.phoneNumberVerifed.post(object: nil)
        
        if let viewControllers = self.navigationController?.viewControllers {
            
            for vc in viewControllers {
                
                if vc is EditProfileViewController {
                    
                    self.navigationController?.popToViewController(vc, animated: true)
                    
                    return
                }
            }
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Web Service Methods
extension VerifyOTPViewController {
    
    func webVerifyOTP() {
        if isCommingFromEarnCoinView == true {
            didCallVerifyOTPAPI()
            return
        }
        
        let api = Constants.verifyOTP
        self.showLoader()
        var dictParams = [String: Any]()
        
        dictParams["activity"] = activityType.rawValue
        dictParams["identity"] = type.rawValue
        
        if let emailId = email {
            
            dictParams["email"] = emailId
        }
        
        if let mobile = phone {
            
            dictParams["mobile"] = mobile
        }
        
        if let phoneCode = countryCode {
            
            dictParams["mobile_code"] = phoneCode
        }
        
        dictParams["otp"] = Int64(strOTP!)!
        
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
        
        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { [weak self] (status, msg, dict) in

            var verifyOtpEventStatus: LoginEventStatus = .success

            if status {
                
                guard let dictRes = dict else {
                    verifyOtpEventStatus = .failure(message: "response is nil")
                    self?.stopLoader()
                    utility.showToast(msg: stringConstants.errSomethingWentWrong, delay: 0, duration: 1.2, bottom: 80)

                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {
                    
                    if let arrErrors = dictRes["error_messages"] as? [String], arrErrors.count > 0  {
                        verifyOtpEventStatus = .failure(message: arrErrors[0])
                        self?.stopLoader()
                        utility.showToast(msg: arrErrors[0], delay: 0, duration: 1.2, bottom: 80)
                    }
                    else {
                        verifyOtpEventStatus = .failure(message: "error not found")
                        self?.stopLoader()
                        utility.showToast(msg: stringConstants.errSomethingWentWrong, delay: 0, duration: 1.2, bottom: 80)
                    }
                    
                    return
                }
                
                if self?.activityType == .login {
                    
                    if dictRes["status_code"] as? Int == 200 {
                        DispatchQueue.main.async {
                           
                            self?.stopLoader()
                            UserDefaults.standard.set("LoginSessionIn", forKey: "LoginSession")
                            UserDefaults.standard.synchronize()
                            
                            if let dictData = dictRes["data"] as? [String:Any] {
                                if let dict = dictData["customer"] as? [String:Any] {
                                    print("Login Successful")
                                    let customer : Customer = Customer.init(dictionary: dict as NSDictionary)!
                                    CustomerDetails.customerData = customer
                                    CustomerDetails.badges = customer.badges
                                    if let metaData = dictData["metaids"] as? [String:Any] {
                                        customer.purchaseStickers =  metaData["purchase_stickers"] as? Bool
                                        customer.directline_room_id =  metaData["directline_room_id"] as? String; DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
                                        DatabaseManager.sharedInstance.storeLikesAndPurchase(like_ids: metaData["like_content_ids"] as! [String], purchaseIds: metaData["purchase_content_ids"] as! [String], block_ids: metaData["block_content_ids"] as? [String])
                                        
                                        CustomerDetails.purchase_stickers = metaData["purchase_stickers"] as? Bool
                                        CustomerDetails.directline_room_id = metaData["directline_room_id"] as? String
                                        _ = self?.getOfflineUserData()
                                    } else {
                                        DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
                                    }
                                    
                                    if let Customer_Id = dict["coins"] as? String{
                                        CustomerDetails.custId = Customer_Id
                                    }
                                    if let Customer_Account_Link = dict["account_link"] as? [String:Any]

                                    {
                                        CustomerDetails.account_link = Customer_Account_Link as? NSMutableDictionary
                                    }
                                  
                                    
                                    if let customer_email = dict["email"] as? String{
                                        UserDefaults.standard.setValue(customer_email, forKey: "useremail")
                                        UserDefaults.standard.synchronize()
                                        CustomerDetails.email = customer_email
                                    }
                                    
                                    if let coinsxp = dictData["coinsxp"] as? [String:Any]
                                        , let coins = coinsxp["coins"] as? Int {
                                        DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: coins)
                                        CustomerDetails.coins = coins
                                        if let commentChannelName = coinsxp["comment_channel_name"] as? String {
                                            CustomerDetails.commentChannelName = commentChannelName
                                        }
                                        if let giftChannelName = coinsxp["gift_channel_name"] as? String {
                                            CustomerDetails.giftChannelName = giftChannelName
                                        }
                                    }
                                    if let profile_completed = dict["profile_completed"] as? Bool {
                                            CustomerDetails.profile_completed = profile_completed
                                       
                                    }
                                    UserDefaults.standard.set(CustomerDetails.profile_completed, forKey: "profile_completed")
                                    
                                    if let Customer_Mobile = dict["mobile"] as? String
                                    {
                                        CustomerDetails.mobileNumber = Customer_Mobile
                                    }
                                    if let Customer_FirstName = dict["first_name"] as? String
                                    {
                                        UserDefaults.standard.setValue(Customer_FirstName, forKey: "username")
                                        UserDefaults.standard.synchronize()
                                        CustomerDetails.firstName = Customer_FirstName
                                    }
                                    if let Customer_LastName = dict["last_name"] as? String
                                   {
                                        CustomerDetails.lastName = Customer_LastName
                                    }
                                    if let Customer_dob = dict["dob"] as? String{
                                        UserDefaults.standard.setValue(Customer_dob, forKey: "dob")
                                        UserDefaults.standard.synchronize()
                                        CustomerDetails.dob = Customer_dob
                                    }
                                    if let Customer_mobile_code = dict["mobile_code"] as? String{
                                        UserDefaults.standard.setValue(Customer_mobile_code, forKey: "mobile_code")
                                        UserDefaults.standard.synchronize()
                                           CustomerDetails.mobile_code = Customer_mobile_code
                                    }
                                    
                                    if let Customer_Token = dictData["token"] as? String
                                    {
                                        CustomerDetails.token = Customer_Token
                                    }
                                    if let Customer_Picture = dict["picture"] as? String
                                    {
                                        CustomerDetails.picture = Customer_Picture
                                    }
                                    UserDefaults.standard.set(dictData["token"] as? String, forKey: "token")
                                    UserDefaults.standard.synchronize()
                                    
                                    if let Customer_token = dictData["token"] as? String{
                                        Constants.TOKEN = Customer_token
                                    }
                                    
                                    CustomerDetails.identity = customer.identity
                                    CustomerDetails.mobileNumber = customer.mobile
                                    CustomerDetails.lastVisited = customer.last_visited
                                    CustomerDetails.status = customer.status
                                    CustomerDetails.mobile_code = customer.mobile_code
                                    CustomerDetails.dob = customer.dob
                                   
                                    if let Customer_MobileVerified = dict["mobile_verified"] as? Bool
                                    {
                                        CustomerDetails.mobile_verified = Customer_MobileVerified
                                    }
                                    
                                    if let Customer_MobileVerified = dict["mobile_verified"] as? Int
                                    {
                                        if Customer_MobileVerified == 0 {
                                            CustomerDetails.mobile_verified = false
                                        } else if Customer_MobileVerified == 1 {
                                            CustomerDetails.mobile_verified = true
                                        }
                                    }
                                    
                                    UserDefaults.standard.set(CustomerDetails.mobile_verified, forKey: "mobile_verified")
                                    UserDefaults.standard.synchronize()
                                   
                                    
                                    if let Customer_EmailVerified = dict["email_verified"] as? Bool
                                    {
                                        CustomerDetails.email_verified = Customer_EmailVerified
                                    }
                                    
                                    if let Customer_EmailVerified = dict["email_verified"] as? Int
                                    {
                                        if Customer_EmailVerified == 0 {
                                            CustomerDetails.email_verified = false
                                        } else if Customer_EmailVerified == 1 {
                                            CustomerDetails.email_verified = true
                                        }
                                    }
                                    
                                    UserDefaults.standard.set(CustomerDetails.email_verified, forKey: "email_verified")
                                    UserDefaults.standard.synchronize()
                                    CustomMoEngage.shared.setMoUserInfoUsingCustomerDetails()
                                    if let relogin =
                                        dictData["re_loggedin"] as? Bool
                                    {
                                        CustomMoEngage.shared.setMoReLogginUserAttributes(re_loggedin: relogin)
                                    } else {
                                        CustomMoEngage.shared.setMoReLogginUserAttributes(re_loggedin: false)
                                    }
//                                    Branch.getInstance()?.setIdentity(customer._id)
                                    
                                    
                                    UserDefaults.standard.set("facebook", forKey: "logintype")
                                    UserDefaults.standard.synchronize()
                                   
                                    
                                    
                         /*           if let newUSerFlag = dictData["new_user"] as? Bool , let reward = dictData["reward"] as? [String:Any] {
                                        
                                        UserDefaults.standard.setValue(newUSerFlag, forKey: "newUSerFlag")
                                        
                                        if newUSerFlag {
                                            if let desc =
                                                reward["description"] as? String{
                                                self?.goToTabMenu(desc: desc, isRewardGet: true)
                                            } else {
                                                self?.goToTabMenu(desc: nil, isRewardGet: false)
                                            }
                                        } else {
                                            self?.goToTabMenu(desc: nil, isRewardGet: false)
                                        }
                                    } else {
                                         self?.goToTabMenu(desc: nil, isRewardGet: false)
                                    }
                                    */
                                    
                                    if let newUSerFlag = dictData["new_user"] as? Bool
                                    {
                                        UserDefaults.standard.setValue(newUSerFlag, forKey: "newUSerFlag")
                                        
                                        if newUSerFlag == true
                                        {
                                            self!.goToDobCheck(isNew: true, user_dob: "")
                                        }else{
                                            self?.validData()
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                           }
                        } else {
                        self?.stopLoader()
                        if self?.type == VerifyOTPType.phone {
                            
                            self?.goToVerifyEmailScreen()
                        }
                        else if self?.type == VerifyOTPType.email {
                            
                            utility.showToast(msg: stringConstants.errSomethingWentWrong, delay: 0, duration: 1.2, bottom: 80)
                        }
                        else {
                            
                            utility.showToast(msg: stringConstants.errSomethingWentWrong, delay: 0, duration: 1.2, bottom: 80)
                        }
                    }
                    
                    } else{
                    self?.stopLoader()
                    // Verify Email/Mobile
                    if self?.type == VerifyOTPType.phone {
                        
                        self?.goToEditProfileScreen()
                    }
                    else if self?.type == VerifyOTPType.email {
                        
                    }
                    
                }
            } else {
                self?.stopLoader()
                verifyOtpEventStatus = .failure(message: msg ?? "")
                utility.showToast(msg: msg ?? "", delay: 0, duration: 1.2, bottom: 80)
            }
        }
  
    
    }
     
    
    func validData()
    {

            if UserDefaults.standard.value(forKey: "dob") as? String != "" {
                if  let ipdate = (UserDefaults.standard.value(forKey: "dob") as? String) {
                    print(ipdate)
                    
                   // self.txtSelectDob.text = ipdate
                    // check dob year
                    //
                    let dateFormatter = DateFormatter()

                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                 if let dateFromString : NSDate = dateFormatter.date(from: ipdate) as NSDate? {
                    dateFormatter.dateFormat = "dd-MMMM-yyyy"
                    let datenew = dateFormatter.string(from: dateFromString as Date)
                    
                    
                    let diffs = Calendar.current.dateComponents([.year], from: dateFromString as Date, to: Date())
                    print(diffs.year!)
                    
                    if diffs.year! < 16
                    {
                        
                        //if year is less than 12 then update dob... open datpicker
                        
                       // self.showAlertForDobButton(title: "UPDATE DOB", msg: "Please update your dob for accessing app content")
                        
                        self.goToDobCheck(isNew: false, user_dob: datenew)
                        
                    }else{
                        
                        
                        UserDefaults.standard.setValue(diffs.year, forKey: "age_difference")
                        UserDefaults.standard.synchronize()
                        
                        self.goToTabMenu(desc: nil, isRewardGet: false)
                     //    call homepage content
                      //  self.showAlert(message: "You are eligible for app")
                      
                    }

                 }

                }
                
            }else
            {
                self.goToDobCheck(isNew: false, user_dob: "")
                //self.showAlertForDobButton(title: "SET DOB", msg: "Please set your dob for accessing app content")
            }
      //  }

    }
    
    func webResendOTP() {
       
        let api = Constants.requestloginOTP
        self.showLoader()
        var dictParams = [String: Any]()
        
        dictParams["activity"] = activityType.rawValue
        dictParams["identity"] = type.rawValue
        
        if activityType == .login {
            if CustomBranchHandler.shared.referralCustomerID != "" {
                dictParams["referrer_customer_id"] = CustomBranchHandler.shared.referralCustomerID
            }
        }
        
        if type == .email {
            
            if let emailId = email {
                
                dictParams["email"] = emailId
            }
        }
        
        if type == .phone {
        
            if let mobile = phone {
                
                dictParams["mobile"] = mobile
            }
            
            if let phoneCode = countryCode {
                
                dictParams["mobile_code"] = phoneCode
            }
        }
        
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
        
        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { (status, msg, dict) in


            if status {
                
                guard let dictRes = dict else {
                    
                    utility.showToast(msg: stringConstants.errSomethingWentWrong, delay: 0, duration: 1.2, bottom: 80)
                    
                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {
                    self.stopLoader()
                    if let arrErrors = dictRes["error_messages"] as? [String] {

                        utility.showToast(msg: arrErrors[0], delay: 0, duration: 1.2, bottom: 80)
                    }
                    else {
                            self.stopLoader()
                        
                        utility.showToast(msg: stringConstants.errSomethingWentWrong, delay: 0, duration: 1.2, bottom: 80)
                    }

                    return
                }
                self.stopLoader()
                self.disableResendButton()
                self.startResendTimer()
            }
            else {
                self.stopLoader()
                utility.showToast(msg: msg ?? "", delay: 0, duration: 1.2, bottom: 80)
            }
        }
    }

}

// MARK: - Web Services
extension VerifyOTPViewController {
    
 
    fileprivate func didCallVerifyOTPAPI() {
        
        let headers: Dictionary<String, String> = ["Content-Type": "application/json",
                                                   "ApiKey": Constants.API_KEY,
                                                   "artistid": Constants.CELEB_ID,
                                                   "platform": Constants.PLATFORM_TYPE,
                                                   "Authorization": Constants.TOKEN]
        
        
        if type == VerifyOTPType.phone {
        requestParameters = ["identity": "mobile",
               "mobile_code": countryCode,
               "activity": "verify","otp":Int64(strOTP!)!,"mobile":phone]
        }else{
            
            requestParameters = ["identity": "email",
            "email": email,
            "activity": "verify","otp":Int64(strOTP!)!]
        }
        
        WebServiceHelper.shared.callPostMethod(endPoint: Constants.mobileVerifyOTP, parameters: requestParameters, responseType: MobileNumberVerifyModel.self, showLoader: true, httpHeaders: headers) { [weak self] (response, error) in
            
            if let error = response?.error, error {
                
                var msg = "Something went wrong."
                
                if let messages = response?.error_messages, messages.count > 0 {
                    msg = messages[0]
                }

                Alert.show(in: self, title: "", message: msg, cancelTitle: nil, comletionForAction: nil)
                
            } else if let msg = response?.message {
                if self?.type == VerifyOTPType.phone {
                    CustomerDetails.mobileNumber = self?.phone
                    CustomerDetails.mobile_verified = true
                    UserDefaults.standard.set(true, forKey: "mobile_verified")
                    UserDefaults.standard.synchronize()
                    
                    if let mobile = self?.phone {
                        DatabaseManager.sharedInstance.updateMobileNumber(mobileNumber: mobile)
                    }
                    
                }else{
                    if let email = self?.email {
                    CustomerDetails.email = self?.email
                        CustomerDetails.email_verified = true
                        UserDefaults.standard.set(true, forKey: "email_verified")
                        UserDefaults.standard.synchronize()
                    DatabaseManager.sharedInstance.updateEmailNumber(emailId: email)
                    }
                }
//                utility.showToast(msg: msg)
                self?.toast(message: msg, duration: 8)
                if self?.isCommingFromEmailverifyOtpView == true {
                    self?.backTwo()
                    
                }else {
                    self?.navigationController?.popViewController(animated: true)
                }
                  
            } else {
                Alert.show(in: self, title: "", message: "Something went wrong.", cancelTitle: nil, comletionForAction: nil)
            }
        }
    }
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    public func toast(message: String, duration: Double) {
        let toast: UIAlertView = UIAlertView.init(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
        toast.show()
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toast.dismiss(withClickedButtonIndex: 0, animated: true)
        }
    }
}

