//
//  PodcastViewController.swift
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
import Shimmer

class PodcastViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PurchaseContentProtocol,PodcastCollectionViewCellDelegate {
    
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var imageview: UIView!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var imageview1: UIView!
    @IBOutlet weak var captionView1: UIView!
    @IBOutlet weak var imageview2: UIView!
    @IBOutlet weak var captionView2: UIView!
    @IBOutlet weak var imageview3: UIView!
    @IBOutlet weak var captionView3: UIView!
    @IBOutlet weak var imageview4: UIView!
    @IBOutlet weak var captionView4: UIView!
    @IBOutlet weak var imageview5: UIView!
    @IBOutlet weak var captionView5: UIView!
    
    
    @IBOutlet var PodcastcollectionView: UICollectionView!
    @IBOutlet var internetConnectionLostView: UIView!
    @IBOutlet var retryAgainButton: UIButton!
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
    var albumName: String = ""
    var albumCover : String = ""
    var navigationTittle = ""
    
    let reachability = Reachability()!
    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView!
    var isTableLoaded : Bool = false
    var selectedlikeButton = [IndexPath]()
    var videosArray : [List] = [List]()
    var bucketsArray : [List]!
    let database = DatabaseManager.sharedInstance
    var flagIsFromLocalOrServer = false
    
    var bucketid: String = ""
    var postId = ""
    var bucketId: String?
    var isLogin = false
    var pageNumber = 0
    var currentPage = 0
    var totalPages = 0
    var totalItems = 0
    let spinner = UIActivityIndicatorView(style: .white)
    
    var shimme1 = FBShimmeringView()
    var shimme2 = FBShimmeringView()
    var shimme3 = FBShimmeringView()
    var shimme4 = FBShimmeringView()
    var shimme5 = FBShimmeringView()
    var shimme6 = FBShimmeringView()
    var shimme7 = FBShimmeringView()
    var shimme8 = FBShimmeringView()
    var shimme9 = FBShimmeringView()
    var shimme10 = FBShimmeringView()
    var shimme11 = FBShimmeringView()
    var shimme12 = FBShimmeringView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        shimme1 = FBShimmeringView(frame: self.imageview.frame)
        shimme1.contentView = imageview
        view.addSubview(shimme1)
        shimme1.isShimmering = true
        
        shimme2 = FBShimmeringView(frame: self.imageview1.frame)
        shimme2.contentView = imageview1
        view.addSubview(shimme2)
        shimme2.isShimmering = true
        
        shimme3 = FBShimmeringView(frame: self.imageview2.frame)
        shimme3.contentView = imageview2
        view.addSubview(shimme3)
        shimme3.isShimmering = true
        
        shimme4 = FBShimmeringView(frame: self.imageview3.frame)
        shimme4.contentView = imageview3
        view.addSubview(shimme4)
        shimme4.isShimmering = true
        
        shimme5 = FBShimmeringView(frame: self.imageview4.frame)
        shimme5.contentView = imageview4
        view.addSubview(shimme5)
        shimme5.isShimmering = true
        
        shimme6 = FBShimmeringView(frame: self.imageview5.frame)
        shimme6.contentView = imageview5
        view.addSubview(shimme6)
        shimme6.isShimmering = true
        
     
        shimme7 = FBShimmeringView(frame: self.captionView.frame)
        shimme7.contentView = captionView
        view.addSubview(shimme7)
        shimme7.isShimmering = true
        
        shimme8 = FBShimmeringView(frame: self.captionView1.frame)
        shimme8.contentView = captionView1
        view.addSubview(shimme8)
        shimme8.isShimmering = true
        
        shimme9 = FBShimmeringView(frame: self.captionView2.frame)
        shimme9.contentView = captionView2
        view.addSubview(shimme9)
        shimme9.isShimmering = true
        
        shimme10 = FBShimmeringView(frame: self.captionView3.frame)
        shimme10.contentView = captionView3
        view.addSubview(shimme10)
        shimme10.isShimmering = true
        
