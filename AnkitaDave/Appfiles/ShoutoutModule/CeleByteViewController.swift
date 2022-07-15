//
//  CeleByteViewController.swift
//  AnveshiJain
//
//  Created by Bhavesh Chaudhari on 04/07/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import Pulley
import AVKit

class CeleByteViewController: UIViewController {

    @IBOutlet var fansVideoCollectionView: UICollectionView!
    @IBOutlet weak var drawerArrow: UIView!
    @IBOutlet var lblrequestNow: UILabel!
    @IBOutlet var lblhowItWorks: UILabel!
    @IBOutlet var lblSendRequest: UILabel!
    @IBOutlet var lblGetPersonalMessage: UILabel!
    @IBOutlet var lblSpreadTheJoy: UILabel!
    @IBOutlet var lblMymessage: UIButton!
    @IBOutlet var lblresponseDays: UILabel!
    @IBOutlet var lblFansSharingJoy: UILabel!
    @IBOutlet var lblviewAll: UIButton!
    @IBOutlet var outerScrollView: UIScrollView!
    var greetingList = [Greetings]()
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
        fansVideoCollectionView.registerNib(withCell: VideoGreetingCollectionViewCell.self)
        fansVideoCollectionView.dataSource = self
        fansVideoCollectionView.delegate = self
        drawerArrow.layer.cornerRadius = 4
        drawerArrow.clipsToBounds = true
        setupFont()
        getData()
        self.parent?.title = "CeleByte"
    }

    private func setupFont() {
        lblrequestNow.font = UIFont(name: AppFont.light.rawValue, size: 30.0)
        lblhowItWorks.font = UIFont(name: AppFont.regular.rawValue, size: 17.0)
        lblSendRequest.font = UIFont(name: AppFont.regular.rawValue, size: 10.0)
        lblGetPersonalMessage.font = UIFont(name: AppFont.regular.rawValue, size: 10.0)
        lblSpreadTheJoy.font = UIFont(name: AppFont.regular.rawValue, size: 10.0)

        lblMymessage.titleLabel?.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
               lblresponseDays.font = UIFont(name: AppFont.regular.rawValue, size: 13.0)
               lblFansSharingJoy.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        lblviewAll.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
    }

//        func loginPopPop() {
//    //        liveIconClick = false
//             let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                      let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//                      self.navigationController?.pushViewController(controller, animated: true)
//        }

    func gotoLoginController() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
           self.navigationController?.pushViewController(controller, animated: true)
       }

}

extension CeleByteViewController {

    @IBAction func seeAllClick(sender: UIButton) {
        let fansVideoListController = Storyboard.videoGreetings.instantiateViewController(viewController: FansVideoListViewController.self)
        fansVideoListController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(fansVideoListController, animated: true)
    }

    @IBAction func messageClick(sender: UIButton) {
        let myGreetings = Storyboard.videoGreetings.instantiateViewController(viewController: MyGreetingsViewController.self)
        myGreetings.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myGreetings, animated: true)
    }

    @IBAction func requestClick(sender: UIButton) {
        if !ShoutoutConfig.isUserLoggedIn() {
           self.gotoLoginController()
            return
        }

        let requestGreeting = Storyboard.videoGreetings.instantiateViewController(viewController:
            RequestGreetingViewController.self)
        requestGreeting.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(requestGreeting, animated: true)
    }

}

extension CeleByteViewController {

    private func playVideoOnPlayer(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

}

// MARK: - CollectionView Delegte & DataSource Methods
extension CeleByteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return greetingList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mediaCell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoGreetingCollectionViewCell.identifier, for: indexPath) as! VideoGreetingCollectionViewCell
        if let video = greetingList[indexPath.item].video {
            mediaCell.configurVideo(video)
        }
        return mediaCell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

       return CGSize(width: 140, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let videoPath = greetingList[indexPath.item].video?.url, let vieoUrl = URL(string:videoPath) {
            playVideoOnPlayer(url: vieoUrl)
        }
    }

}

extension CeleByteViewController {
           func getData() {
            let apiName = "\(Constants.FANS_VIDEO)?platform=android&v=\(ShoutoutConfig.version)"

                guard Reachability.isConnectedToNetwork() else {
                    self.showOnlyAlert(title: "", message: Constants.NO_Internet_MSG)
                    return
                }

            ServerManager.sharedInstance().getRequest(postData: nil, apiName: apiName, extraHeader: nil) { (result) in
             switch result {
             case .success(let data):

                 guard let error = data["error"].bool, error == false else {
                     if let arrErrors = data["error_messages"].arrayObject as? [String] {
                         self.showOnlyAlert(title: "", message: arrErrors[0])
                     }
                     return
                 }

                 guard let arrList = data["data"]["list"].array else {

                     self.showOnlyAlert(title: "", message: "somthing went wrong")

                     return
                 }


                 for dict in arrList {
                    let list : Greetings = Greetings(dictionary: dict.dictionaryObject! as [String:Any])
                     self.greetingList.append(list)
                 }

                 DispatchQueue.main.async {

                    self.fansVideoCollectionView.reloadData()
                 }

                if self.greetingList.count > 0{
                    self.lblviewAll.isHidden = false
                    self.lblFansSharingJoy.isHidden = false
                                   
                }else{
                    self.lblviewAll.isHidden = true
                    self.lblFansSharingJoy.isHidden = true
                }


             case .failure(let error):
                DispatchQueue.main.async {
//                    self.refreshControl.endRefreshing()
//                    self.hideShowPlaceHolder(isHidden: true)
                    self.showOnlyAlert(title: "", message: error.localizedDescription)
                }

             }
            }
        }
}

extension CeleByteViewController: PulleyDrawerViewControllerDelegate , PulleyDelegate {

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

