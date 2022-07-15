//
//  EmailForgotPasswordViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 22/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import AVFoundation

class EmailForgotPasswordViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    //@IBOutlet weak var emailtHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pageHeaderLabel: UILabel!
    
    @IBOutlet weak var eLabel: UILabel!
    
    
    
    var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailIDTextField.keyboardAppearance = .dark
        emailIDTextField.returnKeyType = UIReturnKeyType.done
        
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }
        self.emailIDTextField.isUserInteractionEnabled = true
        
        if self.isLogin {
            self.emailIDTextField.text = CustomerDetails.email
            self.emailIDTextField.isUserInteractionEnabled = false
         }
        
         self.navigationController?.navigationBar.isHidden = false
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                
                 //self.emailtHeight.constant = 160
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                
                
                
            case 2436:
                print("iPhone X")
                
                
            default:
                print("unknown")
            }
        }
        
//        self.navigationItem.title = "FORGOT PASSWORD"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
//        self.setNavigationView(title: "FORGOT PASSWORD")
        self.navigationItem.rightBarButtonItem = nil
        self.resetButton.layer.cornerRadius = 4
        self.resetButton.clipsToBounds = true
         self.navigationController?.navigationBar.isHidden = true
        emailIDTextField.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        eLabel.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        pageHeaderLabel.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
        resetButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 16.0)
        
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.pushAnimation()
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func resetPasswordAction(_ sender: Any) {
        
        if  !(emailIDTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            if !isValidEmail(testStr: emailIDTextField.text!) {
                self.showToast(message: "Please enter valid email address")
                return
            }

            if Reachability.isConnectedToNetwork()
            {
                CustomMoEngage.shared.sendEventUIComponent(componentName: "ForgotPassword_Reset", extraParamDict: nil)
                let dict = [ "email": emailIDTextField.text!,] as [String: Any]
                
                ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.FORGET_PASSWORD, extraHeader: nil) { (response) in
                    switch response {
                    case .success(let data):
                        print(data)
                        if data["error"].boolValue {
                            self.showToast(message: "Something went wrong, Please try again")
                             CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Forgot Password", status: "Failed", reason: "Email is not available", extraParamDict: nil)
                        } else {
                            if let message = data["message"].string {
                                CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Forgot Password", status: "Success", reason: "", extraParamDict: nil)
                                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                   
                                    self.navigationController?.popViewController(animated: true)
                                    
                                  }))
                                
                                
                                self.present(alert, animated: true, completion: nil)
//                                self.showToast(message: message)
                            }
                        }
                    case .failure(let error):
                        print(error)
                        self.showToast(message: "Something went wrong, Please try again")
                        CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Forgot Password", status: "Failed", reason: error.localizedDescription , extraParamDict: nil)
                    }
                }

                
            } else
            {
                self.showToast(message: Constants.NO_Internet_MSG)
                self.stopLoader()
            }
        } else {
            self.showToast(message: "Please enter your email address")
        }
        
     
       }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: Constants.emailIDAcceptedCharacter).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
}
//
//            PFUser.requestPasswordResetForEmail(inBackground: emailIDTextField, block: { (succ, error) in
//                if error == nil {
//                    self.showToast(message: "You will receive an email shortly with a link to reset your password")
//                }})

