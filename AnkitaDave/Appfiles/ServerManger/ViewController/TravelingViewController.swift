//
//  TravelingViewController.swift
//  LeoneOfficialApp
//
//  Created by RazrTech2 on 21/02/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AVKit
import SDWebImage
import Shimmer
import FirebaseDynamicLinks
import Alamofire



public func delay(_ delay: Double, closure: @escaping () -> Void) {
    let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(
        deadline: deadline,
        execute: closure
    )
}


class TravelingViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource, MainTableViewCellDelegate, PurchaseContentProtocol {
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var imageview: UIView!
    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var captionView: UIView!
    
    @IBOutlet weak var imageview1: UIView!
    @IBOutlet weak var daysView1: UIView!
    @IBOutlet weak var captionView1: UIView!
    @IBOutlet var travelingTableView: UITableView!
    
     
    
    let activityView = UIActivityIndicatorView(style: .whiteLarge)
    let spinner = UIActivityIndicatorView(style: .white)
    var viewActivityLarge : SHActivityView?
    var flagIsFromLocalOrServer = false
    var navigationTittle = ""
    var images = [AnyObject]()
    var arrData = NSMutableArray()
    var selectedIndexVal: Int!
    var askAlbum: Bool!
    var likeSelectedArray = [Int]()
    var newLikeCount = [[IndexPath: Int]()]
    var arrStoredDetails = NSMutableArray()
    var photoWidth: CGFloat!
    var imgArr = NSMutableArray()
    var statusArray = NSMutableArray()
    var imageArray = NSMutableArray()
    var statusDict = NSMutableDictionary()
    var is_like = [String]()
    var bucketsArray : [List]!
    var dataArray : [List] = [List]()
    let database = DatabaseManager.sharedInstance

    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    var prevPageValue = 0
    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView!
    var selectedlikeButton = [IndexPath]()
    var isFirstTime = true
    var cellHeights: [IndexPath : CGFloat] = [:]
    var totalImagesCount: Int = 0
    var perPage: Int = 15
    var noOfPages: Int = 1
    var CurrentPageValue: Int = 1
    var postId = ""
    var bucketId: String?
    var isLogin = false
    let reachability = Reachability()
    var ageDiff : Int? = 0

    
    @IBOutlet var internetConnectionLostView: UIView!
    @IBOutlet var retryAgainButton: UIButton!
    
    var shimme1 = FBShimmeringView()
    var shimme2 = FBShimmeringView()
    var shimme3 = FBShimmeringView()
    var shimme4 = FBShimmeringView()
    var shimme5 = FBShimmeringView()
    var shimme6 = FBShimmeringView()
    var contetid:String = ""
    
    var hideforwardBackwardView: UIView!
    var isSwipeVideo: Bool = true
    var timer = Timer()
    var selectedIndexs = 0
    var bucketCodeStr: String?
     var tableSelectedIndex = 0
    var selectedBucketCode: String?
     var isTableLoaded : Bool = false
    var pageList: List?
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
         startPreventingRecordingNew()
        travelingTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        travelingTableView.register(UINib(nibName: "PollTableViewCell", bundle: nil), forCellReuseIdentifier: "PollTableViewCell")
        travelingTableView.dataSource = self
        travelingTableView.delegate = self
        
        self.travelingTableView.estimatedRowHeight = 200
        self.travelingTableView.rowHeight = UITableView.automaticDimension
        self.travelingTableView.setNeedsUpdateConstraints()

        
        shimme1 = FBShimmeringView(frame: self.imageview.frame)
        shimme1.contentView = imageview
        view.addSubview(shimme1)
        shimme1.isShimmering = true
        
        shimme2 = FBShimmeringView(frame: self.daysView1.frame)
        shimme2.contentView = daysView1
        view.addSubview(shimme2)
        shimme2.isShimmering = true
        
        shimme3 = FBShimmeringView(frame: self.daysView.frame)
        shimme3.contentView = daysView
        view.addSubview(shimme3)
        shimme3.isShimmering = true
        
        shimme4 = FBShimmeringView(frame: self.captionView.frame)
        shimme4.contentView = captionView
        view.addSubview(shimme4)
        shimme4.isShimmering = true
        
        shimme5 = FBShimmeringView(frame: self.imageview1.frame)
        shimme5.contentView = imageview1
        view.addSubview(shimme5)
        shimme5.isShimmering = true
        
        shimme6 = FBShimmeringView(frame: self.captionView1.frame)
        shimme6.contentView = captionView1
        view.addSubview(shimme6)
        shimme6.isShimmering = true
        self.placeholderView.isHidden = true
        
        
        
        self.tabBarController?.tabBar.isHidden = false
        self.internetConnectionLostView.isHidden = true

        arrStoredDetails.removeAllObjects()
        arrData.removeAllObjects()
        imgArr.removeAllObjects()
        imageArray.removeAllObjects()
        totalImagesCount = 0
        prevPageValue = 0
        perPage = 15
        noOfPages = 1
        CurrentPageValue = 0
        
