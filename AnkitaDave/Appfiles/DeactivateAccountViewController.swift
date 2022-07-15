//
//  DeactivateAccountViewController.swift
//  HarsimranKaur
//
//  Created by Apple on 21/10/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import MoEngage
import NVActivityIndicatorView

class DeactivateAccountViewController: UIViewController, UITextViewDelegate {
    // MARK: - Constants.
    
    // MARK: - Properties.
    var loaderIndicator: NVActivityIndicatorView!
    fileprivate let messagePlaceholder: String = "Please let us know why you want to deactivate your account"
    
    // MARK: - IBOutlets.
    @IBOutlet weak var deactivateTitleLabel: UILabel!
    @IBOutlet weak var instructionOneLabel: UILabel!
    @IBOutlet weak var instructionTwoLabel: UILabel!
    @IBOutlet weak var instructionThreeLabel: UILabel!
    @IBOutlet weak var instructionFourLabel: UILabel!
    @IBOutlet weak var instructionFiveLabel: UILabel!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var deactivateButton: UIButton!
    
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
        setLoader()
    }
    
    // MARK: - IBActions.
    @IBAction func didTapDeactivateButton(_ sender: UIButton) {
        if checkValidation() {
             showConfirmationAlert()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == messagePlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = messagePlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - Custom Methods.
extension DeactivateAccountViewController {
    fileprivate func setupView() {
        
        title = "Deactivate Account"
        deactivateTitleLabel.font = UIFont(name: AppFont.bold.rawValue, size: 14.0)//ShoutoutFont.bold.withSize(size: .largeTitle)
        [instructionOneLabel, instructionTwoLabel, instructionThreeLabel, instructionFourLabel, instructionFiveLabel].forEach { (label) in
            label?.font = UIFont(name: AppFont.light.rawValue, size: 14.0)//ShoutoutFont.light.withSize(size: .small)
            label?.textColor = .white
        }
        reasonTextView.font =  UIFont(name: AppFont.light.rawValue, size: 14.0)//ShoutoutFont.light.withSize(size: .small)
        deactivateButton.titleLabel?.font =  UIFont(name: AppFont.regular.rawValue, size: 16.0)//ShoutoutFont.bold.withSize(size: .medium)
        deactivateButton.backgroundColor = .white
        deactivateTitleLabel.textColor = .white
        reasonTextView.delegate = self
        reasonTextView.text = messagePlaceholder
        self.view.setGradientBackground()
        
    }
    //MARK:- Loader
    func setLoader() {
        loaderIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loaderIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        loaderIndicator.type = .ballTrianglePath // add your type
        loaderIndicator.color = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        self.view.addSubview(loaderIndicator)
        
    }

    func showLoader() {
        self.loaderIndicator.startAnimating()
    }
    func stopLoader()  {
        DispatchQueue.main.async {
            self.loaderIndicator.stopAnimating()
            
        }
        
    }
    func showConfirmationAlert() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to deactivate your account?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Deactivate", style: .destructive) { action in
            self.callDeActiveAccAPI()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            CustomMoEngage.shared.sendEventDialog("Are you sure you want to deactivate your account?", "Cancel", nil)
        })
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    func checkValidation() -> Bool {
        if reasonTextView.text == messagePlaceholder {
            self.showOnlyAlert(title: "", message: messagePlaceholder)
            return false
        }
        return true
    }
    fileprivate func logout() {
            CustomMoEngage.shared.sendEventDialog("Are you sure you want to deactivate your account?", "Deactivate Account", nil)
            UserDefaults.standard.set("LoginSessionOut", forKey: "LoginSession")
            UserDefaults.standard.set("", forKey: "logintype")
            UserDefaults.standard.synchronize()
            ShoutoutConfig.UserDefaultsManager.clearShoutoutUserData()
            Constants.TOKEN = ""
            CustomerDetails.custId = ""
            CustomerDetails.account_link = [:]
            CustomerDetails.badges = ""
            CustomerDetails.coins = 0
            CustomerDetails.email = ""
            CustomerDetails.firstName = nil
            CustomerDetails.lastName = nil
            CustomerDetails.token = ""
            CustomerDetails.picture = ""
            CustomerDetails.gender = ""
            CustomerDetails.mobileNumber = ""
            CustomerDetails.mobile_verified = false
            UserDefaults.standard.set(false, forKey: "mobile_verified")
            UserDefaults.standard.synchronize()
            GIDSignIn.sharedInstance().signOut()
            AccessToken.current = nil
            Profile.current = nil
            LoginManager().logOut()
            
            let database = DatabaseManager.sharedInstance
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let writePath  = documents +  "/ConsumerDatabase.sqlite"
            database.dbPath = writePath
            /* if let dbURL = GlobalFunctions.createDatabaseUrlPath() {
             database.dbPath = dbURL.path
             }*/
            database.deleteAllData()
            UserDefaults.standard.set(1, forKey: "userFanLevel")
            UserDefaults.standard.synchronize()
            CustomMoEngage.shared.sendEvent(eventType: MoEventType.logOut, action: "Log Out", status: "Success", reason: "", extraParamDict: nil)
            CustomMoEngage.shared.setMoReLogginUserAttributes(re_loggedin: true)
            CustomMoEngage.shared.resetMoUserInfo()
            //                            Branch.getInstance().logout()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if #available(iOS 11.0, *) {
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                //                    self.toast(message: "successfully logged out", duration: 5)
                self.navigationController?.pushViewController(resultViewController, animated: false)
            } else {
                // Fallback on earlier versions
            }
    }
}

// MARK: - Web Services.
extension DeactivateAccountViewController {
    func callDeActiveAccAPI()  {
            guard let reason = reasonTextView.text,
            let customerId = CustomerDetails.custId else { return }
            
            let parameters: [String: Any] = ["reason": reason,
                                             "artist_id": Constants.CELEB_ID,
                                             "customer_id": customerId,
                                             "platform": Constants.PLATFORM_TYPE,
                                             "v": Constants.VERSION]
            
            DispatchQueue.main.async { [weak self] in
                self?.showLoader()
                self?.deactivateButton.isEnabled = false
                self?.deactivateButton.alpha = 0.5
            }
            
            WebService.shared.callPostMethod(endPoint: .customerDeactivate, parameters: parameters, responseType: DeactivateAccountModel.self, showLoader: false) { [weak self] (response, error) in
                
                DispatchQueue.main.async { [weak self] in
                    self?.stopLoader()
                    self?.deactivateButton.isEnabled = true
                    self?.deactivateButton.alpha = 1.0
                }
                
                if let message = response?.message {
                    let shouldAutoDissmissAlert: Bool = response?.error == false ? true : false
                    let displayMessage: String = response?.error == false ? "Your Armsprime account has been successfully deactivated now. For any further information please contact info@armsprime.com." : message
                    Alert.show(in: self, title: "", message: displayMessage, cancelTitle: nil, autoDismiss: shouldAutoDissmissAlert) { action in
                        if response?.error == false {
                            self?.logout()
                        }
                    }
                } else {
                    if let internetError = error as? WebServiceError, internetError == .internetError {
                        return
                    }
                    Alert.show(in: self, title: "", message: "Oops! Something went wrong. Please try again!", cancelTitle: nil, comletionForAction: nil)
                }
            }
    }
}
