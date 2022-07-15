//
//  SendCallRequestViewController.swift
//  Archana Gautam
//
//  Created by developer2 on 11/04/20.
//  Copyright © 2020 ArmsprimeMedia. All rights reserved.
//

import UIKit
import SwiftMessages
import ActiveLabel

class SwiftMessagesBottomCardSegue: SwiftMessagesSegue {
    
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        
        if let liveVC = source as? LiveOverlayViewController, let callRequestVC = destination as? SendCallRequestViewController {
            
            callRequestVC.delegate = liveVC
            
            callRequestVC.liveEvent = liveVC.liveController?.liveEvent
            
            super.init(identifier: identifier, source: liveVC, destination: callRequestVC)
                        
            configure(layout: .bottomCard)
        }
        else {
            
            super.init(identifier: identifier, source: source, destination: destination)
        }
    }
}

protocol SendCallRequestDelegate: NSObject {
    
    func sendRequestWith(type: AgoraRTMConnection.commercialType, requestId: String)
    func didSelectedTermsConditions()
    func didSelectedPrivacyPolicy()
    func didFoundLowBalance()
}

class SendCallRequestViewController: BaseViewController {
    
    @IBOutlet weak var imgViewProfilePic: UIImageView!
    @IBOutlet weak var imgViewCelebProfilePic: UIImageView!
    @IBOutlet weak var btnPaid: UIButton!
    @IBOutlet weak var btnFree: UIButton!
    @IBOutlet weak var btnSendRequest: UIButton!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var lblTerms: ActiveLabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDurationDetails: UILabel!
    @IBOutlet weak var cnstAnyOneLabelTop: NSLayoutConstraint!
    
    var liveEvent: LiveEventModel? = nil
    
    weak var delegate: SendCallRequestDelegate? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setLayoutAndDesign()
    }
}

// MARK: - IBActions
extension SendCallRequestViewController {
    
    @IBAction func btnPaidClicked(sender: UIButton) {
        
        btnPaid.isSelected = true
        btnFree.isSelected = false
    }
    
    @IBAction func btnFreeClicked(sender: UIButton) {
        
        btnPaid.isSelected = false
        btnFree.isSelected = true
    }
    
    @IBAction func btnSendRequestClicked(sender: UIButton) {
        
//        let requestCoins = ArtistConfiguration.sharedInstance().oneToOne?.coins ?? 0
//
//        if let currentCoins = CustomerDetails.coins, currentCoins >= requestCoins  {
//
//            webSendCallRequest { [weak self] (requestId) in
//
//                if let reqId = requestId {
//
//                    self?.sendInvitation(id: reqId)
//                }
//            }
//        }
//        else {
//
//            self.showToast(message: "Not Enough coins please recharge")
//        }
        
        let coins = ArtistConfiguration.sharedInstance().oneToOne?.coins ?? 0
        
        if isBalanceAvailable(Int(coins)) {
            
            webSendCallRequest { [weak self] (requestId) in
                
                if let reqId = requestId {
                    
                    self?.sendInvitation(id: reqId)
                }
            }
        }
        else {
            
            dismiss(animated: true) {
                
                self.delegate?.didFoundLowBalance()
            }
        }
    }
    
