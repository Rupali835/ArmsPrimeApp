//
//  VideosViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 18/04/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AVKit
import SDWebImage
import XCDYouTubeKit
import Shimmer
import FirebaseDynamicLinks

import CoreSpotlight
import MobileCoreServices
import SafariServices

class VideosViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource, VideoTableViewCellDelegate, PurchaseContentProtocol{
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var imageiew: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var captionView: UIView!
    
    @IBOutlet weak var imageiew1: UIView!
    @IBOutlet weak var nameView1: UIView!
    @IBOutlet weak var captionView1: UIView!
    
    @IBOutlet weak var imageiew2: UIView!
    @IBOutlet weak var nameView2: UIView!
    @IBOutlet weak var captionView2: UIView!
    
    var viewActivityLarge : SHActivityView?
    var flagIsFromLocalOrServer = false
    let reachability = Reachability()
    
    @IBOutlet var internetConnectionLostView: UIView!
    @IBOutlet var retryAgainButton: UIButton!
    
    @IBOutlet weak var videoTableView: UITableView!
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
    var isFirstTime = true

    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView!
    var videosArray : [List] = [List]()
    var bucketsArray : [List]!
    var timer = Timer()
    @objc var percentageTimer = Timer()
    var selectedlikeButton = [IndexPath]()
    var selectedIndexs = 0
    var isTableLoaded : Bool!
    var block: DispatchWorkItem?
    var bucketid: String = ""
    var postId = ""
    var bucketId: String?
    var bucketCodeStr: String?
    var isLogin = false
    var pageNumber = 0
    var currentPage = 0
    var totalPages = 0
    var totalItems = 0
    let spinner = UIActivityIndicatorView(style: .white)
    let database = DatabaseManager.sharedInstance
    
    var shimme1 = FBShimmeringView()
    var shimme2 = FBShimmeringView()
    var shimme3 = FBShimmeringView()
    var shimme4 = FBShimmeringView()
    var shimme5 = FBShimmeringView()
    var shimme6 = FBShimmeringView()
    var shimme7 = FBShimmeringView()
    var shimme8 = FBShimmeringView()
    var shimme9 = FBShimmeringView()
    var contetid:String = ""
    var hideforwardBackwardView: UIView!
    var isSwipeVideo: Bool = true
    var pageList: List?
    var projects:[[String]] = []

    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = hexStringToUIColor(hex: MyColors.primaryDark)
        
        //        if contetid != "" {
        //
        //            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
        //            let BucketContentDetailsViewController = mainstoryboad.instantiateViewController(withIdentifier: "BucketContentDetailsViewController") as! BucketContentDetailsViewController
        //            BucketContentDetailsViewController.contedID = contetid
        //
        //            self.navigationController?.pushViewController(BucketContentDetailsViewController, animated: true)
        //        }
        
        shimme1 = FBShimmeringView(frame: self.imageiew.frame)
        shimme1.contentView = imageiew
        view.addSubview(shimme1)
        shimme1.isShimmering = true
        
        shimme2 = FBShimmeringView(frame: self.nameView.frame)
        shimme2.contentView = nameView
        view.addSubview(shimme2)
        shimme2.isShimmering = true
        
        shimme3 = FBShimmeringView(frame: self.captionView.frame)
        shimme3.contentView = captionView
        view.addSubview(shimme3)
        shimme3.isShimmering = true
        
        shimme4 = FBShimmeringView(frame: self.imageiew1.frame)
        shimme4.contentView = imageiew1
        view.addSubview(shimme4)
        shimme4.isShimmering = true
        
        shimme5 = FBShimmeringView(frame: self.nameView1.frame)
        shimme5.contentView = nameView1
        view.addSubview(shimme5)
        shimme5.isShimmering = true
        
        shimme6 = FBShimmeringView(frame: self.captionView1.frame)
        shimme6.contentView = captionView1
        view.addSubview(shimme6)
        shimme6.isShimmering = true
        
        shimme7 = FBShimmeringView(frame: self.imageiew2.frame)
        shimme7.contentView = imageiew2
        view.addSubview(shimme7)
        shimme7.isShimmering = true
        
        shimme8 = FBShimmeringView(frame: self.nameView2.frame)
        shimme8.contentView = nameView2
        view.addSubview(shimme8)
        shimme8.isShimmering = true
        
        shimme9 = FBShimmeringView(frame: self.captionView2.frame)
        shimme9.contentView = captionView2
        view.addSubview(shimme9)
        shimme9.isShimmering = true
        
        self.placeholderView.isHidden = true
        
        pageNumber = 1
        isTableLoaded = false
        self.tabBarController?.tabBar.isHidden = false
        self.internetConnectionLostView.isHidden = true
        //        self.navigationItem.title = "VIDEOS"
        //            self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.white]
        self.setNavigationView(title: (pageList?.name ?? "").uppercased())
        self.videosArray = [List]()
        arrStoredDetails.removeAllObjects()
        arrData.removeAllObjects()
        imgArr.removeAllObjects()
        imageArray.removeAllObjects()
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        projects.append( [writePath] )
        //         projects.append( [self.setNavigationView ?? ""] )
        //          //projects.append( [self.setNavigationView(title: "VIDEOS")] )
        //        projects.append( [title: "VIDEOS" ?? ""] )

                index(item: 0)
        self.videosArray = [List]()
        /*  self.bucketsArray =  database.getBucketListing()
         
         
         if (self.bucketsArray != nil && self.bucketsArray.count > 0) {
         for list in self.bucketsArray{
         BucketValues.bucketTitleArr.append(list.caption ?? "")
         BucketValues.bucketIdArray.append(list._id!)
         }
         self.getData()
         self.displayLayout()
         
         
         }
         else  if BucketValues.bucketContentArr.count > 0 {
         self.getData()
         } else {
         self.getBuketData(completion: { (result) in
         if let id = result["data"]["list"][2]["_id"].string {
         self.bucketId = id
         }
         BucketValues.bucketContentArr = NSMutableArray(array: result["data"]["list"].arrayObject!)
         self.getData()
         })
         }*/
        
