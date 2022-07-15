



import UIKit
import ActiveLabel
import CountryPickerView
import AuthenticationServices
import Foundation
import FBSDKLoginKit
import GoogleSignIn
import Alamofire_SwiftyJSON
import FirebaseAnalytics
import LocalAuthentication
import SwiftyJSON
import Firebase
import Branch
import FirebaseCore


class LoginViewController: BaseViewController,GIDSignInDelegate {
 
    @IBOutlet weak var imgViewFacebook: UIImageView!
    @IBOutlet weak var imgViewGmail: UIImageView!
    @IBOutlet weak var viewAppleBtn: UIView!
    @IBOutlet weak var cnstViewAppleBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstViewAppleBtnVertical: NSLayoutConstraint!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblTermsPrivacy: ActiveLabel!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var viewForm: UIView!
    @IBOutlet weak var lblCountryCode: UILabel!

    var countryPicker: CountryPickerView? = nil
    var isFromLoginSource: String = ""
    var facebookEmail = ""
    var facebookId = ""
    var firstName = ""
    var lastName = ""
    var profilePic = ""
    var gender = ""
    let indiaCountryCode = "91"
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
         GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        viewForm.backgroundColor = .black
        view.backgroundColor = .black
        self.viewForm.frame = CGRect(x: 0, y: 0, width: macros.screenWidth, height: self.viewForm.frame.size.height)
               
