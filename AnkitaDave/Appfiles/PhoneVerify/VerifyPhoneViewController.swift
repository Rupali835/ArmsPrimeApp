//
//  VerifyPhoneViewController.swift
//  Desiplex
//
//  Created by developer2 on 15/06/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit
import CountryPickerView

class VerifyPhoneViewController: UIViewController {

    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblCountryCode: UILabel!
    var countryPicker: CountryPickerView? = nil
  
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setLayoutAndDesign()
    }

    override func viewWillAppear(_ animated: Bool) {
       
    }
}

// MARK: - IBActions
extension VerifyPhoneViewController {
    
    @IBAction func btnCountryCodeClicked() {
        
        self.view.endEditing(true)
        
        showCountryPicker()
    }
    
    @IBAction func btnNextClicked() {
        
        self.view.endEditing(true)
        
        if !isValidFormData() {
            
            return
        }
        
        webSendOTP()
    }
}

// MARK: - Utility Methods
extension VerifyPhoneViewController {
    
    func setLayoutAndDesign() {
        view.backgroundColor = .black
        self.navigationItem.title = ""
        
        txtPhone.setAttributedPlaceholder(text: stringConstants.enterPhone, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.7)])
        
        btnNext.corner = appearences.cornerRadius
        
        btnNext.glowEffect = true
    }
    
    func isValidFormData() -> Bool {
        
        let str = txtPhone.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if str?.count == 0 {
            
            utility.alert(message: stringConstants.errEmptyPhoneNumber, delegate: self, cancel: nil, completion: nil)
            return false
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

// MARK: - Navigations
extension VerifyPhoneViewController {
    
    func gotoVerifyOTPScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifyOTPVC : VerifyOTPViewController = storyboard.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
        
        verifyOTPVC.phone = txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        verifyOTPVC.countryCode = lblCountryCode.text
        
        verifyOTPVC.type = .phone
        
        verifyOTPVC.activityType = .verify
        
        self.navigationController?.pushViewController(verifyOTPVC, animated: true)
    }
}

// MARK: - TextField Delegate Methods
extension VerifyPhoneViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        do {
            
            let pattern = RegularExpression.phone.rawValue
            
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

// MARK: - Country Picker Delegate & DataSource Methods
extension VerifyPhoneViewController: CountryPickerViewDelegate, CountryPickerViewDataSource {
    
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
    }
}

// MARK: - Web Service Methods
extension VerifyPhoneViewController {
    
    func webSendOTP() {
        
        let api = Constants.requestloginOTP
        
        var dictParams = [String: Any]()
        
        dictParams["activity"] = VerifyOTPActivityType.verify.rawValue
        dictParams["identity"] = VerifyOTPType.phone.rawValue
        
        let strPhone = txtPhone.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if let mobile = strPhone {
            
            dictParams["mobile"] = mobile
        }
        
        if let phoneCode = lblCountryCode.text {
            
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
