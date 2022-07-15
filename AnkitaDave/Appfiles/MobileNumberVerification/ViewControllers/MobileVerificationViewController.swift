//
//  MobileVerificationViewController.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 12/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MobileVerificationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var txtContry: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var lblOTP: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var txtContryWidth: NSLayoutConstraint!
    
    // MARK: - Properties
    fileprivate var picker: UIPickerView = UIPickerView()
    fileprivate var arrCountries: [[String: String]] = [[String: String]]()
    fileprivate var mobileNumber: String = ""
    fileprivate let green = hexStringToUIColor(hex: "64AC28")
    fileprivate var timer: Timer?
    fileprivate var secondsRemaining = 30
    fileprivate var requestParameters: [String: Any] = [String: Any]()
    var isMandatory: Bool = false
    let indiaCountryCode = "+91"
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - IBActions
    @IBAction func didTapSubmitBotton(_ sender: UIButton) {
        
        switch sender.titleLabel?.text {
        case "GET OTP":
            handleBtnGetOTP()
        case "VERIFY":
            handleBtnVerify()
        default:
            break
        }
    }
    
    @IBAction func didTapEditBotton(_ sender: UIButton) {
        reset()
    }
    
    @IBAction func didTapResendBotton(_ sender: UIButton) {
        
        txtPhone.text = ""
        didCallRequestOTPAPI()
    }
    
    @IBAction func didTapCloseBotton(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Custom Methods
extension MobileVerificationViewController {
    
    fileprivate func setupView() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
        if let aCountries = NSArray(contentsOfFile: utility.application("countries.plist")) {
            arrCountries = aCountries as? [[String: String]] ?? []
        }
        
        if let mobNumber = txtPhone.text, mobNumber.count > 0 {
            underlineView.backgroundColor = green
            btnSubmit.backgroundColor = green
            btnSubmit.isUserInteractionEnabled = true
        } else {
            underlineView.backgroundColor = .darkGray
            btnSubmit.backgroundColor = .lightGray
            btnSubmit.isUserInteractionEnabled = false
        }
        
        btnClose.isHidden = isMandatory
        txtContry.tintColor = UIColor.clear
        txtContry.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        openKeyboard()
    }
    
    fileprivate func validateData() -> Bool {
        
        guard let contryCode = txtContry.text, contryCode.isNotEmpty else {
            DispatchQueue.main.async {
                utility.showToast(msg: "Please select contry code")
                self.txtContry.becomeFirstResponder()
            }
            return false
        }
        
        requestParameters = ["identity": "mobile",
                             "mobile_code": contryCode,
                             "activity": "verify"]
        
        if txtPhone.placeholder == "Enter OTP" {
            guard let otp = txtPhone.text, otp.isNotEmpty, otp.count == 6 else {
                DispatchQueue.main.async {
                    utility.showToast(msg: "Please enter valid OTP")
                }
                return false
            }
            
            requestParameters["mobile"] = mobileNumber
            requestParameters["otp"] = Int(otp)
        } else {
            mobileNumber = txtPhone.text ?? ""
            requestParameters["mobile"] = mobileNumber
        }
        
        return true
    }
    
    fileprivate func handleBtnGetOTP() {
       
        if validateData() {
            didCallRequestOTPAPI()
        }
        
    }
    
    fileprivate func handleBtnVerify() {
        
        if validateData() {
            timer?.invalidate()
            didCallVerifyOTPAPI()
        }
    }
    
    fileprivate func handleUI() {
        
        DispatchQueue.main.async {
            
            self.secondsRemaining = 30
            self.lblTimer.text = "Resend OTP in \(self.secondsRemaining) seconds"
            
            self.startTimer()
            
            UIView.transition(with: self.lblOTP, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.lblOTP.alpha = 1
            })
            
            UIView.transition(with: self.btnEdit, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.btnEdit.alpha = 1
            })
            
            UIView.transition(with: self.lblTimer, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.lblTimer.alpha = 1
            })
            
            UIView.transition(with: self.btnReset, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.btnReset.alpha = 0
            })
            
            self.lblOTP.text = "OTP sent to " + self.mobileNumber
            self.txtContryWidth.constant = 0
            self.imgDropDown.isHidden = true
            self.txtPhone.text = ""
            self.txtPhone.placeholder = "Enter OTP"
            self.underlineView.backgroundColor = .darkGray
            self.btnSubmit.backgroundColor = .lightGray
            self.btnSubmit.isUserInteractionEnabled = false
            self.btnSubmit.setTitle("VERIFY", for: .normal)
            self.openKeyboard()
        }
    }
    
    fileprivate func reset() {
        
        DispatchQueue.main.async {
            
            self.timer?.invalidate()
            
            UIView.transition(with: self.lblOTP, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.lblOTP.alpha = 0
            })
            
            UIView.transition(with: self.btnEdit, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.btnEdit.alpha = 0
            })
            
            UIView.transition(with: self.lblTimer, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.lblTimer.alpha = 0
            })
            
            UIView.transition(with: self.btnReset, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.btnReset.alpha = 0
            })
            
            self.lblOTP.text = ""
            self.txtContryWidth.constant = 54
            self.imgDropDown.isHidden = false
            self.txtPhone.text = self.mobileNumber
            self.txtPhone.placeholder = "Enter Mobile Number"
            self.underlineView.backgroundColor = self.green
            self.btnSubmit.backgroundColor = self.green
            self.btnSubmit.isUserInteractionEnabled = true
            self.btnSubmit.setTitle("GET OTP", for: .normal)
            self.secondsRemaining = 30
            self.lblTimer.text = "Resend OTP in \(self.secondsRemaining) seconds"
        }
    }
    
    fileprivate func startTimer() {
        
        DispatchQueue.main.async {
            
            self.timer?.invalidate()
            self.secondsRemaining = 30
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                if self.secondsRemaining > 0 {
                    self.secondsRemaining -= 1
                    self.lblTimer.text = "Resend OTP in \(self.secondsRemaining) seconds"
                } else {
                    self.timer?.invalidate()
                    UIView.transition(with: self.btnReset, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.btnReset.alpha = 1
                    })
                    UIView.transition(with: self.lblTimer, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.lblTimer.alpha = 0
                    })
                }
            }
        }
    }
    
    fileprivate func openKeyboard() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.txtPhone.becomeFirstResponder()
        }
    }
}