        shimme11 = FBShimmeringView(frame: self.captionView4.frame)
        shimme11.contentView = captionView4
        view.addSubview(shimme11)
        shimme11.isShimmering = true
        
        shimme12 = FBShimmeringView(frame: self.captionView5.frame)
        shimme12.contentView = captionView5
        view.addSubview(shimme12)
        shimme12.isShimmering = true
        
        pageNumber = 1
        self.tabBarController?.tabBar.isHidden = false
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
            
        }
//        self.navigationItem.title = navigationTittle.uppercased()
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
         self.setNavigationView(title: navigationTittle.uppercased())
        self.internetConnectionLostView.isHidden = true
        self.placeholderView.isHidden = true
        
        arrStoredDetails.removeAllObjects()
        arrData.removeAllObjects()
        imgArr.removeAllObjects()
        imageArray.removeAllObjects()
        self.videosArray = [List]()
        self.bucketsArray = database.getBucketListing()
        
        if (self.bucketsArray != nil && self.bucketsArray.count > 0) {
            for list in self.bucketsArray{
                BucketValues.bucketTitleArr.append(list.caption ?? "")
                BucketValues.bucketIdArray.append(list._id!)
            }
            self.getData()
            
        }
        else  if BucketValues.bucketContentArr.count > 0 {
            self.getData()
        } else {
            self.getBuketData(completion: { (result) in
                if let id = result["data"]["list"][self.selectedIndexVal]["_id"].string {
                    self.bucketId = id
                }
                BucketValues.bucketContentArr = NSMutableArray(array: result["data"]["list"].arrayObject!)
                self.getData()
            })
        }
        
        PodcastcollectionView.allowsMultipleSelection = false
        
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }

        
        PodcastcollectionView.register(UINib.init(nibName: "PodcastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCollectionViewCell")
        
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
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                print("iPhone 4")
                
                let screen = UIScreen.main.bounds
                photoWidth = (screen.size.width - 20 ) / 2
                let photoHeight: CGFloat = photoWidth
                
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 8, left:5,  bottom: 5, right: 5)
                layout.itemSize = CGSize(width: photoWidth, height: photoHeight + 20)
                PodcastcollectionView.collectionViewLayout = layout
                
            case 1136:
                print("iPhone 5 or 5S or 5C")
                let screen = UIScreen.main.bounds
                photoWidth = (screen.size.width - 20 ) / 2
                let photoHeight: CGFloat = photoWidth
                
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 8, left:5,  bottom: 5, right: 5)
                layout.itemSize = CGSize(width: photoWidth, height: photoHeight + 20)
                PodcastcollectionView.collectionViewLayout = layout
                
                
            case 1334:
                print("iPhone 6/6S/7/8")
                let screen = UIScreen.main.bounds
                photoWidth = (screen.size.width - 20 ) / 2
                let photoHeight: CGFloat = photoWidth
                
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 8, left:5,  bottom: 5, right: 5)
                layout.itemSize = CGSize(width: photoWidth, height: photoHeight)
                PodcastcollectionView.collectionViewLayout = layout
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                let screen = UIScreen.main.bounds
                photoWidth = (screen.size.width - 20 ) / 2
                let photoHeight: CGFloat = photoWidth
                
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 8, left:5,  bottom: 5, right: 5)
                layout.itemSize = CGSize(width: photoWidth, height: photoHeight)
                PodcastcollectionView.collectionViewLayout = layout
                
                
            case 2436:
                print("iPhone X")
                
                let screen = UIScreen.main.bounds
                photoWidth = (screen.size.width - 20 ) / 2
                let photoHeight: CGFloat = photoWidth
                
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 8, left:5,  bottom: 5, right: 5)
                layout.itemSize = CGSize(width: photoWidth, height: photoHeight)
                PodcastcollectionView.collectionViewLayout = layout
                
            default:
                print("unknown")
            }
        }
        PodcastcollectionView.dataSource = self
        PodcastcollectionView.delegate = self
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
        if let cell : PodcastCollectionViewCell = self.PodcastcollectionView.cellForItem(at: IndexPath.init(item: index, section: 0)) as? PodcastCollectionViewCell{
            
            cell.blurView.isHidden = true
            cell.unlockImageView.isHidden = false
            cell.unlockdView.isHidden = false
           
        }
