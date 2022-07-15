//
//  BucketContentDetailsViewController.swift
//  Karan Kundrra Official
//
//  Created by Razrtech3 on 04/09/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import AVKit
import Alamofire


class BucketContentDetailsViewController: BaseViewController, PurchaseContentProtocol {
 
    @IBOutlet weak var lblSharedTitle: UILabel!
    @IBOutlet weak var likecount: UILabel!
    @IBOutlet weak var likebutton: UIButton!
    @IBOutlet weak var playButtonImage: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var unlockPriceLabel: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    var contedID: String = ""
    var coins:Int!
    var dataArray : [List]!
    var backButton : UIButton!
    let database = DatabaseManager.sharedInstance
    var playerItem : AVPlayerItem!
    var playerViewController : AVPlayerViewController = AVPlayerViewController()
    var videoPlayer:AVPlayer = AVPlayer()
    var audioplayer: AVPlayer? = AVPlayer()
    var videourl = ""
    var comercialType: String = "free"
    var bucketcodeStr: String?
    var contentType: String = "photo"
    var isPurchase = Bool(false)
    
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var videoLockedView: UIView!
    var hideforwardBackwardView: UIView!
    var isSwipeVideo: Bool = true
    var timer = Timer()
    var dataDict : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.unlockView.isHidden = true

   //     self.addCloseButton()
        premiumLabel.font = UIFont(name: AppFont.regular.rawValue, size: 13.0)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        getData()
        setHideForwardBackWardOnWindow()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = true
        audioplayer?.pause()
        audioplayer = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         self.navigationController?.navigationBar.isHidden = true
        timer.invalidate()
        hideforwardBackwardView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func unlockContent(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true
        {
            if !self.checkIsUserLoggedIn() {
                self.loginPopPop()
                return
            }
            
            CustomMoEngage.shared.sendEventForLockedContent(id: contedID)
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
            self.addChild(popOverVC)
            popOverVC.delegate = self
            popOverVC.contentId = contedID
            popOverVC.coins = self.coins
            let list = List.init(dictionary: ["_id":contedID,"coins":"\(self.coins ?? 0 ) )","commercial_type":comercialType,"type":contentType,"caption":""])
            popOverVC.currentContent = list
            popOverVC.selectedBucketCode = bucketcodeStr
            popOverVC.selectedBucketName = "Share"
            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
        
    } else {
    showToast(message: Constants.NO_Internet_MSG)
    }

    }
    
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        
     
