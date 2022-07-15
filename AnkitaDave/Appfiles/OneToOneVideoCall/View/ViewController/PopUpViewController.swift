//
//  PopUpViewController.swift
//  Gunjan Aras App
//
//  Created by Shriram on 18/06/20.
//  Copyright © 2020 armsprime. All rights reserved.
import UIKit
import SwiftyJSON

import CoreSpotlight
import MobileCoreServices
import SafariServices

class PopUpViewController: UIViewController {
    var status : String? = " "
    var hyperlink : String? = " "
    var videoCallRequestID : String? = " "
    var strVideoCallCoin : String? = " "
    var strReason : String? = " "
     var strTransactionID : String? = " "
     var strScheduledDate : String? = " "
     var strMessage : String? = " "
     var strCoins : String? = " "
     var strBookingDate : String? = " "
    
     var projects:[[String]] = []
    
    @IBOutlet weak var lblTransactionID: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblReasonTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet var transactionId: CopyableLabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblScheduledDate: UILabel!
    @IBOutlet weak var lblScheduledDateTitle: UILabel!
    @IBOutlet weak var lblLinkTitle: UILabel!
    @IBOutlet weak var btnVideoCall: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var lblTitleCoin: UILabel!
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblBookingDateTitle: UILabel!
    @IBOutlet weak var lblBookingDate: UILabel!
    @IBOutlet  var btnNeedToHelp: UIButton!




    var Details : JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(Details as Any)
        print("JSON Dict \(String(describing: Details))")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.lblTransactionID?.text = Details?["passbook_id"].stringValue
        self.lblTransactionID.adjustsFontSizeToFitWidth = true
        // self.lblTransactionID.textAlignment = NSTextAlignment.center
        self.lblMessage?.text = Details?["message"].stringValue
        self.lblMessage.adjustsFontSizeToFitWidth = true
        // self.lblMessage.textAlignment = NSTextAlignment.center
        self.lblReasonTitle?.isHidden = true
        self.lblReason?.isHidden = true
        status = Details?["status"].stringValue
        //self.lblScheduledDate?.text = Details?["scheduled_at"].stringValue
        //
        
        projects.append(([String(describing: Details)]))
        projects.append([(Details?["passbook_id"].stringValue ?? "")])
        projects.append([(Details?["message"].stringValue ?? "")])
        projects.append([(Details?["status"].stringValue ?? "")])
        index(item: 0)

        if let reason = Details?["reason"].stringValue {
                  strReason = reason
                   projects.append( [reason] )
                   index(item: 0)
               }
         
         if let passbookid = Details?["passbook_id"].stringValue {
            strTransactionID = passbookid
             projects.append( [passbookid] )
             index(item: 0)
         }
         
         if let message = Details?["message"].stringValue {
                   strMessage = message
                    projects.append( [message] )
                    index(item: 0)
                }
                
                if let coins = Details?["coins"].stringValue {
                   strCoins = coins
                    projects.append( [coins] )
                    index(item: 0)
                }
         
         
         
         if let scheduleDate = Details?["scheduled_at"].stringValue {
            strScheduledDate = scheduleDate
             projects.append( [scheduleDate] )
             index(item: 0)
         }
         
        
         
         if let createdAt = Details?["created_at"].stringValue {
            strBookingDate = createdAt
             projects.append( [createdAt] )
             index(item: 0)
         }
         
        
        if status == "rejected"{
            self.lblTransactionID?.text = Details?["passbook_id"].stringValue
            self.lblMessage?.text = Details?["message"].stringValue
            self.lblMessage.adjustsFontSizeToFitWidth = true
            self.lblStatus?.text = status
            self.lblStatus?.text = status?.capitalized
            self.lblStatus?.textColor = .red
            self.lblStatus?.adjustsFontSizeToFitWidth = true
            self.lblReasonTitle.adjustsFontSizeToFitWidth = true
            self.lblReason.adjustsFontSizeToFitWidth = true
            self.lblLinkTitle?.isHidden = true
            self.btnVideoCall?.isHidden = true
            self.lblTitleCoin?.isHidden = true
            self.lblCoin.isHidden = true
            self.lblReason?.isHidden = true
            self.lblReasonTitle?.isHidden = true
            self.lblScheduledDateTitle?.text = "Reason"
            self.lblScheduledDate?.text = Details?["reason"].stringValue
            self.lblBookingDate?.text = Details?["coins"].stringValue
            self.lblBookingDateTitle?.text = "Coins"
            projects.append( [(status ?? "")] )

            
        };if status == "accepted"{
            self.lblTransactionID?.text = Details?["passbook_id"].stringValue
            self.lblMessage?.text = Details?["message"].stringValue
            self.lblStatus?.text = status
            self.lblStatus.text = status?.capitalized
            self.lblStatus?.textColor = .systemGreen
            self.lblStatus.adjustsFontSizeToFitWidth = true
            self.lblScheduledDate?.text = Details?["scheduled_at"].stringValue
            self.hyperlink = Details?["url"].stringValue
             print("video call link = \(hyperlink ?? "")")
            self.videoCallRequestID = Details?["_id"].stringValue
            self.btnVideoCall?.isHidden = false
            self.lblReasonTitle?.isHidden = true
            self.lblReason?.isHidden = true
           self.lblCoin?.text = Details?["coins"].stringValue
            self.strVideoCallCoin = Details?["coins"].stringValue
           self.lblCoin.adjustsFontSizeToFitWidth = true
           self.lblBookingDate?.text = Details?["created_at"].stringValue
        }
        if status == "pending"{
            self.lblTransactionID?.text = Details?["passbook_id"].stringValue
            self.lblMessage?.text = Details?["message"].stringValue
            self.lblStatus?.text = status
            self.lblStatus?.textColor = .systemYellow
            self.lblStatus.text = status?.capitalized
            self.lblStatus.adjustsFontSizeToFitWidth = true
            self.lblReasonTitle?.isHidden = true
            self.lblReason?.isHidden = true
            self.lblCoin?.isHidden = true
            self.lblLinkTitle?.isHidden = true
            self.btnVideoCall?.isHidden = true
            self.lblTitleCoin?.isHidden = true
           // self.lblCoin.adjustsFontSizeToFitWidth = true
            self.lblBookingDateTitle?.isHidden = true
            self.lblBookingDate?.isHidden = true
            self.lblScheduledDateTitle?.text = "Coins"
            self.lblScheduledDate?.text = Details?["coins"].stringValue

            self.popUpView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 50.0)
            if let passbookid = Details?["passbook_id"].stringValue {
               strTransactionID = passbookid
                self.lblTransactionID?.text = strTransactionID
                projects.append( [passbookid] )
                index(item: 0)
            }
            