//        self.showToast(message: "Unlocked Successfully")
        
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
//            navigationController?.setNavigationBarHidden(true, animated: true)
//            
//        } else {
//            navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//    }
    
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
            
            self.shimme10.isShimmering = true
            self.shimme10.isHidden = false
            
            self.shimme11.isShimmering = true
            self.shimme11.isHidden = false
            
            self.shimme12.isShimmering = true
            self.shimme12.isHidden = false
            
            self.placeholderView.isHidden = false
            self.getData()
            if  self.videosArray.count > 0 {
                self.internetConnectionLostView.isHidden = true
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTableLoaded = true
        GlobalFunctions.screenViewedRecorder(screenName: "Home \(self.navigationTittle) Screen")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
             self.navigationItem.largeTitleDisplayMode = .never
            
        }
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.isNavigationBarHidden = false
        if BucketValues.bucketIdArray.count > 0 {
            if #available(iOS 10.0, *) {
                PodcastcollectionView.refreshControl = refreshControl
            } else {
                PodcastcollectionView.addSubview(refreshControl)
            }
            
            refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
            refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)
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
        
        self.getData()
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.videosArray != nil && self.videosArray.count > 0
        {
            return self.videosArray.count
        } else
        {
            return 0
        }
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:PodcastCollectionViewCell = PodcastcollectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCollectionViewCell", for: indexPath) as! PodcastCollectionViewCell
        
        cell.albumCoverImage.image = nil
        cell.unlockdView.isHidden = true
        cell.blurView.isHidden = true
        cell.unlockButton.tag = indexPath.row
        cell.delegate = self
        if self.videosArray.count > 0 && self.videosArray.count >= indexPath.row {
            
            let currentList : List = self.videosArray[indexPath.row]
            if (!GlobalFunctions.checkContentBlockId(id: currentList._id!)) {
                
                if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0 {
                    
                    cell.blurView.isHidden = false
                    let strCoins : String = "\(currentList.coins ?? 0)"
                    cell.unlockPriceLabel.text = "Unlock premium content for \(strCoins) coins."
                    
                } else {
                    if (GlobalFunctions.isContentsPurchased(list: currentList)) {
                        cell.unlockImageView.isHidden = false
                        cell.unlockdView.isHidden = false
                       
                    }
                  
                }
             
            
        if self.videosArray.count > 0
        {
            if  let currentList = self.videosArray[indexPath.row] as? List{
            

                    if var urlString = currentList.photo?.cover as? String {
    
                        cell.albumCoverImage.sd_imageIndicator?.startAnimatingIndicator()
                        cell.albumCoverImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.albumCoverImage.sd_imageTransition = .fade
                        cell.albumCoverImage.sd_setImage(with: URL(string: urlString), completed: nil)
                        cell.albumCoverImage.contentMode = .scaleAspectFill
                        cell.albumCoverImage.clipsToBounds = true
                           
                        }
                   

                cell.albumName.text = ""
                
                if  currentList.name != ""
                {
                    cell.albumName.isHidden = false
                    cell.albumName.text = currentList.name
                    cell.albumName.text = cell.albumName.text?.uppercased()
                    
                } else if currentList.caption != ""{
                   
                    cell.albumName.isHidden = false
                    cell.albumName.text = currentList.caption?.captalizeFirstCharacter()
                    
                }
                if let totalEpisode = currentList.stats?.childrens{
                    
                   cell.totalEpisode.text = "\(totalEpisode) Tracks "
                    
                }
            }
                }
        }
        }
        return cell
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.videosArray.count - 1 && self.totalPages > pageNumber {
            if Reachability.isConnectedToNetwork() {
                pageNumber = pageNumber + 1
                self.getData()
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
                
                self.videosArray.removeAll()
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
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (arrStoredDetails != nil && arrStoredDetails.count > 0) {
            
            if let dict = arrStoredDetails.object(at: indexPath.row) as? NSMutableDictionary{
        let currentList : List = self.videosArray[indexPath.row]
        if (GlobalFunctions.isContentsPaidWithDict(dict: dict as! Dictionary<String, Any>)) && currentList.coins != 0{
            CustomMoEngage.shared.sendEventForLockedContent(id: currentList._id ?? "")
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
            self.addChild(popOverVC)
            popOverVC.delegate = self
            popOverVC.contentIndex = indexPath.item
            popOverVC.currentContent = currentList
            popOverVC.selectedBucketCode = "podcast"
            popOverVC.selectedBucketName = "podcast"
            if let contentId = dict.value(forKey: "parentId") as? String{
                if let coin = dict.value(forKey: "coins") as? String{
                    popOverVC.contentId = contentId
                    popOverVC.coins = Int(coin)
                    popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParent: self)
                }
            }
            
        } else {
            
            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            let PodcastDetailsViewController = mainstoryboad.instantiateViewController(withIdentifier: "podcastDetailViewController") as! podcastDetailViewController
             PodcastDetailsViewController.bucketId = self.bucketId!
             PodcastDetailsViewController.selectedPost = currentList
            if let parentId =  dict.object(forKey: "parentId") as? String
            {
                PodcastDetailsViewController.parentId = parentId
            }
            
            self.navigationController?.pushViewController(PodcastDetailsViewController, animated: true)
            
        }
            }
        }
    }
    