        if contentType == "video"{
            self.videoLockedView.isHidden = false
            self.premiumView.isHidden = true
        }else
        {
            if checkIsUserLoggedIn() {
                self.getUserMetaDataNew(id : self.contedID)
            }else{
                loginPopPop()
            }
        }
     
    }
    @IBAction func backbuttonAction(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
    func addCloseButton() {
        let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        //        button.backgroundColor = UIColor.black
        let image = UIImage(named: "backbutton") as UIImage?
        button.frame = CGRect(x: 10, y: 30, width: 25, height: 25)
        //        button.layer.cornerRadius = button.frame.height/2
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(btnPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.isHidden = false
    }
    
    @objc func btnPressed(sender: UIButton!) {
        self.navigationController?.navigationBar.isHidden = false
//         _ = navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: false)
        sender.isHidden = true
    }
    

    @IBAction func playVideo(_ sender: Any) {
        if (GlobalFunctions.checkContentPurchaseId( id : self.contedID)) {
            let videoURL = URL(string: videourl)
            if let player = AVPlayer(url: videoURL!) as? AVPlayer {
                self.playerViewController.player = player
                NotificationCenter.default.addObserver(self, selector: #selector(BucketContentDetailsViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                self.present(self.playerViewController, animated: true) {
                    self.playerViewController.player?.play()
                }
                self.addObeserVerOnPlayerViewController()
            }
        } else if comercialType == "free" {
            let videoURL = URL(string: videourl)
            if let player = AVPlayer(url: videoURL!) as? AVPlayer {
                self.playerViewController.player = player
                NotificationCenter.default.addObserver(self, selector: #selector(BucketContentDetailsViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                self.present(self.playerViewController, animated: true) {
                    self.playerViewController.player?.play()
                }
                self.addObeserVerOnPlayerViewController()
            }
        } else {
            calculateTimeForPartialVideo()
        }
    }
    
    @objc func didfinishplaying(note : NSNotification)
    {
        playerViewController.dismiss(animated: true,completion: nil)
    }
    

    func getData() {
        print("\(#function) called")
        
        likebutton.isUserInteractionEnabled = true

        var blurPic = String()
        var actualPic = String()
        
        if Reachability.isConnectedToNetwork()
        {
            self.showLoader()
            var strUrl = Constants.cloud_base_url + Constants.PHOTOGALARY + "\(self.contedID)"
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: strUrl)
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "GET"
           
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
            request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "ArtistId")
            request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
         
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                if error != nil{
                    print(error?.localizedDescription as Any)
                    self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: "share")
                 self.stopLoader()
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                      print("Photo json \(String(describing: json))")
                     self.dataDict = json
                    DispatchQueue.main.async {
                        
                        let dictData = json?.object(forKey: "data") as! [String:Any]
                        if let content  = dictData["content"] as?  [String:Any] {
                        
                        if  let stats  = content["stats"] as?  [String:Any] {
                        
                        if let like = stats["likes"] as? Int {
                            self.likecount.text = "\(like)"
                        }
                        
                        if let comment = stats["comments"] as? Int {
                            self.commentCount.text = "\(comment)"
                        }
                    }
                            if let meta = content["meta"] as? [String:Any]
                            {
                                guard let title = meta["title"] as? String else {
                                    return
                                }
                                self.lblSharedTitle.text = title
                            }
                      if let videoType = content["type"] as? String {
                        self.contentType = videoType
                         if let coin = content["coins"] as? Int {
                        if videoType == "photo"
                        {
                            self.premiumView.isHidden = true
                            self.videoLockedView.isHidden = true
                            
                            if coin > 0
                            {
                                if let blur_Photo = content["blur_photo"] as? [String: Any]
                                {
                                    
                                    if let b_portrait = blur_Photo["portrait"] as? String
                                    {
                                        if b_portrait != ""
                                        {
                                            blurPic = b_portrait
                                        }
                                      
                                    }
                                     if let b_landscape = blur_Photo["landscape"] as? String
                                    {
                                        if b_landscape != ""
                                        {
                                            blurPic = b_landscape
                                        }
                                       
                                    }
                                    
                                    if self.checkIsUserLoggedIn() {
                                        self.getUserMetaDataNew(id : self.contedID)
                                    }else{
                                        self.loginPopPop()
                                    }
                                    if self.isPurchase == false
                                    {
                                        self.unlockView.isHidden = false
                                        self.coins = coin
                                            self.comercialType = "paid"
                                        self.unlockPriceLabel.text = "Unlock premium content for \(coin) coins."
                                        self.setImage(imgurl: blurPic)
                                    }
                                    
                                }
                                else{
                                    if let bpic = content["blur_photo"] as? NSNull
                                    {
                                        if let pic = content["photo"] as? NSNull
                                        {
                                            self.imageView.image = UIImage(named: "celebrityProfileDP")
                                            self.showAlert(message: "No Object Found")
                                        }
                                        self.imageView.image = UIImage(named: "celebrityProfileDP")
                                        self.showAlert(message: "No Object Found")

                                    }
                                }
                            }
                            else
                            {
                                if let photo = content["photo"] as? [String: Any]
                                {
                              //  self.unlockView.isHidden = true
                                  if let imgUrl = photo["cover"] as? String
                                  {
                                    self.setImage(imgurl: imgUrl)
                                  }
                                }
                            }
                            
                          
                      
                      }
                        else if videoType == "video"  {
                          
                            if  let video  = content["video"] as?  [String:Any] {
                                if let profileimage = video["cover"] as? String {
                                    
                                     if (GlobalFunctions.checkContentPurchaseId( id : self.contedID)) {
                                        self.blurView.isHidden = true
                                        self.playButtonImage.isHidden = false
                                        self.premiumView.isHidden = true
                                        self.videoLockedView.isHidden = false
                                        self.imageView.sd_setImage(with: URL(string: profileimage) , completed: nil)
                                     } else {
                                    if coin == 0 {
                                    self.blurView.isHidden = true
                                    self.playButtonImage.isHidden = false
                                    self.imageView.sd_setImage(with: URL(string: profileimage) , completed: nil)
                                    } else {
                                        self.coins = coin
//                                        self.blurView.isHidden = false
                                         self.comercialType = "paid"
                                        self.premiumView.isHidden = false
                                        self.videoLockedView.isHidden = true
//                                        self.unlockPriceLabel.text = "Unlock premium content for \(coin) coins."
                                        self.playButtonImage.isHidden = false
                                        self.imageView.sd_setImage(with: URL(string: profileimage) , completed: nil)
                                    }
                                    }
                                }
                               if let url = video["url"] as? String {
                                
                                self.videourl = url
                                }
                                
 
                            }
                        } else {
                            if let photo  = content["photo"] as?  [String:Any] {
                                if let profileimage = photo["cover"] as? String {
                                    self.blurView.isHidden = true
                                    self.imageView.sd_imageIndicator?.startAnimatingIndicator()
                                    self.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                    self.imageView.sd_imageTransition = .fade
                                    self.imageView.sd_setImage(with: URL(string: profileimage), completed: nil)
                                }
                            }
                            }
                        }
                        
                   
                }
                    }
                    }
                    self.stopLoader()
                  
                } catch let error as NSError {
                    print(error)
                   self.stopLoader()
                }
               
            }
            task.resume()
            
          
        }
    }
     
    func setImage(imgurl : String)
    {
        self.imageView.sd_imageIndicator?.startAnimatingIndicator()
        self.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imageView.sd_imageTransition = .fade
        self.imageView.sd_setImage(with: URL(string: imgurl), completed: nil)
    }
    
    func getUserMetaDataNew(id : String)
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
         
        Alamofire.request(api, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { [self] (resp) in
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
        
//                        for (cIndex,lcData) in self.dataArray.enumerated()
//                        {
                        self.isPurchase = false
                        let lcId = id
                            
                            for lcdict in purchaseContentData
                            {
                                let id = lcdict["_id"] as? String
                                
                                if id == lcId
                                {
                                    let purchasephoto = lcdict["photo"] as? [String : Any]
                                    
                                    let cover = purchasephoto!["cover"] as? String
                                    
                                    self.setImage(imgurl: cover!)
                                    self.isPurchase = true
                                    
                                    self.unlockView.isHidden = true
                                }

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
    
    @IBAction func commentAction(_ sender: Any) {
    
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let CommentTableViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        CommentTableViewController.postId = contedID
        self.navigationController?.pushViewController(CommentTableViewController, animated: true)
    
    }
    
    @IBAction func likeAction(_ sender: Any) {
        
        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            return
        }
            let dict = ["content_id": contedID, "like": "true"] as [String: Any]
            
            let anim = CABasicAnimation(keyPath: "transform")
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            anim.duration = 0.125
            anim.repeatCount = 1
            anim.autoreverses = true
            anim.isRemovedOnCompletion = true
            anim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0))
            self.likebutton.setImage(UIImage(named: "newLike"),for: .normal)
            self.likebutton.layer.add(anim, forKey: nil)
            
            let likeCount = Int(likecount.text!)
            self.likecount.text = "\(likeCount!+1)"
            self.likebutton.isUserInteractionEnabled = false

            
            ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.LIKE_SAVE, extraHeader: nil) { (result) in
                switch result {
                case .success(let data):
                    GlobalFunctions.saveLikesIdIntoDatabase(content_id: self.contedID)
                    print(data)
                case .failure(let error):
                    print(error)
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
                    
                    CustomMoEngage.shared.sendEventViewVide(id: contedID, coins: self.coins ?? 0, bucketCode:bucketcodeStr!, bucketName: "share", videoName:"", type: comercialType, percent: percentage)
                    
                }
            }
        }
    }
    //MARK:- Partial Video
    func calculateTimeForPartialVideo() {
        //"commercial_type" = paid;
        guard let dataDict = dataDict!["data"] as? [String: Any] else {return}
        guard let content = dataDict["content"] as? [String: Any] else {return}
        if let durationStr = content["partial_play_duration"] as? String {
            if durationStr != "" && durationStr != "0" {
                guard let videoDict = content["video"] as? [String : Any] else {return}
                guard let url = videoDict["url"] as? String else {return}
                let videoURL = URL(string: url)
                let player = AVPlayer(url: videoURL!)
                self.playerViewController.player = player
                self.present(self.playerViewController, animated: true) {
                    
                    self.playerViewController.player?.play()
                    self.hideforwardBackwardView.isHidden = false
                    self.isSwipeVideo = true
                    UIApplication.shared.keyWindow?.addSubview(self.hideforwardBackwardView)
                    //                                                            self.playerViewController.showsPlaybackControls = true
                    
                }
                
                self.addObeserVerOnPlayerViewController()
                if  let t = Int(durationStr) {
                    let timr = (Int(t) / Int (1000))
                    
                    print("video play duration \(timr)")
                    
                    timer = Timer.scheduledTimer(timeInterval: Double(timr), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                    
                }
            } }
        else {
            if !self.checkIsUserLoggedIn() {
                self.loginPopPop()
                CustomMoEngage.shared.sendEventForLike(contentId: contedID ?? "", status: "Failed", reason:"User not logged in", extraParamDict: nil)
                return
            }
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
            self.addChild(popOverVC)
            popOverVC.delegate = self
            popOverVC.contentId = contedID
            popOverVC.coins = self.coins
            let list = List.init(dictionary: ["_id":contedID,"coins":"\(self.coins ?? 0 ) )","commercial_type":comercialType,"type":contentType,"caption":""])
            popOverVC.currentContent = list
            popOverVC.selectedBucketCode =  bucketcodeStr
            popOverVC.selectedBucketName = "share"
            
            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:self.view.frame.height)
            
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
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
        
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            return
        }
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
        self.addChild(popOverVC)
        popOverVC.delegate = self
        popOverVC.contentId = contedID
        popOverVC.coins = self.coins
        let list = List.init(dictionary: ["_id":contedID,"coins":"\(self.coins ?? 0 ) )","commercial_type":comercialType,"type":contentType,"caption":""])
        popOverVC.currentContent = list
        popOverVC.selectedBucketCode =  bucketcodeStr
        popOverVC.selectedBucketName = "share"
        
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:self.view.frame.height)
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        
        
    }
    
    
}

