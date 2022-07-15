//
//  LiveFeedbackViewController.swift
//  HotShot
//
//  Created by developer2 on 31/07/19.
//  Copyright © 2019 com.armsprime.hotshot. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView

class LiveFeedbackViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var imgViewEventPic: UIImageView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var viewContainerForm: UIView!
    @IBOutlet weak var scrViewContainerForm: UIScrollView!
    @IBOutlet weak var rateView: HCSStarRatingView!
    @IBOutlet weak var txtViewFeedback: UITextView!
    
    var eventDetails: LiveEventModel? = nil
    var loaderIndicator: NVActivityIndicatorView!
    fileprivate let messagePlaceholder: String = "Type your feedback here.."
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutDetails()
        setEventDetails()
        setLoader()
    }
    
    // MARK: - IBActions
    @IBAction func btnCloseClicked() {
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    func setLoader() {
        loaderIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loaderIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        loaderIndicator.type = .ballTrianglePath // add your type
        loaderIndicator.color =  UIColor.white
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
    @IBAction func btnSubmitClicked() {
        
        self.view.endEditing(true)
        
        if !isValideFormData() {
            
            return
        }
        
        submitFeedbackToServer()
    }
    
    // MARK: - Utility Methods
    func setLayoutDetails() {
        
        viewContainerForm.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: viewContainerForm.frame.size.height)
        scrViewContainerForm.contentSize = viewContainerForm.frame.size
        scrViewContainerForm.addSubview(viewContainerForm)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        let str = "Type your feedback here.."
        txtViewFeedback.delegate = self
        txtViewFeedback.text = messagePlaceholder
        txtViewFeedback.textColor = .lightGray
        
        txtViewFeedback.layer.borderColor = UIColor.white.cgColor
        txtViewFeedback.layer.borderWidth = 0.5
        txtViewFeedback.layer.cornerRadius = 4.0
        txtViewFeedback.layer.masksToBounds = true
        
        imgViewEventPic.layer.cornerRadius = imgViewEventPic.frame.size.height/2
        imgViewEventPic.layer.borderWidth = 0.5
        imgViewEventPic.layer.borderColor = UIColor.white.cgColor
        imgViewEventPic.contentMode = .scaleAspectFill
        imgViewEventPic.clipsToBounds = true
        imgViewEventPic.layer.masksToBounds = true
    }
    
    func setEventDetails() {
        if let event = self.eventDetails {
            
            if let photo = event.photo {
                
                if let small = photo.small {
                    
                    imgViewEventPic.sd_setImage(with: URL(string: small), completed: nil)
                }
            } else {
                imgViewEventPic.image = UIImage(named: "celebrityProfileDP")
            }
            
            if let name = event.name {
                
                lblEventName.text = name
            } else {
                lblEventName.text = Constants.celebrityName
            }
        } else {
             imgViewEventPic.image = UIImage(named: "celebrityProfileDP")
             lblEventName.text = Constants.celebrityName
        }
    }
    
    func isValideFormData() -> Bool {
        
        if rateView.value == 0.0 {
            
            showOnlyAlert(title: "Error", message: "Please give rating.")
            return false
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == messagePlaceholder {
            textView.text = ""
            textView.textColor = UIColor.white
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = messagePlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - Web Service Methods
extension LiveFeedbackViewController {
    
    func submitFeedbackToServer() {
        
        var apiName = ""
        var dict : [String : Any] = ["":""]
        var feedback: String = txtViewFeedback.backgroundColor == .black ? txtViewFeedback.text : ""
        if eventDetails != nil {
            apiName = Constants.WEB_FEEDBACK_LIVE
           dict = ["artist_id": Constants.CELEB_ID, "entity_id": self.eventDetails?.id ?? "", "platform": Constants.PLATFORM_TYPE, "ratings": Int(rateView.value), "feedback": feedback.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"v":Constants.appVersion] as [String : Any]
        } else {
            apiName = Constants.general_feedback
             dict = ["artist_id": Constants.CELEB_ID, "platform": Constants.PLATFORM_TYPE, "ratings": Int(rateView.value), "feedback": txtViewFeedback.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),"v":Constants.appVersion] as [String : Any]
        }
       
        if Reachability.isConnectedToNetwork() {
            
            self.showLoader()
            
           ServerManager.sharedInstance().postRequest(postData: dict, apiName: apiName, extraHeader: nil) { (result) in
 
                DispatchQueue.main.async {
                    
                   self.stopLoader()
                    
                    switch result {
                    case .success(let data):
                        
                        print(data)
                        
                        var message = "Your feedback has been posted."

                        if let dictObj = data.dictionaryObject {
                            
                            if let msg = dictObj["message"] as? String {
                                
                                message = msg
                            }
                        }
                        
                        self.showOnlyAlert(title: "", message: message, completion: {
                            
                            self.btnCloseClicked()
                        })
                        
                    case .failure(let error):
                        print(error)
                        
                        self.showOnlyAlert(title: "Error", message: "Oops! Something went wrong. Please try again!")
                    }
                }
            }
        }
        else
        {
            self.showOnlyAlert(title: "", message: Constants.NO_Internet_MSG)
            return
        }
    }
}