        videoTableView.allowsMultipleSelection = false
        
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }
        
        //            let backgroundImage = UIImage(named: "background")
        //            let imageView = UIImageView(image: backgroundImage)
        //            self.videoTableView.backgroundView = imageView
        
        videoTableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        videoTableView.register(UINib(nibName: "PollTableViewCell", bundle: nil), forCellReuseIdentifier: "PollTableViewCell")
        self.videoTableView.estimatedRowHeight = UITableView.automaticDimension
        //        self.videoTableView.rowHeight = 367//UITableViewAutomaticDimension
        //        self.videoTableView.estimatedRowHeight = videoTableView.rowHeight
//        self.videoTableView.setNeedsUpdateConstraints()
        

        
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
        
        
        //        addSlideMenuButton()
        setHideForwardBackWardOnWindow()
        getData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.isNavigationBarHidden = false
        if BucketValues.bucketIdArray.count > 0 {
            if #available(iOS 10.0, *) {
                videoTableView.refreshControl = refreshControl
            } else {
                videoTableView.addSubview(refreshControl)
            }
            //            if playerViewController != nil {
            //                print("player view time \(playerViewController.player?.currentItem?.duration)")
            //            }
            
            refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
            refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)//UIColor(red:255, green:255, blue:255, alpha:1.0)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.hideforwardBackwardView.isHidden && isSwipeVideo{
            self.hideforwardBackwardView.removeFromSuperview()
            self.hideforwardBackwardView.isHidden = true
            self.isSwipeVideo = false
        }
        timer.invalidate()
        isTableLoaded = true
        if let index = GlobalFunctions.sortedTabMenuArrayIndex(code: pageList?.code ?? "") {
            if index < 3 {
                self.tabBarController?.viewControllers?[index].tabBarItem.badgeValue = nil
            }
        }
        GlobalFunctions.screenViewedRecorder(screenName: "Home Videos Screen")
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Home_Videos_Tab", extraParamDict: nil)
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        
        if let reachability = note.object as? Reachability {
            
            switch reachability.connection {
            case .wifi:
                
                print("Reachable via WiFi")
            case .cellular:
                
                print("Reachable via Cellular")
            case .none:
                if  self.videosArray.count == 0 {
                    self.internetConnectionLostView.isHidden = false
                }
                print("Network not reachable")
            }
        }
    }
    
    func didTapWebview(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() {
            let currentList : List = self.videosArray[sender.tag]
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebviewUrlViewController") as! WebviewUrlViewController
            resultViewController.webViewName = currentList.webview_label!
            resultViewController.storeDetailsArray = self.videosArray
            
            resultViewController.pagindex = sender.tag
            
            self.navigationController?.pushViewController(resultViewController, animated: true)
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    
    @IBAction func retryAgainClick(_ sender: UIButton) {
        if self.videosArray.count == 0 {
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
                
                self.shimme7.isShimmering = true
                self.shimme7.isHidden = false
                
                self.shimme8.isShimmering = true
                self.shimme8.isHidden = false
                
                self.shimme9.isShimmering = true
                self.shimme9.isHidden = false
                
                self.placeholderView.isHidden = false
            }
            
            self.getData()
            if  self.videosArray.count > 0 {
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
        self.pageNumber = 1
        self.imgArr.removeAllObjects()
        self.arrData.removeAllObjects()
        self.arrStoredDetails.removeAllObjects()
        self.arrSinglePhotoData.removeAllObjects()
        self.videosArray.removeAll()
        _ = self.getOfflineUserData()
        
        self.getData()
        
    }
    func didTapButton(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let CommentTableViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        if (self.videosArray != nil && self.videosArray.count > 0) {
            
            let dict : List = self.videosArray[sender.tag]
            let postId = dict._id
            CommentTableViewController.postId = postId ?? ""
            CommentTableViewController.screenName = "Home Videos Screen"
            projects.append( [postId ?? ""] )
                       projects.append( [CommentTableViewController.screenName] )
                        index(item: 0)
            self.navigationController?.pushViewController(CommentTableViewController, animated: true)
        }
        
    }
    
    func didShareButton(_ sender: UIButton) {
        if !Reachability.isConnectedToNetwork() {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
            return
        }
        
        let content = videosArray[sender.tag]
        
        var params: String = " "
        params += "&bucket_code=" + "\(pageList?.code ?? "")"
        params += "&content_id=" + "\(content._id ?? "")"
        
        let stringUrl: String = Constants.officialWebSitelink + params
        let link: URL = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        projects.append( [stringUrl ] )
        index(item: 0)
        if let components = DynamicLinkComponents(link: link, domainURIPrefix:  Constants.appLink) {
            components.iOSParameters = DynamicLinkIOSParameters(bundleID: Constants.appBundleID)
            components.androidParameters = DynamicLinkAndroidParameters(packageName: Constants.androidPackageID)
            
            
            components.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
            components.navigationInfoParameters?.isForcedRedirectEnabled = true
            
            components.options = DynamicLinkComponentsOptions()
            components.options?.pathLength = .unguessable
            
        components.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            components.socialMetaTagParameters?.title = Constants.celebrityAppName
            components.socialMetaTagParameters?.descriptionText = content.name
            
            var thumbUrl: String?
            
            let coins: Int = content.coins ?? 0
            if content.type == "photo" {
                thumbUrl = coins == 0 ? content.photo?.thumb : AppConstants.appThumbnail
            } else if content.type == "video" {
                thumbUrl = content.video?.cover
            }
            
            
            components.socialMetaTagParameters?.imageURL = URL(string: thumbUrl ?? "")
            print("long link: " + (components.url?.absoluteString)!)
            
            components.shorten { (shortURL, warnings, error) in
                if  shortURL != nil {
                    print("short link: " + (shortURL?.absoluteString)! )
                    let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,shortURL], applicationActivities: nil)
                    viewController.popoverPresentationController?.sourceView = self.view
                    viewController.navigationController?.navigationBar.tintColor = UIColor.gray
                    
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
        let payloadDict = NSMutableDictionary()
        payloadDict.setObject(content._id ?? "", forKey: "content_id" as NSCopying)
        CustomMoEngage.shared.sendEvent(eventType: MoEventType.share, action: "", status: "Success", reason: "", extraParamDict: payloadDict)
    }
    
    func didLikeButton(_ sender: UIButton) {
        
        let socialPost = self.videosArray[sender.tag]
        
        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:  "User not logged in", extraParamDict: nil)
            return
        }
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        guard let cell =  self.videoTableView.cellForRow(at: indexPath) as? VideoTableViewCell else {
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
            if (videosArray != nil && videosArray.count > 0) {
                
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
                            GlobalFunctions.trackEvent(eventScreen: "Home Videos Screen", eventName: "Like", eventPostTitle: "Error : \(error?.localizedDescription ?? "")", eventPostCaption: "", eventId: socialPost._id!)
                            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: nil)
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            if json?.object(forKey: "error") as? Bool == true {
                                var errorString = "Error"
                                if let arr = json?.object(forKey: "error_messages") as? NSMutableArray{
                                    errorString = "Error : \(arr[0] as! String)"
                                }
                                GlobalFunctions.trackEvent(eventScreen: "Home Videos Screen", eventName: "Like", eventPostTitle: errorString, eventPostCaption: "", eventId: socialPost._id!)
                                CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: errorString, extraParamDict: nil)
                            } else if (json?.object(forKey: "status_code") as? Int == 200)
                            {
                                
                                GlobalFunctions.trackEvent(eventScreen: "Home Videos Screen", eventName: "Like", eventPostTitle: "Success", eventPostCaption: "", eventId: socialPost._id!)
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
                            GlobalFunctions.trackEvent(eventScreen: "Home Videos Screen", eventName: "Like", eventPostTitle: "Error : \(error.localizedDescription)", eventPostCaption: "", eventId: socialPost._id!)
                            
                            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: "Error : \(error.localizedDescription)", extraParamDict: nil)
                        }
                        
                    }
                    task.resume()
                }
            }
        } else {
            
            if (videosArray != nil && videosArray.count > 0) {
                
                let contentId = videosArray[indexPath.row]._id
                GlobalFunctions.saveLikesIdIntoDatabase(content_id: contentId as! String)
                if (!self.is_like.contains(contentId ?? "")) {
                    self.is_like.append(contentId ?? "")
                }
                
            }
        }
        
        //                }
        
        
    }
    
    func didTapOpenPurchase(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() == true
        {
            if !self.checkIsUserLoggedIn() {
                self.loginPopPop()
                return
            }
            
            let currentIndex = sender.tag
            if let currentList = self.videosArray[currentIndex] as? List {
                
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
            }
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
        
    }
    
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        
        let currentList : List = self.videosArray[index]
        if let type = currentList.type , type == "poll"{
            self.videoTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        } else {
            if let cell : VideoTableViewCell = self.videoTableView.cellForRow(at: IndexPath.init(item: index, section: 0)) as? VideoTableViewCell{
                cell.optionsTap.isHidden  = false
                cell.optionButton.isHidden = false
                cell.blurView.isHidden = true
                //            cell.optionButton.backgroundColor = UIColor.black.withAlphaComponent(0.20)
                cell.unlockImageView.isHidden = false
                cell.unlockdView.isHidden = false
                cell.premiumView.isHidden = true
                
            } }
//        self.showToast(message: "Unlocked Successfully")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
        
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
    
    func hideContent(sender: UIButton) {
        if (Reachability.isConnectedToNetwork() == true) {
            
            let alert = UIAlertController(title: "You won't see this content again.", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if self.isLogin {
                    
                    _ = self.getOfflineUserData()
                    
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    guard let cell =  self.videoTableView.cellForRow(at: indexPath) as? VideoTableViewCell else {
                        return
                    }
                    let dict : List = self.videosArray[indexPath.row]
                    let contentId = dict._id
                    let customerId = CustomerDetails.custId
                    
                    if (self.database != nil) {
                        
                        self.database.createHideTable()
                        if (contentId != nil && customerId != nil) {
                            self.database.insertIntoHideContent(content: contentId ?? "", customer: customerId!)
                            
                            GlobalFunctions.sendBLockContentToServer(content: contentId!)
                        }
                    }
                    if ( self.arrStoredDetails != nil && self.arrStoredDetails.count > 0) {
                        
                        self.arrStoredDetails.removeObject(at: indexPath.row)
                        self.imgArr.removeObject(at: indexPath.row)
                    }
                    self.videosArray.remove(at: indexPath.row)
                    
                    _ = self.getOfflineUserData()
                    self.videoTableView.reloadData()
                    
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  videosArray != nil &&  videosArray.count > 0
        {
            return videosArray.count
        } else
        {
            return 0
        }
    }
    var player: AVPlayer?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //guard
            let currentList : List = self.videosArray[indexPath.row]  //else  { return UITableViewCell()}
       
        if let type = currentList.type , type == "poll"{
            let cell = videoTableView.dequeueReusableCell(withIdentifier: "PollTableViewCell", for: indexPath) as! PollTableViewCell
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
            let cell = videoTableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath)as! VideoTableViewCell
            
            isTableLoaded = true
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            cell.likeButton.imageView?.image = nil
            cell.profileImageView.image = nil
            cell.unlockImageView.isHidden = true
            cell.unlockdView.isHidden = true
            
            if self.videosArray.count > 0 && self.videosArray.count >= indexPath.row
            {
                let currentList : List = self.videosArray[indexPath.row]
                if (!GlobalFunctions.checkContentBlockId(id: currentList._id ?? "")) {
                    
                    cell.blurView.isHidden = true
                    
                    if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0{
                        
                        if currentList.partial_play_duration != nil && currentList.partial_play_duration != "" && currentList.partial_play_duration != "0" {
                            
                            cell.optionsTap.isHidden  = false
                            cell.optionButton.isHidden = false
                            cell.premiumView.isHidden = false
                            cell.blurView.isHidden = true
                            
                        } else {
                            cell.premiumView.isHidden = false
                            cell.blurView.isHidden = true
                            cell.optionsTap.isHidden  = true
                            //                    cell.optionButton.alpha = 0
                            cell.optionButton.isHidden = true
                            let strCoins : String = "\(currentList.coins ?? 0)"
//                            cell.unlockPriceLabel.text = "Unlock premium content for \(strCoins) coins."
                            
                        }
                        
                    } else {
                        
                        if (GlobalFunctions.isContentsPurchased(list: currentList)) {
                            cell.unlockImageView.isHidden = false
                            cell.unlockdView.isHidden = false
                            cell.premiumView.isHidden = true
                        }
                        cell.optionsTap.isHidden  = false
                        cell.optionButton.isHidden = false
                        //                    cell.optionButton.backgroundColor = UIColor.black.withAlphaComponent(0.20)
                        
                    }
                    
                    cell.profileImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
                    cell.profileImageView.layer.shadowColor = UIColor.black.cgColor
                    cell.profileImageView.layer.shadowRadius = 6
                    cell.profileImageView.layer.shadowOpacity = 0.50
                    cell.profileImageView.layer.masksToBounds = false;
                    
                    
                    if (currentList.video?.player_type == "internal") {
                        if let urlString = currentList.video?.cover as? String {
                            cell.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                            cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.profileImageView.sd_imageTransition = .fade
                            cell.profileImageView.sd_setImage(with: URL(string: urlString), completed: nil)
                            cell.profileImageView.contentMode = .scaleAspectFill
                            cell.profileImageView.clipsToBounds = true
                            
                        }
                    } else {
                        
                        let embedCode = currentList.video?.embed_code
                        //                            let youtubeUrl = "https://www.youtube.com/embed/\(embedCode)"
                        if (embedCode != nil && embedCode != "") {
                            let youtubeUrl = "https://i.ytimg.com/vi/\(embedCode!)/mqdefault.jpg"
                            cell.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                            cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.profileImageView.sd_imageTransition = .fade
                            cell.profileImageView.sd_setImage(with: URL(string: youtubeUrl), completed: nil)
                            cell.profileImageView.contentMode = .scaleAspectFill
                            cell.profileImageView.clipsToBounds = true
                            
                        }
                    }
                    
                    cell.shareTap.tag = indexPath.row
                    cell.likeTap.tag = indexPath.row
                    cell.commentTap.tag = indexPath.row
                    cell.optionsTap.tag = indexPath.row
                    
                    cell.delegate = self
                    
                    
                    if self.videosArray.count > 0
                    {
                        if  let currentList = self.videosArray[indexPath.row] as? List{
                            if (self.isLogin) {
                                if (GlobalFunctions.checkContentLikeId(id: currentList._id!) || self.is_like.contains(currentList._id ?? "")) {
                                    cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
                                } else {
                                    cell.likeButton.setImage(UIImage(named: "newUnlike"), for: .normal)
                                }
                                
                            }
                            
                            if let isCaption = currentList.date_diff_for_human
                            {
                                cell.daysLabel.isHidden = false
                                cell.daysLabel.text = isCaption.captalizeFirstCharacter()
                            }
                            
                            if currentList.commentbox_enable == "true" && currentList.commentbox_enable != nil && currentList.commentbox_enable != "" {
                                cell.commentTap.isUserInteractionEnabled = true
                                cell.commentTap.backgroundColor = UIColor.clear
                                cell.commentButton.isHidden = false
                                cell.commentCountLabel.isHidden = false
                            } else {
                                cell.commentButton.isUserInteractionEnabled = false
                                cell.commentTap.isUserInteractionEnabled = false
                                cell.commentButton.isHidden = true
                                cell.commentCountLabel.isHidden = true
                                cell.commentTap.backgroundColor =  BlackThemeColor.white
                            }
                            
                            if  currentList.Duration != nil && currentList.Duration != "" {
                                cell.durationBackgroundView.isHidden = false
                                cell.durationLabel.isHidden = false
                                cell.durationLabel.text = currentList.Duration
                                
                            } else {
                                cell.durationBackgroundView.isHidden = true
                                cell.durationLabel.isHidden = true
                                
                            }
                            
                            
                            
                            if  currentList.name != "" && currentList.name != nil
                            {
                                cell.statusLabel.isHidden = false
                                cell.statusLabel.text = currentList.name
                                
                                
                            } else {
                                cell.statusLabel.isHidden = false
                                cell.statusLabel.text = currentList.name
                            }
                            if currentList.caption != "" && currentList.caption != nil
                            {
                                cell.statusLabel.isHidden = false
                                cell.statusLabel.text = currentList.caption
                            }
                            
                            if let likes = currentList.stats?.likes{
                                
                                cell.likeCountLabel.text = likes.roundedWithAbbreviations //formatPoints(num: Double(likes)) //
                                
                            }
                            
                            
                            cell.webViewButton.tag = indexPath.row
                            cell.webViewLabel.text = ""
                            if let listLabel = currentList.webview_label, listLabel != "" {
                                cell.webViewLabel.isHidden = false
                                cell.webViewLabel.text = listLabel
                                cell.webViewButton.isUserInteractionEnabled = true
                                cell.webViewLabel.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
                                cell.durationBottomHeight.constant = -40
                            } else {
                                cell.webViewButton.isUserInteractionEnabled = false
                                cell.webViewLabel.backgroundColor = UIColor.clear
                            }
                            
                            if let comments = currentList.stats?.comments{
                                
                                cell.commentCountLabel.text = comments.roundedWithAbbreviations //formatPoints(num: Double(comments)) //
                            }
                        }
                    } else
                    {
                        cell.statusLabel.isHidden = true
                        cell.daysLabel.isHidden = true
                    }
                    
                    //            }
                }
                
                if let socialPostId = currentList._id, self.is_like.contains(socialPostId) {
                    if let viewCount = currentList.stats?.likes {
                        if viewCount == 0 {
                            cell.likeCountLabel.text = "1"
                        }
                    }
                }
                
                if currentList.age_restriction != nil {
                    if let age = currentList.age_restriction {
                        if age > 0 {
                            cell.ratedView.isHidden = false
                            cell.ratedAgeLabel.text = "Rated \(age)+"
                        }
                    }
                } else {
                    cell.ratedView.isHidden = true
                }
                
                if let view = currentList.stats?.views{
                    cell.viewVideoCountView.isHidden = false
                    cell.viewVideoCountLabel.text = view.roundedWithAbbreviations //formatPoints(num: Double(likes)) //
                } else {
                    cell.viewVideoCountView.isHidden = true
                }
            }
            
            
            
            self.configure(cell: cell, forRowAtIndexPath: indexPath)
            
            return cell
        }
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
    //            navigationController?.setNavigationBarHidden(true, animated: true)
    //        } else {
    //            navigationController?.setNavigationBarHidden(false, animated: true)
    //        }
    //    }
    
    func configure(cell: VideoTableViewCell, forRowAtIndexPath indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.videosArray.count - 1 && self.totalItems > pageNumber {
            if ( Reachability.isConnectedToNetwork() == true) {
                pageNumber = pageNumber + 1
                spinner.color = UIColor.white
                
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: videoTableView.bounds.width, height: CGFloat(10))
                
                self.videoTableView.tableFooterView = spinner
                self.videoTableView.tableFooterView?.isHidden = false
                self.getData()
            } else {
                showToast(message: Constants.NO_Internet_MSG)
            }
        } else if (flagIsFromLocalOrServer == true) {
            
            if ( Reachability.isConnectedToNetwork() == true) {
                self.pageNumber = 1
                self.imgArr.removeAllObjects()
                self.arrData.removeAllObjects()
                self.arrStoredDetails.removeAllObjects()
                self.arrSinglePhotoData.removeAllObjects()
                self.videosArray.removeAll()
                spinner.color = UIColor.white
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: videoTableView.bounds.width, height: CGFloat(10))
                self.videoTableView.tableFooterView = spinner
                self.videoTableView.tableFooterView?.isHidden = false
                self.getData()
                flagIsFromLocalOrServer = false
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
        
        if Reachability.isConnectedToNetwork() {
            
            self.selectedIndexs = indexPath.row
            let currentList : List = self.videosArray[indexPath.row]
            if (arrStoredDetails != nil && arrStoredDetails.count > 0) {
                
                if (self.arrStoredDetails != nil && self.arrStoredDetails.count > 0) {
                    
                    if let dict = arrStoredDetails.object(at: indexPath.row) as? NSMutableDictionary{
                        
                        let isVideo = (dict.object(forKey: "video") as? NSNumber)?.boolValue ?? false
                        CustomMoEngage.shared.sendEventUIComponent(componentName: "Videos_video", extraParamDict: nil)
                        if isVideo{
                            if let videoType = dict.object(forKey: "videoType") as? String {
                                if videoType == "internal" {
                                    if let url = dict.object(forKey: "url") as? String {
                                        let videoURL = URL(string: url)
                                        let player = AVPlayer(url: videoURL!)
                                        self.playerViewController.player = player
                                        
                                        if (GlobalFunctions.isContentPiadWithDictCoins(dict: dict as! Dictionary<String, Any>)) && currentList.coins != 0{
                                            
                                            if (GlobalFunctions.isContentsPurchased(list: currentList)) {
                                                
                                                NotificationCenter.default.addObserver(self, selector: #selector(VideosViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                                
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
                                                    if  let t = Int(time) {
                                                        let timr = (Int(t) / Int (1000))
                                                        
                                                        print("video play duration \(timr)")
                                                        
                                                        timer = Timer.scheduledTimer(timeInterval: Double(timr), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                                                        self.callViewCountAPI(currentList._id ?? "", indexPath)
                                                        self.addObeserVerOnPlayerViewController()
                                                    }
                                                    
                                                    
                                                }
                                                
                                            } else {
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
                                                if let contentId = dict.value(forKey: "parentId") as? String{
                                                    CustomMoEngage.shared.sendEventForLockedContent(id: contentId ?? "")
                                                    if let coin = dict.value(forKey: "coins") as? String{
                                                        popOverVC.contentId = contentId
                                                        popOverVC.coins = Int(coin)
                                                        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                                                        self.view.addSubview(popOverVC.view)
                                                        popOverVC.didMove(toParent: self)
                                                    }
                                                }
                                            }
                                            
                                        }
                                        else {
                                            
                                            NotificationCenter.default.addObserver(self, selector: #selector(VideosViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                            self.present(playerViewController, animated: true) {
                                                self.playerViewController.player?.play()
                                                
                                            }
                                            self.callViewCountAPI(currentList._id ?? "", indexPath)
                                            self.addObeserVerOnPlayerViewController()
                                            
                                        }
                                    }
                                    //                                    }
                                } else {
                                    if let url = dict.object(forKey: "url") as? String {
                                        let youtubeCode = URL(string: url)?.lastPathComponent
                                        let videoPlayerViewController =
                                            XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeCode)
                                        NotificationCenter.default.addObserver(self, selector: #selector(VideosViewController.moviePlayerPlaybackDidFinish(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: videoPlayerViewController.moviePlayer)
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
                            if let contentId = currentList._id{
                                popOverVC.contentId = contentId
                                popOverVC.coins = currentList.coins ?? 0
                                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                                self.view.addSubview(popOverVC.view)
                                popOverVC.didMove(toParent: self)
                            }
                            
                        } else if (currentList.type != nil && currentList.type == "poll" && currentList.photo != nil && currentList.photo?.cover != "" && currentList.photo?.cover != nil) {
                            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                            let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
                            //                SingleImageScrollViewController.photoArray =  self.imgArr
                            //                SingleImageScrollViewController.albumData = self.arrStoredDetails
                            //                SingleImageScrollViewController.currentData = self.arrStoredDetails[indexPath.row] as! NSDictionary
                            SingleImageScrollViewController.storeDetailsArray = self.videosArray
                            
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
                                    NotificationCenter.default.addObserver(self, selector: #selector(VideosViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                    self.present(playerViewController, animated: true) {
                                        self.playerViewController.player?.play()
                                        
                                    }
                                    self.callViewCountAPI(currentList._id ?? "", indexPath)
                                    self.addObeserVerOnPlayerViewController()
                                }
                            }
                        }
                        else {
                            
                            
                            let dict = arrStoredDetails.object(at: indexPath.row) as! NSMutableDictionary
                            
                            let destViewController : AlbumViewController = self.storyboard!.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
                            destViewController.pageList = pageList
                            if (GlobalFunctions.checkPartialPaidContent(dictionary: dict)) {
                                destViewController.checkContentLock = true
                            } else {
                                destViewController.checkContentLock = false
                                
                            }
                            if let parentId =  dict.object(forKey: "parentId") as? String
                            {
                                destViewController.parentId = parentId //dict.object(forKey: "parentId") as! String
                                
                            }
                            //            destViewController.isAlbum = (dict.object(forKey: "is_album") != nil)
                            if dict.object(forKey: "is_album") as? Int == 1 || dict.object(forKey: "is_album") as? Bool == true
                            {
                                destViewController.isAlbum = true
                                destViewController.albumName = dict.object(forKey: "albumCaption") as? String
                                destViewController.lvl1ImgString = dict.object(forKey: "selectedImage") as? String
                            } else {
                                
                                destViewController.isAlbum = false
                                let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                                let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
                                //                                SingleImageScrollViewController.photoArray =  self.imgArr
                                //                                SingleImageScrollViewController.albumData = self.arrStoredDetails
                                //                                SingleImageScrollViewController.currentData = self.arrStoredDetails[indexPath.row] as! NSDictionary
                                SingleImageScrollViewController.storeDetailsArray = self.videosArray
                                
                                SingleImageScrollViewController.pageIndex = indexPath.row
                                SingleImageScrollViewController.selectedBucketCode = pageList?.code ?? ""
                                SingleImageScrollViewController.selectedBucketName = pageList?.name ?? ""
                                self.navigationController?.pushViewController(SingleImageScrollViewController, animated: true)
                                
                            }
                            if dict.object(forKey: "is_album") as? Bool == true {
                                if let topViewController : UIViewController = self.navigationController?.topViewController {
                                    destViewController.selectedIndexVal = selectedIndexVal
                                    destViewController.navigationItem.backBarButtonItem?.title = ""
                                    let backItem = UIBarButtonItem()
                                    backItem.title = ""
                                    navigationItem.backBarButtonItem = backItem
                                    
                                    if (topViewController.restorationIdentifier == destViewController.restorationIdentifier) {
                                        print("Same VC")
                                    } else {
                                        self.navigationController!.pushViewController(destViewController, animated: true)
                                    }
                                }
                            }
                        }
                        //                    }
                    }
                }
            }
            
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
            
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
                    if let currentList = self.videosArray[self.selectedIndexs] as? List {
                        CustomMoEngage.shared.sendEventViewVide(id: currentList._id ?? "", coins: currentList.coins ?? 0, bucketCode:pageList?.code ?? "", bucketName: pageList?.name ?? "", videoName: currentList.caption ?? "", type: currentList.commercial_type ?? "", percent: percentage)
                    }
                }
            }
        }
    }
    
    @objc func timerAction() {
        timer.invalidate()
        self.playerViewController.player?.pause()
        isSwipeVideo = false
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
        
        popOverVC.currentContent = self.videosArray[selectedIndexs]
        
        
        if let bucketList = GlobalFunctions.returnSelectedIndexBucketList(arr: bucketsArray, atIndex: 2) {
            popOverVC.selectedBucketCode = bucketList.code ?? "videos"
            popOverVC.selectedBucketName = bucketList.caption ?? "VIDEOS"
        } else {
            popOverVC.selectedBucketCode = "videos"
            popOverVC.selectedBucketName = "VIDEOS"
        }
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
    
    
    @objc func moviePlayerPlaybackDidFinish(notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: notification.object)
        if let finishReason = notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as? Int {
            if finishReason == MPMovieFinishReason.playbackError.rawValue {
                let error = notification.userInfo![XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey]
                print(error!)
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
        print("closed video at end of video")
        playerViewController.dismiss(animated: true,completion: nil)
        timer.invalidate()
        
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
                            let currentList = self.videosArray[index.row]
                            guard let type = currentList.type else {return}
                            
                            if type == "poll" {
                                guard let cell =  self.videoTableView.cellForRow(at: index) as? PollTableViewCell else { return }
                                
                                DispatchQueue.main.async {
                                    if self.videosArray.count > index.row {
                                        let currentList = self.videosArray[index.row]
                                        var views = currentList.stats?.views ?? 0
                                        views = views + 1
                                        cell.videoViewCountLabel.text = "\(views.roundedWithAbbreviations)"
                                        currentList.stats?.views = views
                                        self.videosArray[index.row] = currentList
                                    }
                                    self.videoTableView.reloadRows(at: [index], with: .none)
                                }
                                
                            } else {
                                guard let cell =  self.videoTableView.cellForRow(at: index) as? VideoTableViewCell else { return }
                                DispatchQueue.main.async {
                                    if self.videosArray.count > index.row {
                                        let currentList = self.videosArray[index.row]
                                        var views = currentList.stats?.views ?? 0
                                        views = views + 1
                                        cell.viewVideoCountLabel.text = "\(views.roundedWithAbbreviations)"
                                        currentList.stats?.views = views
                                        self.videosArray[index.row] = currentList
                                    }
                                    self.videoTableView.reloadRows(at: [index], with: .none)
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
    func getData()
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
                
                self.shimme7.isShimmering = true
                self.shimme7.isHidden = false
                
                self.shimme8.isShimmering = true
                self.shimme8.isHidden = false
                
                self.shimme9.isShimmering = true
                self.shimme9.isHidden = false
                
                self.placeholderView.isHidden = false
                
            }
            
        }
        //        if (BucketValues.bucketContentArr.count > 0) {
        //
        //        if let dataDict = BucketValues.bucketContentArr.object(at: 0) as? Dictionary<String, Any> {
        //            bucketId = dataDict["_id"] as? String
        //             bucketCodeStr = dataDict["code"] as? String
        //        }
        //        }
        //         bucketId = BucketValues.bucketIdArray[0]
        
        guard let bucketId = pageList?._id else {
            self.showToast(message: "Something went wrong please try again.")
            return
        }
        
        if Reachability.isConnectedToNetwork() == true
        {
            //            if let bucketId = self.bucketId {
            
            //                var strUrl = Constants.App_BASE_URL + Constants.LEVEL_1_BUCKET_CONTENTS + "?bucket_id=\(bucketId)" + "&page=\(pageNumber)"+"&visibility=customer&platform=ios"
            var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" + "&visibility=customer" + "&page=\(pageNumber)" + "&v=\(Constants.VERSION)"
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let url = URL(string: strUrl)
            let request = NSMutableURLRequest(url: url!)
            
            request.httpMethod = "GET"
            //                    request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
            request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                self.isFirstTime = false
                if error != nil{
                    print(error?.localizedDescription)
                    
                    DispatchQueue.main.async {
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
                            
                            self.shimme7.isShimmering = false
                            self.shimme7.isHidden = true
                            
                            self.shimme8.isShimmering = false
                            self.shimme8.isHidden = true
                            
                            self.shimme9.isShimmering = false
                            self.shimme9.isHidden = true
                            
                            self.placeholderView.isHidden = true
                        }
                        self.refreshControl.endRefreshing()
                        self.flagIsFromLocalOrServer = true
                        self.spinner.stopAnimating()
                        if (self.database != nil) {
                            self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                            if  self.videosArray.count > 0 {
                                self.internetConnectionLostView.isHidden = true
                            }
                            DispatchQueue.main.async {
                                self.videoTableView.reloadData()
                            }
                        }
                    }
                    return
                }
                
                
                do {
                    if (data != nil) {
                        
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                            print("Photo json \(String(describing: json))")
                            //need to store total val & fetch it & add to arr & load tbl view
                            
                            if json.object(forKey: "error") as? Bool == true {
                                
                                DispatchQueue.main.async {
                                    
                                    if let arr = json.object(forKey: "error_messages")! as? NSMutableArray {
                                        self.spinner.stopAnimating()
                                        self.flagIsFromLocalOrServer = true
                                        self.refreshControl.endRefreshing()
                                        if (self.database != nil) {
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
                                                
                                                self.shimme7.isShimmering = false
                                                self.shimme7.isHidden = true
                                                
                                                self.shimme8.isShimmering = false
                                                self.shimme8.isHidden = true
                                                
                                                self.shimme9.isShimmering = false
                                                self.shimme9.isHidden = true
                                                
                                                self.placeholderView.isHidden = true
                                            }
                                            
                                            self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                                            if  self.videosArray.count > 0 {
                                                self.internetConnectionLostView.isHidden = true
                                            }
                                            DispatchQueue.main.async {
                                                self.videoTableView.reloadData()
                                            }
                                        }
                                    }
                                }
                                
                            } else if (json.object(forKey: "status_code") as? Int == 200) {
                                if let AllData = json.object(forKey: "data") as? NSMutableDictionary
                                {
                                    if  let paginationData = AllData.object(forKey: "paginate_data") as? NSMutableDictionary{
                                        self.totalItems  = paginationData.object(forKey: "total") as! Int
                                        self.totalPages  = paginationData.object(forKey: "last_page") as! Int
                                        self.currentPage  = paginationData.object(forKey: "current_page") as! Int
                                    }
                                }
                                let gai = GAI.sharedInstance()
                                if let event = GAIDictionaryBuilder.createEvent(withCategory: "Home Videos Screen ios", action: "API Pagination Number \(self.currentPage) (ios) ", label: "Success", value: nil).build() as? [AnyHashable : Any] {
                                    gai?.defaultTracker.send(event)
                                    
                                }
                                
                                DispatchQueue.main.async {
                                    
                                    self.spinner.stopAnimating()
                                    if let dictData = json.object(forKey: "data") as? NSMutableDictionary{
                                        if let photoDetailsArr = dictData.object(forKey: "list") as? NSMutableArray{
                                            
                                            self.database.createSocialJunctionTable()
                                            self.database.createStatsTable()
                                            self.database.createVideoTable()
                                            for dict in photoDetailsArr{
                                                
                                                if let list : List = List(dictionary: (dict as? NSDictionary)!) {
                                                    if (!GlobalFunctions.checkContentBlockId(id: list._id ?? "")) {
                                                        self.database.insertIntoSocialTable(list:list, datatype: self.pageList?.code ?? "")
                                                        let pollStat = self.database.getPollData(content_Id: list._id ?? "")
                                                        if pollStat.count > 0 {
                                                            list.pollStat = pollStat
                                                        }
                                                        self.videosArray.append(list)
                                                        
                                                    }
                                                }
                                            }
                                            if photoDetailsArr.count > 0
                                            {
                                                self.spinner.stopAnimating()
                                                self.arrData = photoDetailsArr
                                                self.displayLayout()
                                            }
                                            if  self.videosArray.count > 0 {
                                                self.internetConnectionLostView.isHidden = true
                                            }
                                        }
                                    }
                                    
                                }
                                DispatchQueue.main.async {
                                    
                                    self.refreshControl.endRefreshing()
                                    if (self.videosArray.count == 0) {
                                        self.currentPage = self.currentPage + 1
                                        self.getData()
                                    }
                                }
                            }
                        }
                    }
                    //                        self.stopLoader()
                    
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
                        
                        self.shimme7.isShimmering = false
                        self.shimme7.isHidden = true
                        
                        self.shimme8.isShimmering = false
                        self.shimme8.isHidden = true
                        
                        self.shimme9.isShimmering = false
                        self.shimme9.isHidden = true
                        
                        self.placeholderView.isHidden = true
                    }
                    
                } catch let error as NSError {
                    print(error)
                    //                        self.stopLoader()
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
                        
                        self.shimme7.isShimmering = false
                        self.shimme7.isHidden = true
                        
                        self.shimme8.isShimmering = false
                        self.shimme8.isHidden = true
                        
                        self.shimme9.isShimmering = false
                        self.shimme9.isHidden = true
                        
                        self.placeholderView.isHidden = true
                    }
                    
                    self.spinner.stopAnimating()
                    DispatchQueue.main.async {
                        self.flagIsFromLocalOrServer = true
                        self.refreshControl.endRefreshing()
                        if (self.database != nil) {
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
                                
                                self.shimme7.isShimmering = false
                                self.shimme7.isHidden = true
                                
                                self.shimme8.isShimmering = false
                                self.shimme8.isHidden = true
                                
                                self.shimme9.isShimmering = false
                                self.shimme9.isHidden = true
                                
                                self.placeholderView.isHidden = true
                            }
                            self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                            if  self.videosArray.count > 0 {
                                self.internetConnectionLostView.isHidden = true
                            }
                            
                            self.videoTableView.reloadData()
                        }
                    }
                    
                }
                
            }
            task.resume()
            
            //            }
            
            
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
                
                self.shimme7.isShimmering = false
                self.shimme7.isHidden = true
                
                self.shimme8.isShimmering = false
                self.shimme8.isHidden = true
                
                self.shimme9.isShimmering = false
                self.shimme9.isHidden = true
                
                self.placeholderView.isHidden = true
            }
            self.spinner.stopAnimating()
            self.refreshControl.endRefreshing()
            if (self.database != nil) {
                self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                if  self.videosArray.count > 0 {
                    self.internetConnectionLostView.isHidden = true
                }
                DispatchQueue.main.async {
                   self.videoTableView.reloadData()
                }
            }
            
        }
    }
    
    
    
    var arrSinglePhotoData = NSMutableArray()
    func showSinglePics()
    {
        if arrData.count > 0
        {
            for i in 0...arrData.count - 1
            {
                let dict = arrData.object(at: i) as! NSMutableDictionary
                arrSinglePhotoData.add(dict)
            }
            
        }
        DispatchQueue.main.async {
            self.videoTableView.reloadData()
        }
        
        
    }
    
    func displayLayout()
        
    {
        if arrData.count > 0
        {
            for i in 0...arrData.count - 1
            {
                
                if let dict = arrData.object(at: i) as? NSMutableDictionary{
                    
                    if (!GlobalFunctions.checkContentBlockId(id: dict.value(forKey: "_id") as! String)) {
                        
                        if let states = dict.object(forKey: "stats") as? NSMutableDictionary {
                            
                            let comments = states.object(forKey: "comments") as! NSNumber
                            let likes = states.object(forKey: "likes") as! NSNumber
                            //                            is_like.append((Int(dict.object(forKey: "is_like") as! NSNumber)))
                            let shares = states.object(forKey: "shares") as! NSNumber
                            let type = (dict.object(forKey: "type") as! String)
                            
                            
                            
                            if type == "photo"{
                                if let photoDetails = (dict.object(forKey: "photo") as? NSMutableDictionary)
                                {
                                    imgArr.add(photoDetails.object(forKey: "cover") as? String)
                                    
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
                                            if (dict.object(forKey: "is_album") as? String) == "true"
                                            {
                                                //                                    if (dict.object(forKey: "locked") as! String) == "true"
                                                //                                    {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                                //                                }
                                            } else
                                            {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")! , "commercial_type" : dict.object(forKey: "commercial_type")!]
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
                                }
                                
                            } else
                            {
                                
                                var newDict = NSMutableDictionary()
                                if dict.object(forKey: "is_album") as? String == "true"
                                {
                                    //                               if dict.object(forKey: "locked") as! String == "true"
                                    //                               {
                                    
                                    if ((dict.object(forKey: "is_album") as Any) as AnyObject).intValue == 1
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    } else
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares , "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
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
                                    if let videoType = videosDict.object(forKey: "player_type") as? String {
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
                                                newDict.setValue(("https://i.ytimg.com/vi/\(embedCode)/mqdefault.jpg"), forKey: "videoURL")
                                                
                                                newDict.setValue(videoType, forKey: "videoType")
                                                imgArr.add("https://i.ytimg.com/vi/\(embedCode)/mqdefault.jpg")
                                                
                                            }
                                        }
                                    }
                                }
                                
                                arrStoredDetails.add(newDict)
                            }
                            
                        }
                    }
                }
            }
            
            
            if (arrStoredDetails.count == 0 ) {
                pageNumber = pageNumber + 1
                self.getData()
            }
            DispatchQueue.main.async {
                self.videoTableView.reloadData()
            }
            
        }
        
        
    }
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
    
}




extension TimeInterval {
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    private var seconds: Int {
        return Int(self) % 60
    }
    
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    private var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
}
//MARK:- PollTableViewCellDelegate
extension VideosViewController:PollTableViewCellDelegate {
    func didLikePollButton(_ sender: UIButton) {
        let socialPost = self.videosArray[sender.tag]
        
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:"User not logged in", extraParamDict: nil)
            return
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        guard let cell =  self.videoTableView.cellForRow(at: indexPath) as? PollTableViewCell else {
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
            if (videosArray != nil && videosArray.count > 0) {
                
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
            
            if (videosArray != nil && videosArray.count > 0) {
                
                if let contentId = videosArray[indexPath.row]._id {
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
        videoTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func showLoginAlert() {
        self.loginPopPop()
    }
    
    func didTapCommentButton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let CommentViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
            if (videosArray != nil && videosArray.count > 0) {
                let dict = self.videosArray[sender.tag]
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



// MARK: - Custom Methods.
extension VideosViewController {
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
