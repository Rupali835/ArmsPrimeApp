//
//  HelpAndSupportViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 13/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import MessageUI


class HelpAndSupportViewController: BaseViewController{
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var paymentIssueTitleLabel: UILabel!
    @IBOutlet weak var transctionIdHeight: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var transactionTextField: UITextField!
    @IBOutlet weak var txnIdTextField: UITextField!
    @IBOutlet weak var helpSupportTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!

    var PurchaseId = ""
    var isLogin = false
    var venderid = ""
    var vender = Bool()
    var captureType:String!
     var request: VideoCallRequest!
    @IBOutlet weak var faqButton: UIButton!
    
    @IBOutlet weak var termAndCondBtn: UIButton!
    var isFromTransDetails: Bool?
    var isFromShoutout: Bool = false
    var transID: String?
    var isSelectedVideoCall: Bool?

    @IBOutlet weak var screenBackView: UIView!
    @IBOutlet weak var dropDownImageView: UIImageView!
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
       
        paymentIssueTitleLabel.font = ShoutoutFont.regular.withSize(size: .small)
        callButton.setAttributedTitle(AppConstants.helpSupportPhoneNumber.underlinedAtrributed(font: ShoutoutFont.regular.withSize(size: .custom(12.0)), color: .white), for: .normal)
        emailButton.setAttributedTitle(AppConstants.helpSupportEmail.underlinedAtrributed(font: ShoutoutFont.regular.withSize(size: .custom(12.0)), color: .white), for: .normal)
        
        self.transctionIdHeight.constant = 0
        
        if vender == true {
            txnIdTextField.text = venderid
        } else {
            txnIdTextField.text = PurchaseId
        }
        
        if CustomerDetails.email != nil {
            self.emailTextField.text = CustomerDetails.email!
        }
        if CustomerDetails.firstName != nil{
            if CustomerDetails.lastName != nil {
                self.nameTextField.text = CustomerDetails.firstName! + " " + CustomerDetails.lastName
            } else {
                self.nameTextField.text = CustomerDetails.firstName!
            }
            
//            self.nameTextField.text = nameTextField.text?.uppercased()
        }
        
        self.navigationController?.isNavigationBarHidden = false
//        nameTextField.layer.cornerRadius = 5
        nameTextField.clipsToBounds = true
        nameTextField.isEnabled = false
//        self.nameTextField.layer.borderWidth = 1
//        self.nameTextField.layer.borderColor = UIColor.white.cgColor
//        self.nameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
//        emailTextField.layer.cornerRadius = 5
        emailTextField.clipsToBounds = true
        emailTextField.isEnabled = false
//        self.emailTextField.layer.borderWidth = 1
//        self.emailTextField.layer.borderColor = UIColor.white.cgColor
//        self.emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
//        transactionTextField.layer.cornerRadius = 5
        transactionTextField.clipsToBounds = true
        transactionTextField.isEnabled = false
        transactionTextField.text = "Select Subject"
//        self.transactionTextField.layer.borderWidth = 1
//        self.transactionTextField.layer.borderColor = UIColor.white.cgColor
        
//        txnIdTextField.layer.cornerRadius = 5
        txnIdTextField.clipsToBounds = true
        txnIdTextField.isEnabled = true
//        self.txnIdTextField.layer.borderWidth = 1
//        self.txnIdTextField.layer.borderColor = UIColor.white.cgColor
//        self.txnIdTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
//        helpSupportTextView.layer.cornerRadius = 5
        helpSupportTextView.clipsToBounds = true
//        self.helpSupportTextView.layer.borderWidth = 1
//        self.helpSupportTextView.layer.borderColor = UIColor.white.cgColor
        helpSupportTextView.delegate = self
        helpSupportTextView.text = "Write your message here..."
        helpSupportTextView.textColor = UIColor.white
//        self.helpSupportTextView.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        self.submitButton.layer.borderWidth = 1
        self.submitButton.layer.borderColor = UIColor.white.cgColor
        
//        self.navigationItem.title = "Help & Support"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setNavigationView(title: "Help & Support")
        
        DispatchQueue.main.async {
            
            self.screenBackView.setGradientBackground()
            
            self.nameTextField.underlined()
            self.emailTextField.underlined()
            self.transactionTextField.underlined()
            self.txnIdTextField.underlined()
            self.helpSupportTextView.underlined()
        }
        
        nameTextField.changePlaceholderColor(color: UIColor.white.withAlphaComponent(0.6))
        emailTextField.changePlaceholderColor(color: UIColor.white.withAlphaComponent(0.6))
        transactionTextField.changePlaceholderColor(color: UIColor.white.withAlphaComponent(0.6))
        txnIdTextField.changePlaceholderColor(color: UIColor.white.withAlphaComponent(0.6))
        
//       nameTextField.underlined()
        
        submitButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 16.0)
        faqButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 12.0)
        termAndCondBtn.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 12.0)
       
        nameTextField.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        emailTextField.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        transactionTextField.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        txnIdTextField.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        helpSupportTextView.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
       
        if isFromTransDetails != nil && isFromTransDetails! {
            self.transactionTextField.text = "  Transaction"
            self.captureType = "Transaction"
            self.transctionIdHeight.constant = 40
            self.txnIdTextField.isUserInteractionEnabled = false
            self.txnIdTextField.text = PurchaseId
            //            selectSubjectButton.isUserInteractionEnabled = false
        }
        
        if isFromShoutout {
            self.transactionTextField.text = "  Greeting"
            self.captureType = "Greeting"
            self.transctionIdHeight.constant = 40
            self.txnIdTextField.isUserInteractionEnabled = false
            self.txnIdTextField.text = PurchaseId
            self.dropDownImageView.isHidden = true
            //            selectSubjectButton.isUserInteractionEnabled = false
        }
        if isSelectedVideoCall != nil && isSelectedVideoCall! {
            self.transactionTextField.text = "  Video Call"
            self.captureType = "Video Call"
            self.transctionIdHeight.constant = 40
            self.txnIdTextField.isUserInteractionEnabled = false
            self.txnIdTextField.text = PurchaseId
            //            selectSubjectButton.isUserInteractionEnabled = false
        }
        
       
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GlobalFunctions.screenViewedRecorder(screenName: "Help & Support Screen")
        
    }
   
    func addCloseButton() {
        let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        //        button.backgroundColor = UIColor.black
        let image = UIImage(named: "closeIcon") as UIImage?
        button.frame = CGRect(x: 20, y: 75, width: 35, height: 35)
        //        button.layer.cornerRadius = button.frame.height/2
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(btnPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.isHidden = false
    }
    
    @objc func btnPressed(sender: UIButton!) {
        self.navigationController?.isNavigationBarHidden = false

        sender.isHidden = true
    }
    //MARK:- All button action
    @IBAction func selectedSubjectActionbutton(_ sender: Any) {
        
       
        if isFromShoutout { return }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "General", style: .default) { action in
            self.transactionTextField.text = "  General"
            self.captureType = "General"
            self.transctionIdHeight.constant = 0
             CustomMoEngage.shared.sendEventUIComponent(componentName: "Help&Support_Subject_General", extraParamDict: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Transaction", style: .default) { action in
            self.transactionTextField.text = "  Transaction"
            self.captureType = "Transaction"
            self.transctionIdHeight.constant = 40
            CustomMoEngage.shared.sendEventUIComponent(componentName: "Help&Support_Subject_Transaction", extraParamDict: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Greeting", style: .default) { action in
            self.transactionTextField.text = "  Greeting"
            self.captureType = "Greeting"
            self.transctionIdHeight.constant = 40
            CustomMoEngage.shared.sendEventUIComponent(componentName: "Help&Support_Subject_Greeting", extraParamDict: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Video Call", style: .default) { action in
            self.transactionTextField.text = "  Video Call"
            self.captureType = "Video Call"
            self.transctionIdHeight.constant = 40
            CustomMoEngage.shared.sendEventUIComponent(componentName: "Help&Support_Subject_VideoCall", extraParamDict: nil)
        })
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func faqButtonClickAction(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        resultViewController.navigationTitle = "FAQ's"
        resultViewController.openUrl = ArtistConfiguration.sharedInstance().static_url?.faqs ?? "http://www.armsprime.com/faqs.html"
        self.navigationController?.pushViewController(resultViewController, animated: true)
        
    }
    
    
    @IBAction func termsConditions(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        resultViewController.navigationTitle = "Terms & Conditions"
        resultViewController.openUrl = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ??  "http://www.armsprime.com/terms-conditions.html"
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    @IBAction func PostButtonAction(_ sender: Any) {
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            return
        }
        
        if helpSupportTextView.text == "Write your message here..." {
            showToast(message: "Description field must not be empty!")
            return
        }
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            } else {
                self.isLogin = false
            }
        } else {
            self.isLogin = false
        }
        if isLogin {
            CustomMoEngage.shared.sendEventUIComponent(componentName: "Help&Support_Submit", extraParamDict: nil)
            if let email = self.emailTextField.text, let name = self.nameTextField.text, let description = self.helpSupportTextView.text{
                
                if self.transactionTextField.text!.trimmingCharacters(in: .whitespaces).count == 0{
                    self.showToast(message: "Please select subject")
                    return
                }
                if self.transactionTextField.text == "Select Subject" {
                    self.showToast(message: "Please select subject")
                    return
                }
                
                if txnIdTextField.text!.trimmingCharacters(in: .whitespaces).count == 0 && self.captureType == "Transaction" {
                    self.showToast(message: "Please enter transaction Id")
                    return
                }
                
                if txnIdTextField.text!.trimmingCharacters(in: .whitespaces).count == 0 && self.captureType == "Greeting" {
                    self.showToast(message: "Please enter Greeting Id")
                    return
                }
                
                if self.captureType == "Transaction" || self.captureType == "Greeting" {
                    if txnIdTextField.text?.trimmingCharacters(in: .whitespaces).count != 0 {
                        self.PurchaseId = (txnIdTextField.text?.trimmingCharacters(in: .whitespaces))!
                    }
                }
                
            if !(helpSupportTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
              {
                let sv = UIViewController.displaySpinner(onView: self.view)
                if Reachability.isConnectedToNetwork()
                {
                    //
                 let params = ["email" : email , "name" : name ,"capture_type" : self.captureType, "description" : description, "order_id": self.PurchaseId, "artist_id" : Constants.CELEB_ID]
                    print(params)
                    ServerManager.sharedInstance().postRequest(postData: params, apiName: Constants.HELP_SUPPORT, extraHeader: nil, closure: { (result) in
                        switch result {
                        case .success(let data):
                            print(data)
                            if (data["error"] as? Bool == true) {
                                self.showToast(message: "Something went wrong. Please try again!")
                                let  payloadDict = NSMutableDictionary()
                                 payloadDict.setObject(self.captureType, forKey: "capture_type" as NSCopying)
                                payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                                payloadDict.setObject(self.PurchaseId, forKey: "order_id" as NSCopying)
                                CustomMoEngage.shared.sendEvent(eventType: MoEventType.helpNSupport, action: "sendRequest", status: "Failed", reason:  "error occured", extraParamDict: payloadDict)
                                return
                               
                            } else if let message = data["message"].string{
                                let  payloadDict = NSMutableDictionary()
                                payloadDict.setObject(self.captureType, forKey: "capture_type" as NSCopying)
                                payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                                payloadDict.setObject(self.PurchaseId, forKey: "order_id" as NSCopying)
                                CustomMoEngage.shared.sendEvent(eventType: MoEventType.helpNSupport, action: "sendRequest", status: "Success", reason:  "error occured", extraParamDict: payloadDict)
                            let alert = UIAlertController(title: "Alert", message :message , preferredStyle: .alert)
//                                "Your report is submitted successfully."
                                
                            let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (alert) in
                                
                                self.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            } else {
                                let alert = UIAlertController(title: "Alert", message :"Your report is submitted successfully.", preferredStyle: .alert)
                             
                                let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (alert) in
                                    
                                    self.navigationController?.popViewController(animated: true)
                                })
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                            break;
                        case .failure(let error):
                            UIViewController.removeSpinner(spinner: sv)
                            print(error)
                            let  payloadDict = NSMutableDictionary()
                            payloadDict.setObject(self.captureType, forKey: "capture_type" as NSCopying)
                            payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                            payloadDict.setObject(self.PurchaseId, forKey: "order_id" as NSCopying)
                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.helpNSupport, action: "sendRequest", status: "Failed", reason:  error.localizedDescription, extraParamDict: payloadDict)
                        }
                    })
                   
                } else
                {
                    UIViewController.removeSpinner(spinner: sv)
                    self.showToast(message: Constants.NO_Internet_MSG)
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.helpNSupport, action: "sendRequest", status: "Failed", reason:  Constants.NO_Internet_MSG, extraParamDict: nil)
                }
            } else {
                showToast(message: "Description field must not be empty!")
                }
            }
        } else {
            showToast(message: "Please Login to submit the Question.")
        }


    }
    
    @IBAction func didTapCallButton(_ sender: UIButton) {
        ShoutoutUtilities.callNumber(phoneNumber: AppConstants.helpSupportPhoneNumber)
    }
    
    @IBAction func didTapEmailButton(_ sender: UIButton) {
//        ShoutoutUtilities.sendEmail(receipients: [AppConstants.helpSupportEmail], subject: "", inViewController: self, delegate: self)
        if let url = URL(string: "mailto:info@armsprime.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 10, y: self.view.frame.size.height-120, width: self.view.frame.size.width - 20, height: 35))
        //        let toastLabel = UILabel(frame: CGRect(x: 10, y: 350, width: self.view.frame.size.width - 20, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
    }
  
}
//MARK:- UITextViewDelegate
extension HelpAndSupportViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if helpSupportTextView.text == "Write your message here..." {
            helpSupportTextView.text = ""
            helpSupportTextView.textColor = UIColor.white.withAlphaComponent(0.6)
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if helpSupportTextView.text == "" {
            
            helpSupportTextView.text = "Write your message here..."
            helpSupportTextView.textColor = UIColor.white.withAlphaComponent(0.6)
        }
    }
}

//MARK:- UITextFieldDelegate
extension HelpAndSupportViewController: UITextFieldDelegate{
    
}

extension HelpAndSupportViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
