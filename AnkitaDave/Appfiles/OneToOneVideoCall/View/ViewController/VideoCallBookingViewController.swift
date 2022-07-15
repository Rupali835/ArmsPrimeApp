    //
    //  VideoCallBookingViewController.swift
    //  Gunjan Aras App
    //
    //  Created by Shriram on 17/06/20.
    //  Copyright © 2020 armsprime. All rights reserved.
    //
    
    import UIKit
    // import FlagPhoneNumber
    import Foundation
    import AVFoundation
    import SDWebImage
    import Alamofire
    import SwiftyJSON
    import IQKeyboardManagerSwift
    import MoEngage
    import NVActivityIndicatorView
    import CountryPickerView
    
    import CoreSpotlight
    import MobileCoreServices
    import SafariServices
    
    class VideoCallBookingViewController: BaseViewController, PurchaseContentProtocol {
        func contentPurchaseSuccessful(index: Int, contentId: String?) {
            // <#code#>
        }
        fileprivate var countryPicker = CountryPickerView()
        var atristConfigCoins = ArtistConfiguration.sharedInstance()
        
        @IBOutlet weak var phoneNumberTextField: UITextField!
        // @IBOutlet weak var tfContactNo: UITextField!
        @IBOutlet weak var tfMailId: UITextField!
        @IBOutlet weak var txtViewMessage: UITextView!
        @IBOutlet weak var checkbox: UIButton!
        @IBOutlet weak var termCheckBoxImgView: UIImageView!
        @IBOutlet weak var lblCoins: UILabel!
        @IBOutlet weak var lblAcceptance: UILabel!
        @IBOutlet weak var lblNoteTitle: UILabel!
        @IBOutlet weak var lblCallDuration: UILabel!
        @IBOutlet weak var mobileNumberTextfield: UITextField!
        @IBOutlet weak var mobileNumberLabel: UILabel!
        @IBOutlet weak var lbldurationTitle: UILabel!
         @IBOutlet weak var imgDropdown: UIImageView!
        @IBOutlet weak var viewDuration: UIView!
        
         @IBOutlet weak var viewDurationHeight: NSLayoutConstraint!
        @IBOutlet weak var viewLabelsHeight: NSLayoutConstraint!
        
        
        var selectedDuration: Int64?
        var selectedCoins:  Int64?
        var selectedDefaultRatecard: String?
        var durationList = [Int64]()
        var coinsList = [Int64]()
        var defaultDurationKey = [Int64]()
        var isDatacard = ""
        @IBOutlet weak var txtCallDuration: UITextField!
        var isdefaultRatecard = [Bool]()
        
        var strCountryCode:String?
        
        var Notes:String? = " "
        var VideoCAllBookingID:String?
        var projects:[[String]] = []
        var activity: NSUserActivity?
        
        var FilterCountryCode : String? = " "
        private var overlayView = LoadingOverlay.shared
        var isTermCond: Bool = false
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            title = "Video Call Booking"
            projects.append( [ ("Video Call Booking")] )
            createPickerView()
            dismissPickerView()
            
            self.txtCallDuration.delegate = self
            self.lblAcceptance.adjustsFontSizeToFitWidth = true
            self.lblAcceptance.textAlignment = NSTextAlignment.center
            
            
            if let StrCallDuration = atristConfigCoins.privateVideoCallrateCard?.durations {
                self.durationList = StrCallDuration
                print("multiple call Duration: \(StrCallDuration)")
            }
            
            
            
            if let StrMultipleCoinsvalue = atristConfigCoins.privateVideoCallrateCard?.coins {
                self.coinsList = StrMultipleCoinsvalue
                print("multiple coins: \(StrMultipleCoinsvalue)")
            }
            
            if let defaultRatecardValue = atristConfigCoins.privateVideoCallrateCard?.defaultRatecard {
                self.defaultDurationKey = defaultRatecardValue
                if let index = defaultRatecardValue.firstIndex(of:1){
                    selectedDuration = durationList[index]
                }
                
            }
            
            if let duraion = self.selectedDuration{
                self.txtCallDuration?.text = String(duraion) + " minutes"
            }
            
            
            if let defaultRatecardCoins = atristConfigCoins.privateVideoCallrateCard?.defaultRatecard {
                self.defaultDurationKey = defaultRatecardCoins
                if let index = defaultRatecardCoins.firstIndex(of:1){
                    selectedCoins = coinsList[index]
                }
                
            }
            
            if let selectedCoins = self.selectedCoins{
                self.lblCoins?.text = String(selectedCoins)
            }
            
            self.lblNoteTitle.text? = "Note:- While sending your requests refrain from using obscene, derogatory, insulting and offensive language. Non complaince to this will result in rejection of your request and coins will not be refunded."
            self.lblNoteTitle.adjustsFontSizeToFitWidth = true
            IQKeyboardManager.shared.enableAutoToolbar = true
            projects.append( [String (self.lblNoteTitle.text ?? "")] )
            index(item: 0)
            setupView()
            
            
            if self.durationList.isEmpty
            {
                self.lbldurationTitle?.isHidden = true
                self.txtCallDuration?.isHidden = true
                self.imgDropdown?.isHidden = true
                self.lblCallDuration?.isHidden = false
                
                viewDurationHeight.constant = 0
                self.view.layoutSubviews()
                
                if let StrCallDuration = atristConfigCoins.privateVideoCall?.duration {
                  
                    self.lblCallDuration.text? = "Note: Video call duration will be " + String (StrCallDuration)  +  " minutes"
                    self.lblCallDuration.adjustsFontSizeToFitWidth = true
                    self.lblCallDuration.textAlignment = NSTextAlignment.center
                    projects.append( [String (StrCallDuration)] )
                    index(item: 0)
                }
                
                if let priceAmount = atristConfigCoins.privateVideoCall?.coins {
                    print(priceAmount)
                    self.lblCoins.text? = String (priceAmount)
                    projects.append( [String (priceAmount)] )
                    index(item: 0)
                }
            }else{
                 self.lblCallDuration?.isHidden = true
               // viewDurationHeight.constant = 0
            }
            
        }
         
        override func restoreUserActivityState(_ activity: NSUserActivity) {
            
            self.activity = activity
            
            super.restoreUserActivityState(activity)
            
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //            if let StrCallDuration = atristConfigCoins.privateVideoCall?.duration {
            //
            //                self.lblCallDuration.text? = "Video call duration: " + String (StrCallDuration)  +  " minutes"
            //                self.lblCallDuration.adjustsFontSizeToFitWidth = true
            //                self.lblCallDuration.textAlignment = NSTextAlignment.center
            //                projects.append( [String (StrCallDuration)] )
            //                index(item: 0)
            //            }
            
            self.lblNoteTitle.text? = "Note:- While sending your requests refrain from using obscene, derogatory, insulting and offensive language. Non complaince to this will result in rejection of your request and coins will not be refunded."
            self.lblNoteTitle.adjustsFontSizeToFitWidth = true
            projects.append( [String (self.lblNoteTitle.text ?? "")] )
            index(item: 0)
            
            if CustomerDetails.customerData.email != nil {
                self.tfMailId.text = CustomerDetails.customerData.email ?? ""
                projects.append( [CustomerDetails.customerData.email ?? ""] )
                index(item: 0)
            }
            
            if CustomerDetails.mobileNumber  == "" {
                let mobNo = self.mobileNumberTextfield.text
                self.mobileNumberTextfield.text = mobNo
                projects.append( [(mobNo ?? "")] )
                index(item: 0)
            } else {
                self.mobileNumberTextfield.text = CustomerDetails.mobileNumber
                projects.append( [(self.mobileNumberTextfield.text ?? "")] )
                index(item: 0)
            }
            
//            if let priceAmount = atristConfigCoins.privateVideoCall?.coins {
//                print(priceAmount)
//                 self.lblCoins.text? = String (priceAmount)
//                projects.append( [String (priceAmount)] )
//                index(item: 0)
//            }
            index(item: 0)
            let activity = NSUserActivity(activityType: "com.proactive.mapview" + UUID().uuidString)
            activity.isEligibleForSearch = true
            activity.isEligibleForHandoff = true
            activity.isEligibleForPublicIndexing = true
            activity.title = title
            
            self.activity = activity
            self.activity?.becomeCurrent()
            
            
            
            
            
            
        }
        //MARK:- Loader
        func setLoader() {
            loaderIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            loaderIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
            loaderIndicator.type = .ballClipRotateMultiple // add your type
            //loaderIndicator.color =  hexStringToUIColor(hex: MyColors.appThemeColor)
            self.view.addSubview(loaderIndicator)
            
        }
        override func showLoader(){
            self.loaderIndicator?.startAnimating()
        }
        override func stopLoader()  {
            DispatchQueue.main.async {
                self.loaderIndicator?.stopAnimating()
            }
        }
        
        private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
            let toolbar: UIToolbar = UIToolbar()
            
            toolbar.barStyle = UIBarStyle.default
            toolbar.items = items
            toolbar.sizeToFit()
            
            return toolbar
        }
        
        
        
        func isValidEmail(testStr:String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: testStr)
        }
        func checkValidation() -> Bool {
            if tfMailId.text!.trimmingCharacters(in: .whitespaces).count == 0 {
                self.showToast(message: "Please enter email ID")
                return false
            }else if !isValidEmail(testStr: tfMailId.text!) {
                self.showToast(message: "Please enter valid email ID")
                return false
            } else if mobileNumberTextfield.text!.trimmingCharacters(in: .whitespaces).count == 0 {
                self.showToast(message: "Please enter mobile number")
                return false
            } else if mobileNumberTextfield.text!.trimmingCharacters(in: .whitespaces).count < 6 {
                self.showToast(message: "Please enter valid mobile number")
                return false
            }else if txtViewMessage.text!.trimmingCharacters(in: .whitespaces).count == 0 {
                self.showToast(message: "Please enter your message")
                return false
            }else if isTermCond == false {
                self.showToast(message: "Please accept terms and conditions")
                return false
            }
            return true
        }
        
        @IBAction func termsconditionsClickButton(_ sender: UIButton) {
            
            if checkbox.isSelected {
                termCheckBoxImgView.image = UIImage.init(named: "check")
                isTermCond = true
            }else {
                termCheckBoxImgView.image = UIImage.init(named: "uncheck")
                isTermCond = false
            }
            
            checkbox.isSelected = !checkbox.isSelected
            
        }
        
        
        @IBAction func termsConditions(_ sender: Any) {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            resultViewController.navigationTitle = "Terms & Conditions"
            resultViewController.openUrl = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ??  "http://www.armsprime.com/terms-conditions.html"
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }
        
        
        func rechareAlert(){
            
            let refreshAlert = UIAlertController(title: "Video Call", message: "You have insufficient balance!", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "RECHARE", style: .default, handler: { (action: UIAlertAction!) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PurchaseCoinsViewController")  as? PurchaseCoinsViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        
        
        
        func rechargeCoinsPopPop(){
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
            self.addChild(popOverVC)
            popOverVC.delegate = self
            popOverVC.isComingFrom = "private_video_call"
            // popOverVC.coins = Int(100)
            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
        }
        
        
        @IBAction func butnBookNowClicked(_ sender: Any) {
            
            if checkValidation(){
                if Reachability.isConnectedToNetwork()
                {
                    if CustomerDetails.coins == 0 {
                        //rechareAlert()
                        rechargeCoinsPopPop()
                    } else if CustomerDetails.coins  < (atristConfigCoins.privateVideoCall?.coins ?? 1) {
                        // rechareAlert()
                        rechargeCoinsPopPop()
                        
                    }else{
                        self.overlayView.showOverlay(view: self.view)
                       
                       var dict = [String:Any]()

                        if self.durationList.isEmpty
                        {
                             dict = ["email": tfMailId.text!, "message": txtViewMessage.text!, "artist_id": Constants.CELEB_ID ] as [String : Any]
                            
                            if let mobileNumber = mobileNumberTextfield.text, mobileNumber.count > 0 {
                                let countryCode = countryPicker.selectedCountry.phoneCode
                                dict["mobile_code"] = countryCode
                                dict["mobile"] = mobileNumber
                            }
                        }else{
                             dict = ["email": tfMailId.text!, "message": txtViewMessage.text!, "duration": self.selectedDuration ?? 0, "artist_id": Constants.CELEB_ID ] as [String : Any]
                            
                            if let mobileNumber = mobileNumberTextfield.text, mobileNumber.count > 0 {
                                let countryCode = countryPicker.selectedCountry.phoneCode
                                dict["mobile_code"] = countryCode
                                dict["mobile"] = mobileNumber
                            }
                            
                        }
                        
                        print(dict)
                        ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.videoCallRequest, extraHeader: nil, closure: { (result) in
                            switch result {
                            case .success(let data):
                                print(data)
                                self.stopLoader()
                                if(data["error"] as? Bool == true){
                                    //                                self.stopLoader()
                                    self.overlayView.hideOverlayView()
                                    self.showToast(message: "The mobile field is required.")
                                    self.showToast(message: "Something went wrong. Please try again!")
                                    //                                    CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason: "Something went wrong. Please try again!", extraParamDict: nil)
                                    return
                                    
                                } else {
                                    
                                    self.txtViewMessage.text = " "
                                    self.termCheckBoxImgView.image = UIImage.init(named: "uncheck")
                                    self.isTermCond = false
                                    
                                    self.overlayView.hideOverlayView()
                                    //                                // SHRIRAM CHANGE
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoCallBookingStatusViewController")  as? VideoCallBookingStatusViewController
                                    self.overlayView.hideOverlayView()
                                    // vc?.strVideoCAllBookingID = self.VideoCAllBookingID
                                    let jsonObject = data
                                    vc!.Details = jsonObject
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                }
                            case .failure(let error):
                                //                            self.stopLoader()
                                self.overlayView.hideOverlayView()
                                
                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                                self.showToast(message: "Something went wrong. Please try again!")
                                print(error)
                            }
                        })
                    }
                }else {
                    self.showToast(message: Constants.NO_Internet_MSG)
                    
                    CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason:  Constants.NO_Internet_MSG, extraParamDict: nil)
                    self.showToast(message: "No Internet Connection")
                    
                }
            }
            
        }
        
        public func successToast(message: String, duration: Double) {
            
        }
        
    }
    
    
    
    // MARK: - Custom Methods.
    extension VideoCallBookingViewController {
        fileprivate func setupView() {
            [ mobileNumberTextfield].forEach { (textField) in
                textField?.delegate = self
            }
            
            
            // Country Picker.
            countryPicker.showCountryCodeInView = true
            countryPicker.font = ShoutoutFont.regular.withSize(size: .medium)
            countryPicker.flagSpacingInView = 2.0
            countryPicker.delegate = self
            countryPicker.dataSource = self
            self.mobileNumberTextfield.delegate = self
            let countryPickerContainer = UIView()
            let separator = UIView()
            
            separator.backgroundColor = UIColor.black
            countryPickerContainer.addSubview(separator)
            countryPickerContainer.addSubview(countryPicker)
            
            // UITextField LeftView issue fix for iOS 13.0
            if #available(iOS 13.0, *) {
                countryPickerContainer.translatesAutoresizingMaskIntoConstraints = false
                separator.translatesAutoresizingMaskIntoConstraints = false
                countryPicker.translatesAutoresizingMaskIntoConstraints = false
                
                countryPickerContainer.widthAnchor.constraint(equalToConstant: 108.0).isActive = true
                countryPickerContainer.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
                
                countryPicker.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
                countryPicker.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
                countryPicker.leadingAnchor.constraint(equalTo: countryPickerContainer.leadingAnchor, constant: 10.0).isActive = true
                countryPicker.centerYAnchor.constraint(equalTo: countryPickerContainer.centerYAnchor).isActive = true
                
                separator.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
                separator.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
                separator.centerYAnchor.constraint(equalTo: countryPickerContainer.centerYAnchor).isActive = true
                separator.trailingAnchor.constraint(equalTo: countryPickerContainer.trailingAnchor, constant: -1.0).isActive = true
                
            } else {
                // Fallback on earlier versions.
                // LeftView frame works as expected on earlier versions.
                countryPickerContainer.frame = CGRect(x: 0.0, y: 0.0, width: 108.0, height: 40.0)
                separator.frame = CGRect(x: countryPickerContainer.frame.width - 1.0, y: 5.0, width: 1.0, height: countryPickerContainer.frame.height - 10.0)
                countryPicker.frame = CGRect(x: 10.0, y: 0.0, width: 90, height: 40.0)
            }
            
            mobileNumberTextfield.leftView = countryPickerContainer
            mobileNumberTextfield.leftViewMode = .always
            
        }
        fileprivate func setupUIProperties() {
            // view.setGradientBackground()
            [ mobileNumberLabel].forEach { (label) in
                label?.font = ShoutoutFont.light.withSize(size: .small)
                label?.textColor = .white//UIColor.black
            }
            
            [mobileNumberTextfield].forEach { (textField) in
                textField?.font = ShoutoutFont.regular.withSize(size: .medium)
                textField?.borderWidth = 0.5
                textField?.borderColor = UIColor.gray
            }
            
        }
        
    }
    
    // MARK: - UITextField Delegate Methods.
    
    extension VideoCallBookingViewController: UITextFieldDelegate {
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return true
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            
            
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            if (textField == mobileNumberTextfield), let text = textField.text {
                let newText = (text as NSString).replacingCharacters(in: range, with: string)
                let numberOfChars = newText.count
                
                return textField == mobileNumberTextfield ? numberOfChars <= 15 : numberOfChars <= ShoutoutConstants.charLimitForOtherOccasion
            } else {
                
                return true
            }
        }
    }
    
    
    
    // MARK: - CountryPickerView DataSource and Delegate.
    extension VideoCallBookingViewController: CountryPickerViewDataSource, CountryPickerViewDelegate {
        func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
            strCountryCode = country.phoneCode
        }
        
        func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
            return "Select your country"
        }
        
        func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
            return .hidden
        }
    }
    
    
    // MARK: - Custom Methods.
    extension VideoCallBookingViewController {
        func index(item:Int) {
            
            let project = projects[item]
            let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attrSet.title = project[0]
            //attrSet.contentDescription = project[1]
            attrSet.contentDescription = project[0]
            
            let item = CSSearchableItem(
                uniqueIdentifier: "\(item)",
                domainIdentifier: "kho.arthur",
                attributeSet: attrSet )
            
            CSSearchableIndex.default().indexSearchableItems( [item] )
            { error in
                
                if let error = error
                { print("Indexing error: \(error.localizedDescription)")
                }
                else
                { print("Search item successfully indexed.")
                }
            }
            
        }
        
        
        func deindex(item:Int) {
            
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"])
            { error in
                
                if let error = error
                { print("Deindexing error: \(error.localizedDescription)")
                }
                else
                { print("Search item successfully removed.")
                }
            }
        }
    }
    
    
    // MARK: - PickerView Methods.
    extension VideoCallBookingViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return durationList.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return  String(durationList[row])
            
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedDuration = durationList[row]
            self.txtCallDuration.text = String(selectedDuration ?? 0) + " minutes"
            selectedCoins = coinsList[row]
            self.lblCoins.text = String(selectedCoins ?? 0)
        }
        
        func createPickerView() {
            let pickerView = UIPickerView()
            pickerView.delegate = self
            self.txtCallDuration?.inputView = pickerView
            
            
        }
        
        
        func dismissPickerView() {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
             UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
            let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
            toolBar.setItems([button], animated: true)
            toolBar.isUserInteractionEnabled = true
            self.txtCallDuration.inputAccessoryView = toolBar
        }
        
        @objc func action() {
            view.endEditing(true)
        }
        
    }

