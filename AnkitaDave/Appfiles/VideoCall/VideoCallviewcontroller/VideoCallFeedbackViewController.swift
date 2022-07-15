//
//  VideoCallFeedbackViewController.swift
//  Multiplex
//
//  Created by Parikshit on 24/10/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit
import HCSStarRatingView

class VideoCallFeedbackViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnNotNow: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewRate: HCSStarRatingView!
    var request: VGShoutout!
    //var request: ShoutoutRequestDetails! // SHRIRAM
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLayoutAndDesigns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        setStatusBarStyle(isBlack: false)
    }
}

// MARK: - IBActions
extension VideoCallFeedbackViewController {

    @IBAction func btnNotNowClicked() {
        
        self.view.endEditing(true)
        
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSubmitClicked() {
        
        self.view.endEditing(true)
        
        if !isValideFormData() {
            
            return
        }
        
        webSubmitFeedback()
    }
}

// MARK: - Utility Methods
extension VideoCallFeedbackViewController {
    
    func setLayoutAndDesigns() {
        
        viewContainer.corner = 8.0
        btnNotNow.corner = 8.0
        btnSubmit.corner = 8.0
        
        btnNotNow.backgroundColor = .clear
        btnNotNow.borderColor = appearences.yellowColor
        btnNotNow.setTitleColor(appearences.yellowColor, for: .normal)
        btnNotNow.borderWidth = 0.6
        
        self.view.backgroundColor = appearences.newIndigoColor
        
        btnSubmit.backgroundColor = appearences.yellowColor
    }
    
    func isValideFormData() -> Bool {
        
        if viewRate.value == 0.0 {
            
           // utility.showToast(msg: stringConstants.errEmptyRating)
            utility.showToast(msg:stringConstants.errEmptyRating)
            
            return false
        }
        
        return true
    }
}

// MARK: - Web Service Methods
extension VideoCallFeedbackViewController {
    
    func webSubmitFeedback() {
        
        var dictParams = [String:Any]()
        
        dictParams["product"] = Constants.product
        dictParams["ratings"] = Int(viewRate.value)
        dictParams["entity_id"] = request._id
        dictParams["artist_id"] = Constants.CELEB_ID//request.artist_id
    
        
        //let api = webConstants.videoCallFeedback
        let api = Constants.videoCallFeedback
       // let web = WebService(showInternetProblem: true, isCloud: false, loaderView: self.view)
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
     
        web.shouldPrintLog = true
                
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { [weak self] (status, msg, dict) in
                        
            if status {
                
                guard let dictRes = dict else {
                    
                    utility.showToast(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {

                    if let arrErrors = dictRes["error_messages"] as? [String] {

                        utility.showToast(msg: arrErrors[0])
                    }
                    else {
                            
                        utility.showToast(msg: stringConstants.errSomethingWentWrong)
                    }
                    
                    return
                }
                
                guard let msg = dictRes["message"] as? String else {
                                 
                    utility.showToast(msg: stringConstants.msgLiveFeedbackSuccess)
                    
                    return
                }
                
                utility.showToast(msg: msg, delay: 0, duration: 2.0, bottom: 80)
                
                self?.btnNotNowClicked()
            }
            else {
                
                utility.showToast(msg: msg!)
            }
        }
    }
}
