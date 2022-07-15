//
//  PHVIdeoCallBookingSuccessPopupViewController.swift
//  Multiplex
//
//  Created by Parikshit on 28/10/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

class PHVIdeoCallBookingSuccessPopupViewController: UIViewController {

    @IBOutlet weak var lblTransactionID: UILabel!
        
    var obj: Any? = nil
    
    var isVideoCall = false
    var isVideoMessage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setLayoutAndDesigns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setStatusBarStyle(isBlack: false)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)                        
    }
}

// MARK: - IBActions
extension PHVIdeoCallBookingSuccessPopupViewController {
    
  /*  @IBAction func btnMyBookingSelectionClicked(_ sender: Any) {
        
//        let videoCallRequestVC = Storyboard.myInbox.instantiateViewController(viewController: MyInboxViewController.self)
        
        let videoCallRequestVC = storyboard?.instantiateViewController(withIdentifier: "MyInboxVideoViewController")  as? MyInboxVideoViewController
//              self.navigationController?.pushViewController(vc!, animated: true)

        videoCallRequestVC!.selectVideoCall = isVideoCall
        videoCallRequestVC!.selectVideoMessage = isVideoMessage
        self.navigationController?.pushViewController(videoCallRequestVC!, animated: true)
        
        var viewControllers = self.navigationController?.viewControllers

        viewControllers?.removeAll(where: { $0 is PHVIdeoCallBookingSuccessPopupViewController})
        
        self.navigationController?.viewControllers = viewControllers!
    }*/
    
    @IBAction func btnMyBookingSelectionClicked(_ sender: Any) {
            
    //        let videoCallRequestVC = Storyboard.myInbox.instantiateViewController(viewController: MyInboxViewController.self)
            
            let videoCallRequestVC = storyboard?.instantiateViewController(withIdentifier: "VideoCallListViewController")  as? VideoCallListViewController
    //              self.navigationController?.pushViewController(vc!, animated: true)

            videoCallRequestVC!.selectVideoCall = isVideoCall
            videoCallRequestVC!.selectVideoMessage = isVideoMessage
            self.navigationController?.pushViewController(videoCallRequestVC!, animated: true)
            
            var viewControllers = self.navigationController?.viewControllers

            viewControllers?.removeAll(where: { $0 is PHVIdeoCallBookingSuccessPopupViewController})
            
            self.navigationController?.viewControllers = viewControllers!
        }
}

// MARK: - Utility Methods
extension PHVIdeoCallBookingSuccessPopupViewController {
    
    func setLayoutAndDesigns() {
        
        self.navigationItem.title = ""
        
        if isVideoCall {
            
            if let response = obj as? VideoCallBookingResponse, let passbookId = response.passbook_id {
                
                lblTransactionID.text = "Order ID: #\(passbookId)"
            }
        }
        
//        if isVideoMessage {
//
//            if let response = obj as? PurchasedContentDetails, let passbookId = response._id {
//
//                lblTransactionID.text = "Order ID: #\(passbookId)"
//            }
//        }
    }
}
