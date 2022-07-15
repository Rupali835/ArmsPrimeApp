//
//  SingleImageScrollViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 19/04/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SingleImageScrollViewController: PannableViewController, UIScrollViewDelegate, UICollectionViewDelegate, photoDetailPurchaseDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    
    var playerViewController : AVPlayerViewController = AVPlayerViewController()
//    @IBOutlet weak var commentButton: UIButton!
//    @IBOutlet weak var shareButton: UIButton!
//    var albumData : NSArray! = NSArray()
    @IBOutlet weak var imageheightlayout: NSLayoutConstraint!
//    var photoArray =  NSMutableArray()
    var storeDetailsArray : [List] = [List]()
    var currentData : NSDictionary!
    var pageIndex = 0
    var isLogin = false
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var likeImageheightlayout: NSLayoutConstraint!
    @IBOutlet weak var commentImageheightlayout: NSLayoutConstraint!
    var filterArrayImages : NSMutableArray!
    @IBOutlet weak var commentWidth: NSLayoutConstraint!
    var backButton : UIButton!
//    var saveButton : UIButton!
    var isFirstTime = true
    var initialTouchPoint = CGPoint.zero
    var selectedPageIndex:Int = 0
    var selectedBucketCode: String?
    var selectedBucketName: String?
    var isFromAlbum: Bool?
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = ""

        self.imagesCollectionView.register(UINib.init(nibName: "imageScrollCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageScrollCollectionViewCell")
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
//                commentWidth.constant = 170
                
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                
//                imageheightlayout.constant = 600
                
            case 2436:
                print("iPhone X")
            default:
                print("")
            }
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.imagesCollectionView.frame.size.width, height: self.imagesCollectionView.frame.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        self.imagesCollectionView.showsHorizontalScrollIndicator = false
        self.imagesCollectionView.isPagingEnabled = true
        self.imagesCollectionView.collectionViewLayout = layout
        self.tabBarController?.tabBar.isHidden = true
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }

        backButton   = UIButton(type: UIButton.ButtonType.system) as UIButton
//        backButton.backgroundColor = UIColor.red
        
        let image = UIImage(named: "backbutton") as UIImage?
        backButton.frame = CGRect(x: 10, y: self.imagesCollectionView.frame.origin.y - 55, width: 20, height: 22)
        //        button.layer.cornerRadius = button.frame.height/2
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.white
        backButton.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
//        self.view.addSubview(backButton)
        
        let backButtonContainer   = UIButton(type: UIButton.ButtonType.system) as UIButton
        backButtonContainer.frame = CGRect(x: 20, y: self.imagesCollectionView.frame.origin.y - 20, width: 40, height: 40)
        backButtonContainer.tintColor = UIColor.white
        backButtonContainer.titleLabel?.text = ""
        backButtonContainer.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