        self.scrView.contentSize = self.viewForm.bounds.size
        self.scrView.addSubview(self.viewForm)
         setLayoutAndDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
         self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func goToTabMenu(desc: String? , isRewardGet: Bool) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
            vc.isCommingFromRewardView = isRewardGet
            vc.descMsg = desc
            self.stopLoader()
            self.pushAnimation()
            let currentNav: UINavigationController =  UIApplication.shared.delegate?.window??.rootViewController as! UINavigationController
            currentNav.pushViewController(vc, animated: false)
        }
    }
    
    func goToDobCheck(isNew : Bool, user_dob: String)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifyDOBVC : DobCheckerVC = storyboard.instantiateViewController(withIdentifier: "DobCheckerVC") as! DobCheckerVC
        verifyDOBVC.isNew = isNew
        verifyDOBVC.isDobPresent = user_dob
        self.navigationController?.pushViewController(verifyDOBVC, animated: true)
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
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!)
    {
        // Perform any operations when the user disconnects from app here.
        // ...
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

// MARK: - IBActions
extension LoginViewController {
    
    @IBAction func btnLoginTypeClicked(sender: UIButton) {
        
        btnEmail.isSelected = false
        btnPhone.isSelected = false
        
        sender.isSelected = true
        
        if sender == btnEmail {
            
            viewEmail.isHidden = false
            viewPhone.isHidden = true
            txtEmail.becomeFirstResponder()
        }
        else {
            
            viewEmail.isHidden = true
            viewPhone.isHidden = false
            
            txtPhone.becomeFirstResponder()
        }
    }
    
    @IBAction func btnCountryCodeClicked() {
        
        self.view.endEditing(true)
        
        showCountryPicker()
    }
    
    @IBAction func btnNextClicked() {
        
        self.view.endEditing(true)
        if lblCountryCode.text == indiaCountryCode {
           if !isValidFormData() {

            return
           }
        }
        if btnEmail.isSelected {
            
            let email = txtEmail.text!.trimmingCharacters(in: CharacterSet.whitespaces)
            self.showLoader()
            webLogin(id: nil, email: email, firstname: nil, lastname: nil, phone: nil, countryCode: nil, type: .email)
            
        }
        else {
            
            let phone = txtPhone.text!.trimmingCharacters(in: CharacterSet.whitespaces)
            
            let countryCode = lblCountryCode.text
            
            webLogin(id: nil, email: nil, firstname: nil, lastname: nil, phone: phone, countryCode: countryCode, type: .phone)
        }
    }
    
    @IBAction func btnFacebookClicked() {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Login_Facebook", extraParamDict: nil)
        
        let fbLoginManager : LoginManager = LoginManager()
        let permisions = ["email","public_profile"]
        fbLoginManager.logIn(permissions: permisions, from: self) { (result, error) -> Void in
            
            if (error == nil) {
                
                let fbloginresult : LoginManagerLoginResult = result!
                
                if fbloginresult.grantedPermissions != nil {
                    
                    if (fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.isFromLoginSource = "Facebook"
                        self.getFBUserData()
                        
                    }
                    
                } else {
                    
                    print("No information available")
                    
                }
            }
        }

      
    }
    
    @IBAction func btnGmailClicked() {
        
        self.isFromLoginSource = "Google"
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Login_G_Plus", extraParamDict: nil)
        GIDSignIn.sharedInstance().signIn()
    }
    @available(iOS 13.0, *)
    @objc func btnAppleClicked() {
        
        self.view.endEditing(true)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
        @IBAction func loginLaterClicked(_ sender: Any) {
            CustomMoEngage.shared.sendEventUIComponent(componentName: "Login_skip", extraParamDict: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
            self.pushAnimation()
            let currentNav: UINavigationController =  UIApplication.shared.delegate?.window??.rootViewController as!  UINavigationController
            currentNav.pushViewController(vc, animated: false)
        }
    
    @IBAction func btnSignUpClicked() {
        
        self.view.endEditing(true)

    }
}

// MARK: - Utility Methods
extension LoginViewController {
    
    func setLayoutAndDesign() {

        self.viewAppleBtn.backgroundColor = .clear
        txtEmail.keyboardAppearance = .dark
        txtPhone.keyboardAppearance = .dark
        txtEmail.tintColor = .white
        txtPhone.tintColor = .white
        self.viewForm.frame = CGRect(x: 0, y: 0, width: macros.screenWidth, height: self.viewForm.frame.size.height)
        
        self.scrView.contentSize = self.viewForm.bounds.size
        self.scrView.addSubview(self.viewForm)
        
        self.setAppleBtn()
        txtEmail.setAttributedPlaceholder(text: stringConstants.enterEmail, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.7)])
        txtPhone.setAttributedPlaceholder(text: stringConstants.enterPhone, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.7)])
        
        viewEmail.backgroundColor = .clear
        viewPhone.backgroundColor = .clear
        
        btnNext.corner = appearences.cornerRadius
        btnNext.glowEffect = true
        
        imgViewFacebook.makeCircular()
        imgViewGmail.makeCircular()
        

        btnLoginTypeClicked(sender: btnPhone)
        
        setTermLabel()
        setNextBtnEnabled(false)
    }
    
    func setAppleBtn() {

        if #available(iOS 13.0, *) {

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) { [weak self] in

                let appBtn = self!.getAppleLoginBtn()
                appBtn?.frame = self!.viewAppleBtn.bounds
//                appBtn?.cornerRadius = appBtn!.frame.size.height/2
                self?.viewAppleBtn.addSubview(appBtn!)

                appBtn?.addTarget(self, action: #selector(self?.btnAppleClicked), for: .touchUpInside)
            }
        } else {
            // Fallback on earlier versions
            viewAppleBtn.isHidden = true
            cnstViewAppleBtnHeight.constant = 0
            cnstViewAppleBtnVertical.constant = 0
        }
    }
    
   
    
    func setTermLabel() {
        
        let terms = stringConstants.termsCondition
        let privacy = stringConstants.privacyPolicy
        let msg = stringConstants.loginTerms

        lblTermsPrivacy.customize { (lbl) in

            lblTermsPrivacy.text = msg

            let termsType = ActiveType.custom(pattern: "\\s\(terms)\\b")

            let privacyType = ActiveType.custom(pattern: "\\s\(privacy)\\b")

            lblTermsPrivacy.enabledTypes = [termsType, privacyType]

            lblTermsPrivacy.customColor[termsType] = appearences.newTheamColor
            lblTermsPrivacy.customSelectedColor[termsType] = UIColor.gray
            lblTermsPrivacy.customColor[privacyType] = appearences.newTheamColor
            lblTermsPrivacy.customSelectedColor[privacyType] = UIColor.gray


            lblTermsPrivacy.handleCustomTap(for: termsType) { element in

                print("Custom type tapped: \(element)")

                self.showTermsOrPrivacy(isTerms: true)
            }

            lblTermsPrivacy.handleCustomTap(for: privacyType) { element in

                print("Custom type tapped: \(element)")

                self.showTermsOrPrivacy(isTerms: false)
            }
        }
    }
    
    func showTermsOrPrivacy(isTerms: Bool) {
        if isTerms {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            resultViewController.navigationTitle = "Terms & Conditions"
            let str = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ?? "http://armsprime.com/terms-conditions.html"
            resultViewController.openUrl = str
            self.navigationController?.pushViewController(resultViewController, animated: true)
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            resultViewController.navigationTitle = "Privacy Policy"
            let str = ArtistConfiguration.sharedInstance().static_url?.privacy_policy ?? "http://www.armsprime.com/arms-prime-privacy-policy.html"
            resultViewController.openUrl = str
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }
        
    }
    
    func isValidFormData() -> Bool {

        if btnPhone.isSelected {

            let str = txtPhone.text?.trimmingCharacters(in: CharacterSet.whitespaces)

            if str?.count == 0 {

                utility.showToast(msg: stringConstants.errEmptyPhoneNumber, delay: 0, duration: 2.0, bottom: 80)
                return false
            }
            
           
               if !utility.isValidPhone(strPhone: str!) {

                utility.showToast(msg: stringConstants.errInvalidPhoneNumber, delay: 0, duration: 2.0, bottom: 80)

                return false
               }
            
        }
        else {

            let str = txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespaces)

            if str?.count == 0 {

                utility.showToast(msg: stringConstants.errEmptyEmailAddress, delay: 0, duration: 2.0, bottom: 80)
                return false
            }

            if !utility.isValidEmail(emailStr: str!) {

                utility.showToast(msg: stringConstants.errInvalidEmailAddress, delay: 0, duration: 2.0, bottom: 80)

                return false
            }
        }

        return true
    }
    
    func showCountryPicker() {
        
        countryPicker = CountryPickerView()
        countryPicker?.delegate = self
        countryPicker?.dataSource = self
        
        countryPicker?.showCountriesList(from: self)
    }
}

// MARK: - Country Picker Delegate & DataSource Methods
extension LoginViewController: CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    func sectionTitleLabelColor(in countryPickerView: CountryPickerView) -> UIColor? {
        
        return UIColor.white
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        
        return stringConstants.titleSelectCountry
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {

        return .navigationBar
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        
        return true
    }
    
    func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale {
        
        return Locale.current
    }
    
        func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
                
        lblCountryCode.text = (country.phoneCode as NSString).replacingOccurrences(of: "+", with: "")
        
        let isIndia = (lblCountryCode.text == indiaCountryCode) ? true : false
        
        if utility.isValidPhone(strPhone: txtPhone.text!, isIndia: isIndia) {
            
            setNextBtnEnabled(true)
        }
        else {
            
            setNextBtnEnabled(false)
        }
    }
}