    @IBAction func btnCancelClicked() {
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Utility Methods
extension SendCallRequestViewController {
    
    func setLayoutAndDesign() {
        
        self.view.tag = -100
        
        btnPaid?.isSelected = true
        
        btnSendRequest.cornerRadius = 4.0
        
        setDetails()
        
        setTermLabel()
        
        lblTitle.text = "Request to be in \(ArtistConfiguration.sharedInstance().first_name ?? "Celeb")'s Live Broadcasting."
        
        if let imgURL = CustomerDetails.picture, imgURL.count > 0 {
            
            imgViewProfilePic.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "profile_placeholder_small"), options: .highPriority, context: [:])
        }
        else {
            
            imgViewProfilePic.image = UIImage(named: "profile_placeholder_small")
        }
        
        if let imgURL = ArtistConfiguration.sharedInstance().photo, imgURL.count > 0 {
            
            imgViewCelebProfilePic.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "profile_placeholder_small"), options: .highPriority, context: [:])
        }
        else {
            
            imgViewCelebProfilePic.image = UIImage(named: "profile_placeholder_small")
        }
        
        imgViewProfilePic.makeCirculaer = true
        imgViewCelebProfilePic.makeCirculaer = true
        
        imgViewCelebProfilePic.contentMode = .scaleAspectFill
        imgViewProfilePic.contentMode = .scaleAspectFill
        
        imgViewCelebProfilePic.borderColor = .white
        imgViewCelebProfilePic.borderWidth = 2.5
        imgViewCelebProfilePic.layer.masksToBounds = true
        
        imgViewProfilePic.borderColor = .lightGray
        imgViewProfilePic.borderWidth = 0.5
        imgViewProfilePic.layer.masksToBounds = true

        NotificationCenter.default.addObserver(self, selector: #selector(liveEndedEvent), name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
    }
    
    func setDetails() {
        
        let coins = ArtistConfiguration.sharedInstance().oneToOne?.coins ?? 0
        
        if coins > 0 {
            
            let costMsg = " \(coins == 1 ? "\(coins) \(stringConstants.coin)" : "\(coins) \(stringConstants.coins)") \(stringConstants.msgCoinsWillBeDeducted)"
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "armsCoin")
            attachment.bounds = CGRect(x: 0, y: -5, width: 18, height: 18)
            let attachmentStr = NSAttributedString(attachment: attachment)
            
            let myString = NSMutableAttributedString(string: "")
            myString.append(attachmentStr)
            
            let myString1 = NSMutableAttributedString(string: costMsg)
            myString.append(myString1)
            
            lblCoins.font = fonts.regular(size: 14)
            lblCoins.attributedText = myString
        }
        else {
            
            lblCoins.text = ""
            cnstAnyOneLabelTop.constant = 0
        }
        
        let duration = ArtistConfiguration.sharedInstance().oneToOne?.duration ?? 0
        
        let strDuration = utility.getDurationString(Int(duration))
        
        lblDurationDetails.text = stringConstants.msgCallDuration(strDuration)
    }
    
    func setTermLabel() {
        
        let terms = "Terms & Conditions"
        let privacy = "Privacy Policy"
        
        let msg = "By clicking send button you are agreeing to\n\(terms) and \(privacy)."
        
        lblTerms.customize { (lbl) in
            
            lblTerms.text = msg
            
            let termsType = ActiveType.custom(pattern: "\\s\(terms)\\b")
            
            let privacyType = ActiveType.custom(pattern: "\\s\(privacy)\\b")
            
            lblTerms.enabledTypes = [termsType, privacyType]

            lblTerms.customColor[termsType] = UIColor.blue
            lblTerms.customSelectedColor[termsType] = UIColor.gray
            lblTerms.customColor[privacyType] = UIColor.blue
            lblTerms.customSelectedColor[privacyType] = UIColor.gray
                
            self.lblTerms.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                
                if type == termsType {
                    
                    atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
                }
                
                if type == privacyType {
                    
                    atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
                }
                
                return atts
            }
                        
            lblTerms.handleCustomTap(for: termsType) { element in
                
                print("Custom type tapped: \(element)")
//                self.showTermsOrPrivacy(isTerms: true)
                self.btnCancelClicked()
                self.delegate?.didSelectedTermsConditions()
            }
            
            lblTerms.handleCustomTap(for: privacyType) { element in
                
                print("Custom type tapped: \(element)")
//                self.showTermsOrPrivacy(isTerms: false)
                self.btnCancelClicked()
                self.delegate?.didSelectedPrivacyPolicy()
            }
        }
    }
    
    func showTermsOrPrivacy(isTerms: Bool) {
        
        let termeAndCond = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
        
        if isTerms {
            
            termeAndCond.navigationTitle = "Terms & Conditions"
            
            termeAndCond.openUrl = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ?? ""
        }
        else {
            
            termeAndCond.navigationTitle = "Privacy Policy"
            
            termeAndCond.openUrl = ArtistConfiguration.sharedInstance().static_url?.privacy_policy ?? ""
        }
        
        termeAndCond.hideRightBarButtons = true
        
        let navVC = UINavigationController(rootViewController: termeAndCond)
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        self.present(navVC, animated: true, completion: nil)
    }
    
    func sendInvitation(id: String) {
        
        var type = AgoraRTMConnection.commercialType.paid
                
        if let coins = ArtistConfiguration.sharedInstance().oneToOne?.coins, coins > 0 {
            
            type = .paid
        }
        
//        if btnPaid.isSelected == true {
//
//            type = .paid
//        }
        
        delegate?.sendRequestWith(type: type, requestId: id)
        
        btnCancelClicked()
    }
    
    func isBalanceAvailable(_ price:Int) -> Bool {
        
        if CustomerDetails.coins >= price {
            
            return true
        }
        else {
            
            return false
        }
    }
    
    @objc func liveEndedEvent() {
        
        btnCancelClicked()
    }
}

// MARK: - Web Service Methods
extension SendCallRequestViewController {
    
    func webSendCallRequest(completion: ((String?)->())?) {
        
        var dictParams = [String:Any]()
        
        if let ip = utility.getIPAddress() {
            
            dictParams["ip"] = ip
        }
        
        dictParams["artist_id"] = Constants.CELEB_ID
        
        dictParams["v"] = Constants.VERSION
        
        dictParams["platform"] = "ios"
        
        if let live_id = self.liveEvent?.id {
            
            dictParams["live_id"] = live_id
        }
        else {
            
            dictParams["live_id"] = "5a9d91aab75a1a17711af799"
        }
        
        dictParams["type"] = AgoraCallRequestType.oneToone.rawValue

        if Reachability.isConnectedToNetwork() {
            
            self.view.isUserInteractionEnabled = false
          
            self.showLoader()

            ServerManager.sharedInstance().postRequest(postData: dictParams as [String:Any], apiName: Constants.sendCallRequest, extraHeader: nil) { [weak self] (result) in
                
                self?.view.isUserInteractionEnabled = true
                
                DispatchQueue.main.async {
                                        
                    self?.stopLoader()
                    
                    switch result {
                    case .success(let data):
                        
                        print("webSendCallRequest => : \(data)")
                        
                        if let dictData = data["data"].dictionaryObject, let dictRequest = dictData["livevideorequest"] as? [String:Any], let request_id = dictRequest["_id"] as? String {
                            
                            completion?(request_id)
                        }
                        else {
                            
                            completion?(nil)
                            
                            self?.showOnlyAlert(title: "Error", message: "There might be some problem on server, Please try again later.", completion: nil)
                        }
                    case .failure(let error):
                        print(error)
                        
                        completion?(nil)
                        
                        self?.showOnlyAlert(title: "Error", message: "There might be some problem on server, Please try again later.", completion: nil)
                    }
                }
            }
        }
        else
        {
            completion?(nil)
            
            self.showOnlyAlert(title: "Error", message: Constants.NO_Internet_MSG, completion: nil)
        }
    }
}
