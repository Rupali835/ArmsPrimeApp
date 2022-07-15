//
//  podcastDetailViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 07/09/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AVKit
import SDWebImage
import XCDYouTubeKit
import AudioPlayerManager
import MediaPlayer


class podcastDetailViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource,PodcastDetailTableViewCellDelegate,PurchaseContentProtocol{
 
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var daysAgo: UILabel!
    @IBOutlet weak var totaltrack: UILabel!
    @IBOutlet weak var albumCaption: UILabel!
    @IBOutlet weak var albumTitleName: UILabel!
    @IBOutlet weak var podDetailsTableView: UITableView!
    @IBOutlet var backgroundimage: UIImageView!
    @IBOutlet var internetConnectionLostView: UIView!
    @IBOutlet var retryAgainButton: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    
    let hasWeaponOfMassDescrtruction : Bool = true
    var images = [AnyObject]()
    var arrData = NSMutableArray()
    var selectedIndexVal: Int!
    var askAlbum: Bool!
    var parentId = ""
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
    
    let reachability = Reachability()!
    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView!
    var isTableLoaded : Bool = false
    var selectedlikeButton = [IndexPath]()
    var videosArray : [List]! = [List]()
    var bucketsArray : [List]!
    var currentSong: List?
    let database = DatabaseManager.sharedInstance
    var flagIsFromLocalOrServer = false
    var arrSinglePhotoData = NSMutableArray()
    var bucketid: String = ""
    var albumname: String = ""
    var albumcover:String = ""
    var postId = ""
    var bucketId: String?
    var isLogin = false
    var pageNumber = 0
    var currentPage = 0
    var totalPages = 0
    var totalItems = 0
    let spinner = UIActivityIndicatorView(style: .white)
    var selectedPost : List!
    var currentAudioUrl = ""
    var contetid:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
//        if contetid != "" {
//
//            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
//            let BucketContentDetailsViewController = mainstoryboad.instantiateViewController(withIdentifier: "BucketContentDetailsViewController") as! BucketContentDetailsViewController
//            BucketContentDetailsViewController.contedID = contetid
//
//            self.navigationController?.pushViewController(BucketContentDetailsViewController, animated: true)
//        }
        
//        self.bottomBarView.isHidden = true
        
        backgroundimage.sd_setImage(with: URL(string: (selectedPost.photo?.cover)!) , completed: nil)
        
         if let albumcaption = selectedPost.caption{
              self.albumCaption.text = "\(albumcaption) | "
        }
        
        if let totalEpisode = selectedPost.stats?.childrens{
            
            self.totaltrack.text = "\(totalEpisode) Tracks "
            
        }
         if let days = selectedPost.date_diff_for_human{
            
            self.daysAgo.text = "\(days)"
        }
        
    
        pageNumber = 1
        self.tabBarController?.tabBar.isHidden = true
      
        self.navigationItem.title =  self.selectedPost.name
//        self.albumTitleName.text = self.selectedPost.name
       self.navigationItem.rightBarButtonItem = nil
        
//        if #available(iOS 11.0, *) {
//             self.navigationController?.navigationBar.prefersLargeTitles = true
//             self.navigationItem.largeTitleDisplayMode = .always
//
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            self.navigationController?.navigationBar.shadowImage = UIImage();           self.navigationController?.navigationBar.isTranslucent = true
////            self.navigationController?.view.backgroundColor = .yellow
//            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        } else {
//            // Fallback on earlier versions
//        }
      
//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.internetConnectionLostView.isHidden = true
        arrStoredDetails.removeAllObjects()
        arrData.removeAllObjects()
        imgArr.removeAllObjects()
        imageArray.removeAllObjects()
        self.getData()
        