// MARK: - TextField Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        do {
            
            var pattern = ""
            
            if textField == txtEmail {
                
                pattern = RegularExpression.email.rawValue
            }
            
            if textField == txtPhone {
                
                pattern = RegularExpression.phone.rawValue
            }
            
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                
                return false
            }
        }
        catch {
           
            print("ERROR")
        }
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                    
        if lblCountryCode.text == indiaCountryCode {
            
            if str.count > 10 && string != "" {
                
                return false
            }
            
            if str.count == 10 {
                
                setNextBtnEnabled(true)
            }
            else {
                
                setNextBtnEnabled(false)
            }
        }
        else {
            
//            if str.count > 12 && string != "" {
//
//                return false
//            }
//
            if str.count == 0  {
//
                setNextBtnEnabled(false)
            }else{
                setNextBtnEnabled(true)
            }
//            else {
//
//                setNextBtnEnabled(false)
//            }
        }
        return true
    }
    
    func setNextBtnEnabled(_ enable: Bool) {
        
        if enable {
            
            btnNext.backgroundColor = appearences.newTheamColor
            btnNext.glowEffect = true
            btnNext.isUserInteractionEnabled = true
        }
        else {
            
            btnNext.backgroundColor = UIColor.lightGray
            btnNext.isUserInteractionEnabled = false
            
            btnNext.shadowColor = UIColor.clear
            btnNext.shadowOffest = CGSize.init(width: 0, height: 0)
            btnNext.shadowRadius = 0.0
            btnNext.shadowOpacity = 0.0
            btnNext.viewMasksToBounds = true
        }
    }
}


// MARK: - Navigations
extension LoginViewController {
    
  
    
    func goToVerifyOTPScreen() {
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifyOTPVC : VerifyOTPViewController = storyboard.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
        if btnPhone.isSelected {

            verifyOTPVC.phone = txtPhone.text
            verifyOTPVC.countryCode = lblCountryCode.text

            verifyOTPVC.type = .phone
        }
        else {

            verifyOTPVC.email = txtEmail.text
            verifyOTPVC.type = .email
        }

        verifyOTPVC.activityType = .login

        self.navigationController?.pushViewController(verifyOTPVC, animated: true)
    }
    
    
}

// MARK: - Apple Login Context
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {

    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController {
    func sign(_ signIn: GIDSignIn, didSignInFor user: GIDGoogleUser, withError error: Error!) {
    
            if (error == nil)
            {
    
                if Reachability.isConnectedToNetwork()
                {
                    self.showLoader()
                    let profilePicUrl = user.profile.imageURL(withDimension: 200) as? String
                    var dict : [String: Any]
                    if CustomBranchHandler.shared.referralCustomerID.count == 0 {
                        dict = ["email": user.profile.email,"first_name": user.profile.name , "profile_pic_url" : profilePicUrl, "identity": "google", "google_id": user.userID, "device_id": Constants.DEVICE_ID ?? "", "segment_id": 2, "fcm_id": UserDefaults.standard.string(forKey: "fcmId") ?? "", "platform": "ios" ] as [String: Any]
                    } else {
                        dict = ["email": user.profile.email,"first_name": user.profile.name , "profile_pic_url" : profilePicUrl, "identity": "google", "google_id": user.userID, "device_id": Constants.DEVICE_ID ?? "", "segment_id": 2, "fcm_id": UserDefaults.standard.string(forKey: "fcmId") ?? "", "platform": "ios" ,"referrer_customer_id":CustomBranchHandler.shared.referralCustomerID ] as [String: Any]
                    }
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
                                    //                                self.showToast(message: (error?.localizedDescription) ?? "The Internet connection appears to be offline.")
                                    GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: "Error : \(error?.localizedDescription ?? "")", eventPostTitle: "Google", eventPostCaption: "", eventId: "")
                                    //                                 CustomMoEngage.shared.sendEventUserLogin(source: self.isFromLoginSource, action: "Login", status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: nil)
                                    let payloadDict = NSMutableDictionary()
                                    payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                    CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: payloadDict)
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
                                        //                                    DispatchQueue.main.async {
                                        if let arr = json?.object(forKey: "error_messages") as? NSMutableArray {
                                            self.stopLoader()
    
                                            self.showToast(message: arr[0] as! String)
                                            var errorString = "Error"
                                            errorString = "Error : \(arr[0] as! String)"
    
                                            GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: errorString, eventPostTitle: "Google", eventPostCaption: "", eventId: "")
                                            //                                             CustomMoEngage.shared.sendEventUserLogin(source: self.isFromLoginSource, action: "Login", status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: nil)
                                            let payloadDict = NSMutableDictionary()
                                            payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                            CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: payloadDict)
                                        }
                                        //                                    }
                                    } else
                                        if (json?.object(forKey: "status_code") as? Int == 200)
                                        {
                                            GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: "Success", eventPostTitle: "Google", eventPostCaption: "", eventId: "")
    