        self.dataArray = [List]()
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
    
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }
        reachability?.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability?.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
      
     //   self.getData(bRelaodData: true)

         setHideForwardBackWardOnWindow()
        
    }
    
    
    func startPreventingRecordingNew() {
    //        self.alert(message: "Screen Prevent", title: "Error")
            NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: UIScreen.main, queue: OperationQueue.main) { [self] (notification) in
                let isCaptured =  UIScreen.main.isCaptured
                if isCaptured {
                   // AppAlert.shared.simpleAlert(view: self, title: "Screen prevent", message: "No recording", buttonTitle: "Ok")
                    
                   // self.alert(message: "Screen Prevent", title: "Error")
                    self.playerViewController.player?.pause()
                    self.playerViewController.showsPlaybackControls = true
                    self.playerViewController.contentOverlayView?.isUserInteractionEnabled = true
                    self.playerViewController.view.frame = self.view.bounds
                    self.playerViewController.view.isUserInteractionEnabled = true
                    self.playerViewController.showsPlaybackControls = true
                   
                        
                    
                }else{
                    self.playerViewController.player?.play()
                    self.playerViewController.showsPlaybackControls = true
                }
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
     //   self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
         self.setNavigationView(title: (pageList?.name ?? "").uppercased())
        if #available(iOS 10.0, *) {
            travelingTableView.refreshControl = refreshControl
        } else {
            travelingTableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
        refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)
        
        self.getData(bRelaodData: true)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            
            print("Reachable via WiFi")
        case .cellular:
            
            print("Reachable via Cellular")
        case .none:
            if  self.dataArray.count == 0 {
                self.internetConnectionLostView.isHidden = false
            }
            print("Network not reachable")
        }
    }
    
    
    
    
    @IBAction func retryAgainClick(_ sender: UIButton) {
        if self.dataArray.count == 0 {
            self.shimme1.isShimmering = true
            self.shimme1.isHidden = false
            
            self.shimme2.isShimmering = true
            self.shimme2.isHidden = false
            
            self.shimme3.isShimmering = true
            self.shimme3.isHidden = false
            
            self.shimme4.isShimmering = true
            self.shimme4.isHidden = false
            
            self.shimme5.isShimmering = true
            self.shimme5.isHidden = false
            
            self.shimme6.isShimmering = true
            self.shimme6.isHidden = false
            
            self.placeholderView.isHidden = false
            
            self.getData(bRelaodData: true)
            if  self.dataArray.count > 0 {
                self.internetConnectionLostView.isHidden = true
            }
        }
        
    }
    
    @objc private func refreshPhotosData(_ sender: Any) {
        guard Reachability.isConnectedToNetwork() else {
            self.showToast(message: Constants.NO_Internet_MSG)
            self.refreshControl.endRefreshing()
            return
        }
        
        self.prevPageValue = 0
        self.CurrentPageValue = 0
        self.imgArr.removeAllObjects()
        self.arrData.removeAllObjects()
        self.arrStoredDetails.removeAllObjects()
        self.arrSinglePhotoData.removeAllObjects()
        self.dataArray.removeAll()
        _ = self.getOfflineUserData()
        
        self.getData(bRelaodData: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getData(bRelaodData: true)
        
        GlobalFunctions.screenViewedRecorder(screenName: "Home \(navigationTittle) Screen")
        self.isTableLoaded = true
        if let index = GlobalFunctions.sortedTabMenuArrayIndex(code: pageList?.code ?? "") {
            if index < 3 {
                self.tabBarController?.viewControllers?[index].tabBarItem.badgeValue = nil
            }
        }
        if !self.hideforwardBackwardView.isHidden && isSwipeVideo{
                   self.hideforwardBackwardView.removeFromSuperview()
                   self.hideforwardBackwardView.isHidden = true
                   self.isSwipeVideo = false
               }
               timer.invalidate()
    }
    
    func didTapButton(_ sender: UIButton) {
        //        if Reachability.isConnectedToNetwork() {
        
        if isLogin {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let CommentTableViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
            if (self.dataArray != nil && self.dataArray.count > 0) {
                
                let dict : List = self.dataArray[sender.tag]
                let postId = dict._id
                CommentTableViewController.postId = postId ?? ""
                CommentTableViewController.screenName = "Home \(navigationTittle) Screen"
                
                self.navigationController?.pushViewController(CommentTableViewController, animated: true)
            }
        }
        else {
//            let alert = UIAlertController(title: "Not Logged In.Please log in to continue", message: "", preferredStyle: UIAlertController.Style.alert)
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//
//            // show the alert
//            self.present(alert, animated: true, completion: nil)
//
//
//            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                if #available(iOS 11.0, *) {
//                    let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                    self.pushAnimation()
//                    self.navigationController?.pushViewController(resultViewController, animated: false)
//                }
//            })
            
            self.loginPopPop()
            return
        }
        //    else
        //    {
        //        self.showToast(message: Constants.NO_Internet_MSG)
        //
        //    }
    }
    
    func didShareButton(_ sender: UIButton) {
        if !Reachability.isConnectedToNetwork() {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
            return
        }
        let content = dataArray[sender.tag]
        
        var params: String = " "
        params += "&bucket_code=" + "\(pageList?.code ?? "")"
        params += "&content_id=" + "\(content._id ?? "")"
        CustomBranchHandler.shared.shareContentBranchLink(content: content, bucketCode: pageList?.code ?? "",inViewController: self)
    
        
    }
    func didTapOpenPurchase(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true
        {
            if !self.checkIsUserLoggedIn() {
                self.loginPopPop()
                
                return
            }
            let currentIndex = sender.tag
            let currentList = self.dataArray[currentIndex]
            
            if (currentList != nil) {
                if !self.checkIsUserLoggedIn() {
                    self.loginPopPop()
                    return
                }
                CustomMoEngage.shared.sendEventForLockedContent(id: currentList._id ?? "")
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
                self.addChild(popOverVC)
                popOverVC.delegate = self
                popOverVC.contentId = currentList._id
                popOverVC.coins = currentList.coins
                popOverVC.contentIndex = currentIndex
                popOverVC.currentContent = currentList
                popOverVC.selectedBucketCode = pageList?.code ?? ""
                popOverVC.selectedBucketName =  pageList?.name ?? ""
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
            
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    func contentPurchaseSuccessful(index: Int, contentId: String?)
    {
         let currentList : List = self.dataArray[index]
        
         print("after purchase selected index =\(index) type[\(currentList.type) commercial type =\(currentList.commercial_type) description\(currentList.name)]")
        
         if let type = currentList.type , type == "poll"{
             self.travelingTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
         } else {
             if let cell : MainTableViewCell = self.travelingTableView.cellForRow(at: IndexPath.init(item: index, section: 0)) as? MainTableViewCell{
                 
                 let selectedList = dataArray[index]
                 if selectedList.type != nil && selectedList.type == "video" {
                     cell.videoLockedPadView.isHidden = false
                     cell.premiumView.isHidden = true
                 } else {
                    if self.checkIsUserLoggedIn() {
                        self.getUserMetaDataNew()
                    }
            
                    if currentList._id == contentId //rupali
                    {
                        if GlobalFunctions.checkContentPurchaseId(id: contentId!)
                        {
                            
                            cell.unlockImageView.isHidden = false
                            cell.unlockdView.isHidden = false
                         
                        }

                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
                  
                 }
                 cell.optionsButton.isHidden = false
                 cell.optionsTap.isHidden  = false
                 
             }
            
            
         }
         if let type = currentList.type , type == "video"{
             if let url = currentList.video?.url {
                 let videoURL = URL(string: url)
                 let player = AVPlayer(url: videoURL!)
                 self.playerViewController.player = player
                 if (GlobalFunctions.isContentsPurchased(list: currentList)) {
                             NotificationCenter.default.addObserver(self, selector: #selector(TravelingViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                             
                             self.present(playerViewController, animated: true) {
                                 //self.playerViewController.player?.play()
                             }
                             let indexPath = IndexPath(row: index, section: 0)
                             self.callViewCountAPI(currentList._id ?? "", indexPath)
                             self.addObeserVerOnPlayerViewController()
                 }
             }
         }
    
//         self.showToast(message: "Unlocked Successfully")
        
     }
    
    func didTapOpenOptions(_ sender: UIButton) {
        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report this content", style: .default) { action in
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackReportPopUpViewController") as! FeedbackReportPopUpViewController
            self.addChild(popOverVC)
            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(popOverVC.view)
            popOverVC.titleLabel.text = "Give feedback on this content"
            
            popOverVC.didMove(toParent: self)
        })
        alert.addAction(UIAlertAction(title: "Hide this content", style: .destructive) { action in
            self.hideContent(sender: sender)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func didTapWebview(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
            let currentList : List = self.dataArray[sender.tag]
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebviewUrlViewController") as! WebviewUrlViewController
            resultViewController.webViewName = currentList.webview_label!
            resultViewController.storeDetailsArray = self.dataArray
            resultViewController.pagindex = sender.tag
            
            
            self.navigationController?.pushViewController(resultViewController, animated: true)
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    func hideContent(sender: UIButton) {
            if (Reachability.isConnectedToNetwork() == true) {
                
                let alert = UIAlertController(title: "You won't see this content again.", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    if self.isLogin {
                        
                        _ = self.getOfflineUserData()
                        
                        let indexPath = IndexPath(row: sender.tag, section: 0)
    //                    guard let cell =  self.travelingTableView.cellForRow(at: indexPath) as? MainTableViewCell else {
    //                        return
    //                    }
                        let dict : List = self.dataArray[indexPath.row]
                        let contentId = dict._id
                        let customerId = CustomerDetails.custId
                        
                        if (self.database != nil) {
                            
                            self.database.createHideTable()
                            if (contentId != nil && customerId != nil) {
                                self.database.insertIntoHideContent(content: contentId ?? "", customer: customerId!)
                                
                                GlobalFunctions.sendBLockContentToServer(content: contentId!)
                            }
                        }
    //                    if ( self.arrStoredDetails != nil && self.arrStoredDetails.count > 0) {
    //
    //                        self.arrStoredDetails.removeObject(at: indexPath.row)
    //                        self.imgArr.removeObject(at: indexPath.row)
    //                    }
                        if self.dataArray.count != 0 && self.dataArray.count > indexPath.row{
                            self.dataArray.remove(at: indexPath.row)
                        }
                       
                        DispatchQueue.main.async {
                            self.travelingTableView.reloadData()
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.showToast(message: Constants.NO_Internet_Connection_MSG)
            }
        }
    
    func didLikeButton(_ sender: UIButton) {
        let socialPost = self.dataArray[sender.tag]
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
              CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:"User not logged in", extraParamDict: nil)
            return
        }
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        guard let cell =  self.travelingTableView.cellForRow(at: indexPath) as? MainTableViewCell else {
            return
        }
        if let socialPostId = socialPost._id, self.is_like.contains(socialPostId) {
            self.animateDidLikeButton(cell.likeButton)
            return
        }
        if let likeCount = Int(cell.likeCountLabel.text!) {
            cell.likeCountLabel.text = (likeCount + 1).roundedWithAbbreviations
        }
        self.animateDidLikeButton(cell.likeButton)
        
        if (!self.is_like.contains(socialPost._id!)) {
            self.is_like.append(socialPost._id ?? "")
        }
        if Reachability.isConnectedToNetwork()
        {
            if (dataArray != nil && dataArray.count > 0) {
                
                let dict = ["content_id": socialPost._id ?? "", "like": "true"] as [String: Any] //
                print(dict)
                if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                    
                    let url = NSURL(string: Constants.App_BASE_URL + Constants.LIKE_SAVE)!
                    let request = NSMutableURLRequest(url: url as URL)
                    
                    request.httpMethod = "POST"
                    request.httpBody = jsonData
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                    request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "ArtistId")
                    request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
                    request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                        if error != nil{
                            self.showToast(message: Constants.NO_Internet_MSG)
                            
                            GlobalFunctions.trackEvent(eventScreen: "Home \(self.navigationTittle) Screen", eventName: "Like", eventPostTitle: "Error : \(error?.localizedDescription ?? "")", eventPostCaption: "", eventId: socialPost._id!)

                            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: nil)
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("Photo json \(String(describing: json))")
                            if json?.object(forKey: "error") as? Bool == true {
                                var errorString = "Error"
                                if let arr = json?.object(forKey: "error_messages") as? NSMutableArray{
                                    errorString = "Error : \(arr[0] as! String)"
                                }
                                GlobalFunctions.trackEvent(eventScreen: "Home \(self.navigationTittle) Screen", eventName: "Like", eventPostTitle: errorString, eventPostCaption: "", eventId: socialPost._id!)
                                  CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: errorString, extraParamDict: nil)
                            } else if (json?.object(forKey: "status_code") as? Int == 200)
                            {
                                GlobalFunctions.trackEvent(eventScreen: "Home \(self.navigationTittle) Screen", eventName: "Like", eventPostTitle: "Success", eventPostCaption: "", eventId: socialPost._id!)
                                DispatchQueue.main.async {
                                    
                                    if !self.likeSelectedArray.contains(cell.likeTap.tag) {
                                        self.likeSelectedArray.append(cell.likeTap.tag)
                                    }
                                    
                                    GlobalFunctions.saveLikesIdIntoDatabase(content_id: socialPost._id ?? "")
                                    CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Success", reason: "", extraParamDict: nil)
                                }
                            }
                            
                        } catch let error as NSError {
                            print(error)
                            GlobalFunctions.trackEvent(eventScreen: "Home \(self.navigationTittle) Screen", eventName: "Like", eventPostTitle: "Error : \(error.localizedDescription)", eventPostCaption: "", eventId: socialPost._id!)
                             CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: "Error : \(error.localizedDescription)", extraParamDict: nil)
                        }
                        
                    }
                    task.resume()
                }
            }
        } else {
            
            if (dataArray != nil && dataArray.count > 0) {
                
                let contentId = dataArray[indexPath.row]._id
                GlobalFunctions.saveLikesIdIntoDatabase(content_id: contentId as! String)
                if (!self.is_like.contains(contentId!)) {
                    self.is_like.append(contentId ?? "")
                }
            }
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("data array count \(self.dataArray.count)")
        if self.dataArray != nil && self.dataArray.count > 0
        {
            return self.dataArray.count
        } else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.dataArray != nil && self.dataArray.count != 0 {
            let currentList : List = self.dataArray[indexPath.row]
            if let type = currentList.type , type == "poll"{
                let cell = travelingTableView.dequeueReusableCell(withIdentifier: "PollTableViewCell", for: indexPath) as! PollTableViewCell
                cell.delegate = self
                cell.currentList = currentList
                cell.likeTapButton.tag = indexPath.row
                cell.commentTapButton.tag = indexPath.row
                cell.shareTapButton.tag = indexPath.row
                cell.optionButtonTap.tag = indexPath.row
                cell.selectionStyle = .none
                
                if (GlobalFunctions.checkContentLikeId(id: currentList._id ?? "") || self.is_like.contains(currentList._id ?? "")) {
                    cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
                    self.is_like.append(currentList._id ?? "")
                } else {
                    cell.likeButton.setImage(UIImage(named: "newUnlike"), for: .normal)
                }
                configurePollCell(cell: cell, forRowAtIndexPath: indexPath)
                return cell
            } else {
                let cell = travelingTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)as!MainTableViewCell
                isTableLoaded = true
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                cell.shareTap.tag = indexPath.row
                cell.likeTap.tag = indexPath.row
                cell.commentTap.tag = indexPath.row
                cell.optionsTap.tag = indexPath.row
                cell.webViewButton.tag = indexPath.row
                cell.socialLogoImageView.isHidden = true
                cell.unlockImageView.isHidden = true
                cell.unlockdView.isHidden = true
//                cell.blurView.isHidden = true
                cell.premiumView.isHidden = true
                cell.videoLockedPadView.isHidden = true
                
                if self.dataArray.count > 0 && self.dataArray.count >= indexPath.row
                {
                    
                    if let currentList : List = self.dataArray[indexPath.row] as? List {
                        print("ARR=\(currentList)")
                        cell.list = currentList
                        if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0{
                            
                            if currentList.partial_play_duration != nil && currentList.partial_play_duration != "" && currentList.partial_play_duration != "0" {
                                cell.optionsTap.isHidden  = false
                                cell.optionsButton.isHidden = false
                                cell.premiumView.isHidden = false
                            } else {
                                if currentList.type != nil && currentList.type == "video" {
                                    cell.premiumView.isHidden = false
                                    cell.optionsButton.isHidden = true
                                    cell.optionsTap.isHidden  = true
                                    cell.optionsView.alpha = 0
                                } else {
//                                    cell.blurView.isHidden = false
//                                    cell.optionsButton.isHidden = true
                                    cell.optionsTap.isHidden  = true
                                    cell.optionsView.alpha = 0
                                    let strCoins : String = "\(currentList.coins ?? 0)"
//                                    cell.unlockPriceLabel.text = "Unlock premium content for \(strCoins) coins."
                                }
                              
                            }
                            
                            
                        } else {
                            
                            if (GlobalFunctions.isContentsPurchased(list: currentList)) {
                                //                        cell.unlockImageView.isHidden = false
                                //                        cell.unlockdView.isHidden = false
                                if currentList.type != nil && currentList.type == "video" {
                                    if currentList.coins != 0 {
                                        cell.videoLockedPadView.isHidden = false
                                        cell.premiumView.isHidden = true
                                    } else {
                                        cell.videoLockedPadView.isHidden = true
                                        cell.premiumView.isHidden = true
                                    }
                                } else {
                                    cell.unlockImageView.isHidden = false
                                    cell.unlockdView.isHidden = false
                                }
                            } else {
                                
                            }
                            
                            cell.optionsButton.isHidden = false
                            cell.optionsTap.isHidden  = false
                            //                    cell.optionsView.backgroundColor = UIColor.black.withAlphaComponent(0.20)
                            
                        }
          
                        if (GlobalFunctions.checkContentLikeId(id: currentList._id ?? "") || self.is_like.contains(currentList._id ?? "")) {
                            cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
                            if (!self.is_like.contains(currentList._id ?? "")) {
                                self.is_like.append(currentList._id ?? "")
                            }
                        } else {
                            cell.likeButton.setImage(UIImage(named: "newUnlike"), for: .normal)
                        }
                        
                        cell.delegate = self
                        
                        self.configure(cell: cell, forRowAtIndexPath: indexPath)
                        
                        if let socialPostId = currentList._id, self.is_like.contains(socialPostId) {
                            if let viewCount = currentList.stats?.likes {
                                if viewCount == 0 {
                                    cell.likeCountLabel.text = "1"
                                }
                            }
                        }
                    }
                }
                
                return cell
                
            }
        }
        else {
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    func configure(cell: MainTableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        print("==== \(indexPath.row) ====")
        if likeSelectedArray.contains(indexPath.row) {
            cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
            cell.likeButton.isSelected = true
        }
        else {
            // not selected
            //            cell.likeButton.setImage(UIImage(named: "ic_like_white"), for: .normal)
            cell.likeButton.isSelected = false
        }
    }
    func configurePollCell(cell: PollTableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        print("==== \(indexPath.row) ====")
        if likeSelectedArray.contains(indexPath.row) {
            cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
            cell.likeButton.isSelected = true
        }
        else {
            cell.likeButton.isSelected = false
        }
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
//            navigationController?.setNavigationBarHidden(true, animated: true)
//        } else {
//            navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == self.dataArray.count - 1) && noOfPages > CurrentPageValue {
            if ( Reachability.isConnectedToNetwork() == true) {
                spinner.color = hexStringToUIColor(hex: MyColors.casual)
                
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: travelingTableView.bounds.width, height: CGFloat(10))
                self.travelingTableView.tableFooterView = spinner
                self.travelingTableView.tableFooterView?.isHidden = false
                
                self.getData(bRelaodData: true)

        } else {
            showToast(message: Constants.NO_Internet_MSG)
            }
        }
    }
    
    func kFormat(forNumber number: Int) -> String? {
        var result: Double
        if number >= 1000 {
            result = Double(number / 1000)
            let kValue = "\(result)" + "k"
            return kValue
        }
        return "\(number)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexs = indexPath.row
        let currentList = dataArray[indexPath.row]
        let type = currentList.type ?? ""
        print("selected index =\(selectedIndexs) type[\(type) commercial type =\(currentList.commercial_type) description\(currentList.name)]")
        if type == "video" {
            if let videoType = currentList.video?.player_type {
                if videoType == "internal" {
                    if let url = currentList.video?.url,
                        let videoURL = URL(string: url) {
                        let player = AVPlayer(url: videoURL)
                        self.playerViewController.player = player
                                if (GlobalFunctions.isContentsPurchased(list: currentList)) {
                                    
                                    NotificationCenter.default.addObserver(self, selector: #selector(TravelingViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                    
                                    self.present(playerViewController, animated: true) {
                                        self.playerViewController.player?.play()
                                        
                                    }
                                    self.callViewCountAPI(currentList._id ?? "", indexPath)
                                    self.addObeserVerOnPlayerViewController()
                                } else if currentList.partial_play_duration != nil && currentList.partial_play_duration != "" && currentList.partial_play_duration != "0" {
                                    
                                    if  let time = currentList.partial_play_duration{
                                        
                                        
                                        self.present(self.playerViewController, animated: true) {
                                            
                                            self.playerViewController.player?.play()
                                            self.hideforwardBackwardView.isHidden = false
                                            self.isSwipeVideo = true
                                            UIApplication.shared.keyWindow?.addSubview(self.hideforwardBackwardView)
                                            //                                                            self.playerViewController.showsPlaybackControls = true
                                            
                                        }
                                        self.callViewCountAPI(currentList._id ?? "", indexPath)
                                        self.addObeserVerOnPlayerViewController()
                                        if  let t = Int(time) {
                                            let timr = (Int(t) / Int (1000))
                                            
                                            print("video play duration \(timr)")
                                            
                                            timer = Timer.scheduledTimer(timeInterval: Double(timr), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                                            
                                        }
                                        
                                        
                                    }
                                    
                                } else if (!GlobalFunctions.isContentsPurchased(list: currentList)) && currentList.coins != 0 {
                                    if !self.checkIsUserLoggedIn() {
                                        self.loginPopPop()
                                        return
                                    }
                                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
                                    self.addChild(popOverVC)
                                    popOverVC.delegate = self
                                    popOverVC.contentIndex = indexPath.item
                                    popOverVC.currentContent = currentList
                                    popOverVC.selectedBucketCode = pageList?.code ?? ""
                                    popOverVC.selectedBucketName =  pageList?.name ?? ""
                                    if let contentId = currentList._id{
                                        CustomMoEngage.shared.sendEventForLockedContent(id: contentId)
                                        if let coin = currentList.coins{
                                            popOverVC.contentId = contentId
                                            popOverVC.coins = Int(coin)
                                            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                                            self.view.addSubview(popOverVC.view)
                                            popOverVC.didMove(toParent: self)
                                        }
                                    }
                                } else {
                                    
                                    NotificationCenter.default.addObserver(self, selector: #selector(TravelingViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                    
                                    self.present(playerViewController, animated: true) {
                                        self.playerViewController.player?.play()
                                        
                                    }
                                    self.callViewCountAPI(currentList._id ?? "", indexPath)
                                    self.addObeserVerOnPlayerViewController()
                        }
                    }
                } else {
                    if let url = currentList.video?.url {
                        let youtubeCode = URL(string: url)?.lastPathComponent
                        let videoPlayerViewController =
                            XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeCode)
                        NotificationCenter.default.addObserver(self, selector: #selector(TravelingViewController.moviePlayerPlaybackDidFinish(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: videoPlayerViewController.moviePlayer)
                        self.present(videoPlayerViewController, animated: true) {
                            
                            videoPlayerViewController.moviePlayer.play()
                        }
                        
                    }
                }
            }
        } else if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0{
            if !self.checkIsUserLoggedIn() {
                self.loginPopPop()
                return
            }
            CustomMoEngage.shared.sendEventForLockedContent(id: currentList._id ?? "")
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
            self.addChild(popOverVC)
            popOverVC.delegate = self
            popOverVC.contentIndex = indexPath.item
            popOverVC.currentContent = currentList
            popOverVC.selectedBucketCode = pageList?.code ?? ""
            popOverVC.selectedBucketName =  pageList?.name ?? ""
            if let contentId = currentList._id {
                if let coin = currentList.coins{
                    popOverVC.contentId = contentId
                    popOverVC.coins = Int(coin)
                    popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParent: self)
                }
            }
            
        } else if (currentList.type != nil && currentList.type == "poll" && currentList.photo != nil && currentList.photo?.cover != "" && currentList.photo?.cover != nil) {
            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
            SingleImageScrollViewController.storeDetailsArray = self.dataArray
            
            SingleImageScrollViewController.pageIndex = indexPath.row
            SingleImageScrollViewController.selectedBucketCode = pageList?.code ?? ""
            SingleImageScrollViewController.selectedBucketName = pageList?.name ?? ""
            self.pushAnimation()
            self.navigationController?.pushViewController(SingleImageScrollViewController, animated: false)
        } else if (currentList.type != nil && currentList.type == "poll" && currentList.video?.cover != nil && currentList.video?.url != nil) {
            if let videoURLStr = currentList.video?.url {
                if let videoURL = URL(string: videoURLStr) {
                    let player = AVPlayer(url: videoURL)
                    self.playerViewController.player = player
                    NotificationCenter.default.addObserver(self, selector: #selector(TravelingViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                    self.present(playerViewController, animated: true) {
                        self.playerViewController.player?.play()
                        
                    }
                    self.callViewCountAPI(currentList._id ?? "", indexPath)
                    self.addObeserVerOnPlayerViewController()
                }
            }
        } else if type == "photo" {
            if let isAlbum = currentList.is_album {
                if isAlbum == "true" {
                    let destViewController : AlbumViewController = Storyboard.main.instantiateViewController(viewController: AlbumViewController.self)
                    destViewController.pageList = pageList
                    if (GlobalFunctions.checkPartialPaidContentList(list:currentList)) {
                        destViewController.checkContentLock = true
                    } else {
                        destViewController.checkContentLock = false
                    }
                     destViewController.parentId = currentList._id ?? ""
                    destViewController.isAlbum = true
                    destViewController.albumName = currentList.name ?? ""
                    self.navigationController!.pushViewController(destViewController, animated: true)
                } else {
                    let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                    let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
                    SingleImageScrollViewController.storeDetailsArray = self.dataArray
                    
                    SingleImageScrollViewController.pageIndex = indexPath.row
                    SingleImageScrollViewController.selectedBucketCode = pageList?.code ?? ""
                    SingleImageScrollViewController.selectedBucketName = pageList?.name ?? ""
                    self.pushAnimation()
                    self.navigationController?.pushViewController(SingleImageScrollViewController, animated: false)
                }
            }
        }
        
    }


func addCloseButton() {
    let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
    //        button.backgroundColor = UIColor.black
    let image = UIImage(named: "backbutton") as UIImage?
    button.frame = CGRect(x: 20, y: 50, width: 35, height: 35)
    //        button.layer.cornerRadius = button.frame.height/2
    button.setImage(image, for: .normal)
    button.tintColor = UIColor.white
    button.addTarget(self, action: #selector(btnPressed(sender:)), for: .touchUpInside)
    self.view.addSubview(button)
    button.isHidden = false
}

@objc func btnPressed(sender: UIButton!) {
    self.navigationController?.navigationBar.isHidden = false
    
    sender.isHidden = true
}
@objc func didfinishplaying(note : NSNotification)
{
    playerViewController.dismiss(animated: true,completion: nil)
}

func getData(bRelaodData: Bool)
{
    if isFirstTime == true {
        //            self.showLoader()
        DispatchQueue.main.async {
            self.shimme1.isShimmering = true
            self.shimme1.isHidden = false
            
            self.shimme2.isShimmering = true
            self.shimme2.isHidden = false
            
            self.shimme3.isShimmering = true
            self.shimme3.isHidden = false
            
            self.shimme4.isShimmering = true
            self.shimme4.isHidden = false
            
            self.shimme5.isShimmering = true
            self.shimme5.isHidden = false
            
            self.shimme6.isShimmering = true
            self.shimme6.isHidden = false
            
            self.placeholderView.isHidden = false
        }
    }

    bucketId = pageList?._id ?? ""
    if Reachability.isConnectedToNetwork() == true
    {
        let age = UserDefaults.standard.value(forKey: "age_difference")
        
        if age != nil
        {
            self.ageDiff = age as? Int
        }
        
      
        if let bucketId = self.bucketId {
            if CurrentPageValue < noOfPages
            {
                CurrentPageValue = CurrentPageValue + 1
            } else {
                
                return
            }
          //  var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" + "&visibility=customer" + "&page=\(CurrentPageValue)" + "&v=\(Constants.VERSION)"
            
            var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" + "&page=\(CurrentPageValue)" + "&perpage=\(perPage)" + "&v=\(Constants.VERSION)" + "&age_restriction=\(self.ageDiff ?? 18)"
            
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let url = URL(string: strUrl)
            let request = NSMutableURLRequest(url: url!)
            
            request.httpMethod = "GET"
            //                    request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
            request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "ArtistId")
            request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
            request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                self.isFirstTime = false
                if error != nil{
                    print("error =>\(error?.localizedDescription)")
                    //                            self.stopLoader()
                    
                    DispatchQueue.main.async {
                        self.shimme1.isShimmering = false
                        self.shimme1.isHidden = true
                        
                        self.shimme2.isShimmering = false
                        self.shimme2.isHidden = true
                        
                        self.shimme3.isShimmering = false
                        self.shimme3.isHidden = true
                        
                        self.shimme4.isShimmering = false
                        self.shimme4.isHidden = true
                        
                        self.shimme5.isShimmering = false
                        self.shimme5.isHidden = true
                        
                        self.shimme6.isShimmering = false
                        self.shimme6.isHidden = true
                        
                        self.placeholderView.isHidden = true
                    }
                    self.flagIsFromLocalOrServer = true
                    if (self.database != nil) {
                        
                        self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                        self.checkIsBlockContentAndRemoveIt()
                        if self.dataArray.count != 0 {
                            DispatchQueue.main.async {
                                self.travelingTableView.reloadData()
                            }
                        }
                        
                    }
                    return
                }
                
                
                do {
                    if (data != nil) {
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        print("Photo json \(String(describing: json))")
                        //need to store total val & fetch it & add to arr & load tbl view
                        
                        if json?.object(forKey: "error") as? Bool == true {
                            
                            DispatchQueue.main.async {
                                self.flagIsFromLocalOrServer = true
                                //                                    self.stopLoader()
                                
                                DispatchQueue.main.async {
                                    self.shimme1.isShimmering = false
                                    self.shimme1.isHidden = true
                                    
                                    self.shimme2.isShimmering = false
                                    self.shimme2.isHidden = true
                                    
                                    self.shimme3.isShimmering = false
                                    self.shimme3.isHidden = true
                                    
                                    self.shimme4.isShimmering = false
                                    self.shimme4.isHidden = true
                                    
                                    self.shimme5.isShimmering = false
                                    self.shimme5.isHidden = true
                                    
                                    self.shimme6.isShimmering = false
                                    self.shimme6.isHidden = true
                                    
                                    self.placeholderView.isHidden = true
                                }
                                
                                self.spinner.stopAnimating()
                                let arr = json?.object(forKey: "error_messages")! as! NSMutableArray
                                self.showToast(message: arr[0] as! String)
                            }
                            
                        } else if (json?.object(forKey: "status_code") as? Int == 200) {
                            if let AllData = json?.object(forKey: "data") as? NSMutableDictionary
                            {
                                //                                        if let contentPart = AllData.object(forKey: "contents") as? NSMutableDictionary
                                //                                        {
                                if  let paginationData = AllData.object(forKey: "paginate_data") as? NSMutableDictionary{
                                    self.totalImagesCount  = paginationData.object(forKey: "total") as! Int
                                    self.noOfPages  = paginationData.object(forKey: "last_page") as! Int
                                    self.CurrentPageValue  = paginationData.object(forKey: "current_page") as! Int
                                }
                                //                                        }
                            }
                            
                            let gai = GAI.sharedInstance()
                            if let event = GAIDictionaryBuilder.createEvent(withCategory: "Home \(self.navigationTittle) Screen ios", action: "API Pagination Number \(self.CurrentPageValue) (ios) ", label: "Success", value: nil).build() as? [AnyHashable : Any] {
                                gai?.defaultTracker.send(event)
                                
                            }
                            
                            DispatchQueue.main.async {
                                
                                
                                if let dictData = json?.object(forKey: "data") as? NSMutableDictionary{
                                    
                                    if let photoDetailsArr = dictData.object(forKey: "list") as? NSMutableArray{
                                        
                                        self.database.createSocialJunctionTable()
                                        self.database.createStatsTable()
                                        self.database.createVideoTable()
                                        for dict in photoDetailsArr{
                                            
                                            let list : List = List(dictionary: dict as! NSDictionary)!
                                            if (!GlobalFunctions.checkContentBlockId(id: list._id!)) {
                                                self.database.insertIntoSocialTable(list:list, datatype: self.pageList?.code ?? "")
                                                let pollStat = self.database.getPollData(content_Id: list._id ?? "")
                                                
                                                if pollStat.count > 0 {
                                                    list.pollStat = pollStat
                                                }
                                                
                                                self.dataArray.append(list)
                                            }
                                        }
                                        if self.checkIsUserLoggedIn() {
                                            self.getUserMetaDataNew()
                                        }
                                      
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                
                                self.refreshControl.endRefreshing()
                                if (self.dataArray.count == 0) {
                                    self.CurrentPageValue = self.CurrentPageValue + 1
                                    self.getData(bRelaodData: true)
                                }
                            }
                        }
                    }
                    //                            self.stopLoader()
                    DispatchQueue.main.async {
                        self.shimme1.isShimmering = false
                        self.shimme1.isHidden = true
                        
                        self.shimme2.isShimmering = false
                        self.shimme2.isHidden = true
                        
                        self.shimme3.isShimmering = false
                        self.shimme3.isHidden = true
                        
                        self.shimme4.isShimmering = false
                        self.shimme4.isHidden = true
                        
                        self.shimme5.isShimmering = false
                        self.shimme5.isHidden = true
                        
                        self.shimme6.isShimmering = false
                        self.shimme6.isHidden = true
                        
                        self.placeholderView.isHidden = true
                        
                        if bRelaodData
                        {
                            self.travelingTableView.reloadData()
                        }
                    }
                    
                } catch let error as NSError {
                    print("error 2 =>\(error)")
                    //                            self.stopLoader()
                    DispatchQueue.main.async {
                        self.shimme1.isShimmering = false
                        self.shimme1.isHidden = true
                        
                        self.shimme2.isShimmering = false
                        self.shimme2.isHidden = true
                        
                        self.shimme3.isShimmering = false
                        self.shimme3.isHidden = true
                        
                        self.shimme4.isShimmering = false
                        self.shimme4.isHidden = true
                        
                        self.shimme5.isShimmering = false
                        self.shimme5.isHidden = true
                        
                        self.shimme6.isShimmering = false
                        self.shimme6.isHidden = true
                        
                        self.placeholderView.isHidden = true
                    }
                    self.flagIsFromLocalOrServer = true
                    if (self.database != nil) {
                        
                        self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                        self.checkIsBlockContentAndRemoveIt()
                        if self.dataArray.count != 0 {
                            DispatchQueue.main.async {
                                self.travelingTableView.reloadData()
                            }
                        }
                        
                    }
                    
                }
                
                
            }
            task.resume()
            
        }
        
        
    } else
    {
        self.flagIsFromLocalOrServer = true
        self.showToast(message: Constants.NO_Internet_MSG)
        //            self.stopLoader()
        DispatchQueue.main.async {
            self.shimme1.isShimmering = false
            self.shimme1.isHidden = true
            
            self.shimme2.isShimmering = false
            self.shimme2.isHidden = true
            
            self.shimme3.isShimmering = false
            self.shimme3.isHidden = true
            
            self.shimme4.isShimmering = false
            self.shimme4.isHidden = true
            
            self.shimme5.isShimmering = false
            self.shimme5.isHidden = true
            
            self.shimme6.isShimmering = false
            self.shimme6.isHidden = true
            
            self.placeholderView.isHidden = true
        }
        self.refreshControl.endRefreshing()
        if (self.database != nil) {
            
            self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
            self.checkIsBlockContentAndRemoveIt()
            if self.dataArray.count != 0 {
                DispatchQueue.main.async {
                    self.travelingTableView.reloadData()
                }
            }
        }
    }
}

    func getUserMetaDataNew()
    {
        let api = Constants.App_BASE_URL + Constants.META_ID + Constants.artistId_platform
        
        let headers: HTTPHeaders = [
                    "Content-Type": "application/json",
                    "Authorization": Constants.TOKEN,
                    "ApiKey": Constants.API_KEY,
                    "ArtistId": Constants.CELEB_ID,
                    "Platform": Constants.PLATFORM_TYPE,
                    "platform": Constants.PLATFORM_TYPE,
                    "V": Constants.VERSION,
                    ]
         
        Alamofire.request(api, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_) :
               if let json = resp.result.value as? NSDictionary
               {
                if let data = json["data"] as? NSDictionary
                {
                    if let purchaseContentData = data["purchase_content_data"] as? [[String: Any]]
                    {
                        
                        for (cIndex,lcData) in self.dataArray.enumerated()
                        {
                            let lcId = lcData._id
                            
                            for lcdict in purchaseContentData
                            {
                                let id = lcdict["_id"] as? String
                                
                                if id == lcId
                                {
                                    let purchasephoto = lcdict["photo"] as? [String : Any]
                                    let lcPhoto = Photo(dict: purchasephoto)
                                    
                                   self.dataArray[cIndex].photo = lcPhoto
                                    
                                  
                                }
                            }
                        }
                        
                       
                            DispatchQueue.main.async {
                                
                                self.travelingTableView.reloadData()
                            }
                        
                       
                        
                    }
                }
               }
                
                
                
                break
                
            case .failure(_) :
                break
                
            }
            
            
        }
         
    
    }

var arrSinglePhotoData = NSMutableArray()
func showSinglePics()
{
    if arrData.count > 0
    {
        if prevPageValue < CurrentPageValue || totalImagesCount > arrSinglePhotoData.count
        {
            prevPageValue = CurrentPageValue
            for i in 0...arrData.count - 1
            {
                let dict = arrData.object(at: i) as! NSMutableDictionary
                arrSinglePhotoData.add(dict)
            }
            
            
        }
    }
    
    DispatchQueue.main.async {
        self.travelingTableView.reloadData()
       
    }
    
    
}

func displayLayout()
    
{
    if arrData.count > 0
    {
        if prevPageValue < CurrentPageValue || totalImagesCount > imgArr.count
        {
            prevPageValue = CurrentPageValue
            for i in 0...arrData.count - 1
            {
                if let dict = self.arrData.object(at: i) as? NSMutableDictionary{
                    
                    if (!GlobalFunctions.checkContentBlockId(id: dict.value(forKey: "_id") as! String)) {
                        
                        if let states = dict.object(forKey: "stats") as? NSMutableDictionary {
                            
                            //                        if GlobalFunctions.checkContentsLock(dictionary: dict) {
                            let comments = states.object(forKey: "comments") as! NSNumber
                            let likes = states.object(forKey: "likes") as! NSNumber
                            //                            is_like.append((Int(dict.object(forKey: "is_like") as! NSNumber)))
                            let shares = states.object(forKey: "shares") as! NSNumber
                            let type = (dict.object(forKey: "type") as! String)
                            
                            
                            
                            if type == "photo"{
                                if let photoDetails = (dict.object(forKey: "photo") as? NSMutableDictionary)
                                {
                                    imgArr.add(photoDetails.object(forKey: "cover") as! String)
                                    
                                    statusArray.add(statusDict)
                                    
                                    var newDict = NSMutableDictionary()
                                    if dict.object(forKey: "is_album") != nil
                                    {
                                        
                                        if let nameCaption = dict.object(forKey: "name")
                                        {
                                            if let nameDays = dict.object(forKey: "date_diff_for_human")
                                            {
                                                
                                                if (dict.object(forKey: "is_album") as! String) == "true"
                                                {
                                                    newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                                } else
                                                {
                                                    newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                                }
                                            }
                                        } else
                                        {
                                            //                        if ((dict.object(forKey: "is_album") as Any) as AnyObject).intValue == 1
                                            if (dict.object(forKey: "is_album") as! String) == "true"
                                            {
                                                //                                    if (dict.object(forKey: "locked") as! String) == "true"
                                                //                                    {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares , "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                                //                                }
                                            } else
                                            {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                            }
                                        }
                                        
                                        //                        }
                                    } else
                                    {
                                        if let nameCaption = dict.object(forKey: "name")
                                        {
                                            newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": nameCaption, "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                        } else {
                                            newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                        }
                                    }
                                    
                                    arrStoredDetails.add(newDict)
                                } } else
                            {
                                
                                var newDict = NSMutableDictionary()
//                                if  dict.object(forKey: "is_album") != nil {
//
//                                }
                                
                                if dict.object(forKey: "is_album") as? String == "true"
                                {
                                    //                               if dict.object(forKey: "locked") as! String == "true"
                                    //                               {
                                    
                                    if ((dict.object(forKey: "is_album") as Any) as AnyObject).intValue == 1
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    } else
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    }
                                    //                            }
                                } else
                                {
                                    if let nameCaption = dict.object(forKey: "name")
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": nameCaption, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    } else {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    }
                                }
                                if let videosDict = dict.object(forKey: "video") as? NSDictionary {
                                    let videoType = videosDict.object(forKey: "player_type") as! String
                                    if videoType == "internal" {
                                        if let converImage = videosDict.object(forKey: "cover"), let url = videosDict.object(forKey: "url") {
                                            newDict.setValue(true, forKey: "video")
                                            newDict.setValue(url, forKey: "url")
                                            newDict.setValue(converImage, forKey: "videoURL")
                                            
                                            newDict.setValue(videoType, forKey: "videoType")
                                            imgArr.add(converImage)
                                            
                                        }
                                    } else {
                                        if let embedCode = videosDict.object(forKey: "embed_code") as? String {
                                            newDict.setValue(true, forKey: "video")
                                            let youtubeUrl = "https://www.youtube.com/embed/\(embedCode)"
                                            newDict.setValue(youtubeUrl, forKey: "url")
                                            newDict.setValue(videoType, forKey: "videoType")
                                            newDict.setValue(("https://i.ytimg.com/vi/\(embedCode)/mqdefault.jpg"), forKey: "videoURL")
                                            
                                            imgArr.add("https://i.ytimg.com/vi/\(embedCode)/mqdefault.jpg")
                                            
                                        }
                                    }
                                }
                                
                                arrStoredDetails.add(newDict)
                            }
                            //                        }
                        }
                    }
                }
            }
            
            if (arrStoredDetails.count == 0 ) {
                CurrentPageValue = CurrentPageValue + 1
                self.getData(bRelaodData: true)
            }
            DispatchQueue.main.async {
                self.travelingTableView.reloadData()
                
            }
            
        }
        
    }
    
    
}
    func checkIsBlockContentAndRemoveIt() {
        var indexOfArr = 0
        for list in dataArray {
            if GlobalFunctions.checkContentBlockId(id:list._id ?? "") {
               dataArray.remove(at: indexOfArr)
            }
            indexOfArr = indexOfArr + 1
        }
    }
    //MARK:- Partial Video
    func setHideForwardBackWardOnWindow() {
        let window = UIApplication.shared.keyWindow!
        hideforwardBackwardView = UIView.init(frame: CGRect(x: 0, y: window.bounds.height-110, width:window.bounds.width, height: 150))
        hideforwardBackwardView.backgroundColor = .clear
        hideforwardBackwardView.isHidden = true
        //        hideforwardBackwardView.alpha = 0.7
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = hideforwardBackwardView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hideforwardBackwardView.addSubview(blurEffectView)
        let lockImageView = UIImageView.init(frame: CGRect(x: (self.view.frame.width/2) - 15, y: (hideforwardBackwardView.frame.height/2) - 15, width: 30, height: 30))
        lockImageView.image = UIImage.init(named: "contetLock")
        lockImageView.contentMode = .scaleAspectFit
        //        hideforwardBackwardView.addSubview(lockImageView)
    }
    
    @objc func timerAction() {
        timer.invalidate()
        self.playerViewController.player?.pause()
        isSwipeVideo = false
        self.hideforwardBackwardView.removeFromSuperview()
        self.hideforwardBackwardView.isHidden = true
        if !self.hideforwardBackwardView.isHidden {
            self.playerViewController.dismiss(animated: true) { self.hideforwardBackwardView.removeFromSuperview()
                self.hideforwardBackwardView.isHidden = true
            }
        } else {
            self.playerViewController.dismiss(animated: true,completion: nil)
        }
        
        let dict = arrStoredDetails.object(at: selectedIndexs) as? NSMutableDictionary
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            return
        }
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
        self.addChild(popOverVC)
        popOverVC.delegate = self
        popOverVC.contentIndex = selectedIndexs
        popOverVC.currentContent = self.dataArray[selectedIndexs]
        popOverVC.selectedBucketCode = pageList?.code ?? ""
        popOverVC.selectedBucketName =  pageList?.name ?? ""
        if let contentId = dict?.value(forKey: "parentId") as? String{
            if let coin = dict?.value(forKey: "coins") as? String{
                popOverVC.contentId = contentId
                popOverVC.coins = Int(coin)
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:self.view.frame.height)
                
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        }
        
    }
    
    //MARK:- Viewvideo event
    func addObeserVerOnPlayerViewController() {
        self.playerViewController.player!.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === playerViewController.player {
            if keyPath == "rate" {
                
                if playerViewController.player!.rate > 0 {
                } else {
                    let watchedSec = playerViewController.player!.currentTime().seconds
                    if watchedSec.isNaN {return}
                    let durationSec = playerViewController.player?.currentItem?.duration.seconds
                    if durationSec!.isNaN {return}
                    let ratio = watchedSec / durationSec!
                    let fraction = ratio - floor(ratio)
                    let percentageDouble = 100 * fraction
                    let percentage = Int(round(percentageDouble))
                    print("watched % \(percentage)")
                    if let currentList = self.dataArray[self.selectedIndexs] as? List {
                        CustomMoEngage.shared.sendEventViewVide(id: currentList._id ?? "", coins: currentList.coins ?? 0, bucketCode:pageList?.code ?? "video", bucketName:pageList?.name ?? "video", videoName: currentList.caption ?? "", type: currentList.commercial_type ?? "", percent: percentage)
                    }
                }
            }
        }
    }
    @objc func moviePlayerPlaybackDidFinish(notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: notification.object)
        if let finishReason = notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as? Int {
            if finishReason == MPMovieFinishReason.playbackError.rawValue {
                let error = notification.userInfo![XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey]
                print(error!)
            }
        }
        
    }
    //MARK:- new Share & view API
    func callViewCountAPI(_ contentID: String ,_ index:IndexPath) {
        if !Reachability.isConnectedToNetwork() {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
            return
        }
        
        if !self.checkIsUserLoggedIn() {
            return
        }
        
        ServerManager.sharedInstance().updateShareViewCount(contentId: contentID, apiName: Constants.updateViewCountAPI) { (result) in
            switch result {
            case .success(let data):
                if let error = data["error"].bool{
                    if error {
                        return
                    } else {
                        if let statusCode = data["status_code"].int{
                            if statusCode != 200 {
                                return
                            }
                            let currentList = self.dataArray[index.row]
                            guard let type = currentList.type else {return}
                            
                            if type == "poll" {
                                guard let cell =  self.travelingTableView.cellForRow(at: index) as? PollTableViewCell else { return }
                                
                                DispatchQueue.main.async {
                                    if self.dataArray.count > index.row {
                                        let currentList = self.dataArray[index.row]
                                        var views = currentList.stats?.views ?? 0
                                        views = views + 1
                                        cell.videoViewCountLabel.text = "\(views.roundedWithAbbreviations)"
                                        currentList.stats?.views = views
                                        self.dataArray[index.row] = currentList
                                    }
                                    self.travelingTableView.reloadRows(at: [index], with: .none)
                                }
                                
                            } else {
                                guard let cell =  self.travelingTableView.cellForRow(at: index) as? MainTableViewCell else { return }
                                DispatchQueue.main.async {
                                    if self.dataArray.count > index.row {
                                        let currentList = self.dataArray[index.row]
                                        var views = currentList.stats?.views ?? 0
                                        views = views + 1
                                        cell.viewVideoCountLabel.text = "\(views.roundedWithAbbreviations)"
                                        currentList.stats?.views = views
                                        self.dataArray[index.row] = currentList
                                    }
                                    self.travelingTableView.reloadRows(at: [index], with: .none)
                                }
                            }
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }
            print("result of view count api\(result)")
        }
    }
}
//MARK:- PollTableViewCellDelegate
extension TravelingViewController:PollTableViewCellDelegate {
    func didLikePollButton(_ sender: UIButton) {
        let socialPost = self.dataArray[sender.tag]
        
        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:"User not logged in", extraParamDict: nil)
            return
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        guard let cell =  self.travelingTableView.cellForRow(at: indexPath) as? PollTableViewCell else {
            return
        }
        if let socialPostId = socialPost._id, self.is_like.contains(socialPostId) {
            self.animateDidLikeButton(cell.likeButton)
            return
        }
        if let likeCount = Int(cell.likeCountLabel.text!) {
            cell.likeCountLabel.text = (likeCount + 1).roundedWithAbbreviations
        }
        self.animateDidLikeButton(cell.likeButton)
        
        if (!self.is_like.contains(socialPost._id ?? "")) {
            self.is_like.append(socialPost._id ?? "")
        }
        if Reachability.isConnectedToNetwork()
        {
            if (dataArray != nil && dataArray.count > 0) {
                
                let dict = ["content_id": socialPost._id ?? "", "like": "true"] as [String: Any] //
                print(dict)
                if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                    
                    let url = NSURL(string: Constants.App_BASE_URL + Constants.LIKE_SAVE)!
                    let request = NSMutableURLRequest(url: url as URL)
                    
                    request.httpMethod = "POST"
                    request.httpBody = jsonData
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                    request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "ArtistId")
                    request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
                    request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                        if error != nil{
                            self.showToast(message: Constants.NO_Internet_MSG)
                            GlobalFunctions.trackEvent(eventScreen: "Home News Feed Screen", eventName: "Like", eventPostTitle: "Error : \(error?.localizedDescription ?? "")", eventPostCaption: "", eventId: socialPost._id ?? "")
                            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: nil)
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("Photo json \(String(describing: json))")
                            
                            
                            if json?.object(forKey: "error") as? Bool == true {
                                var errorString = "Error"
                                if let arr = json?.object(forKey: "error_messages") as? NSMutableArray{
                                    errorString = "Error : \(arr[0] as! String)"
                                }
                                GlobalFunctions.trackEvent(eventScreen: "Home News Feed Screen", eventName: "Like", eventPostTitle: errorString, eventPostCaption: "", eventId: socialPost._id ?? "")
                                CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: errorString, extraParamDict: nil)
                            } else if (json?.object(forKey: "status_code") as? Int == 200)
                            {
                                GlobalFunctions.trackEvent(eventScreen: "Home News Feed Screen", eventName: "Like", eventPostTitle: "Success", eventPostCaption: "", eventId: socialPost._id ?? "")
                                DispatchQueue.main.async {
                                    
                                    if !self.likeSelectedArray.contains(cell.likeTapButton.tag) {
                                        self.likeSelectedArray.append(cell.likeTapButton.tag)
                                    }
                                    if let contentId = socialPost._id {
                                        CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Success", reason: "", extraParamDict: nil)
                                        GlobalFunctions.saveLikesIdIntoDatabase(content_id: socialPost._id ?? "")
                                    }
                                }
                                
                            }
                            
                        } catch let error as NSError {
                            print(error)
                            GlobalFunctions.trackEvent(eventScreen: "Home News Feed Screen", eventName: "Like", eventPostTitle: "Error : \(error.localizedDescription)", eventPostCaption: "", eventId: socialPost._id ?? "")
                            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: "Error : \(error.localizedDescription)", extraParamDict: nil)
                        }
                        
                    }
                    task.resume()
                }
            }
        } else {
            
            if (dataArray != nil && dataArray.count > 0) {
                
                if let contentId = dataArray[indexPath.row]._id {
                    GlobalFunctions.saveLikesIdIntoDatabase(content_id: contentId as String)
                    if (!self.is_like.contains(contentId ?? "")) {
                        self.is_like.append(contentId ?? "")
                    }
                }
            }
        }
        
        //                }
        
        
    }
    
    func reloadCellOfTableView(index: Int) {
        travelingTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func showLoginAlert() {
       self.loginPopPop()
    }
    
    func didTapCommentButton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let CommentViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
            if (dataArray != nil && dataArray.count > 0) {
                let dict = self.dataArray[sender.tag]
                CommentViewController.postId = dict._id ?? ""
                CommentViewController.screenName = "Home News Feed Screen"
                self.pushAnimation()
                self.navigationController?.pushViewController(CommentViewController, animated: false)
            }
            
        }
    }
    
    func didSharePollButton(_ sender: UIButton) {
        didShareButton(sender)
    }
    
    func didTapOpenPollOptions(_ sender: UIButton) {
        didTapOpenOptions(sender)
    }
    
    func didTapOpenPollPurchase(_ sender: UIButton) {
        didTapOpenPurchase(sender)
    }
    
    func showPurchaseAlert() {
        self.showToast(message: "Please unlock the content before submit poll")
    }
}