        podDetailsTableView.allowsMultipleSelection = false
        
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }
        
        
     podDetailsTableView.register(UINib(nibName: "PodcastDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PodcastDetailTableViewCell")
        
        self.podDetailsTableView.rowHeight = 170
        self.podDetailsTableView.estimatedRowHeight = podDetailsTableView.rowHeight
        self.podDetailsTableView.setNeedsUpdateConstraints()
        podDetailsTableView.dataSource = self
        podDetailsTableView.delegate = self
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }

    }
    

   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
        if scrollView.contentOffset.y <= 0
        {
            scrollView.contentOffset = CGPoint.zero
        }
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            
            print("Reachable via WiFi")
        case .cellular:
            
            print("Reachable via Cellular")
        case .none:
            if (videosArray.count == 0) {
                self.internetConnectionLostView.isHidden = false
            }
            print("Network not reachable")
        }
    }
    
    @IBAction func retryAgainClick(_ sender: UIButton) {
        if self.videosArray.count == 0 {
            self.getData()
            if  self.videosArray.count > 0 {
                self.internetConnectionLostView.isHidden = true
            }
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isTranslucent = true
    }
 

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTableLoaded = true
        GlobalFunctions.screenViewedRecorder(screenName: "Home podcast Screen")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
//         self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = false
        
        if BucketValues.bucketIdArray.count > 0 {
            if #available(iOS 10.0, *) {
                podDetailsTableView.refreshControl = refreshControl
            } else {
                podDetailsTableView.addSubview(refreshControl)
            }
            
            refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
            refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)
        }
        
        if AudioPlayerManager.shared.isPlaying() {
            let item = AudioPlayerManager.shared.currentTrack?.getPlayerItem()
            if let url = (item?.asset as? AVURLAsset)?.url {
                self.currentAudioUrl = "\(url)"
            }
        }

        self.podDetailsTableView.reloadData()
        
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
            
            self.navigationController?.pushViewController(CommentTableViewController, animated: true)
        }
        
        
    }
    
    func didShareButton(_ sender: UIButton) {
        if !Reachability.isConnectedToNetwork() {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
            return
        }
        let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,Constants.appStoreLink], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view
        
        self.present(viewController, animated: true, completion: nil)
 
    }
    
    func didLikeButton(_ sender: UIButton) {
        if !self.checkIsUserLoggedIn() {
            self.showAlert(message: Messages.loginAlertMsg)

            CustomMoEngage.shared.sendEventForLike(contentId: videosArray[sender.tag]._id ?? "", status: "Failed", reason:"User not logged in", extraParamDict: nil)
            return
        }
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell =  self.podDetailsTableView.cellForRow(at: indexPath) as? PodcastDetailTableViewCell else {
            return
        }
        let content = videosArray[sender.tag]
        if let postId = content._id, self.is_like.contains(postId) {
//            self.animateDidLikeButton(cell.likeButton)
            
            
            let anim = CABasicAnimation(keyPath: "transform")
            anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            anim.duration = 0.125
            anim.repeatCount = 1
            anim.autoreverses = true
            anim.isRemovedOnCompletion = true
            anim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0))
            cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
            cell.likeButton.layer.add(anim, forKey: nil)
            
            return
        }
        if let likeCount = Int(cell.likeCount.text!) {
            cell.likeCount.text = (likeCount + 1).roundedWithAbbreviations
        }
        let anim = CABasicAnimation(keyPath: "transform")
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.duration = 0.125
        anim.repeatCount = 1
        anim.autoreverses = true
        anim.isRemovedOnCompletion = true
        anim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0))
        cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
        cell.likeButton.layer.add(anim, forKey: nil)
        
        if Reachability.isConnectedToNetwork()
        {
            
            let dict = ["content_id": content._id ?? "", "like": "true"] as [String: Any]
            if (!self.is_like.contains(content._id!)) {
                self.is_like.append(content._id ?? "")
            }
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
                        print(error?.localizedDescription)
                        GlobalFunctions.trackEvent(eventScreen: "Home Videos Screen", eventName: "Like", eventPostTitle: "Error : \(error?.localizedDescription)", eventPostCaption: "", eventId: content._id!)
                        CustomMoEngage.shared.sendEventForLike(contentId: content._id ?? "", status: "Failed", reason: error?.localizedDescription ?? "", extraParamDict: nil)
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        if json?.object(forKey: "error") as? Bool == true {
                            GlobalFunctions.trackEvent(eventScreen: "Home Videos Screen", eventName: "Like", eventPostTitle: "Error", eventPostCaption: "", eventId: content._id!)
                              CustomMoEngage.shared.sendEventForLike(contentId: content._id ?? "", status: "Failed", reason: "", extraParamDict: nil)
                        } else if (json?.object(forKey: "status_code") as? Int == 200)
                        {
                            
                            GlobalFunctions.trackEvent(eventScreen: "Home Videos Screen", eventName: "Like", eventPostTitle: "Success", eventPostCaption: "", eventId: content._id!)
                            
                            print("Photo json \(String(describing: json))")
                            
                            DispatchQueue.main.async {
                                
                                let indexPath = IndexPath(row: sender.tag, section: 0)
                                
                                if let cell = self.podDetailsTableView.cellForRow(at: indexPath) as? PodcastDetailTableViewCell
                                {
                                    
                                    GlobalFunctions.saveLikesIdIntoDatabase(content_id: content._id ?? "")
                                    
                                    if !self.likeSelectedArray.contains(cell.likeButton.tag) {
                                        self.likeSelectedArray.append(cell.likeButton.tag)
                                    }
                                }
                                CustomMoEngage.shared.sendEventForLike(contentId: content._id ?? "", status: "Success", reason: "", extraParamDict: nil)
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                        GlobalFunctions.trackEvent(eventScreen: "Home Videos Screen", eventName: "Like", eventPostTitle: "Error : \(error.localizedDescription)", eventPostCaption: "", eventId: content._id!)
                         CustomMoEngage.shared.sendEventForLike(contentId: content._id ?? "", status: "Failed", reason: "Error : \(error.localizedDescription)", extraParamDict: nil)
                    }
                    
                }
                task.resume()
            }
        } else {
            
            if (videosArray != nil && videosArray.count > 0) {
                
                let contentId = videosArray[indexPath.row]._id
                GlobalFunctions.saveLikesIdIntoDatabase(content_id: contentId as! String)
                if (!self.is_like.contains(contentId!)) {
                    self.is_like.append(contentId!)
                }
            }
        }
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.videosArray != nil && self.videosArray.count > 0
        {
            return self.videosArray.count
        } else
        {
            return 0
        }
    }
    
    func didTapOpenPurchase(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true
        {
            let currentIndex = sender.tag
            let currentList = self.videosArray[currentIndex]
            
            if (currentList != nil) {
                if !self.checkIsUserLoggedIn() {
                    self.showAlert(message: Messages.loginAlertMsg)
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
                popOverVC.selectedBucketCode = "podcast"
                popOverVC.selectedBucketName = "podcast"
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        } else {
            showToast(message: Constants.NO_Internet_MSG)
        }
        
        
        
    }
    
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
     
        if let cell : PodcastDetailTableViewCell = self.podDetailsTableView.cellForRow(at: IndexPath.init(item: index, section: 0)) as? PodcastDetailTableViewCell{
            
         
            cell.lockImage.isHidden = false
            cell.lockImage.image = UIImage(named: "unlocked")
        }
//        self.showToast(message: "Unlocked Successfully")
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podDetailsTableView.dequeueReusableCell(withIdentifier: "PodcastDetailTableViewCell", for: indexPath)as!PodcastDetailTableViewCell

        if self.videosArray.count > 0 && self.videosArray.count >= indexPath.row {
            
            let currentList : List = self.videosArray[indexPath.row]
            if (!GlobalFunctions.checkContentBlockId(id: currentList._id!)) {
                
                if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0 {

                     cell.lockImage.isHidden = false
                     cell.premiumLabel.isHidden = false
                } else {
                    if (GlobalFunctions.isContentsPurchased(list: currentList)) {

                        cell.lockImage.isHidden = false
                        cell.lockImage.image = UIImage(named: "unlocked")

                    }

                }
             
                
                if currentList.audio?.url == self.currentAudioUrl {
                    cell.playAnimationImage.loadGif (name: "giphy")
                }
              
//                cell.playAnimationImage.loadGif (name: "giphy")
                cell.shareButton.tag = indexPath.row
                cell.likeButton.tag = indexPath.row
                cell.commentButton.tag = indexPath.row
                
                cell.delegate = self
                
                if self.videosArray.count > 0
                {
                    if  let currentList = self.videosArray[indexPath.row] as? List{
                        
                        if (GlobalFunctions.checkContentLikeId(id: currentList._id!) || self.is_like.contains(currentList._id!)) {
                            cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
                        } else {
                            cell.likeButton.setImage(UIImage(named: "newUnlike"), for: .normal)
                        }
                        
                        let ceckType = currentList.type
                        if  ceckType == "audio" {
                        if var urlString = currentList.audio?.cover as? String {
                            
                            cell.podcastImage.sd_imageIndicator?.startAnimatingIndicator()
                            cell.podcastImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.podcastImage.sd_imageTransition = .fade
                            cell.podcastImage.sd_setImage(with: URL(string: urlString), completed: nil)
                            cell.podcastImage.contentMode = .scaleAspectFill
                            cell.podcastImage.clipsToBounds = true
                            
                        }
                        
                        
                        cell.podcastTitleName.text = ""
                        cell.podcastCaption.text = ""
                        
                        if  currentList.name != ""
                        {
                            cell.podcastTitleName.isHidden = false
                            cell.podcastTitleName.text = currentList.name
                            cell.podcastTitleName.text = cell.podcastTitleName.text?.uppercased()
                            
                        }
                        if currentList.caption != ""{
                            
                            cell.podcastCaption.isHidden = false
                            cell.podcastCaption.text = currentList.caption?.captalizeFirstCharacter()
                            
                        }
                        
                        if let days = currentList.date_diff_for_human{
                            
                            cell.daysAgo.text = "\(days)"
                            
                        }
                        
                        if let totallike = currentList.stats?.likes{
                            
                            cell.likeCount.text = totallike.roundedWithAbbreviations
                            
                        }
                        if let totalcomment = currentList.stats?.comments{
                            
                            cell.commentCount.text = totalcomment.roundedWithAbbreviations
                            
                        }
                    }
                        else {
                           
                            
                        }
                }
                }
            }
        }
        
        
         self.configure(cell: cell, forRowAtIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: PodcastDetailTableViewCell, forRowAtIndexPath indexPath: IndexPath) {
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
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        for index in 0...tableView.numberOfRows(inSection: 0) {
            let indexpath = IndexPath(item: index, section: 0)
            if let cell = podDetailsTableView.cellForRow(at: indexpath) as? PodcastDetailTableViewCell {
                
                cell.playAnimationImage.image = UIImage(named: "playMusicButton")
            }

        }

        if (Reachability.isConnectedToNetwork() == true) {
            if let dict = arrStoredDetails.object(at: indexPath.row) as? NSMutableDictionary{
                let currentCell = podDetailsTableView.cellForRow(at: indexPath) as? PodcastDetailTableViewCell
                let selectedItem = indexPath
                
                if selectedItem == indexPath {
                    if (GlobalFunctions.isContentPiadWithDictCoins(dict: dict as! Dictionary<String, Any>)) {
                        currentCell?.playAnimationImage.image = UIImage(named: "playMusicButton")
                    } else {
                        currentCell?.playAnimationImage.loadGif (name: "giphy")
                    }
                    
                }
                
                let currentList = videosArray[indexPath.row] as? List
                if (GlobalFunctions.isContentPiadWithDictCoins(dict: dict as! Dictionary<String, Any>)) {
                   
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
//               currentCell?.playAnimationImage.loadGif (name: "giphy")
                    self.addChild(popOverVC)
                    popOverVC.delegate = self
                    popOverVC.contentIndex = indexPath.item
                    popOverVC.currentContent = currentList
                    popOverVC.selectedBucketCode = "podcast"
                    popOverVC.selectedBucketName = "podcast"
                    if let contentId = dict.value(forKey: "parentId") as? String{
                        if let coin = dict.value(forKey: "coins") as? String{
                            CustomMoEngage.shared.sendEventForLockedContent(id: contentId )
                            popOverVC.contentId = contentId
                            popOverVC.coins = Int(coin)
                            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                            self.view.addSubview(popOverVC.view)
                            popOverVC.didMove(toParent: self)
                        }
                    }
                    
                } else {

                    let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                    let PodcastPlayerViewController = mainstoryboad.instantiateViewController(withIdentifier: "PodcastPlayerViewController") as! PodcastPlayerViewController
                    PodcastPlayerViewController.podcastPlayer = currentList
                    PodcastPlayerViewController.storeDetailsArray = self.videosArray
                    PodcastPlayerViewController.pageIndex = indexPath.row

                    self.navigationController?.pushViewController(PodcastPlayerViewController, animated: true)
                
                    
                }
            }
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
 
  
    
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.videosArray.count - 1 && self.totalPages > pageNumber {
            
            pageNumber = pageNumber + 1
            spinner.color = UIColor.white
            
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: podDetailsTableView.bounds.width, height: CGFloat(10))
            
            self.podDetailsTableView.tableFooterView = spinner
            self.podDetailsTableView.tableFooterView?.isHidden = false
            self.getData()
        } else if (flagIsFromLocalOrServer == true) {
            
            if ( Reachability.isConnectedToNetwork() == true) {
                self.pageNumber = 1
                self.imgArr.removeAllObjects()
                self.arrData.removeAllObjects()
                self.arrStoredDetails.removeAllObjects()
                self.arrSinglePhotoData.removeAllObjects()
                self.videosArray.removeAll()
                self.getData()
                flagIsFromLocalOrServer = false
            }
        }
    }
    
    func getData()
    {
        if isFirstTime == true {
            self.showLoader()
        }
        //        if (BucketValues.bucketContentArr.count > 0) {
        //
        //            if let dataDict = BucketValues.bucketContentArr.object(at: self.selectedIndexVal) as? Dictionary<String, Any> {
        //                bucketId = dataDict["_id"] as? String
        //            }
        //        } else {
        //            bucketId = BucketValues.bucketIdArray[self.selectedIndexVal]
        //        }
        if Reachability.isConnectedToNetwork() == true
        {
            if let bucketId = self.bucketId {
                
                //                var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" + "&visibility=customer" + "&page=\(pageNumber)" + "&v=\(Constants.VERSION)"
                var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" +  "&parent_id=" + parentId + "&page=\(pageNumber)"
                
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
                            self.stopLoader()
                            self.refreshControl.endRefreshing()
                            self.flagIsFromLocalOrServer = true
                            self.spinner.stopAnimating()
                            if (self.database != nil) {
                                self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: "podcast")
                                if  self.videosArray.count > 0 {
                                    self.internetConnectionLostView.isHidden = true
                                }
                                
                                self.podDetailsTableView.reloadData()
                            }
                            
                        }
                        return
                    }
                    
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        print("Photo json \(String(describing: json))")
                        //need to store total val & fetch it & add to arr & load tbl view
                        
                        if json?.object(forKey: "error") as? Bool == true {
                            
                            DispatchQueue.main.async {
                                
                                let arr = json?.object(forKey: "error_messages")! as! NSMutableArray
                                self.spinner.stopAnimating()
                                self.flagIsFromLocalOrServer = true
                                self.refreshControl.endRefreshing()
                                if (self.database != nil) {
                                    self.stopLoader()
                                    //
                                    self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: "podcast")
                                    if  self.videosArray.count > 0 {
                                        self.internetConnectionLostView.isHidden = true
                                    }
                                    
                                    self.podDetailsTableView.reloadData()
                                
                                }
                            }
                            
                        } else if (json?.object(forKey: "status_code") as? Int == 200) {
                            if let AllData = json?.object(forKey: "data") as? NSMutableDictionary
                            {
                                if  let paginationData = AllData.object(forKey: "paginate_data") as? NSMutableDictionary{
                                    self.totalItems  = paginationData.object(forKey: "total") as! Int
                                    self.totalPages  = paginationData.object(forKey: "last_page") as! Int
                                    self.currentPage  = paginationData.object(forKey: "current_page") as! Int
                                }
                            }
                            
                            DispatchQueue.main.async {
                                
                                self.spinner.stopAnimating()
                                if let dictData = json?.object(forKey: "data") as? NSMutableDictionary{
                                    if let photoDetailsArr = dictData.object(forKey: "list") as? NSMutableArray{
                                        
                                        self.database.createSocialJunctionTable()
                                        self.database.createStatsTable()
                                        self.database.createVideoTable()
                                        for dict in photoDetailsArr{
                                            
                                            let list : List = List.init(dictionary: dict as! NSDictionary)!
                                            if (!GlobalFunctions.checkContentBlockId(id: list._id!)) {
                                                self.database.insertIntoSocialTable(list:list, datatype: "podcast")
                                                self.videosArray.append(list)
                                                
                                            }
                                        }
                                        self.videosArray = self.videosArray.unique{$0._id ?? ""}
                                        self.videosArray = self.videosArray.filter{$0.type != "photo"}
                                        
                                        //                                        self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: "video")
                                        
                                        if photoDetailsArr.count > 0
                                        {
                                            self.spinner.stopAnimating()
                                            self.arrData = photoDetailsArr
                                            self.displayLayout()
                                        }
                                        else
                                        {
                                            //                                               self.showToast(message: "No Data Available")
                                        }
                                    }
                                }
                                self.refreshControl.endRefreshing()
                                if (self.videosArray.count == 0) {
                                    self.currentPage = self.currentPage + 1
                                    self.getData()
                                }
                                
                                self.stopLoader()
                                if  self.videosArray.count > 0 {
                                    self.internetConnectionLostView.isHidden = true
                                }
                                
                                
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                        self.stopLoader()
                        
                        self.spinner.stopAnimating()
                        DispatchQueue.main.async {
                            self.flagIsFromLocalOrServer = true
                            self.refreshControl.endRefreshing()
                            if (self.database != nil) {
                                self.stopLoader()
                                
                                self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: "video")
                                if  self.videosArray.count > 0 {
                                    self.internetConnectionLostView.isHidden = true
                                }
                                
                                self.podDetailsTableView.reloadData()
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
            self.stopLoader()
            self.spinner.stopAnimating()
            self.refreshControl.endRefreshing()
            if (self.database != nil) {
                self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: "video")
                if  self.videosArray.count > 0 {
                    self.internetConnectionLostView.isHidden = true
                }
                
                self.podDetailsTableView.reloadData()
                
                
            }
            
        }
    }
    
    
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
            self.podDetailsTableView.reloadData()
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
                            let childrens = states.object(forKey: "childrens") as! NSNumber
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
                                                    newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments,"childrens":childrens, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                                } else
                                                {
                                                    newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments,"childrens":childrens, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                                }
                                            }
                                        } else
                                        {
                                            //                        if ((dict.object(forKey: "is_album") as Any) as AnyObject).intValue == 1
                                            if (dict.object(forKey: "is_album") as? String) == "true"
                                            {
                                                //                                    if (dict.object(forKey: "locked") as! String) == "true"
                                                //                                    {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments,"childrens":childrens, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                                //                                }
                                            } else
                                            {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments,"childrens":childrens, "shares": shares, "coins" : dict.object(forKey: "coins")! , "commercial_type" : dict.object(forKey: "commercial_type")!]
                                            }
                                        }
                                        
                                        //                        }
                                    } else
                                    {
                                        if let nameCaption = dict.object(forKey: "name")
                                        {
                                            newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": nameCaption, "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments,"childrens":childrens, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                        } else {
                                            newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments,"childrens":childrens, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
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
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments,"childrens":childrens, "shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    } else
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments,"childrens":childrens, "shares": shares , "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    }
                                    //                            }
                                } else
                                {
                                    if let nameCaption = dict.object(forKey: "name")
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": nameCaption, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "childrens":childrens,"shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    } else {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "childrens":childrens,"shares": shares, "coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    }
                                }
//                                if let videosDict = dict.object(forKey: "audio") as? NSDictionary {
//                                    if let videoType = videosDict.object(forKey: "content_types") as? String {
//                                        if videoType == "audios" {
//                                            if let converImage = videosDict.object(forKey: "cover"), let url = videosDict.object(forKey: "url") {
//                                                newDict.setValue(true, forKey: "audio")
//                                                newDict.setValue(url, forKey: "url")
//                                                newDict.setValue(converImage, forKey: "url")
//                                                
//                                                newDict.setValue(videoType, forKey: "audios")
//                                                imgArr.add(converImage)
//                                                
//                                            }
//                                        }
//                                    }
//                                }
                                
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
                self.podDetailsTableView.reloadData()
            }
            
        }
        
        
    }

}
extension UIView{
    func animShow() {
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide() {
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
