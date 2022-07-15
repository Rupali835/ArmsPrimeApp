//
//  SocialJunctionViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 18/04/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//heartIconRed

import UIKit
import SDWebImage
import AVKit
import Alamofire
import XCDYouTubeKit
import Firebase
import SAConfettiView
import Shimmer
import FirebaseDynamicLinks

class SocialJunctionViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,SocialTableViewCellDelegate {
    
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var imageiew1: UIView!
    @IBOutlet weak var imageiew2: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var imagecontentView: UIView!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var imageiew: UIView!
    @IBOutlet weak var nameView1: UIView!
    @IBOutlet weak var captionView1: UIView!
    @IBOutlet weak var imagecontentView1: UIView!
    @IBOutlet weak var statusViews: UIView!
    
    @IBOutlet weak var minimumBalancebackgroundView: UIView!
    @IBOutlet weak var rechargeButton: UIButton!
    
    @IBOutlet weak var demoView3: UIView!
    @IBOutlet weak var demoView2: UIView!
    @IBOutlet weak var nameView2: UIView!
    @IBOutlet weak var captionView2: UIView!
    @IBOutlet weak var textLabelMinimumBalance: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textlabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var socialTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    var images = [AnyObject]()
    var arrData = NSMutableArray()
    var selectedIndexVal: Int!
    var askAlbum: Bool!
    var wating:Bool!
    var arrStoredDetails = NSMutableArray()
    var photoWidth: CGFloat!
    var imgArr = NSMutableArray()
    var sourceType = [String]()

    var isLogin = false
    var iswating = false
    var bucketId: String?
    var isFirstTime = true
    var spinnerView = UIView()
    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    var likeSelectedArray = [Int]()
    var newLikeCount = [[IndexPath: Int]()]
    var is_like = [String]()
    var bucketsArray : [List]!
    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView!
    private var overlayView = LoadingOverlay.shared
    //    var bucketid: String = ""
    var flagIsFromLocalOrServer = false
    var arrSinglePhotoData = NSMutableArray()
    var socialArray = [List]()
    let database = DatabaseManager.sharedInstance
    let spinner = UIActivityIndicatorView(style: .white)
    var cellHeights: [IndexPath : CGFloat] = [:]
    var pageNumber = 0
    var currentPage = 0
    var totalPages = 0
    var totalItems = 0
    var isNewDataLoading = false
    var isTableLoaded : Bool = false
    var reachability = Reachability()
    
    var shimmer = FBShimmeringView()
    var shimmer1 = FBShimmeringView()
    var shimmer2 = FBShimmeringView()
    var shimmer3 = FBShimmeringView()
    var shimmer4 = FBShimmeringView()
    
    var shimme1 = FBShimmeringView()
    var shimme2 = FBShimmeringView()
    var shimme3 = FBShimmeringView()
    var shimme4 = FBShimmeringView()
    var shimme5 = FBShimmeringView()
    