//                                            if (UserDefaults.standard.object(forKey: "LoginSession") != nil || UserDefaults.standard.object(forKey: "LoginSession") as? String == "LoginSessionOut" || UserDefaults.standard.object(forKey: "LoginSession") as? String == "LoginSession")
//                                            {
                                                UserDefaults.standard.set("LoginSessionIn", forKey: "LoginSession")
                                                UserDefaults.standard.synchronize()
    
                                                //                                            self.showToast(message: "Customer Login successfully")
    
                                                let dictData = json?.object(forKey: "data") as? NSDictionary
                                                //
                                                if  let dict = dictData?.object(forKey: "customer") as? NSMutableDictionary {
                                                    if  let customer : Customer = Customer.init(dictionary: dict){
                                                    CustomerDetails.customerData = customer
                                                    CustomerDetails.badges = customer.badges
                                                    print("user badge \(customer.badges) and api response \(dict["badges"])")
                                                    //                                              self.findLevelOfFan(array: dict["badges"])
                                                    if let metaData = dictData?.value(forKey: "metaids") as? [String: Any] {
                                                        customer.purchaseStickers =  metaData["purchase_stickers"] as? Bool
                                                        customer.directline_room_id =  metaData["directline_room_id"] as? String; DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
                                                        DatabaseManager.sharedInstance.storeLikesAndPurchase(like_ids: metaData["like_content_ids"] as! [String], purchaseIds: metaData["purchase_content_ids"] as! [String], block_ids: metaData["block_content_ids"] as? [String])
                                                        CustomerDetails.purchase_stickers = metaData["purchase_stickers"] as? Bool
                                                        CustomerDetails.directline_room_id = metaData["directline_room_id"] as? String
                                                        _ = self.getOfflineUserData()
                                                    }
    
                                                    //
                                            if let profile_completed = dict.object(forKey: "profile_completed") as? Bool {
                                                    CustomerDetails.profile_completed = profile_completed
                                                
                                                        }
                                                     UserDefaults.standard.set(CustomerDetails.profile_completed, forKey: "profile_completed")
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
                                                        if let Customer_dob = dict.object(forKey: "dob") as? String{
                                                                                                               UserDefaults.standard.setValue(Customer_dob, forKey: "dob")
                                                                                                                                                      UserDefaults.standard.synchronize()
                                                            CustomerDetails.dob = Customer_dob
                                                                                                        }
                                                        if let Customer_mobile_code = dict.object(forKey: "mobile_code") as? String{
                                                            UserDefaults.standard.setValue(Customer_mobile_code, forKey: "mobile_code")
                                                            UserDefaults.standard.synchronize()
                                                               CustomerDetails.mobile_code = Customer_mobile_code
                                                        }
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
    
                                                    //"re_loggedin" = 0;
                                                    CustomerDetails.identity = customer.identity
                                                    CustomerDetails.lastVisited = customer.last_visited
                                                    CustomerDetails.status = customer.status
                                                    CustomerDetails.mobile_code = customer.mobile_code
                                                    CustomerDetails.dob = customer.dob
                                                        
                                                        
                                                        if let Customer_EmailVerified = dict.object(forKey: "email_verified") as? Bool {
                                                            CustomerDetails.email_verified = Customer_EmailVerified
                                                        }
                                                        
                                                        if let Customer_EmailVerified = dict.object(forKey: "email_verified") as? Int {
                                                            if Customer_EmailVerified == 0 {
                                                                CustomerDetails.email_verified = false
                                                            } else if Customer_EmailVerified == 1 {
                                                                CustomerDetails.email_verified = true
                                                            }
                                                        }
                                                        
                                                        UserDefaults.standard.set(CustomerDetails.email_verified, forKey: "email_verified")
                                                        UserDefaults.standard.synchronize()
                                                        
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
                                                        
                                                    CustomMoEngage.shared.setMoUserInfo(customer: customer)
                                                    CustomMoEngage.shared.setMoUserInfoUsingCustomerDetails()
                                                    if let relogin = dictData?.object(forKey: "re_loggedin") as? Bool{
                                                        CustomMoEngage.shared.setMoReLogginUserAttributes(re_loggedin: relogin)
                                                    } else {
                                                        CustomMoEngage.shared.setMoReLogginUserAttributes(re_loggedin: false)
                                                    }
                                                    Branch.getInstance().setIdentity(customer._id)
                                                    print("Login Successful")
    
                                                    if let newUSerFlag = dictData?.object(forKey: "new_user") as? Bool {
                                                        if newUSerFlag {
    
                                                            let payloadDict = NSMutableDictionary()
                                                            payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                                            CustomMoEngage.shared.sendEventSignUpLogin(eventType: .signUp,status: "Success", reason: "", extraParamDict: payloadDict)
                                                        } else {
                                                            let payloadDict = NSMutableDictionary()
                                                            payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                                            CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Success", reason: "", extraParamDict: payloadDict)
                                                        }
                                                    }
    
                                                    UserDefaults.standard.set("google", forKey: "logintype")
                                                    UserDefaults.standard.synchronize()
                                                    self.stopLoader()
                                                        
                                            /*        if let newUSerFlag = dictData?.object(forKey: "new_user") as? Bool , let reward = dictData?.object(forKey: "reward") as? NSMutableDictionary {
                                                        if newUSerFlag {
                                                            if let desc = reward.object(forKey: "description") as? String{
                                                                self.goToTabMenu(desc: desc, isRewardGet: true)
                                                            } else {
                                                                self.goToTabMenu(desc: "", isRewardGet: false)
                                                            }
                                                        } else {
                                                            self.goToTabMenu(desc: "", isRewardGet: false)
                                                        }
                                                    } else {
                                                        self.goToTabMenu(desc: nil, isRewardGet: false)
                                                    }
                                                 */
                                                        
                                                        if let newUSerFlag = dictData?["new_user"] as? Bool
                                                        {
                                                            UserDefaults.standard.setValue(newUSerFlag, forKey: "newUSerFlag")
                                                            
                                                            if newUSerFlag == true
                                                            {
                                                                self.goToDobCheck(isNew: true, user_dob: "")
                                                            }else{
                                                                self.validData()
                                                            }
                                                            
                                                        }
                                                        
                                                }
                                            }
