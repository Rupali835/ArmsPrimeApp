//
//  VideoCallBookingStatusViewController.swift
//  Gunjan Aras App
//
//  Created by Shriram on 17/06/20.
//  Copyright © 2020 armsprime. All rights reserved.
//

import UIKit
import SwiftyJSON

import CoreSpotlight
import MobileCoreServices
import SafariServices

class VideoCallBookingStatusViewController: BaseViewController {
    @IBOutlet weak var txtVwDisclamer: UITextView!
    @IBOutlet weak var lblTransactionID: UILabel!
    
    var Details : JSON?
  //  var projects:[[String]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Video Call Booking"
        print(Details as Any)
        if let priceAmount = Details?["data"] ["passbook_id"].stringValue {
            // print(priceAmount)
            self.lblTransactionID.text? = "Your booking Id is:   " + String (priceAmount)
            self.lblTransactionID.adjustsFontSizeToFitWidth = true
            self.lblTransactionID.textAlignment = NSTextAlignment.center
        }
        
        if let Disclamer = Details?["message"].stringValue {
            // print(priceAmount)
            self.txtVwDisclamer.text? = Disclamer
          //  projects.append( [Disclamer] )

        }
     //   index(item: 0)

    }
   
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
        if let coinAfterTransaction = Details?["data"] ["coin_after_transaction"].int {
                 CustomerDetails.coins =   coinAfterTransaction
                 let database = DatabaseManager.sharedInstance
            database.updateCustomerCoins(coinsValue: CustomerDetails.coins)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
             }
       }
    
    @IBAction func btnMyBookingSelectionClicked(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MyInboxVideoViewController")  as? MyInboxVideoViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoCallListViewController")  as? VideoCallListViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
        
        let videoCallVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallListingViewController.self)
        self.navigationController?.pushViewController(videoCallVC, animated: true)

    }
}

/*
// MARK: - Custom Methods.
extension VideoCallBookingStatusViewController {
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
*/