    var shim1 = FBShimmeringView()
    var shim2 = FBShimmeringView()
    var shim3 = FBShimmeringView()
    var shim4 = FBShimmeringView()
    var shim5 = FBShimmeringView()
    var contetid:String = ""
    @IBOutlet var internetConnectionLostView: UIView!
    @IBOutlet var retryAgainButton: UIButton!
     var isShowPhoto: Bool = false
    var selectedIndexs = 0
    var bucketCodeStr: String?
    var navigationTittle = ""
    var pageList: List?
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if contetid != "" {
//            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
//            let BucketContentDetailsViewController = mainstoryboad.instantiateViewController(withIdentifier: "BucketContentDetailsViewController") as! BucketContentDetailsViewController
//            BucketContentDetailsViewController.contedID = contetid
//            self.navigationController?.pushViewController(BucketContentDetailsViewController, animated: true)
//        }
        
        shimme1 = FBShimmeringView(frame: self.imagecontentView1.frame)
        shimme1.contentView = imagecontentView1
        view.addSubview(shimme1)
        shimme1.isShimmering = true
        
        shimme2 = FBShimmeringView(frame: self.captionView1.frame)
        shimme2.contentView = captionView1
        view.addSubview(shimme2)
        shimme2.isShimmering = true
        
        shimme3 = FBShimmeringView(frame: self.nameView1.frame)
        shimme3.contentView = nameView1
        view.addSubview(shimme3)
        shimme3.isShimmering = true
        
        shimme4 = FBShimmeringView(frame: self.imageiew.frame)
        shimme4.contentView = imageiew
        view.addSubview(shimme4)
        shimme4.isShimmering = true
        
        shimme5 = FBShimmeringView(frame: self.statusViews.frame)
        shimme5.contentView = statusViews
        view.addSubview(shimme5)
        shimme5.isShimmering = true
        
        
        
        shimmer = FBShimmeringView(frame: self.imagecontentView.frame)
        shimmer.contentView = imagecontentView
        view.addSubview(shimmer)
        shimmer.isShimmering = true
        
        shimmer1 = FBShimmeringView(frame: self.nameView.frame)
        shimmer1.contentView = nameView
        view.addSubview(shimmer1)
        shimmer1.isShimmering = true
        
        shimmer2 = FBShimmeringView(frame: self.captionView.frame)
        shimmer2.contentView = captionView
        view.addSubview(shimmer2)
        shimmer2.isShimmering = true
        
        shimmer3 = FBShimmeringView(frame: self.imageiew1.frame)
        shimmer3.contentView = imageiew1
        view.addSubview(shimmer3)
        shimmer3.isShimmering = true
        
        
        shimmer4 = FBShimmeringView(frame: self.statusView.frame)
        shimmer4.contentView = statusView
        view.addSubview(shimmer4)
        shimmer4.isShimmering = true
        
        
        /*
         @IBOutlet weak var demoView3: UIView!
         @IBOutlet weak var demoView2: UIView!
         @IBOutlet weak var nameView2: UIView!
         @IBOutlet weak var captionView2: UIView!
         */
        
        
        shim1 = FBShimmeringView(frame: self.demoView3.frame)
        shim1.contentView = nameView
        view.addSubview(shim1)
        shim1.isShimmering = true
        
        shim2 = FBShimmeringView(frame: self.demoView2.frame)
        shim2.contentView = demoView2
        view.addSubview(shim2)
        shim2.isShimmering = true
        
        shim3 = FBShimmeringView(frame: self.nameView2.frame)
        shim3.contentView = nameView2
        view.addSubview(shim3)
        shim3.isShimmering = true
        
        shim4 = FBShimmeringView(frame: self.captionView2.frame)
        shim4.contentView = captionView2
        view.addSubview(shim4)
        shim4.isShimmering = true
        
        shim5 = FBShimmeringView(frame: self.imageiew2.frame)
        shim5.contentView = imageiew2
        view.addSubview(shim5)
        shim5.isShimmering = true
        
        
        self.imageiew1.layer.cornerRadius = imageiew1.frame.size.width / 2
        self.imageiew1.layer.masksToBounds = false
        self.imageiew1.clipsToBounds = true
        
        self.imageiew2.layer.cornerRadius = imageiew2.frame.size.width / 2
        self.imageiew2.layer.masksToBounds = false
        self.imageiew2.clipsToBounds = true
        
        self.imageiew.layer.cornerRadius = imageiew.frame.size.width / 2
        self.imageiew.layer.masksToBounds = false
        self.imageiew.clipsToBounds = true
        
        
        
        
        if  RCValues.sharedInstance.bool(forKey: .eventDisplay) == true {
            updateBanner()
            let contentview = SAConfettiView(frame: self.view.bounds)
            contentview.type = .Triangle
            //            contentview.colors = [UIColor.orange, UIColor.green, UIColor.white]
            contentview.colors = RCValues.sharedInstance.colors(forKey: .flyingColors)
            backgroundView.addSubview(contentview)
            contentview.startConfetti()
            self.backgroundView.isHidden = false
            addClosesButton()
            
        }
        
        
        
        reachability = Reachability.init()
        pageNumber = 1
        //        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.isNavigationBarHidden = false
        self.internetConnectionLostView.isHidden = true
        //        let backgroundImage = UIImage(named: "sunnybackground")
        //        let imageView = UIImageView(image: backgroundImage)
        //        self.socialTableView.backgroundView = imageView
        
        //        addSlideMenuButton()
        
        arrStoredDetails.removeAllObjects()
        arrData.removeAllObjects()
        imgArr.removeAllObjects()
        
        socialTableView.dataSource = self
        socialTableView.delegate = self
        
        socialTableView.register(UINib(nibName: "SocialTableViewCell", bundle: nil), forCellReuseIdentifier: "SocialTable")
        socialTableView.register(UINib(nibName: "PollTableViewCell", bundle: nil), forCellReuseIdentifier: "PollTableViewCell")
//        self.socialTableView.estimatedRowHeight = 200
        self.socialTableView.rowHeight = UITableView.automaticDimension

        self.socialTableView.setNeedsUpdateConstraints()
        
//        self.navigationItem.title = "NEWSFEED"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.white]
         self.setNavigationView(title:navigationTittle.uppercased())
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
       /* self.bucketsArray = [List]()
        self.bucketsArray =  database.getBucketListing()
        if (self.bucketsArray != nil && self.bucketsArray.count > 0) {
            for list in self.bucketsArray{
                BucketValues.bucketTitleArr.append(list.caption ?? "")
                BucketValues.bucketIdArray.append(list._id ?? "")
            }
            bucketCodeStr = BucketValues.bucketTitleArr[0]
            self.getData()
        } else if BucketValues.bucketContentArr.count > 0 {
            self.getData()
        } else {
            self.getBuketData(completion: { (result) in
                if let id = result["data"]["list"][0]["_id"].string {
                    self.bucketId = id
                }
                
                if (result["data"]["list"].arrayObject != nil) {
                    BucketValues.bucketContentArr = NSMutableArray(array: result["data"]["list"].arrayObject!)
                    self.getData()
                }
            })
        }*/

        
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
        
        
        let  stringNumber = RCValues.sharedInstance.string(forKey: .rechargeAmount)
        
        _ = self.getOfflineUserData()
        
        
        
//        if let coins = CustomerDetails.coins , let coinsFromRemote = Int(stringNumber) , coins < coinsFromRemote {
//
//            self.minimumBalancebackgroundView.isHidden = false
//            self.textLabelMinimumBalance.isHidden = false
//            self.rechargeButton.isHidden = false
//            self.closeButton.isHidden = false
//            self.rechargeButton.layer.cornerRadius = 5
//            textLabelMinimumBalance.text = RCValues.sharedInstance.string(forKey: .rechargeTitleText)
//
//        } else {
        
            self.minimumBalancebackgroundView.isHidden = true
            self.textLabelMinimumBalance.isHidden = true
            self.rechargeButton.isHidden = true
            self.closeButton.isHidden = true
            
//        }
        self.getData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.backgroundView.isHidden = true
    }
    
    func updateBanner() {
        
        self.textlabel.text = RCValues.sharedInstance.string(forKey: .eventTitleText)
        self.textlabel.textColor = RCValues.sharedInstance.color(forKey: .eventTitleColor)
        let imageURL = RCValues.sharedInstance.string(forKey: .bannerImageview)
        let url = URL(string: imageURL)
        //        imageView.image = UIImage.gif (url: imageURL)
        self.imageView.sd_setImage(with:url, completed: nil)
        
    }
    
    
    
