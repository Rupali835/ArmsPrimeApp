//
//  RewardMessageViewController.swift
//  Kangna Sharma
//
//  Created by Rohit Mac Book on 07/10/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import UIKit
import Social
import Foundation
import AVFoundation
import SafariServices

protocol RewardMessageViewControllerDelegate: class{
    func closeRewardPopUp(_ sender: UIButton)
}

class RewardMessageViewController: UIViewController {
//    @IBOutlet weak var cancleImage: UIImageView!
     weak var delegate: RewardMessageViewControllerDelegate?
    @IBOutlet weak var descriptionLabel: UILabel!
    var descMsg: String? {
        didSet {
           descriptionLabel.text = descMsg
        }
    }
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
       self.showAnimate()
        descriptionLabel.text = descMsg
//        self.cancleImage.layer.cornerRadius = cancleImage.frame.size.width / 2
//        self.cancleImage.layer.masksToBounds = false
//        self.cancleImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
//    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rewardViewClose"), object: nil, userInfo: nil)
        delegate?.closeRewardPopUp(sender as! UIButton)
    }
    
    @IBAction func claimNowButtonAction(_ sender: Any) {
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rewardViewClose"), object: nil, userInfo: nil)
        delegate?.closeRewardPopUp(sender as! UIButton)
    }
    
    @IBAction func fbButtonAction(_ sender: Any) {
        let text = Constants.celebrityAppName
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Share_facebook", extraParamDict: nil)
        
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText(text)
            vc.title = Constants.celebrityAppName
            vc.add(URL(string: Constants.appStoreLink))
            present(vc, animated: true)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func twitterButtonAction(_ sender: Any) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Share_Twitter", extraParamDict: nil)
        
        let urlstring = Constants.appStoreLink
        
        let shareURL = NSURL(string: urlstring)
        
        let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,shareURL], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view
        self.present(viewController, animated: true, completion: nil)
        
//        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
//
//            vc.setInitialText(Constants.celebrityAppName)
//            vc.add(URL(string: Constants.appStoreLink))
//            present(vc, animated: true)
//        } else {
//            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertController.Style.alert)
//
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    @IBAction func whatsAppButtonAction(_ sender: Any) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Share_WhatsApp", extraParamDict: nil)
        
        let message = Constants.appStoreLink
        let urlWhats = "whatsapp://send?text=\(message)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
               
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                        
                    })
                } else {
//                    showToast(message: "Please install whatsapp")
                }
            } else {
//                showToast(message: "Please install whatsapp")
            }
        }
    }
    
    @IBAction func shareWithGoogleP(_ sender: UIButton)
    {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Profile_Share_Google", extraParamDict: nil)
        let urlstring = Constants.appStoreLink
        
        let shareURL = NSURL(string: urlstring)
        
        let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,shareURL], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view
//        viewController.navigationController?.navigationBar.tintColor = UIColor.gray
        
        self.present(viewController, animated: true, completion: nil)
        
//        let urlComponents = NSURLComponents(string: "https://plus.google.com/share")
//
//        urlComponents!.queryItems = [NSURLQueryItem(name: "url", value: shareURL!.absoluteString) as URLQueryItem]
//
//        let url = urlComponents!.url!
//
//        if #available(iOS 9.0, *) {
//            let svc = SFSafariViewController(url: url)
//            svc.delegate = self as? SFSafariViewControllerDelegate as? SFSafariViewControllerDelegate
//            self.present(svc, animated: true, completion: nil)
//        } else {
////            showToast(message: "Please install Google+ application")
//        }
    }

    func showAnimate() {
        
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
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