//                                            }
                                    }
                                }
                            } catch let error as NSError {
                                print(error)
                                DispatchQueue.main.async {
                                    self.stopLoader()
                                    GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: "Error : \(error.localizedDescription)", eventPostTitle: "Google", eventPostCaption: "", eventId: "")
                                    //                                 CustomMoEngage.shared.sendEventUserLogin(source: self.isFromLoginSource, action: "Login", status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                                    let payloadDict = NSMutableDictionary()
                                    payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                    CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
                                }
    
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
                let payloadDict = NSMutableDictionary()
                payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
            }
    }
    
   

    func getFBUserData() {
        //        self.overlayView.showOverlay(view: self.view)
        self.showLoader()
        if ((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    let currentConditions = result as! [String:Any]
                    print("facebook data=> \(currentConditions)")

                    if currentConditions["email"] == nil{
                        self.stopLoader()
                        self.showOnlyAlert(title: "Info",message: "Your facebook account don't have email Id, please enter email Id in your facebook account to access this app.")
                        return
                    }
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

                        if key == "email" {
                            if let facebookEmail = value as? String, facebookEmail != "" {
                                self.facebookEmail = facebookEmail
                            } else {
                                //                                self.facebookEmail = self.firstName + "." + self.lastName + "@facebook.com"
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
                    //                    CustomMoEngage.shared.sendEventUserLogin(source: self.isFromLoginSource, action: "Login", status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: nil)
                    let payloadDict = NSMutableDictionary()
                    payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                    CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: payloadDict)
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
            var dict : [String: Any]
            if CustomBranchHandler.shared.referralCustomerID.count == 0 {
                dict = ["email": facebookEmail, "identity": "facebook", "facebook_id": facebookId, "first_name" : self.firstName , "last_name" : self.lastName, "picture" : self.profilePic, "device_id": Constants.DEVICE_ID ?? "", "segment_id": 2, "fcm_id": UserDefaults.standard.string(forKey: "fcmId") ?? "", "platform": "ios" ] as [String: Any]
            } else {
                dict = ["email": facebookEmail, "identity": "facebook", "facebook_id": facebookId, "first_name" : self.firstName , "last_name" : self.lastName, "picture" : self.profilePic, "device_id": Constants.DEVICE_ID ?? "", "segment_id": 2, "fcm_id": UserDefaults.standard.string(forKey: "fcmId") ?? "", "platform": "ios" ,"referrer_customer_id":CustomBranchHandler.shared.referralCustomerID]as [String: Any]
            }

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
                            //                            self.showToast(message: (error?.localizedDescription) ?? "The Internet connection appears to be offline.")
                            GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: "Error : \(error?.localizedDescription ?? "")", eventPostTitle: "Facebook", eventPostCaption: "", eventId: "")
                            //                              CustomMoEngage.shared.sendEventUserLogin(source: self.isFromLoginSource, action: "Login", status: "Failed", reason:error?.localizedDescription ?? "", extraParamDict: nil)
                            let payloadDict = NSMutableDictionary()
                            payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                            CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: payloadDict)

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
                                    var errorString = "Error"
                                    if let arr = json?.object(forKey: "error_messages") as? NSMutableArray{
                                        errorString = "Error : \(arr[0] as! String)"
                                    }
                                    GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: errorString, eventPostTitle: "Facebook", eventPostCaption: "", eventId: "")
                                    //                                    CustomMoEngage.shared.sendEventUserLogin(source: self.isFromLoginSource, action: "Login", status: "Failed", reason:errorString, extraParamDict: nil)
                                    let payloadDict = NSMutableDictionary()
                                    payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                    CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: errorString, extraParamDict: payloadDict)
                                }
                            }
                        } else if (json?.object(forKey: "status_code") as? Int == 200) {
                            DispatchQueue.main.async {
                                GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: "Success", eventPostTitle: "Facebook", eventPostCaption: "", eventId: "")

//                                if (UserDefaults.standard.object(forKey: "LoginSession") != nil || UserDefaults.standard.object(forKey: "LoginSession") as? String == "LoginSessionOut" || UserDefaults.standard.object(forKey: "LoginSession") as? String == "LoginSession")
//                                {
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
                                         
                                        customer.directline_room_id =  metaData["directline_room_id"] as? String; DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
                                        DatabaseManager.sharedInstance.storeLikesAndPurchase(like_ids: metaData["like_content_ids"] as! [String], purchaseIds: metaData["purchase_content_ids"] as! [String], block_ids: metaData["block_content_ids"] as? [String])

                                        CustomerDetails.purchase_stickers = metaData["purchase_stickers"] as? Bool
                                      
                                        
                                        CustomerDetails.directline_room_id = metaData["directline_room_id"] as? String
                                        _ = self.getOfflineUserData()
                                    } else {
                                        DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
                                    }

                                    if let Customer_Id = dict.object(forKey: "_id") as? String{
                                        CustomerDetails.custId = Customer_Id
                                    }
                                    if let Customer_Account_Link = dict.object(forKey: "account_link") as? NSMutableDictionary{
                                        CustomerDetails.account_link = Customer_Account_Link
                                    }
                                    //                                        CustomerDetails.badges = dict.object(forKey: "badges")

                                   if let profile_completed = dict.object(forKey: "profile_completed") as? Bool {
                                                CustomerDetails.profile_completed = profile_completed
                                   
                                        }
                                            UserDefaults.standard.set(CustomerDetails.profile_completed, forKey: "profile_completed")
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
                                            if let Customer_dob = dict.object(forKey: "dob") as? String{
                                                UserDefaults.standard.setValue(Customer_dob, forKey: "dob")
                                                                                       UserDefaults.standard.synchronize()
                                                                                                   CustomerDetails.dob = Customer_dob
                                                                                            }
                                            if let Customer_mobile_code = dict.object(forKey: "mobile_code") as? String{
                                                UserDefaults.standard.setValue(Customer_mobile_code, forKey: "mobile_code")
                                                UserDefaults.standard.synchronize()
                                                   CustomerDetails.mobile_code = Customer_mobile_code
                                            }
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
                                    CustomerDetails.identity = customer.identity
                                    CustomerDetails.lastVisited = customer.last_visited
                                    CustomerDetails.status = customer.status
                                    CustomerDetails.mobile_code = customer.mobile_code
                                    CustomerDetails.dob = customer.dob
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
                                            
                                            if let Customer_EmailVerified = dict.object(forKey: "email_verified") as? Bool {
                                                        CustomerDetails.email_verified = Customer_EmailVerified
                                                }

                                        if let Customer_EmailVerified = dict.object(forKey: "email_verified") as? Int {
                                            if Customer_EmailVerified == 0 {
                                                CustomerDetails.email_verified = false
                                            } else if Customer_EmailVerified == 1 {
                                                CustomerDetails.email_verified = true
                                                }
                                        }

                                            UserDefaults.standard.set(CustomerDetails.email_verified, forKey: "email_verified")
                                                UserDefaults.standard.synchronize()
                                    //                                    CustomMoEngage.shared.setMoUserInfo(customer: customer)
                                    CustomMoEngage.shared.setMoUserInfoUsingCustomerDetails()
                                    if let relogin = dictData.object(forKey: "re_loggedin") as? Bool{
                                        CustomMoEngage.shared.setMoReLogginUserAttributes(re_loggedin: relogin)
                                    } else {
                                        CustomMoEngage.shared.setMoReLogginUserAttributes(re_loggedin: false)
                                    }
                                    Branch.getInstance().setIdentity(customer._id)

                                    if let newUSerFlag = dictData.object(forKey: "new_user") as? Bool {
                                        if newUSerFlag {
                                            let payloadDict = NSMutableDictionary()
                                            payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                            CustomMoEngage.shared.sendEventSignUpLogin(eventType: .signUp,status: "Success", reason: "", extraParamDict: payloadDict)
                                        } else {
                                            let payloadDict = NSMutableDictionary()
                                            payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                            CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Success", reason: "", extraParamDict: payloadDict)
                                        }
                                    }
                                    UserDefaults.standard.set("facebook", forKey: "logintype")
                                    UserDefaults.standard.synchronize()
                      /*              if let newUSerFlag = dictData.object(forKey: "new_user") as? Bool , let reward = dictData.object(forKey: "reward") as? NSMutableDictionary {
                                        if newUSerFlag {
                                            if let desc = reward.object(forKey: "description") as? String{
                                                //          self.showCongoPopup(msg: desc)
                                                self.goToTabMenu(desc: desc, isRewardGet: true)
                                            } else {
                                                self.goToTabMenu(desc: nil, isRewardGet: false)
                                            }
                                        } else {
                                            self.goToTabMenu(desc: nil, isRewardGet: false)
                                        }
                                    } else {
                                        self.goToTabMenu(desc: nil, isRewardGet: false)
                                    }
                                            */
                                            
                                            if let newUSerFlag = dictData["new_user"] as? Bool
                                            {
                                                UserDefaults.standard.setValue(newUSerFlag, forKey: "newUSerFlag")
                                                
                                                if newUSerFlag == true
                                                {
                                                    self.goToDobCheck(isNew: true, user_dob: "")
                                                }else{
                                                    self.validData()
                                                }
                                                
                                            }

                                      }
                                
                               }

