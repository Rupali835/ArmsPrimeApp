//
//  InviteFriendViewController.swift
//  HotShot
//
//  Created by webwerks on 29/08/19.
//  Copyright © 2019 com.armsprime.hotshot. All rights reserved.
//

import UIKit
import Social
import MessageUI

//MARK:- CLASS InviteTableViewCell
class InviteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var imgViewIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        menuNameLabel.font = UIFont(name: AppFont.medium.rawValue, size: 14.0)
    }
}
//MARK:- CLASS InviteFriendViewController
class InviteFriendViewController: BaseViewController {

    @IBOutlet weak var inviteTableView: UITableView!
    var inviteOptionArray = [[String:String]]()
    let imagekey = "optionImage"
    let optionNameKey = "optionName"
    let optionCodeKey = "optionCode"
    var copyPopUp : CopyToClipViewController?
    
    @IBOutlet weak var inviteAFrndHeaderLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inviteTableView.rowHeight = 60
        setUpInitialOptionArray()
        self.view.setGradientBackground()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationItem.title = "Invite a Friend"
    }
    func setUpInitialOptionArray() {
        inviteAFrndHeaderLabel.font = UIFont(name: AppFont.medium.rawValue, size: 20.0)
        infoLabel.font = UIFont(name: AppFont.regular.rawValue, size: 17.0)
        
        infoLabel.text = "Get up to 100 Coins when your friend registers for the first time on \(Constants.celebrityName) official App."
        
        // Old text: Get reward coins when your friend register for the first time on \(Constants.celebrityName) official App.
        
        let waDict = [imagekey: "inviteWa" , optionNameKey: "Whatsapp" , optionCodeKey: "wa"]
        inviteOptionArray.append(waDict)
        let fbDict = [imagekey: "inviteFB" , optionNameKey: "Facebook" , optionCodeKey: "fb"]
        inviteOptionArray.append(fbDict)
        let smsDict = [imagekey: "InviteSMS" , optionNameKey: "SMS" , optionCodeKey: "sms"]
        inviteOptionArray.append(smsDict)
        let copyDict = [imagekey: "InviteLink" , optionNameKey: "Copy Referral Link" , optionCodeKey: "copy"]
        inviteOptionArray.append(copyDict)
        let emailDict = [imagekey: "inviteEmail" , optionNameKey: "Email" , optionCodeKey: "email"]
        inviteOptionArray.append(emailDict)
        let twitDict = [imagekey: "InviteTwit" , optionNameKey: "Twitter" , optionCodeKey: "twit"]
        inviteOptionArray.append(twitDict)
        
        inviteTableView.reloadData()
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

extension InviteFriendViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         let cell = inviteTableView.dequeueReusableCell(withIdentifier: "InviteTableViewCell", for: indexPath) as! InviteTableViewCell
        let dict = inviteOptionArray[indexPath.row]
        cell.selectionStyle = .none
        
        cell.menuNameLabel.text = dict[optionNameKey]
        cell.imgViewIcon.image = UIImage(named: dict[imagekey]!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            
            return
        }
        let dict = inviteOptionArray[indexPath.row]
        print("selected \(dict[optionNameKey])")
        guard let selectedOptionCode = dict[optionCodeKey] else { return }
        CustomBranchHandler.shared.shareReferralBranchLink(customerId: CustomerDetails.custId ?? "") { (str) in
            if let url = str {
                switch selectedOptionCode {
                case "wa":
                    self.openWhatsApp(str: url)
                    break
                case "fb":
                     self.openFB(str: url)
                    break
                case "sms":
                     self.openSms(str: url)
                    break
                case "copy":
                    self.openCopyToClip(str: url)
                    break
                case "email":
                    self.openEmail(str: url)
                    break
                case "twit":
                    self.openTwitter(str: url)
                    break
                default:
                    self.openWhatsApp(str: url)
                    break
                }
        }
    }
        
}
    
    func openWhatsApp(str: String)  {
        let urlWhats = "whatsapp://send?text=\(str)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                       })
                } else {
                    // Handle a problem
                }
            }
        }
    }
    
    func openFB(str: String)  {
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.add(URL(string: str))
            present(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openSms(str: String)  {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.body = str
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func openTwitter(str: String)  {
       ShoutoutUtilities.shareOnTwitter(tweet: Constants.celebrityAppName, url: Constants.appStoreLink, inViewController: self)
    }
    
    func openEmail(str: String)  {
        if let mc: MFMailComposeViewController? = MFMailComposeViewController() {
        mc?.mailComposeDelegate = self
        mc?.navigationBar.tintColor = .blue
        mc?.navigationItem.backBarButtonItem?.tintColor = .blue
        
        let emailTitle = "Download \(Constants.celebrityName) official app!"
        let body = "Check out Ankita Dave official app. Sign up using this link to claim your free coins. \n \(str)"
        mc?.setSubject(emailTitle)
        mc?.setMessageBody(body, isHTML: false)
            self.present((mc)!, animated: true, completion: nil)
        }
        
    }
    
    func openCopyToClip(str: String)  {
//        self.showToast(message: "Link Copied Successfully!")
        showCopyClipBoardPopUp()
        UIPasteboard.general.string = str
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.removeCopyClipBoardPopUp()
        }
        
    }
    
    func showCopyClipBoardPopUp() {
         copyPopUp = CopyToClipViewController.loadFromNib()
        copyPopUp!.view.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(copyPopUp!.view)
        copyPopUp!.didMove(toParent: self)
    }
    
    func removeCopyClipBoardPopUp() {

        UIView.animate(withDuration: 0.25, animations: {
             self.copyPopUp!.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
             self.copyPopUp!.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                 self.copyPopUp!.view.removeFromSuperview()
            }
        });
    }
}

extension InviteFriendViewController: MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription ?? "")")
        default:
            break
        }
        controller.dismiss(animated: true)
    }
}