//        self.view.addSubview(backButtonContainer)
        
       self.navigationController?.navigationBar.isHidden = true
       
        if let dictData = self.storeDetailsArray[pageIndex] as? List{
           
            let contentId : String = dictData._id!
            if GlobalFunctions.checkContentLikeId(id: contentId) {
                
                self.likeImage.image =  UIImage(named: "newLike")
            }
        }
        
        imagesCollectionView.isScrollEnabled = false
        if let albumSelected = isFromAlbum {
            if albumSelected {
                imagesCollectionView.isScrollEnabled = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        //        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.backBarButtonItem?.title = ""
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
// UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear], for: .normal)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear], for: .normal)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let pageWidth:CGFloat = self.imagesCollectionView.frame.width
        let currentPage:CGFloat = floor((self.imagesCollectionView.contentOffset.x-pageWidth/2)/pageWidth)+1
        if let currentPhotoDetails = self.storeDetailsArray[Int(currentPage)] as? List{
            if (GlobalFunctions.isContentsPaidCoins(list: currentPhotoDetails)) && currentPhotoDetails.coins != 0 {
                self.showOnlyAlert(title:"" ,message: "Please unlock the content before save")
                return
            }
        }
        UserDefaults.standard.set(self.storeDetailsArray[pageIndex]._id, forKey: "entityId")
        UserDefaults.standard.synchronize()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share", style: .default) { action in
          
            if let currentPhotoDetails = self.storeDetailsArray[Int(currentPage)] as? List
            {
                CustomBranchHandler.shared.shareContentBranchLink(content: currentPhotoDetails, bucketCode: self.selectedBucketCode ?? "",inViewController: self)
            }
        })
        
        
        alert.addAction(UIAlertAction(title: "Report this content", style: .default) { action in
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackReportPopUpViewController") as! FeedbackReportPopUpViewController
            self.addChild(popOverVC)
            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(popOverVC.view)
            popOverVC.titleLabel.text = "Report this content"
            popOverVC.view.clipsToBounds = true
            popOverVC.didMove(toParent: self)
        })
        
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,Constants.appStoreLink], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (isFirstTime) {
            if (pageIndex <= collectionView(self.imagesCollectionView, numberOfItemsInSection: 0)) {
                
                self.imagesCollectionView.scrollToItem(at:IndexPath(item: pageIndex, section: 0) , at: .centeredHorizontally, animated: false)
            }
            if let currentPhotoDetails = self.storeDetailsArray[Int(pageIndex)] as? List{

//            if let statusDict : NSDictionary = self.albumData?[pageIndex] as? NSDictionary{
            if (GlobalFunctions.checkContentLikeId(id: currentPhotoDetails._id as! String)) {
                self.likeImage.image =  UIImage(named: "newLike")

            }
                if currentPhotoDetails.name != nil {
                    self.lblTitle.text = currentPhotoDetails.name
                }
            if currentPhotoDetails.commentbox_enable == "true" && currentPhotoDetails.commentbox_enable != nil && currentPhotoDetails.commentbox_enable != "" {
                self.commentButton.isHidden = false
                self.commentButton.isUserInteractionEnabled = true
                self.commentCountLabel.isHidden = false
          } else {
                self.commentButton.isHidden = true
                self.commentButton.isUserInteractionEnabled = false
                self.commentCountLabel.isHidden = true
              }
                
                if let likes = currentPhotoDetails.stats?.likes{
                
                self.likeCountLabel.text = "\(likes)" //formatPoints(num: Double(likes))//String(likes)
                }
                if let comments = currentPhotoDetails.stats?.comments{
                
                self.commentCountLabel.text = "\(comments)" //formatPoints(num: Double(comments))//String(comments)
                }
        
            isFirstTime = false
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
    

    
    func showToast(message : String) {
        DispatchQueue.main.async {
            
            let toastLabel = UILabel(frame: CGRect(x: 10, y: self.view.frame.size.height-120, width: self.view.frame.size.width - 20, height: 35))
            //        let toastLabel = UILabel(frame: CGRect(x: 10, y: 350, width: self.view.frame.size.width - 20, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Montserrat-Light", size: 11.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 7.0, delay: 0.2, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }

    
    @IBAction func didTapOpenHideContetnt(_ sender: UIButton) {
        
        if !self.checkIsUserLoggedIn() {
          self.loginPopPopds()
            return
        }
        let currentIndex = sender.tag
        if  let currentList = self.storeDetailsArray[currentIndex] as? List{
            if (currentList != nil) {
                CustomMoEngage.shared.sendEventForLockedContent(id: currentList._id ?? "")
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
                self.addChild(popOverVC)
                popOverVC.delegate = self
                popOverVC.contentId = currentList._id
                if let coin = currentList.coins {
                    popOverVC.coins = coin
                }
                popOverVC.contentIndex = currentIndex
                popOverVC.currentContent = currentList
                popOverVC.selectedBucketCode = selectedBucketCode
                popOverVC.selectedBucketName = selectedBucketName
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageWidth:CGFloat = imagesCollectionView.frame.width
        let currentPage:CGFloat = floor((imagesCollectionView.contentOffset.x-pageWidth/2)/pageWidth)+1
        
        self.likeImage.image =  UIImage(named: "newUnlike")
        
        if (self.storeDetailsArray.count > Int(currentPage)) {
            
            if let currentPhotoDetails = self.storeDetailsArray[Int(currentPage)] as? List{

                if (GlobalFunctions.checkContentLikeId(id: currentPhotoDetails._id!)) {
                    self.likeImage.image =  UIImage(named: "newLike")
                    
                }
                
                if currentPhotoDetails.type == "video" {
                    
                    //                    self.downloadButton.isHidden = true
                }
                
                
                if currentPhotoDetails.commentbox_enable == "true" && currentPhotoDetails.commentbox_enable != nil && currentPhotoDetails.commentbox_enable != "" {
                    self.commentButton.isHidden = false
                    self.commentButton.isUserInteractionEnabled = true
                    self.commentCountLabel.isHidden = false
                } else {
                    self.commentButton.isHidden = true
                    self.commentButton.isUserInteractionEnabled = false
                    self.commentCountLabel.isHidden = true
                }
                
                if let likes = currentPhotoDetails.stats?.likes{
                    
                    self.likeCountLabel.text = "\(likes)"  //formatPoints(num: Double(likes))//String(likes)
                }
                if let comments = currentPhotoDetails.stats?.comments{
                    
                    self.commentCountLabel.text = "\(comments)" //formatPoints(num: Double(comments))//String(comments)
                }
            }
        }
    }
//
    
    
   
    @objc func backButtonPressed(sender: UIButton!) {
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,Constants.appStoreLink], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view

        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func didTapOpenPurchase(index: Int) {
        if Reachability.isConnectedToNetwork() == true
        {
            if !self.checkIsUserLoggedIn() {
             self.loginPopPopds()
                return
            }
        let currentIndex = index
        if  let currentList = self.storeDetailsArray[currentIndex] as? List{
            if (currentList != nil) {
                CustomMoEngage.shared.sendEventForLockedContent(id: currentList._id ?? "")
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
                self.addChild(popOverVC)
                popOverVC.delegate = self
                popOverVC.contentId = currentList._id
                popOverVC.currentContent = currentList
                if let coin = currentList.coins {
                    popOverVC.coins = Int(coin)
                }
                //                popOverVC.currentContent = currentList
                popOverVC.contentIndex = currentIndex
                popOverVC.currentContent = currentList
                popOverVC.selectedBucketCode = selectedBucketCode
                popOverVC.selectedBucketName = selectedBucketName
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        }
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
        
    }
    
    
    
    @IBAction func commentAction(_ sender: Any) {
            let pageWidth:CGFloat = self.imagesCollectionView.frame.width
            let currentPage:CGFloat = floor((self.imagesCollectionView.contentOffset.x-pageWidth/2)/pageWidth)+1
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let CommentTableViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
            if let dict =  self.storeDetailsArray[Int(currentPage)] as? List{
                let postId = dict._id
                CommentTableViewController.postId = postId!
                self.navigationController?.pushViewController(CommentTableViewController, animated: true)
                
            }
    }
    func loginPopPopds() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPopPopViewController") as! LoginPopPopViewController
            self.addChild(popOverVC)
            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            popOverVC.textLabel.text = "Hey there! log in right now to connect with me"
            popOverVC.coinsView.isHidden = true
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func likeAction(_ sender: UIButton) {
        if !self.checkIsUserLoggedIn() {
            self.loginPopPopds()
            return
        }
            let pageWidth:CGFloat = self.imagesCollectionView.frame.width
            let currentPage:CGFloat = floor((self.imagesCollectionView.contentOffset.x-pageWidth/2)/pageWidth)+1
            
            if let dictData = self.storeDetailsArray[Int(currentPage)] as? List {
                
            let contentId : String = dictData._id!
                
                if GlobalFunctions.checkContentLikeId(id: contentId) {
                    
                    return
                }
                
            let dict = ["content_id": contentId, "like": "true"] as [String: Any]

            let anim = CABasicAnimation(keyPath: "transform")
                anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            anim.duration = 0.125
            anim.repeatCount = 1
            anim.autoreverses = true
            anim.isRemovedOnCompletion = true
            anim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0))
            self.likeImage.image =  UIImage(named: "newLike")
            self.likeImage.layer.add(anim, forKey: nil)
            
            let likeCount = Int(likeCountLabel.text!)
            self.likeCountLabel.text = "\(likeCount!+1)"
            
            ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.LIKE_SAVE, extraHeader: nil) { (result) in
                switch result {
                case .success(let data):
                    GlobalFunctions.saveLikesIdIntoDatabase(content_id: contentId)
                    CustomMoEngage.shared.sendEventForLike(contentId: contentId, status: "Success", reason:  "", extraParamDict: nil)
                    print(data)
                case .failure(let error):
                    print(error)
                    CustomMoEngage.shared.sendEventForLike(contentId: contentId, status: "Failed", reason:  error.localizedDescription, extraParamDict: nil)
                }
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
                    if  let currentList = self.storeDetailsArray[pageIndex] as? List{
//                        CustomMoEngage.shared.sendEventViewVide(id: currentList._id ?? "", coins: currentList.coins ?? 0, bucketCode:"Single Photo", videoName: currentList.caption ?? "", type: currentList.commercial_type ?? "", percent: percentage)
                    }
                }
            }
        }
    }
    
}
//MARK:- PurchaseContentProtocol
extension SingleImageScrollViewController: PurchaseContentProtocol{
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        if let cell : imageScrollCollectionViewCell = self.imagesCollectionView.cellForItem(at: IndexPath.init(item: index, section: 0)) as? imageScrollCollectionViewCell{
            cell.blurView.isHidden = true
        }
        //        self.showToast(message: "Unlocked Successfully")
        
        
    }
}
//MARK:- UICollectionViewDelegate
extension SingleImageScrollViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if Reachability.isConnectedToNetwork() {
            if let currentPhotoDetails = self.storeDetailsArray[indexPath.item] as? List{
                if !self.checkIsUserLoggedIn() {
                    self.loginPopPopds()
                    return
                }
                
                //        let isVideo = (dict.object(forKey: "video") as? NSNumber)?.boolValue
                if currentPhotoDetails.type == "video"{
                    if  let videoType = currentPhotoDetails.video?.player_type as? String {
                        if videoType == "internal" {
                            if let url = currentPhotoDetails.video?.url as? String {
                                let videoURL = URL(string: url)
                                if let player = AVPlayer(url: videoURL!) as? AVPlayer {
                                    self.playerViewController.player = player
                                    NotificationCenter.default.addObserver(self, selector: #selector(SingleImageScrollViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                    self.present(playerViewController, animated: true) {
                                        
                                        self.playerViewController.player?.play()
                                        
                                    }
                                }
                            }
                        } else {
                            if let url = currentPhotoDetails.video?.url as? String {
                    
//                                self.addCloseButton()test comment
                            }
                        }
                    }
                }
            }
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 1
        let hardCodedPadding:CGFloat = 0
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
//MARK:- UICollectionViewDataSource
extension SingleImageScrollViewController:  UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.storeDetailsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        selectedPageIndex = indexPath.item
        print("Each index path \(selectedPageIndex)")
        let cell : imageScrollCollectionViewCell = self.imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imageScrollCollectionViewCell", for: indexPath) as! imageScrollCollectionViewCell
        
        if let currentPhotoDetails = self.storeDetailsArray[indexPath.item] as? List {
            
            //            cell.blurView.isHidden  = true
            
            //        let statusDict : NSDictionary = self.albumData?[indexPath.item] as! NSDictionary
            if (GlobalFunctions.isContentsPaidCoins(list: currentPhotoDetails)) && currentPhotoDetails.coins != 0 {
                print("cell id[\(indexPath.item)] \(self.storeDetailsArray[indexPath.item]._id)")
                cell.blurView.isHidden  = false
                let strCoins : String = "\(currentPhotoDetails.coins ?? 0)"
                //                cell.unlockPriceLabel.text = "Unlock premium content for \(strCoins) coins."
                
            }
            cell.playVideoImage.isHidden = true
            
            if currentPhotoDetails.type == "video"{
                
                cell.playVideoImage.isHidden = false
                cell.cellImage.sd_imageTransition = .fade
                if let videoCover = currentPhotoDetails.video?.cover{
                    
                    cell.cellImage.sd_setImage(with: URL(string:videoCover), completed: nil)
                }
                
            }else{
                cell.cellImage.sd_imageTransition = .fade
                if let photoCover = currentPhotoDetails.photo?.cover{
                    cell.cellImage.sd_setImage(with: URL(string:photoCover), completed: nil)
                }
            }
            
            cell.cellImage.clipsToBounds = true
            self.commentButton.tag = indexPath.row
            cell.viewTag = indexPath.row
            cell.blurView.tag = indexPath.row
            cell.unlockButton.tag = indexPath.row
            cell.delegate = self
        }
        return cell
    }
}