//                                }
                            }
                        }


                    } catch let error as NSError {
                        print(error)
                        DispatchQueue.main.async {
                            self.stopLoader()
                            GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: "Error:\(error.localizedDescription)", eventPostTitle: "Facebook", eventPostCaption: "", eventId: "")
                            //                             CustomMoEngage.shared.sendEventUserLogin(source: self.isFromLoginSource, action: "Login", status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                            let payloadDict = NSMutableDictionary()
                            payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                            CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
                        }
                    }
                }
                task.resume()
            }
        }

    }
}
@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func getAppleLoginBtn() -> ASAuthorizationAppleIDButton? {
        
        return ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
      }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            print("User Id - \(appleIDCredential.user)")
            print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
            print("User Email - \(appleIDCredential.email ?? "")")
            print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
            }



            let string = "\(appleIDCredential.email ?? "")"

            if Reachability.isConnectedToNetwork()
            {
                
                let dict = ["email": "\(appleIDCredential.email ?? "")", "identity": "apple", "apple_id": "\(appleIDCredential.user )", "first_name" : "\(appleIDCredential.fullName?.givenName ?? "N/A")" , "last_name" : "\(appleIDCredential.fullName?.familyName ?? "N/A")", "device_id": Constants.DEVICE_ID ?? "", "segment_id": 2, "fcm_id": UserDefaults.standard.string(forKey: "fcmId") ?? "", "platform": "ios" ] as [String: Any] //streamType":"start/end (Depending on the status), "

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
                                //                            self.hideWhiteLoader()
                                self.stopLoader()
                                //                            self.showToast(message: (error?.localizedDescription) ?? "The Internet connection appears to be offline.")
                                GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: "Error : \(error?.localizedDescription ?? "")", eventPostTitle: "Facebook", eventPostCaption: "", eventId: "")
                                //                              CustomMoEngage.shared.sendEventUserLogin(source: self.isFromLoginSource, action: "Login", status: "Failed", reason:error?.localizedDescription ?? "", extraParamDict: nil)
                                let payloadDict = NSMutableDictionary()
                                payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: payloadDict)

                            }
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("apple login response json \(String(describing: json))")
                            //                        print("facebook login response json desc \(json?.description)")

                            if json?.object(forKey: "error") as? Bool == true
                            {
                                DispatchQueue.main.async {
                                    if let arr = json?.object(forKey: "error_messages") as? NSMutableArray {
                                        //                                    self.hideWhiteLoader()
                                        self.stopLoader()
                                        self.showToast(message: arr[0] as! String)
                                        var errorString = "Error"
                                        if let arr = json?.object(forKey: "error_messages") as? NSMutableArray{
                                            errorString = "Error : \(arr[0] as! String)"
                                            self.showToast(message: arr[0] as! String)
                                        }
                                        GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: errorString, eventPostTitle: "Facebook", eventPostCaption: "", eventId: "")
                                        //                                    CustomMoEngage.shared.sendEventUserLogin(source: self.isFromLoginSource, action: "Login", status: "Failed", reason:errorString, extraParamDict: nil)
                                        let payloadDict = NSMutableDictionary()
                                        payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                        CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: errorString, extraParamDict: payloadDict)
                                    }
                                }
                            } else if (json?.object(forKey: "status_code") as? Int == 200) {
                                //                            self.hideWhiteLoader()
                                self.stopLoader()
                                DispatchQueue.main.async {
                                    GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: "Success", eventPostTitle: "Facebook", eventPostCaption: "", eventId: "")

//                                    if (UserDefaults.standard.object(forKey: "LoginSession") != nil || UserDefaults.standard.object(forKey: "LoginSession") as? String == "LoginSessionOut" || UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSession")
//                                    {
                                        UserDefaults.standard.set("LoginSessionIn", forKey: "LoginSession")
                                        UserDefaults.standard.synchronize()
                                        if  let dictData = json?.object(forKey: "data") as? NSDictionary {
                                            if let dict = dictData.object(forKey: "customer") as? NSMutableDictionary {
                                        print("Login Successful")
                                        //                                    if let mainDict = json?.object(forKey: "data") as? [String:Any] {
                                        //                                        GlobalFunctions.findTypeOfFan(dict: mainDict)
                                        //                                    }
                                        let customer : Customer = Customer.init(dictionary: dict)!
                                        CustomerDetails.customerData = customer
                                        CustomerDetails.badges = customer.badges
                                        if let metaData = dictData.value(forKey: "metaids") as? [String: Any] {
                                            customer.purchaseStickers =  metaData["purchase_stickers"] as? Bool
                                            customer.directline_room_id =  metaData["directline_room_id"] as? String;    DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
                                            DatabaseManager.sharedInstance.storeLikesAndPurchase(like_ids: metaData["like_content_ids"] as! [String], purchaseIds: metaData["purchase_content_ids"] as! [String], block_ids: metaData["block_content_ids"] as? [String])

                                            CustomerDetails.directline_room_id = metaData["directline_room_id"] as? String;   CustomerDetails.purchase_stickers = metaData["purchase_stickers"] as? Bool

                                            _ = self.getOfflineUserData()
                                        } else {
                                            DatabaseManager.sharedInstance.insertCustomerDataToDatabase(cust: customer)
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
                                       if let profile_completed = dict.object(forKey: "profile_completed") as? Bool {
                                                    CustomerDetails.profile_completed = profile_completed
                                                    
                                         }
                                    UserDefaults.standard.set(CustomerDetails.profile_completed, forKey: "profile_completed")
                                                                                      
                                                
                                    UserDefaults.standard.synchronize()
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
                                     if let Customer_dob = dict.object(forKey: "dob") as? String{
                                            UserDefaults.standard.setValue(Customer_dob, forKey: "dob")
                                                                                                                                              UserDefaults.standard.synchronize()
                                                    CustomerDetails.dob = Customer_dob
                                                                                                }
                                                if let Customer_mobile_code = dict.object(forKey: "mobile_code") as? String{
                                                    UserDefaults.standard.setValue(Customer_mobile_code, forKey: "mobile_code")
                                                    UserDefaults.standard.synchronize()
                                                       CustomerDetails.mobile_code = Customer_mobile_code
                                                }

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
                                        CustomerDetails.identity = customer.identity
                                        CustomerDetails.lastVisited = customer.last_visited
                                        CustomerDetails.status = customer.status
                                        CustomerDetails.mobile_code = customer.mobile_code
                                        CustomerDetails.dob = customer.dob
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

                                                
                                                if let Customer_EmailVerified = dict.object(forKey: "email_verified") as? Bool {
                                                                                           CustomerDetails.email_verified = Customer_EmailVerified
                                                                                       }

                                                                                       if let Customer_EmailVerified = dict.object(forKey: "email_verified") as? Int {
                                                                                           if Customer_EmailVerified == 0 {
                                                                                               CustomerDetails.email_verified = false
                                                                                           } else if Customer_EmailVerified == 1 {
                                                                                               CustomerDetails.email_verified = true
                                                                                           }
                                                                                       }

                                            UserDefaults.standard.set(CustomerDetails.email_verified, forKey: "email_verified")
                                                UserDefaults.standard.synchronize()
                                        //                                    CustomMoEngage.shared.setMoUserInfo(customer: customer)
                                        CustomMoEngage.shared.setMoUserInfoUsingCustomerDetails()
                                        //                                     Branch.getInstance()?.setIdentity(customer._id)

                                        if let newUSerFlag = dictData.object(forKey: "new_user") as? Bool {
                                            if newUSerFlag {
                                                let payloadDict = NSMutableDictionary()
                                                payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .signUp,status: "Success", reason: "", extraParamDict: payloadDict)
                                            } else {
                                                let payloadDict = NSMutableDictionary()
                                                payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Success", reason: "", extraParamDict: payloadDict)
                                            }
                                        }


                                        if let newUSerFlag = dictData.object(forKey: "new_user") as? Bool {
                                            if newUSerFlag {
                                                let payloadDict = NSMutableDictionary()
                                                payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .signUp,status: "Success", reason: "", extraParamDict: payloadDict)
                                            } else {
                                                let payloadDict = NSMutableDictionary()
                                                payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Success", reason: "", extraParamDict: payloadDict)
                                            }
                                        }


                                        let New_User = dictData.object(forKey: "new_user") as? Bool

                                        print("New User Check Status \(New_User)")

                                                
                                        if let newUSerFlag = dictData.object(forKey: "new_user") as? Bool
                                        {
                                            UserDefaults.standard.setValue(newUSerFlag, forKey: "newUSerFlag")
                                                    
                                            if newUSerFlag == true
                                                    {
                                                        self.goToDobCheck(isNew: true, user_dob: "")
                                                    }else{
                                                        self.validData()
                                                    }
                                                    
                                                }
                                                
                                                
                             /*           if New_User == true {
                                            if  let reward = dictData.object(forKey: "reward") as? NSMutableDictionary{

                                                if let desc = reward.object(forKey: "description") as? String{
                                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                    let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
                                                    vc.isCommingFromRewardView = true
                                                    vc.descMsg = desc ?? ""
                                                    self.stopLoader()
                                                    self.pushAnimation()

                                                    let currentNav: UINavigationController =  UIApplication.shared.delegate?.window??.rootViewController as!  UINavigationController
                                                    currentNav.pushViewController(vc, animated: false)
                                                }
                                            } else {
                                                let notificationType = UIApplication.shared.currentUserNotificationSettings!.types

                                                print("notifications are enabled")
                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController

                                                self.stopLoader()
                                                self.pushAnimation()

                                                let currentNav: UINavigationController =  UIApplication.shared.delegate?.window??.rootViewController as!  UINavigationController
                                                currentNav.pushViewController(vc, animated: false)
                                            }
                                        } else {

                                            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types

                                            print("notifications are enabled")
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController

                                            self.stopLoader()
                                            self.pushAnimation()

                                            let currentNav: UINavigationController =  UIApplication.shared.delegate?.window??.rootViewController as!  UINavigationController
                                            currentNav.pushViewController(vc, animated: false)
                                        }  */
                                    }
                                     }