            if let message = Details?["message"].stringValue {
                      strMessage = message
                self.lblMessage?.text = strMessage
                       projects.append( [message] )
                       index(item: 0)
                   }
                   
                   if let coins = Details?["coins"].stringValue {
                      strCoins = coins
                    self.lblScheduledDate?.text = strCoins
                       projects.append( [coins] )
                       index(item: 0)
                   }

        }
        if status == "completed"{
            self.lblTransactionID?.text = Details?["passbook_id"].stringValue
            self.lblMessage?.text = Details?["message"].stringValue
            self.lblStatus?.text = status
            self.lblStatus.text = status?.capitalized
            self.lblStatus?.textColor = .white
            self.lblStatus.adjustsFontSizeToFitWidth = true
            self.lblScheduledDate?.text = Details?["scheduled_at"].stringValue
            self.lblReasonTitle?.isHidden = true
            self.lblReason?.isHidden = true
            self.btnVideoCall?.isHidden = false
//            self.lblCoin?.text = Details?["coins"].stringValue
            self.lblCoin.adjustsFontSizeToFitWidth = true
            self.lblBookingDateTitle.text = "Coins"
            self.lblBookingDate?.text = Details?["coins"].stringValue
            self.btnVideoCall?.isHidden = true
            self.lblLinkTitle?.isHidden = true
            self.lblScheduledDateTitle.text = "Booking Date"
            self.lblScheduledDate?.text = Details?["created_at"].stringValue
            self.btnVideoCall?.isHidden = true
            self.lblLinkTitle?.isHidden = true
            self.lblCoin?.isHidden = true
            self.lblTitleCoin?.isHidden = true
             
        }
            if status == "rescheduled"{
                self.lblTransactionID?.text = Details?["passbook_id"].stringValue
                self.lblMessage?.text = Details?["message"].stringValue
                self.lblStatus?.text = status
                self.lblStatus.text = status?.capitalized
                self.lblStatus?.textColor = .white
                self.lblStatus.adjustsFontSizeToFitWidth = true
                self.lblScheduledDate?.text = Details?["scheduled_at"].stringValue
                self.hyperlink = Details?["url"].stringValue
                self.btnVideoCall?.isHidden = false
                self.lblReasonTitle?.isHidden = true
                self.lblReason?.isHidden = true
               self.lblCoin?.text = Details?["coins"].stringValue
               self.lblCoin.adjustsFontSizeToFitWidth = true
               self.lblBookingDate?.text = Details?["created_at"].stringValue
            }
            
            
        else{
            self.lblStatus?.text = Details?["status"].stringValue
            self.lblStatus.text = status?.capitalized
        }
        
         
        self.showAnimate()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           super.viewWillDisappear(animated)
           navigationController?.setNavigationBarHidden(false, animated: animated)
       }
       
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    @objc func buttonTapped() {
        print("Button Clicked")
    }
    
    @IBAction func videoCallLink(_ sender: Any) {
               
        let videoCallVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallViewController.self)
               videoCallVC.videoCallreRuestIdOnAcceptedCall = videoCallRequestID
            videoCallVC.strVideoCallCoin = strVideoCallCoin
            videoCallVC.videoCallLink = self.hyperlink ?? ""
            print("video call link = \(self.hyperlink ?? "")")
            videoCallVC.completionCallEnded = { [weak self] in
               
                   //self?.showVideoCallFeedbackScreen(videoCallRequestID)
               }
               videoCallVC.hidesBottomBarWhenPushed = false
               self.navigationController?.pushViewController(videoCallVC, animated: true)
        
//        if let url = URL(string: hyperlink!) {
//                  UIApplication.shared.open(url)
//              }
    }
    
    
    @IBAction func copyToClipBoard(_ sender: Any) {
        transactionId.showMenu(sender: sender as AnyObject)
    }
    @IBAction func NeedAndHelpButtonClicked(_ sender: Any) {
        self.removeAnimate()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
        //self.view.removeFromSuperview()
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


// MARK: - Custom Methods.
extension PopUpViewController {
func index(item:Int) {

  let project = projects[item]
  let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
  attrSet.title = project[0]
  //attrSet.contentDescription = project[1]
    attrSet.contentDescription = project[0]

  let item = CSSearchableItem(
      uniqueIdentifier: "\(item)",
      domainIdentifier: "kho.arthur",
      attributeSet: attrSet )

  CSSearchableIndex.default().indexSearchableItems( [item] )
  { error in

    if let error = error
    { print("Indexing error: \(error.localizedDescription)")
    }
    else
    { print("Search item successfully indexed.")
    }
  }

}


func deindex(item:Int) {

  CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"])
  { error in

    if let error = error
    { print("Deindexing error: \(error.localizedDescription)")
    }
    else
    { print("Search item successfully removed.")
    }
  }

}
}