// MARK: - Web Services
extension MobileVerificationViewController {
    
    fileprivate func didCallRequestOTPAPI() {
        
        let headers: Dictionary<String, String> = ["Content-Type": "application/json",
                                                   "ApiKey": Constants.API_KEY,
                                                   "artistid": Constants.CELEB_ID,
                                                   "platform": Constants.PLATFORM_TYPE,
                                                   "Authorization": Constants.TOKEN]
        
        WebServiceHelper.shared.callPostMethod(endPoint: Constants.requestloginOTP, parameters: requestParameters, responseType: MobileNumberVerifyModel.self, showLoader: true, httpHeaders: headers) { [weak self] (response, error) in
            
            if let error = response?.error, error {
                
                var msg = "Something went wrong."
                
                if let messages = response?.error_messages, messages.count > 0 {
                    msg = messages[0]
                }
                
                Alert.show(in: self, title: "", message: msg, cancelTitle: nil, comletionForAction: nil)
                
            } else if let msg = response?.message {
                utility.showToast(msg: msg)
                self?.handleUI()
            } else {
                Alert.show(in: self, title: "", message: "Something went wrong.", cancelTitle: nil, comletionForAction: nil)
            }
        }
    }
    
    fileprivate func didCallVerifyOTPAPI() {
        
        let headers: Dictionary<String, String> = ["Content-Type": "application/json",
                                                   "ApiKey": Constants.API_KEY,
                                                   "artistid": Constants.CELEB_ID,
                                                   "platform": Constants.PLATFORM_TYPE,
                                                   "Authorization": Constants.TOKEN]
        
        WebServiceHelper.shared.callPostMethod(endPoint: Constants.mobileVerifyOTP, parameters: requestParameters, responseType: MobileNumberVerifyModel.self, showLoader: true, httpHeaders: headers) { [weak self] (response, error) in
            
            if let error = response?.error, error {
                
                var msg = "Something went wrong."
                
                if let messages = response?.error_messages, messages.count > 0 {
                    msg = messages[0]
                }
                
                DispatchQueue.main.async {
                    if let timer = self?.lblTimer {
                        UIView.transition(with: timer, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            timer.alpha = 0
                        })
                    }
                    
                    if let btn = self?.btnReset {
                        UIView.transition(with: btn, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            btn.alpha = 1
                        })
                    }
                }
                
                Alert.show(in: self, title: "", message: msg, cancelTitle: nil, comletionForAction: nil)
                
            } else if let msg = response?.message {
                
                CustomerDetails.mobileNumber = self?.mobileNumber
                CustomerDetails.mobile_verified = true
                UserDefaults.standard.set(true, forKey: "mobile_verified")
                UserDefaults.standard.synchronize()
                
                if let mobile = self?.mobileNumber {
                    DatabaseManager.sharedInstance.updateMobileNumber(mobileNumber: mobile)
                }
                
                utility.showToast(msg: msg)
                
                self?.view.endEditing(true)
                self?.dismiss(animated: true)
            } else {
                Alert.show(in: self, title: "", message: "Something went wrong.", cancelTitle: nil, comletionForAction: nil)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension MobileVerificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if txtContry.text == indiaCountryCode {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            let mininumDigits = txtPhone.placeholder == "Enter OTP" ? 6 : 9
            
            if string.isEmpty || Int(string) != nil {
                if newString.length > mininumDigits {
                    underlineView.backgroundColor = green
                    btnSubmit.backgroundColor = green
                    btnSubmit.isUserInteractionEnabled = true
                } else {
                    underlineView.backgroundColor = .darkGray
                    btnSubmit.backgroundColor = .lightGray
                    btnSubmit.isUserInteractionEnabled = false
                }
            }
            
            return string.isEmpty || Int(string) != nil
        }else {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if str.count == 0  {
                underlineView.backgroundColor = .darkGray
                btnSubmit.backgroundColor = .lightGray
                btnSubmit.isUserInteractionEnabled = false
            }else{
                underlineView.backgroundColor = green
                btnSubmit.backgroundColor = green
                btnSubmit.isUserInteractionEnabled = true
            }
            
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var index = 0
        switch textField {
        case txtContry:
            if let txt = txtContry.text {
                if getCodeIndex().contains(txt) {
                    index = getCodeIndex().firstIndex(of: txt) ?? 0
                }
                break
            }
            
        default:
            break
        }
        picker.reloadAllComponents()
        picker.selectRow(index, inComponent: 0, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let row = picker.selectedRow(inComponent: 0)
        switch textField {
        case txtContry:
            if arrCountries.count > 0 {
                txtContry.text = arrCountries[row]["dial_code"] ?? ""
            }
            break
        default:
            break
        }
    }
    
    func getCodeIndex() -> [String] {
        return arrCountries.map({$0["dial_code"] ?? ""})
    }
    

}

// MARK: - UIPickerViewDataSource
extension MobileVerificationViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCountries.count
    }
}

// MARK: - UIPickerViewDelegate
extension MobileVerificationViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCountries[row]["dial_code"] ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arrCountries.count > 0 {
            
            let isIndia = (txtContry.text == indiaCountryCode) ? true : false
            if isIndia == true {
            if txtPhone.text?.count == 10 {
                underlineView.backgroundColor = green
                btnSubmit.backgroundColor = green
                btnSubmit.isUserInteractionEnabled = true
            }else {
               
                underlineView.backgroundColor = .darkGray
                btnSubmit.backgroundColor = .lightGray
                btnSubmit.isUserInteractionEnabled = false
                                       
                }
            }else{
               
                underlineView.backgroundColor = green
                btnSubmit.backgroundColor = green
                btnSubmit.isUserInteractionEnabled = true
                      
            }
            txtContry.text = arrCountries[row]["dial_code"] ?? ""
        }
    }
}
