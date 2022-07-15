//
//  NewCelebyteVideoViewController.swift
//  Gunjan Aras App
//
//  Created by Shriram on 16/06/20.
//  Copyright © 2020 armsprime. All rights reserved.
//
import UIKit
import AVKit
import Pulley

import CoreSpotlight
import MobileCoreServices
import SafariServices

class NewCelebyteVideoViewController: BaseViewController {


    @IBOutlet weak var viewUpDown: UIView!
    @IBOutlet weak var drawerArrow: UIView!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblHowItWorks: UILabel!
    @IBOutlet weak var lblCallDuration: UILabel!
    @IBOutlet weak var lblNoVideo: UILabel!
    @IBOutlet weak var outerScrollView: UIScrollView!

    var strArtistFirstName:String?
    var strArtistLastName:String?
    var strArtistName:String?
    var atristConfigCoins = ArtistConfiguration.sharedInstance()
    var projects:[[String]] = []

    var stateChangeClouser: ((DrawerState) -> ())?
    fileprivate var drawerBottomSafeArea: CGFloat = 0.0 {
        didSet {
            self.loadViewIfNeeded()

            // We'll configure our UI to respect the safe area. In our small demo app, we just want to adjust the contentInset for the tableview.
            outerScrollView.contentInset = UIEdgeInsets(top: 15.0, left: 0.0, bottom: drawerBottomSafeArea + 10, right: 0.0)
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        outerScrollView.contentInset = UIEdgeInsets(top: 15.0, left: 0.0, bottom: drawerBottomSafeArea + 10, right: 0.0)

        drawerArrow.layer.cornerRadius = 4
        drawerArrow.clipsToBounds = true
//        title = "Video Call"
        self.parent?.title = "Video Call"
        setupView()

    }



    @IBAction func btnMyRequestClicked(_ sender: Any) {

        if !self.checkIsUserLoggedIn() {
            self.gotoLoginController()
            return
        }
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MyInboxVideoViewController")  as? MyInboxVideoViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
//                let vc = storyboard?.instantiateViewController(withIdentifier: "VideoCallListViewController")  as? VideoCallListViewController
//                self.navigationController?.pushViewController(vc!, animated: true)
        
        let videoCallVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallListingViewController.self)
        self.navigationController?.pushViewController(videoCallVC, animated: true)

        
    }

    
    func gotoLoginController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func btnBookNowClicked(_ sender: Any) {

        if !self.checkIsUserLoggedIn() {
            self.gotoLoginController()
            return

        }
        //   PHVideoCallBookingViewController  // VideoCallBookingViewController
        if  let vc = storyboard?.instantiateViewController(withIdentifier: "PHVideoCallBookingViewController")  as? PHVideoCallBookingViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }

//        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoCallBookingViewController")  as? VideoCallBookingViewController
//
//        self.navigationController?.pushViewController(vc!, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}


// MARK: - Custom Methods
extension NewCelebyteVideoViewController {

    fileprivate func setupView() {
//       if let priceAmount = atristConfigCoins.privateVideoCall?.coins {
//
//           self.lblCoins?.text? = "BOOK NOW@ " + String (priceAmount)
//           self.lblCoins?.adjustsFontSizeToFitWidth = true
//           self.lblCoins?.textAlignment = NSTextAlignment.center
//        projects.append( ["BOOK NOW@ " + String (priceAmount)] )
//        projects.append( [String(self.lblCoins?.text ?? "")] )
//
//
//
//       }

       viewUpDown.roundCorners(corners: [.topLeft, .topRight], radius: 20)
       strArtistFirstName = atristConfigCoins.first_name ?? ""
       strArtistLastName = atristConfigCoins.last_name ?? ""
       strArtistName = (strArtistFirstName ?? "") + " " + (strArtistFirstName ?? "")

       self.lblArtistName.text? = "ONE-TO-ONE CALL WITH " + String (strArtistFirstName!.uppercased())
       self.lblArtistName.adjustsFontSizeToFitWidth = true
       self.lblArtistName.textAlignment = NSTextAlignment.center
       self.lblHowItWorks.adjustsFontSizeToFitWidth = true
       self.lblHowItWorks.textAlignment = NSTextAlignment.center
        projects.append( ["ONE-TO-ONE CALL WITH " + String (strArtistFirstName!)] )
        projects.append( [String(self.lblArtistName?.text ?? "")] )
        index(item: 0)


//       if let StrCallDuration = atristConfigCoins.privateVideoCall?.duration {
//
//           self.lblCallDuration?.text? = "Video call duration: " + String (StrCallDuration)  +  " minutes"
//           self.lblCallDuration?.adjustsFontSizeToFitWidth = true
//           self.lblCallDuration?.textAlignment = NSTextAlignment.center
//         projects.append( ["Video call duration: " + String (StrCallDuration)] +  [" minutes"] )
//        projects.append( [String(self.lblCallDuration.text ?? "")] )
//        index(item: 0)
//       }
    }
}

extension NewCelebyteVideoViewController: PulleyDrawerViewControllerDelegate , PulleyDelegate {

    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
        // For devices with a bottom safe area, we want to make our drawer taller. Your implementation may not want to do that. In that case, disregard the bottomSafeArea value.
        print("collapsedDrawerHeight = \(bottomSafeArea)")
        return (self.view.frame.height - 470) + (pulleyViewController?.currentDisplayMode == .drawer ? 20.0 : 0.0)
    }

    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat
    {
         print("partialRevealDrawerHeight = \(bottomSafeArea)")
        return 100 + (pulleyViewController?.currentDisplayMode == .drawer ? bottomSafeArea : 0.0)
    }

    func makeUIAdjustmentsForFullscreen(progress: CGFloat, bottomSafeArea: CGFloat) {
        print("progress = \(progress)")
        let OldRange  : Double = 1 - 0
        let NewRange : Double = 58 - 100
        let NewValue = (((Double(progress) - 0.0) * NewRange) / OldRange) + 0.0
        print("NewValue = \(NewValue)")
    }

    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.open,.collapsed,.closed] // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }

    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        print("drawerChangedDistanceFromBottom = \(bottomSafeArea)")
    }

    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        drawerBottomSafeArea = bottomSafeArea
        
        outerScrollView.isScrollEnabled = drawer.drawerPosition == .open || drawer.currentDisplayMode == .panel
        if stateChangeClouser != nil {
            let state: DrawerState = (drawer.drawerPosition == .open) ? .open : .close
            stateChangeClouser!(state)
        }
    }


    /// This function is called when the current drawer display mode changes. Make UI customizations here.
    func drawerDisplayModeDidChange(drawer: PulleyViewController) {

        print("Drawer: \(drawer.currentDisplayMode)")
        //        gripperTopConstraint.isActive = drawer.currentDisplayMode == .drawer
    }
}


// MARK: - Custom Methods.
extension NewCelebyteVideoViewController {
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