//     NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
//    func playerDidFinishPlaying(note: NSNotification) {
//
//        print("call")
//
//    }
    
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
            
            self.shimme10.isShimmering = true
            self.shimme10.isHidden = false
            
            self.shimme11.isShimmering = true
            self.shimme11.isHidden = false
            
            self.shimme12.isShimmering = true
            self.shimme12.isHidden = false
            
            self.placeholderView.isHidden = false
                
            }
        }
        
        if (BucketValues.bucketContentArr.count > 0) {
            
            if let dataDict = BucketValues.bucketContentArr.object(at: self.selectedIndexVal) as? Dictionary<String, Any> {
                bucketId = dataDict["_id"] as? String
            }
        } else {
            bucketId = BucketValues.bucketIdArray[self.selectedIndexVal]
        }
        if Reachability.isConnectedToNetwork() == true
        {
            if let bucketId = self.bucketId {
                
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
                                
                                self.shimme10.isShimmering = false
                                self.shimme10.isHidden = true
                                
                                self.shimme11.isShimmering = false
                                self.shimme11.isHidden = true
                                
                                self.shimme12.isShimmering = false
                                self.shimme12.isHidden = true
                                
                                self.placeholderView.isHidden = true
                                
                            }
                            
                            self.refreshControl.endRefreshing()
                            self.flagIsFromLocalOrServer = true
                            self.spinner.stopAnimating()
                            if (self.database != nil) {
                                self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: "podcast")
                                if  self.videosArray.count > 0 {
                                    self.internetConnectionLostView.isHidden = true
                                }
                                
                                self.PodcastcollectionView.reloadData()
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
                                        
                                        self.shimme10.isShimmering = false
                                        self.shimme10.isHidden = true
                                        
                                        self.shimme11.isShimmering = false
                                        self.shimme11.isHidden = true
                                        
                                        self.shimme12.isShimmering = false
                                        self.shimme12.isHidden = true
                                        
                                        self.placeholderView.isHidden = true
                                        
                                    }
                                    //
                                    self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: "podcast")
                                    if  self.videosArray.count > 0 {
                                        self.internetConnectionLostView.isHidden = true
                                    }
                                    
                                    self.PodcastcollectionView.reloadData()
                                    
                                    
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
                                