//                                    }
                                }
                            }


                        } catch let error as NSError {
                            print(error)
                            DispatchQueue.main.async {
                                //                            self.hideWhiteLoader()
                                self.stopLoader()
                                GlobalFunctions.trackEvent(eventScreen: "Login Screen", eventName: "Error:\(error.localizedDescription)", eventPostTitle: "Facebook", eventPostCaption: "", eventId: "")
                            
                                let payloadDict = NSMutableDictionary()
                                payloadDict.setObject(self.isFromLoginSource , forKey: "source" as NSCopying)
                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .login,status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
                            }
                        }
                    }
                    task.resume()
                }
            }
            //            }
            //



            //Show Home View Controller
            //            HomeViewController.Push()
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password

            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

}
// MARK: - Web Service Methods
extension LoginViewController {
    
    func webLogin(id: String?, email: String?, firstname: String?, lastname: String?, phone: String?, countryCode: String?, type: LoginType) {
        
        let api = Constants.requestloginOTP
    
        var dictParams = [String: Any]()
        
        dictParams["activity"] = "login"
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
        
        if let fname = firstname {
            
            dictParams["first_name"] = fname
        }
        
        if let lname = lastname {
            
            dictParams["last_name"] = lname
        }
        
        if CustomBranchHandler.shared.referralCustomerID != "" {
            dictParams["referrer_customer_id"] = CustomBranchHandler.shared.referralCustomerID
        }
        
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
        
        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { (status, msg, dict) in

            var loginEventStatus: LoginEventStatus = .success

            if status {
                
                guard let dictRes = dict else {
                    loginEventStatus = .failure(message: "response is nil")
                    self.showError(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {
                    
                    if let arrErrors = dictRes["error_messages"] as? [String], arrErrors.count > 0 {
                        loginEventStatus = .failure(message: arrErrors[0])
                        self.showError(msg: arrErrors[0])
                    }
                    else {
                        loginEventStatus = .failure(message: "error not found")
                        self.showError(msg: stringConstants.errSomethingWentWrong)
                    }
                    
                    return
                }
                
   
                self.goToVerifyOTPScreen()
                
            }
            else {
                loginEventStatus = .failure(message: msg ?? "")
                utility.alert(message: msg, delegate: self, cancel: nil, completion: nil)
            }
        }
    }

}

extension UIView{
    func addBorderWithCornerRadius(width: CGFloat , cornerRadius: CGFloat , color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
    }
}
