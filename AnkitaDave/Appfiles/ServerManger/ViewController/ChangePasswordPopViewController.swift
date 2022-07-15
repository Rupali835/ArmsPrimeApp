//
//  ChangePasswordPopViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 22/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit


class ChangePasswordPopViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var popUiView: UIView!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    
    var iconClick : Bool!
    @IBOutlet weak var hideOrshowButton: UIButton!
    @IBOutlet weak var newhideOrshowButton: UIButton!
    @IBOutlet weak var confirmhideOrshowButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.removeGradient()
        
        self.changePasswordButton.layer.cornerRadius = 5
        self.changePasswordButton.clipsToBounds = true
        
        self.popUiView.layer.cornerRadius = 5
        self.popUiView.clipsToBounds = true
        
        self.showAnimate()
         oldPasswordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
         newPasswordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
         confirmPasswordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textDidChange(textField: UITextField) {
        if  self.oldPasswordTextField.isSecureTextEntry {
            self.hideOrshowButton.setImage(UIImage.init(named: "eyeIcon"), for: .normal)
        } else {
            self.hideOrshowButton.setImage(UIImage.init(named: "eye"), for: .normal)
        }
        
        if  self.newPasswordTextField.isSecureTextEntry {
            self.newhideOrshowButton.setImage(UIImage.init(named: "eyeIcon"), for: .normal)
        } else {
            self.newhideOrshowButton.setImage(UIImage.init(named: "eye"), for: .normal)
        }
        
        if  self.confirmPasswordTextField.isSecureTextEntry {
            self.confirmhideOrshowButton.setImage(UIImage.init(named: "eyeIcon"), for: .normal)
        } else {
            self.confirmhideOrshowButton.setImage(UIImage.init(named: "eye"), for: .normal)
        }
    }
    
    @IBAction func newPasswordiconAction(_ sender: Any) {
        if !(newPasswordTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            if (iconClick == true) {
                self.newPasswordTextField.isSecureTextEntry = false
                iconClick = false
//                self.newhideOrshowButton.setTitle("Hide", for: .normal)
                self.newhideOrshowButton.setImage(UIImage.init(named: "eye"), for: .normal)
            } else {
                self.newPasswordTextField.isSecureTextEntry = true
                iconClick = true
//                self.newhideOrshowButton.setTitle("Show", for: .normal)
                self.newhideOrshowButton.setImage(UIImage.init(named: "eyeIcon"), for: .normal)
                
            }
        } else {
            showToast(message: "Please enter password")
        }
        
    }
    
    @IBAction func confirmPasswordiconAction(_ sender: Any) {
        if !(confirmPasswordTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            if (iconClick == true) {
                self.confirmPasswordTextField.isSecureTextEntry = false
                iconClick = false
//                self.confirmhideOrshowButton.setTitle("Hide", for: .normal)
                self.confirmhideOrshowButton.setImage(UIImage.init(named: "eye"), for: .normal)
            } else {
                self.confirmPasswordTextField.isSecureTextEntry = true
                iconClick = true
//                self.confirmhideOrshowButton.setTitle("Show", for: .normal)
                self.confirmhideOrshowButton.setImage(UIImage.init(named: "eyeIcon"), for: .normal)
                
            }
        } else {
            showToast(message: "Please enter password")
        }
        
    }
    
    @IBAction func oldPasswordiconAction(_ sender: Any) {
        if !(oldPasswordTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            if (iconClick == true) {
                self.oldPasswordTextField.isSecureTextEntry = false
                iconClick = false
//                self.hideOrshowButton.setTitle("Hide", for: .normal)
                self.hideOrshowButton.setImage(UIImage.init(named: "eye"), for: .normal)
            } else {
                self.oldPasswordTextField.isSecureTextEntry = true
                iconClick = true
//                self.hideOrshowButton.setTitle("Show", for: .normal)
                self.hideOrshowButton.setImage(UIImage.init(named: "eyeIcon"), for: .normal)
                
            }
        } else {
            showToast(message: "Please enter password")
        }

    }
    
  
    @IBAction func changePassword(_ sender: UIButton) {
        //        if (!(oldPasswordTextField.text?.isEmpty)! && !(newPasswordTextField.text?.isEmpty)! && !(confirmPasswordTextField.text?.isEmpty)!)
        //        {
        //            if newPasswordTextField.text == confirmPasswordTextField.text
        //            {
        if validation() {
            if Reachability.isConnectedToNetwork()
            {
                
                let dict = [ "email": CustomerDetails.email,"old_password":oldPasswordTextField.text,"new_password":newPasswordTextField.text] as [String: Any]
                
                ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.CHANGE_PASSWORD, extraHeader: nil) { (response) in
                    switch response {
                    case .success(let data):
                        print(data)
                        /*
                         {
                         "status_code" : 200,
                         "message" : "New password cannot be same as old password",
                         "data" : null,
                         "error" : false
                         }
                         */
                        if data["status_code"] == 200 {
                            if data["error"].boolValue {
                                self.showToast(message: "Something went wrong, Please try again")
                                CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Change Password", status: "Failed", reason:"\(data["error"])", extraParamDict: nil)
                            } else {
                                CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Change Password", status: "Success", reason:"reset new password", extraParamDict: nil)
                            }
                        } else {
                            self.showToast(message: "Something went wrong, Please try again")
                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Change Password", status: "Failed", reason:"\(data["error"])", extraParamDict: nil)
                        }
                        
                        if let message = data["message"].string {
                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Change Password", status: "Success", reason:"reset new password", extraParamDict: nil)
                            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    case .failure(let error):
                        print(error)
                        CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Change Password", status: "Failed", reason:error.localizedDescription, extraParamDict: nil)
                        self.showToast(message: "Something went wrong, Please try again")
                    }
                }
                
            } else {
                self.showToast(message: Constants.NO_Internet_MSG)
                CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Change Password", status: "Failed", reason:Constants.NO_Internet_MSG, extraParamDict: nil)
            }
        }
        
        //            } else {
        //                showToast(message: "Please enter correct Password")
        //               }
        //            } else {
        //            showToast(message: "Please enter correct Info")
        //         }
        
    }
    func validation() -> Bool {
        if oldPasswordTextField.text!.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showToast(message: "Please enter old password")
            return false
        } else if newPasswordTextField.text!.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showToast(message: "Please enter new password")
            return false
        } else if !GlobalFunctions.checkPasswordIsInCorrectFormat(pwd: newPasswordTextField.text!) {
            self.showToast(message: "Your new password should be a minimum of 8 characters with at least 1 number and 1 special character.")
            return false
        } else if confirmPasswordTextField.text!.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showToast(message: "Please enter confirm password")
            return false
        } else if newPasswordTextField.text != confirmPasswordTextField.text {
            self.showToast(message: "New password and confirm password should be same")
            return false
        } else if !GlobalFunctions.checkPasswordIsInCorrectFormat(pwd: confirmPasswordTextField.text!) {
            self.showToast(message: "Your new password should be a minimum of 8 characters with at least 1 number and 1 special character.")
            return false
        }
        
        return true
    }
     @IBAction func forgetPassword(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc : EmailForgotPasswordViewController = storyboard.instantiateViewController(withIdentifier: "EmailForgotPasswordViewController") as! EmailForgotPasswordViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func closeButtonPress(_ sender: Any) {
       self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

}