//                                self.stopLoader()
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
                                    
                                    self.shimme10.isShimmering = false
                                    self.shimme10.isHidden = true
                                    
                                    self.shimme11.isShimmering = false
                                    self.shimme11.isHidden = true
                                    
                                    self.shimme12.isShimmering = false
                                    self.shimme12.isHidden = true
                                    
                                    self.placeholderView.isHidden = true
                                    
                                }
                                
                                
                                if  self.videosArray.count > 0 {
                                    self.internetConnectionLostView.isHidden = true
                                }
                                
                                
                            }
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
                            
                            self.shimme10.isShimmering = false
                            self.shimme10.isHidden = true
                            
                            self.shimme11.isShimmering = false
                            self.shimme11.isHidden = true
                            
                            self.shimme12.isShimmering = false
                            self.shimme12.isHidden = true
                            
                            self.placeholderView.isHidden = true
                            
                        }
                        
                        self.spinner.stopAnimating()
                        DispatchQueue.main.async {
                            self.flagIsFromLocalOrServer = true
                            self.refreshControl.endRefreshing()
                            if (self.database != nil) {
//                                self.stopLoader()
                                
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
                                    
                                    self.shimme10.isShimmering = false
                                    self.shimme10.isHidden = true
                                    
                                    self.shimme11.isShimmering = false
                                    self.shimme11.isHidden = true
                                    
                                    self.shimme12.isShimmering = false
                                    self.shimme12.isHidden = true
                                    
                                    self.placeholderView.isHidden = true
                                    
                                }
                                
                                
                                self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: "video")
                                if  self.videosArray.count > 0 {
                                    self.internetConnectionLostView.isHidden = true
                                }
                                
                                self.PodcastcollectionView.reloadData()
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
                
                self.shimme7.isShimmering = false
                self.shimme7.isHidden = true
                
                self.shimme8.isShimmering = false
                self.shimme8.isHidden = true
                
                self.shimme9.isShimmering = false
                self.shimme9.isHidden = true
                
                self.shimme10.isShimmering = false
                self.shimme10.isHidden = true
                
                self.shimme11.isShimmering = false
                self.shimme11.isHidden = true
                
                self.shimme12.isShimmering = false
                self.shimme12.isHidden = true
                
                self.placeholderView.isHidden = true
                
            }
            self.spinner.stopAnimating()
            self.refreshControl.endRefreshing()
            if (self.database != nil) {
                self.videosArray =  self.database.getSocialJunctionFromDatabase(datatype: "video")
                if  self.videosArray.count > 0 {
                    self.internetConnectionLostView.isHidden = true
                }
                
                self.PodcastcollectionView.reloadData()
                
                
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
            self.PodcastcollectionView.reloadData()
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
                            
                            if  let comments = states.object(forKey: "comments") as? NSNumber {
                                if let likes = states.object(forKey: "likes") as? NSNumber {
                                    if  let childrens = states.object(forKey: "childrens") as? NSNumber {
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
                                if let videosDict = dict.object(forKey: "audio") as? NSDictionary {
                                    if let videoType = videosDict.object(forKey: "content_types") as? String {
                                        if videoType == "audios" {
                                            if let converImage = videosDict.object(forKey: "cover"), let url = videosDict.object(forKey: "url") {
                                                newDict.setValue(true, forKey: "audio")
                                                newDict.setValue(url, forKey: "url")
                                                newDict.setValue(converImage, forKey: "url")
                                                
                                                newDict.setValue(videoType, forKey: "audios")
                                                imgArr.add(converImage)
                                                
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
                    }
                }
            }
            
            
            if (arrStoredDetails.count == 0 ) {
                pageNumber = pageNumber + 1
                self.getData()
            }
            DispatchQueue.main.async {
                self.PodcastcollectionView.reloadData()
            }
            
        }
        
        
    }

}