    func addClosesButton() {
        let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        //        button.backgroundColor = UIColor.black
        let image = UIImage(named: "closewhite") as UIImage?
        button.frame = CGRect(x: 20, y: 20, width: 35, height: 35)
        //        button.layer.cornerRadius = button.frame.height/2
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(btnPresseds(sender:)), for: .touchUpInside)
        self.backgroundView.addSubview(button)
        button.isHidden = false
    }
    
    @objc func btnPresseds(sender: UIButton!) {
        //        self.navigationController?.navigationBar.isHidden = false
        self.backgroundView.removeFromSuperview()
        backgroundView.isHidden = true
        imageView.isHidden = true
        textlabel.isHidden = true
        
    }
    
    @IBAction func closeButtonMinimumBalanceView(_ sender: Any) {
        
        self.minimumBalancebackgroundView.isHidden = true
        self.textLabelMinimumBalance.isHidden = true
        self.rechargeButton.isHidden = true
        self.closeButton.isHidden = true
        
    }
    
    
    @IBAction func rechargeButtonAction(_ sender: Any) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as? PurchaseCoinsViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        
        if let reachability = note.object as? Reachability {
            
            switch reachability.connection {
            case .wifi:
                
                print("Reachable via WiFi")
            case .cellular:
                
                print("Reachable via Cellular")
            case .none:
                if  self.socialArray.count == 0 {
                    self.internetConnectionLostView.isHidden = false
                }
                print("Network not reachable")
            }
        }
    }
    
    
    
    
    @IBAction func retryAgainClick(_ sender: UIButton) {
        if self.socialArray.count == 0 {
            //            self.showLoader()
            
            self.shimmer.isShimmering = true
            self.shimmer.isHidden = false
            
            self.shimmer1.isShimmering = true
            self.shimmer1.isHidden = false
            
            self.shimmer2.isShimmering = true
            self.shimmer2.isHidden = false
            
            self.shimmer3.isShimmering = true
            self.shimmer3.isHidden = false
            
            self.shimmer4.isShimmering = true
            self.shimmer4.isHidden = false
            
            self.shimme5.isShimmering = true
            self.shimme5.isHidden = false
            
            self.shimme1.isShimmering = true
            self.shimme1.isHidden = false
            
            self.shimme2.isShimmering = true
            self.shimme2.isHidden = false
            
            self.shimme3.isShimmering = true
            self.shimme3.isHidden = false
            
            self.shimme4.isShimmering = true
            self.shimme4.isHidden = false
            
            
            self.shim1.isShimmering = true
            self.shim1.isHidden = false
            
            self.shim2.isShimmering = true
            self.shim2.isHidden = false
            
            self.shim3.isShimmering = true
            self.shim3.isHidden = false
            
            self.shim4.isShimmering = true
            self.shim4.isHidden = false
            
            self.shim5.isShimmering = true
            self.shim5.isHidden = false
            
            self.placeholderView.isHidden = false
            
            self.getData()
            if  self.socialArray.count > 0 {
                self.internetConnectionLostView.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: MyColors.navigationnBar)
        self.navigationController?.isNavigationBarHidden = false
       
        self.tabBarController?.tabBar.isHidden = false
        if isShowPhoto {
             self.navigationController?.navigationBar.isHidden = false
            self.setNavigationView(title: "NEWSFEED")
            isShowPhoto = false
        }
        if BucketValues.bucketIdArray.count > 0 {
            if #available(iOS 10.0, *) {
                socialTableView.refreshControl = refreshControl
            } else {
                socialTableView.addSubview(refreshControl)
            }
            refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
            refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)
        }
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            } else {
                self.isLogin = false
            }
        } else {
            self.isLogin = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isShowPhoto{
//            let colors: [UIColor] = [UIColor.black,UIColor.black]
////            self.navigationController!.navigationBar.setGradientBackground(colors: colors)
//            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//            self.navigationController?.navigationBar.barTintColor = .black
//            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isTableLoaded = true
        
        if let index = GlobalFunctions.sortedTabMenuArrayIndex(code: pageList?.code ?? "") {
            if index < 3 {
                self.tabBarController?.viewControllers?[index].tabBarItem.badgeValue = nil
            }
        }
        GlobalFunctions.screenViewedRecorder(screenName: "Home News Feed Screen")
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Home_News_Feed_Tab", extraParamDict: nil)
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
        self.socialArray.removeAll()
        _ = self.getOfflineUserData()
        self.getData()
        
    }
    func didTapButton(_ sender: UIButton) {

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let CommentViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
            if (socialArray != nil && socialArray.count > 0) {
                let dict = self.socialArray[sender.tag]
                CommentViewController.postId = dict._id ?? ""
                CommentViewController.screenName = "Home News Feed Screen"
                self.pushAnimation()
                self.navigationController?.pushViewController(CommentViewController, animated: false)
            }
            
        }
    }
    
    func didLikeButton(_ sender: UIButton) {
        let socialPost = self.socialArray[sender.tag]
        
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:"User not logged in", extraParamDict: nil)
            return
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        guard let cell =  self.socialTableView.cellForRow(at: indexPath) as? SocialTableViewCell else {
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
            if (socialArray != nil && socialArray.count > 0) {
                
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
                                    
                                    if !self.likeSelectedArray.contains(cell.likeTap.tag) {
                                        self.likeSelectedArray.append(cell.likeTap.tag)
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
            
            if (socialArray != nil && socialArray.count > 0) {
                
                if let contentId = socialArray[indexPath.row]._id {
                    GlobalFunctions.saveLikesIdIntoDatabase(content_id: contentId as String)
                    if (!self.is_like.contains(contentId ?? "")) {
                        self.is_like.append(contentId ?? "")
                    }
                }
            }
        }
        
        // }
        
    }
    
    func didShareButton(_ sender: UIButton) {
        if !Reachability.isConnectedToNetwork() {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
            return
        }
        
            let content = self.socialArray[sender.tag]
            
            var params: String = " "
            params += "&bucket_code=" + "\(pageList?.code ?? "")"
            params += "&content_id=" + "\(content._id ?? "")"
            
            let stringUrl: String = Constants.officialWebSitelink + params
            let link: URL = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
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
       
//        let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,"Hi"], applicationActivities: nil)
//        viewController.popoverPresentationController?.sourceView = self.view
//        self.present(viewController, animated: true, completion: nil)
//
//        let payloadDict = NSMutableDictionary()
//        payloadDict.setObject(self.socialArray[sender.tag]._id, forKey: "content_id" as NSCopying)
//        CustomMoEngage.shared.sendEvent(eventType: MoEventType.share, action: "", status: "Success", reason: "Home News Feed", extraParamDict: payloadDict)
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
            
            let alert = UIAlertController(title: "You won't see this post again.", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if self.isLogin {
                    _ = self.getOfflineUserData()
                    
                    self.database.createHideTable()
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    guard let cell =  self.socialTableView.cellForRow(at: indexPath) as? SocialTableViewCell else {
                        return
                    }
                    
                    let dict : List = self.socialArray[indexPath.row]
                    let contentId = dict._id
                    let customerId = CustomerDetails.custId
                    if (contentId != nil && customerId != nil) {
                        
                        self.database.createHideTable()
                        if (contentId != nil && customerId != nil) {
                            self.database.insertIntoHideContent(content: contentId ?? "", customer: customerId ?? "")
                            GlobalFunctions.sendBLockContentToServer(content: contentId ?? "")
                        }
                        
                    }
                    if ( self.socialArray != nil && self.socialArray.count > 0) {
                        
                        self.socialArray.remove(at: indexPath.row)
                        //                        removeObject(at: indexPath.row)
                        //                        self.imgArr.removeObject(at: indexPath.row)
                    }
                    self.socialArray.remove(at: indexPath.row)
                    _ = self.getOfflineUserData()
                    self.socialTableView.reloadData()
                    
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.socialArray.count > 0 {
            return self.socialArray.count
        } else {
            return 0
        }
        
    }
    
    func didTapWebview(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
            let currentList : List = self.socialArray[sender.tag]
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebviewUrlViewController") as? WebviewUrlViewController {
                resultViewController.webViewName = currentList.webview_label ?? ""
                resultViewController.storeDetailsArray = self.socialArray
                resultViewController.pagindex = sender.tag
                
                self.navigationController?.pushViewController(resultViewController, animated: true)
            }
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentList : List = self.socialArray[indexPath.row]
        if let type = currentList.type , type == "poll"{
            let cell = socialTableView.dequeueReusableCell(withIdentifier: "PollTableViewCell", for: indexPath) as! PollTableViewCell
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
            let cell = socialTableView.dequeueReusableCell(withIdentifier: "SocialTable", for: indexPath) as! SocialTableViewCell
            isTableLoaded = true
            cell.optionsButton.tag = indexPath.row
            
            if self.socialArray.count > 0 && self.socialArray.count > indexPath.row
            {
                let currentList : List = self.socialArray[indexPath.row]
                
                cell.list = self.socialArray[indexPath.row]
                cell.shareTap.tag = indexPath.row
                cell.likeTap.tag = indexPath.row
                cell.commentTap.tag = indexPath.row
                cell.optionsButton.tag=indexPath.row
                cell.webviewButton.tag = indexPath.row
                cell.delegate = self
                
                
                
                if (GlobalFunctions.checkContentLikeId(id: currentList._id ?? "") || self.is_like.contains(currentList._id ?? "")) {
                    cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
                    self.is_like.append(currentList._id ?? "")
                } else {
                    cell.likeButton.setImage(UIImage(named: "newUnlike"), for: .normal)
                }
                
                
                if let isCaption = currentList.date_diff_for_human
                {
                    cell.daysLabel.isHidden = false
                    cell.daysLabel.text = isCaption.captalizeFirstCharacter()
                }
                
                print("cell for row name\(currentList.name) && caption(\(currentList.caption))")
                if currentList.name != "" && currentList.name != nil
                {
                    let types: NSTextCheckingResult.CheckingType = .link
                    cell.statusLabel.isHidden = false
                    cell.statusLabel.text = currentList.name
                } else {
                    //                cell.statusLabel.isHidden = false
                    //                cell.statusLabel.text = currentList.name
                }
                if currentList.caption != "" && currentList.caption != nil
                {
                    cell.statusLabel.isHidden = false
                    cell.statusLabel.text = currentList.caption
                }
                
                if let likes = currentList.stats?.likes{
                    
                    cell.likeCountLabel.text = likes.roundedWithAbbreviations  //formatPoints(num: Double(likes))//String(likes)
                }
                if currentList.commentbox_enable == "true" && currentList.commentbox_enable != nil && currentList.commentbox_enable != "" {
                    cell.commentTap.isUserInteractionEnabled = true
                    cell.commentTap.backgroundColor = UIColor.clear
                } else {
                    cell.commentButton.isUserInteractionEnabled = false
                    cell.commentTap.isUserInteractionEnabled = false
                    cell.commentTap.backgroundColor =  BlackThemeColor.white//hexStringToUIColor(hex: MyColors.cardBackground)
                }
                
                cell.webViewLabel.text = ""
                if let listLabel = currentList.webview_label, listLabel != "" {
                    cell.webViewLabel.isHidden = false
                    cell.webViewLabel.text = listLabel
                    cell.webviewButton.isUserInteractionEnabled = true
                    cell.webViewLabel.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
                } else {
                    cell.webviewButton.isUserInteractionEnabled = false
                    cell.webViewLabel.backgroundColor = UIColor.clear
                }
                
                if let comments = currentList.stats?.comments{
                    
                    cell.commentCountLabel.text = comments.roundedWithAbbreviations //formatPoints(num: Double(comments))//String(comments)
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
            }
            
            self.configure(cell: cell, forRowAtIndexPath: indexPath)
            
            return cell
        }
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
//            navigationController?.setNavigationBarHidden(true, animated: true)
//
//            //            changeTabBars(hidden: true, animated: true)
//            //            self.tabBarController?.tabBar.isHidden = true
//        } else {
//            navigationController?.setNavigationBarHidden(false, animated: true)
//
//            //            changeTabBars(hidden: false, animated: true)
//            //            self.tabBarController?.tabBar.isHidden = false
//        }
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == self.socialArray.count - 1 && self.totalPages > pageNumber {
            if ( Reachability.isConnectedToNetwork() == true) {
                pageNumber = pageNumber + 1
                spinner.color = hexStringToUIColor(hex: "#000000")
                
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: socialTableView.bounds.width, height: CGFloat(10))
                
                self.socialTableView.tableFooterView = spinner
                self.socialTableView.tableFooterView?.isHidden = false
                if !self.isNewDataLoading {
                    self.isNewDataLoading = true
                    self.getData()
                }
            } else {
                self.showToast(message: Constants.NO_Internet_MSG)
            }
            
        } else if (flagIsFromLocalOrServer == true) {
            
            
            if ( Reachability.isConnectedToNetwork() == true) {
                self.pageNumber = 1
                self.imgArr.removeAllObjects()
                self.arrData.removeAllObjects()
                self.arrStoredDetails.removeAllObjects()
                self.arrSinglePhotoData.removeAllObjects()
                self.socialArray.removeAll()
                spinner.color = UIColor.white
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: socialTableView.bounds.width, height: CGFloat(10))
                self.socialTableView.tableFooterView = spinner
                self.socialTableView.tableFooterView?.isHidden = false
                if !self.isNewDataLoading {
                    self.isNewDataLoading = true
                    self.getData()
                }
                flagIsFromLocalOrServer = false
            } else {
                if self.socialArray.count == indexPath.row{
                    self.showToast(message: Constants.NO_Internet_Connection_MSG)
                }
            }
        } else {
//            cellHeights[indexPath] = cell.frame.size.height
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return cellHeights[indexPath] ?? UITableView.automaticDimension
//    }
    
    func configure(cell: SocialTableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        print("==== \(indexPath.row) ====")
        if likeSelectedArray.contains(indexPath.row) {
            cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
            cell.likeButton.isSelected = true
        }
        else {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.socialArray.count > 0, let currentList = socialArray[indexPath.row] as? List {
            let currentList : List  = socialArray[indexPath.row]
            self.selectedIndexs = indexPath.row
            //        if let dict = arrStoredDetails.object(at: indexPath.row) as? NSMutableDictionary{
            
            //        let isVideo = (dict.object(forKey: "video") as? NSNumber)?.boolValue
            if currentList.type == "video" {
                CustomMoEngage.shared.sendEventUIComponent(componentName: "News_Feed_Video", extraParamDict: nil)
                if (Reachability.isConnectedToNetwork() == true) {
                    
                    // let videoType = dict.object(forKey: "videoType") as! String
                    if currentList.video?.player_type == "internal" {
                        if let url = currentList.video?.url {
                            if let videoURL = URL(string: url) {
                                let player = AVPlayer(url: videoURL)
                                self.playerViewController.player = player
                                NotificationCenter.default.addObserver(self, selector: #selector(SocialJunctionViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                self.present(playerViewController, animated: true) {
                                    
                                    self.playerViewController.player?.play()
                                    
                                }
                                self.callViewCountAPI(currentList._id ?? "", indexPath)
                                self.addObeserVerOnPlayerViewController()
                            }
                        }
                    } else {
                        if currentList.video?.url != nil && currentList.video?.url != ""{
                            let url = currentList.video?.url
                            if url == "NA" {
                                self.showToast(message: "This video is currently unavailable.")
                                let  payloadDict = NSMutableDictionary()
                                payloadDict.setObject(currentList._id ?? "" , forKey: "content_id" as NSCopying)
                                payloadDict.setObject("Failed", forKey: "status" as NSCopying)
                                payloadDict.setObject("This video is currently unavailable." , forKey: "reason" as NSCopying)
                                CustomMoEngage.shared.sendEventUIComponent(componentName: "News_Feed_Video", extraParamDict: payloadDict)
                            } else {

                                self.addCloseButton()
                            }
                        } else {
                            self.showToast(message: "This video is currently unavailable.")
                            let  payloadDict = NSMutableDictionary()
                            payloadDict.setObject(currentList._id ?? "" , forKey: "content_id" as NSCopying)
                            payloadDict.setObject("Failed", forKey: "status" as NSCopying)
                            payloadDict.setObject("This video is currently unavailable." , forKey: "reason" as NSCopying)
                            CustomMoEngage.shared.sendEventUIComponent(componentName: "News_Feed_Video", extraParamDict: payloadDict)
                        }
                    }
                } else {
                    self.showToast(message: Constants.NO_Internet_MSG)
                }
                //            }
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
                
            } else if (currentList.type == "poll" && currentList.photo != nil && currentList.photo?.cover != "" && currentList.photo?.cover != nil) {
                CustomMoEngage.shared.sendEventUIComponent(componentName: "News_Feed_Photo", extraParamDict: nil)
                let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                
                let SocialPhotosViewController = mainstoryboad.instantiateViewController(withIdentifier: "SocialPhotosViewController") as! SocialPhotosViewController
                
                SocialPhotosViewController.storeDetailsArray = self.socialArray
                SocialPhotosViewController.pageIndex = indexPath.row
                self.pushAnimation()
                isShowPhoto = true
                self.navigationController?.pushViewController(SocialPhotosViewController, animated: false)
            } else if (currentList.type != nil && currentList.type == "poll" && currentList.video?.cover != nil && currentList.video?.url != nil) {
                if let videoURLStr = currentList.video?.url {
                    if let videoURL = URL(string: videoURLStr) {
                        let player = AVPlayer(url: videoURL)
                        self.playerViewController.player = player
                        NotificationCenter.default.addObserver(self, selector: #selector(SocialJunctionViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                        self.present(playerViewController, animated: true) {
                            self.playerViewController.player?.play()
                            
                        }
                        self.callViewCountAPI(currentList._id ?? "", indexPath)
                        self.addObeserVerOnPlayerViewController()
                    }
                }
            } else if currentList.type == "photo" {
                let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
                SingleImageScrollViewController.storeDetailsArray = [currentList]
                SingleImageScrollViewController.pageIndex = 0
                SingleImageScrollViewController.selectedBucketCode = pageList?.code ?? ""
                SingleImageScrollViewController.selectedBucketName = pageList?.name ?? ""
                SingleImageScrollViewController.isFromAlbum = true
                self.pushAnimation()
                self.navigationController?.pushViewController(SingleImageScrollViewController, animated: false)
            }
        }
    }
    
    func playVideo(url: String) {
        let youtubeCode = URL(string: url)?.lastPathComponent
        let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeCode)
        NotificationCenter.default.addObserver(self, selector: #selector(VideosViewController.moviePlayerPlaybackDidFinish(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: videoPlayerViewController.moviePlayer)
        self.present(videoPlayerViewController, animated: true) {
            videoPlayerViewController.moviePlayer.play()
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
        playerViewController.dismiss(animated: true,completion: nil)
    }
    
    func getData() {
        
        if isFirstTime == true {
            
            //            self.showLoader()
            self.shimmer.isShimmering = true
            self.shimmer.isHidden = false
            
            self.shimmer1.isShimmering = true
            self.shimmer1.isHidden = false
            
            self.shimmer2.isShimmering = true
            self.shimmer2.isHidden = false
            
            self.shimmer3.isShimmering = true
            self.shimmer3.isHidden = false
            
            self.shimmer4.isShimmering = true
            self.shimmer4.isHidden = false
            
            self.shimme5.isShimmering = true
            self.shimme5.isHidden = false
            
            self.shimme1.isShimmering = true
            self.shimme1.isHidden = false
            
            self.shimme2.isShimmering = true
            self.shimme2.isHidden = false
            
            self.shimme3.isShimmering = true
            self.shimme3.isHidden = false
            
            self.shimme4.isShimmering = true
            self.shimme4.isHidden = false
            
            self.shim1.isShimmering = true
            self.shim1.isHidden = false
            
            self.shim2.isShimmering = true
            self.shim2.isHidden = false
            
            self.shim3.isShimmering = true
            self.shim3.isHidden = false
            
            self.shim4.isShimmering = true
            self.shim4.isHidden = false
            
            self.shim5.isShimmering = true
            self.shim5.isHidden = false
            
            self.placeholderView.isHidden = false
        }
        
//        guard let bucketId = BucketValues.bucketIdArray.first else {
//            self.showToast(message: "Something went wrong please try again.")
//            return
//        }
        guard let bucketId = pageList?._id else {
            self.showToast(message: "Something went wrong please try again.")
            return
        }
        
        //        Reachability.networkSharedInstance.startNetworkReachabilityObserver()
        
        if Reachability.isConnectedToNetwork() {
            
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" + "&visibility=customer" + "&page=\(pageNumber)" + "&v=\(Constants.VERSION)", extraHeader: nil) { (result) in
                self.isFirstTime = false
                switch result {
                case .success(let data):
                    self.spinner.stopAnimating()
                    self.isNewDataLoading = false
                    self.isFirstTime = false
                    //                    self.stopLoader()
                    DispatchQueue.main.async {
                        //                            self.stopLoader()
                        //
                        self.shimmer.isShimmering = false
                        self.shimmer.isHidden = true
                        
                        self.shimmer1.isShimmering = false
                        self.shimmer1.isHidden = true
                        
                        self.shimmer2.isShimmering = false
                        self.shimmer2.isHidden = true
                        
                        self.shimmer3.isShimmering = false
                        self.shimmer3.isHidden = true
                        
                        self.shimmer4.isShimmering = false
                        self.shimmer4.isHidden = true
                        
                        self.shimme5.isShimmering = false
                        self.shimme5.isHidden = true
                        
                        
                        self.shimme1.isShimmering = false
                        self.shimme1.isHidden = true
                        
                        self.shimme2.isShimmering = false
                        self.shimme2.isHidden = true
                        
                        self.shimme3.isShimmering = false
                        self.shimme3.isHidden = true
                        
                        self.shimme4.isShimmering = false
                        self.shimme4.isHidden = true
                        
                        
                        self.shim1.isShimmering = false
                        self.shim1.isHidden = true
                        
                        self.shim2.isShimmering = false
                        self.shim2.isHidden = true
                        
                        self.shim3.isShimmering = false
                        self.shim3.isHidden = true
                        
                        self.shim4.isShimmering = false
                        self.shim4.isHidden = true
                        
                        self.shim5.isShimmering = false
                        self.shim5.isHidden = true
                        
                        self.placeholderView.isHidden = true
                        
                    }
                    
                    UIViewController.removeSpinner(spinner: self.spinnerView)
                    print("=>\(data)")
                    self.refreshControl.endRefreshing()
                    if let feeds = data["data"]["list"].arrayObject {
                        self.database.createSocialJunctionTable()
                        self.database.createStatsTable()
                        self.database.createVideoTable()
                        for feed in feeds {
                            if let list = List(dictionary: feed as! NSDictionary), !GlobalFunctions.checkContentBlockId(id: list._id ?? "") {
                                self.database.insertIntoSocialTable(list:list, datatype: self.pageList?.code ?? "")
                                let pollStat = self.database.getPollData(content_Id: list._id ?? "")
                                if pollStat.count > 0 {
                                    list.pollStat = pollStat
                                }
                                self.socialArray.append(list)
                            } else {
                                print(feed)
                            }
                        }
                        if  self.socialArray.count > 0 {
                            self.internetConnectionLostView.isHidden = true
                        }
                        DispatchQueue.main.async {
                        self.socialTableView.reloadData()
                        }
                    }
                    if let totalPages = data["data"]["paginate_data"]["last_page"].int {
                        self.totalPages = totalPages
                    }
                    if let totalRecords = data["data"]["paginate_data"]["total"].int {
                        self.totalItems = totalRecords
                    }
                    if let currentPage =  data["data"]["paginate_data"]["current_page"].int{
                        self.currentPage = currentPage
                    }
                    
                    let gai = GAI.sharedInstance()
                    if let event = GAIDictionaryBuilder.createEvent(withCategory: "Home News Feed Screen ios", action: "API Pagination Number \(self.currentPage) (ios) ", label: "Success", value: nil).build() as? [AnyHashable : Any] {
                        gai?.defaultTracker.send(event)
                        
                    }
                    
                case .failure(let error):
                    self.isNewDataLoading = false
                    //                    self.stopLoader()
                    DispatchQueue.main.async {
                        //                            self.stopLoader()
                        //
                        self.shimmer.isShimmering = false
                        self.shimmer.isHidden = true
                        
                        self.shimmer1.isShimmering = false
                        self.shimmer1.isHidden = true
                        
                        self.shimmer2.isShimmering = false
                        self.shimmer2.isHidden = true
                        
                        self.shimmer3.isShimmering = false
                        self.shimmer3.isHidden = true
                        
                        self.shimmer4.isShimmering = false
                        self.shimmer4.isHidden = true
                        
                        self.shimme5.isShimmering = false
                        self.shimme5.isHidden = true
                        
                        
                        self.shimme1.isShimmering = false
                        self.shimme1.isHidden = true
                        
                        self.shimme2.isShimmering = false
                        self.shimme2.isHidden = true
                        
                        self.shimme3.isShimmering = false
                        self.shimme3.isHidden = true
                        
                        self.shimme4.isShimmering = false
                        self.shimme4.isHidden = true
                        
                        self.shim1.isShimmering = false
                        self.shim1.isHidden = true
                        
                        self.shim2.isShimmering = false
                        self.shim2.isHidden = true
                        
                        self.shim3.isShimmering = false
                        self.shim3.isHidden = true
                        
                        self.shim4.isShimmering = false
                        self.shim4.isHidden = true
                        
                        self.shim5.isShimmering = false
                        self.shim5.isHidden = true
                        
                        self.placeholderView.isHidden = true
                    }
                    UIViewController.removeSpinner(spinner: self.spinnerView)
                    self.refreshControl.endRefreshing()
                    //                    if self.isFirstTime == true {
                    if (self.database != nil) {
                        self.flagIsFromLocalOrServer = true
                        self.socialArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                        if  self.socialArray.count > 0 {
                            self.internetConnectionLostView.isHidden = true
                        }
                        DispatchQueue.main.async {
                            self.socialTableView.reloadData()
                        }
                    }
                    else {
                        //                        self.stopLoader()
                        
                        DispatchQueue.main.async {
                            //                            self.stopLoader()
                            //
                            self.shimmer.isShimmering = false
                            self.shimmer.isHidden = true
                            
                            self.shimmer1.isShimmering = false
                            self.shimmer1.isHidden = true
                            
                            self.shimmer2.isShimmering = false
                            self.shimmer2.isHidden = true
                            
                            self.shimmer3.isShimmering = false
                            self.shimmer3.isHidden = true
                            
                            self.shimmer4.isShimmering = false
                            self.shimmer4.isHidden = true
                            
                            self.shimme5.isShimmering = false
                            self.shimme5.isHidden = true
                            
                            
                            self.shimme1.isShimmering = false
                            self.shimme1.isHidden = true
                            
                            self.shimme2.isShimmering = false
                            self.shimme2.isHidden = true
                            
                            self.shimme3.isShimmering = false
                            self.shimme3.isHidden = true
                            
                            self.shimme4.isShimmering = false
                            self.shimme4.isHidden = true
                            
                            self.shim1.isShimmering = false
                            self.shim1.isHidden = true
                            
                            self.shim2.isShimmering = false
                            self.shim2.isHidden = true
                            
                            self.shim3.isShimmering = false
                            self.shim3.isHidden = true
                            
                            self.shim4.isShimmering = false
                            self.shim4.isHidden = true
                            
                            self.shim5.isShimmering = false
                            self.shim5.isHidden = true
                            
                            self.placeholderView.isHidden = true
                        }
                        
                        //                        self.showToast(message: error.localizedDescription)
                        self.socialArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                        if  self.socialArray.count > 0 {
                            self.internetConnectionLostView.isHidden = true
                        }
                        DispatchQueue.main.async {
                            self.socialTableView.reloadData()
                        }
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            //            self.stopLoader()
            
            DispatchQueue.main.async {
                //                            self.stopLoader()
                //
                self.shimmer.isShimmering = false
                self.shimmer.isHidden = true
                
                self.shimmer1.isShimmering = false
                self.shimmer1.isHidden = true
                
                self.shimmer2.isShimmering = false
                self.shimmer2.isHidden = true
                
                self.shimmer3.isShimmering = false
                self.shimmer3.isHidden = true
                
                self.shimmer4.isShimmering = false
                self.shimmer4.isHidden = true
                
                self.shimme5.isShimmering = false
                self.shimme5.isHidden = true
                
                
                self.shimme1.isShimmering = false
                self.shimme1.isHidden = true
                
                self.shimme2.isShimmering = false
                self.shimme2.isHidden = true
                
                self.shimme3.isShimmering = false
                self.shimme3.isHidden = true
                
                self.shimme4.isShimmering = false
                self.shimme4.isHidden = true
                
                self.shim1.isShimmering = false
                self.shim1.isHidden = true
                
                self.shim2.isShimmering = false
                self.shim2.isHidden = true
                
                self.shim3.isShimmering = false
                self.shim3.isHidden = true
                
                self.shim4.isShimmering = false
                self.shim4.isHidden = true
                
                self.shim5.isShimmering = false
                self.shim5.isHidden = true
                
                self.placeholderView.isHidden = true
            }
            if (self.database != nil) {
                self.flagIsFromLocalOrServer = true
                self.socialArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                if  self.socialArray.count > 0 {
                    self.internetConnectionLostView.isHidden = true
                }
                DispatchQueue.main.async {
                    self.socialTableView.reloadData()
                }
            }
            self.showToast(message: Constants.NO_Internet_MSG)
        }
        
    }
    
    
    func showSinglePics()
    {
        if arrData.count > 0
        {
            for i in 0...arrData.count - 1
            {
                if let dict = arrData.object(at: i) as? NSMutableDictionary {
                    arrSinglePhotoData.add(dict)
                }
            }
            
            //            }
        }
        DispatchQueue.main.async {
            self.socialTableView.reloadData()
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
//                    var bCode = "social-life"
//                    var bName = "STAY CLOSE"
//                    if let bucketList = GlobalFunctions.returnSelectedIndexBucketList(arr: bucketsArray, atIndex: 0) {
//                        bCode = bucketList.code ?? "social-life"
//                        bName = bucketList.caption ?? "STAY CLOSE"
//                    }
                    if let currentList = self.socialArray[self.selectedIndexs] as? List {
                        CustomMoEngage.shared.sendEventViewVide(id: currentList._id ?? "", coins: currentList.coins ?? 0, bucketCode:pageList?.code ?? "", bucketName: pageList?.name ?? "", videoName: currentList.caption ?? "", type: currentList.commercial_type ?? "", percent: percentage)
                    }

                }
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
                            let currentList = self.socialArray[index.row]
                            guard let type = currentList.type else {return}
                            
                            if type == "poll" {
                                guard let cell =  self.socialTableView.cellForRow(at: index) as? PollTableViewCell else { return }
                                
                                DispatchQueue.main.async {
                                    if self.socialArray.count > index.row {
                                        let currentList = self.socialArray[index.row]
                                        var views = currentList.stats?.views ?? 0
                                        views = views + 1
                                        cell.videoViewCountLabel.text = "\(views.roundedWithAbbreviations)"
                                        currentList.stats?.views = views
                                        self.socialArray[index.row] = currentList
                                    }
                                    self.socialTableView.reloadRows(at: [index], with: .none)
                                }
                                
                            } else {
                                guard let cell =  self.socialTableView.cellForRow(at: index) as? SocialTableViewCell else { return }
                                DispatchQueue.main.async {
                                    if self.socialArray.count > index.row {
                                        let currentList = self.socialArray[index.row]
                                        var views = currentList.stats?.views ?? 0
                                        views = views + 1
                                        cell.videoViewCountLabel.text = "\(views.roundedWithAbbreviations)"
                                        currentList.stats?.views = views
                                        self.socialArray[index.row] = currentList
                                    }
                                    self.socialTableView.reloadRows(at: [index], with: .none)
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
extension SocialJunctionViewController:PollTableViewCellDelegate {
    
    func didLikePollButton(_ sender: UIButton) {
        let socialPost = self.socialArray[sender.tag]
        
        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:"User not logged in", extraParamDict: nil)
            return
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        guard let cell =  self.socialTableView.cellForRow(at: indexPath) as? PollTableViewCell else {
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
            if (socialArray != nil && socialArray.count > 0) {
                
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
            
            if (socialArray != nil && socialArray.count > 0) {
                
                if let contentId = socialArray[indexPath.row]._id {
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
        socialTableView.beginUpdates()
        socialTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        socialTableView.endUpdates()
    }
    
    func showLoginAlert() {
        self.loginPopPop()
    }
    
    func didTapCommentButton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let CommentViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
            if (socialArray != nil && socialArray.count > 0) {
                let dict = self.socialArray[sender.tag]
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
        if Reachability.isConnectedToNetwork() == true
        {
            if !self.checkIsUserLoggedIn() {
                self.loginPopPop()
                return
            }
            let currentIndex = sender.tag
            let currentList = self.socialArray[currentIndex]
            
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
    func showPurchaseAlert() {
        self.showToast(message: "Please unlock the content before submit poll")
    }
}

extension SocialJunctionViewController: PurchaseContentProtocol{
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        let currentList : List = self.socialArray[index]
        if let type = currentList.type , type == "poll"{
            self.socialTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
        }
    }
}
