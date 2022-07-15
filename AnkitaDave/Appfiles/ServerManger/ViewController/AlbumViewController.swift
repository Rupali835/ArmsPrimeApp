//
//  AlbumViewController.swift
//  ConsumerOfficialApp
//
//  Created by RazrTech2 on 22/02/19.
//  Copyright © 2019 com.armsprime.Consumerofficial. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AVKit
import SDWebImage
import Shimmer
import FirebaseDynamicLinks
import Alamofire

class AlbumViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource, MainTableViewCellDelegate, PurchaseContentProtocol {

    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var imageview: UIView!
    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var captionView: UIView!
    
    @IBOutlet weak var imageview1: UIView!
    @IBOutlet weak var daysView1: UIView!
    @IBOutlet weak var captionView1: UIView!
    
    var codes:String = ""
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var albumTableView: UITableView!
    
    var checkContentLock : Bool! = false
    var parentId = ""
    var isAlbum: Bool = false
    var isFromSHows:Bool = false
    var albumName: String!
    var lvl1ImgString: String!
    var selectedIndexVal: Int!
    var arrData = NSMutableArray()
    var imgArr = NSMutableArray()
    var imageArray = NSMutableArray()

    var likeSelectedArray = [Int]()
    var newLikeCount = [[IndexPath: Int]()]
    var arrStoredDetails = NSMutableArray()
    var lvl2ImgString: String!
    var is_like = [String]()
    var bucketId: String?
    var isFirstTime = true
    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    var photoWidth: CGFloat!
    var isLogin = false
    var cellHeights: [IndexPath : CGFloat] = [:]
    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView!
    var pageNumber = 0
    var currentPage = 0
    var totalPages = 0
    var totalItems = 0
    let database = DatabaseManager.sharedInstance
    var reachability = Reachability()
    var dataArray : [List] = [List]()
    let spinner = UIActivityIndicatorView(style: .white)
    var shimme1 = FBShimmeringView()
    var shimme2 = FBShimmeringView()
    var shimme3 = FBShimmeringView()
    var shimme4 = FBShimmeringView()
    var shimme5 = FBShimmeringView()
    var shimme6 = FBShimmeringView()
    var bucketCodeStr: String?
    var ageDiff : Int? = 0
    
    @IBOutlet var internetConnectionLostView: UIView!
    @IBOutlet var retryAgainButton: UIButton!
    var contetid:String = ""
    var selectedTableIndex = 0
    var pageList: List?
    @IBOutlet weak var albumTitleLabel: UILabel!
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        albumTableView.dataSource = self
        albumTableView.delegate = self
        
        self.albumTableView.estimatedRowHeight = 200
        self.albumTableView.rowHeight = UITableView.automaticDimension
        self.albumTableView.setNeedsUpdateConstraints()
        
        if contetid != "" {
            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            let BucketContentDetailsViewController = mainstoryboad.instantiateViewController(withIdentifier: "BucketContentDetailsViewController") as! BucketContentDetailsViewController
            BucketContentDetailsViewController.contedID = contetid
            self.navigationController?.pushViewController(BucketContentDetailsViewController, animated: true)
        }
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
        
        pageNumber = 1
        self.tabBarController?.tabBar.isHidden = false
        self.internetConnectionLostView.isHidden = true
//        self.navigationItem.title = "ALBUM"
//
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setNavigationView(title: albumName.capitalized)
        albumTitleLabel.text = ""
         albumTitleLabel.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        albumTitleLabel.textColor = .white
        imgArr.removeAllObjects()
        imageArray.removeAllObjects()
        arrStoredDetails.removeAllObjects()
        self.albumTableView.reloadData()
       
        
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }
       
        

        
        
        if isAlbum {
            
            // Add Refresh Control to Table View
            if #available(iOS 10.0, *) {
                albumTableView.refreshControl = refreshControl
            } else {
                albumTableView.addSubview(refreshControl)
            }
            refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
            refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)//UIColor(red:255, green:255, blue:255, alpha:1.0)
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

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear], for: .normal)
        if (self.albumName != nil && self.albumName != "") {
            GlobalFunctions.screenViewedRecorder(screenName: self.albumName )
        }
        
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
        if self.arrStoredDetails.count == 0 {
            //            self.showLoader()
            
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
            
            self.getData()
            if  self.arrStoredDetails.count > 0 {
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
        self.arrStoredDetails.removeAllObjects()
        self.dataArray.removeAll()
        _ = self.getOfflineUserData()
        
        self.getData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear], for: .normal)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.isNavigationBarHidden = false
        
        dataArray.removeAll()
        imageArray.removeAllObjects()
        arrStoredDetails.removeAllObjects()
        
        if isAlbum {
            self.getData()
        } else
        {
            //            self.showLvl1Image()
        }
        
    }
    
    var flagHasLvl2Data: Bool = false
    
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
                                
                                self.albumTableView.reloadData()
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
                
                self.placeholderView.isHidden = false
            }
            
        }
        if Reachability.isConnectedToNetwork()
        {
//            if (!isFromSHows) {
//                if (BucketValues.bucketContentArr.count > 0) {
//
//                    if let dataDict = BucketValues.bucketContentArr.object(at: selectedIndexVal) as? Dictionary<String, Any> {
//                        bucketId = dataDict["_id"] as? String
//
//                    }
//                }
//                bucketId = BucketValues.bucketIdArray[selectedIndexVal]
//                bucketCodeStr =  BucketValues.bucketTitleArr[selectedIndexVal]
//            }
            
            
            guard let codeId = pageList?._id else {
                self.showToast(message: "Something went wrong please try again.")
                return
            }
            
            
            let age = UserDefaults.standard.value(forKey: "age_difference")
            
            if age != nil
            {
                self.ageDiff = age as? Int
            }

                
                var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(codeId)" +  "&parent_id=" + parentId + "&page=\(pageNumber)" + "&v=\(Constants.VERSION)" + "&age_restriction=\(self.ageDiff ?? 18)"
                
            
                strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let url = URL(string: strUrl)
                let request = NSMutableURLRequest(url: url!)
                
           
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                    self.isFirstTime = false
                    if error != nil{
                        self.showToast(message: error?.localizedDescription ?? "The Internet connection appears to be offline.")
                        return
                    }
                    do {
                        if (data != nil) {
                            
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("Photo level 2 bucket json \(String(describing: json))")
                            
                            if json?.object(forKey: "error") as? Bool == true {
                                DispatchQueue.main.async {
                                    let arr = json?.object(forKey: "error_messages")! as! NSMutableArray
                                    self.showToast(message: arr[0] as! String)
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
                                }
                                
                                
                            } else if (json?.object(forKey: "status_code") as? Int == 200) {
                                DispatchQueue.main.async {
                                    
                                    if let dictData = json?.object(forKey: "data") as? NSMutableDictionary{
                                        
                                        //                                        let contentsDict = dictData.object(forKey: "contents") as! NSMutableDictionary
                                        if  let paginationData = dictData.object(forKey: "paginate_data") as? NSMutableDictionary{
                                            self.totalItems  = paginationData.object(forKey: "total") as! Int
                                            self.totalPages  = paginationData.object(forKey: "last_page") as! Int
                                            self.currentPage  = paginationData.object(forKey: "current_page") as! Int
                                        }
                                        let gai = GAI.sharedInstance()
                                        if let event = GAIDictionaryBuilder.createEvent(withCategory: "\(self.albumName))", action: "API Pagination Number \(self.currentPage) (ios) ", label: "Success", value: nil).build() as? [AnyHashable : Any] {
                                            gai?.defaultTracker.send(event)
                                            
                                        }
                                        if let photoDetailsArr = dictData.object(forKey: "list") as? NSMutableArray
                                        {
                                            
                                            if photoDetailsArr.count > 0
                                            {
                                                self.flagHasLvl2Data = true
                                                for dict in photoDetailsArr{
                                                    
                                                    let list : List = List.init(dictionary: dict as! NSDictionary)!
                                                    if (!GlobalFunctions.checkContentBlockId(id: list._id!)) {
                                                        //                                                        if GlobalFunctions.checkContentsLockId(list: list) == true {
                                                        //                                                    self.database.insertIntoSocialTable(list:list, datatype: "album")
                                                        self.dataArray.append(list)
                                                        //                                                        }
                                                    }
                                                }
                                                if self.checkIsUserLoggedIn() {
                                                    self.getUserMetaDataNew()
                                                }
                                           
                                                self.arrData = photoDetailsArr
                                                //                                                print("arrData \(self.arrData)")
                                                self.displayLayout()
                                                if  self.dataArray.count > 0 {
                                                    self.internetConnectionLostView.isHidden = true
                                                }
                                                
                                            } else
                                            {
                                                self.flagHasLvl2Data = false
                                                
                                                if !self.isAlbum
                                                {
                                                    //                                                    self.showLvl1Image()
                                                }
                                                self.showToast(message: "No Data Available")
                                            }
                                        }
                                        
                                    } else {
                                        //                                            self.showLvl1Image()
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
                        }
                        
                    } catch let error as NSError {
                        
                        print(error)
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
                    }
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                    }
                }
                task.resume()
//            }
            
        } else
        {
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
            self.showToast(message: Constants.NO_Internet_MSG)
            
        }
    }
    
    
    var lvl1Image: UIImageView!
    
    
    func displayLayout()
    {
        if arrData.count > 0
        {
            
            for i in 0...arrData.count - 1
            {
                let dict = arrData.object(at: i) as! NSMutableDictionary
                if (!GlobalFunctions.checkContentBlockId(id: dict.value(forKey: "_id") as! String)) {
                    
                    //                print("arrdata [\(i)] **** \(dict)")
                    if let states = dict.object(forKey: "stats") as? NSMutableDictionary {
                        
                        //                        var contentLock = true
                        //                        if (GlobalFunctions.checkContentPurchaseId(id:self.parentId)) {
                        //                            contentLock = false
                        //                        }
                        //                        if !contentLock || (GlobalFunctions.checkContentsLock(dictionary: dict)) == true {
                        
                        let comments = states.object(forKey: "comments") as! NSNumber
                        let likes = states.object(forKey: "likes") as! NSNumber
                        //                            is_like.append((Int(dict.object(forKey: "is_like") as! NSNumber)))
                        let shares = states.object(forKey: "shares") as! NSNumber
                        let type = (dict.object(forKey: "type") as! String)
                        
                        if type == "photo"{
                            
                            if let photoDetails = (dict.object(forKey: "photo") as? NSMutableDictionary)
                            {
                                
                                imgArr.add(photoDetails.object(forKey: "cover") as? String)
                                //                        imageArray.add(photoDetails.object(forKey: "cover") as! String)
                                var newDict = NSMutableDictionary()
                                if dict.object(forKey: "is_album") != nil
                                {
                                    if let nameCaption = dict.object(forKey: "name")
                                    {
                                        if let nameDays = dict.object(forKey: "date_diff_for_human")
                                        {
                                            //                        if ((dict.object(forKey: "is_album") as Any) as AnyObject).intValue == 1
                                            //                        if (dict.object(forKey: "is_album") as! AnyObject) as! Bool == "true"
                                            if (dict.object(forKey: "is_album") as! String) == "true"
                                            {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                            } else
                                            {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                            }
                                        }
                                        
                                    } else
                                    {
                                        //                        if ((dict.object(forKey: "is_album") as Any) as AnyObject).intValue == 1
                                        if (dict.object(forKey: "is_album") as! String) == "true"
                                        {
                                            newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                        } else
                                        {
                                            newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                        }
                                    }
                                    
                                } else
                                {
                                    if let nameCaption = dict.object(forKey: "name")
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": nameCaption, "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    } else {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    }
                                }
                                
                                arrStoredDetails.add(newDict)
                            } } else
                        {
                            //                imgArr.insert("sampleImage", at: i)
                            
                            var newDict = NSMutableDictionary()
                            if dict.object(forKey: "is_album") as! String == "true"
                            {
                                if ((dict.object(forKey: "is_album") as Any) as AnyObject).intValue == 1
                                {
                                    newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                } else
                                {
                                    newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                }
                            } else
                            {
                                if let nameCaption = dict.object(forKey: "name")
                                {
                                    newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": nameCaption, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                } else {
                                    newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
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
                                        newDict.setValue(("https://i.ytimg.com/vi/\(embedCode)/mqdefault.jpg"), forKey: "videoURL")
                                        
                                        newDict.setValue(videoType, forKey: "videoType")
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
            
            if (arrStoredDetails.count == 0 ) {
                pageNumber = pageNumber + 1
                self.getData()
            }
            DispatchQueue.main.async {
                self.albumTableView.reloadData()
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArray.count > 0
        {
            return self.dataArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = albumTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)as!MainTableViewCell
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
        cell.blurView.isHidden = true
        //        self.index = indexPath.row
        if self.dataArray.count > 0 && self.dataArray.count >= indexPath.row
        {
            if let currentList : List = self.dataArray[indexPath.row] as? List {
                cell.list = currentList
                if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0{
                    
                    cell.blurView.isHidden = false
                    cell.optionsButton.isHidden = true
                    cell.optionsTap.isHidden  = true
                    cell.optionsView.alpha = 0
                    let strCoins : String = "\(currentList.coins ?? 0)"
                    cell.unlockPriceLabel.text = "Unlock premium content for \(strCoins) coins."
                    
                } else {
                    
                    if (GlobalFunctions.isContentsPurchased(list: currentList)) {
                        cell.unlockImageView.isHidden = false
                        cell.unlockdView.isHidden = false
                   
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
            }
        }
        return cell
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.dataArray.count - 1 && self.totalPages > pageNumber {
            if ( Reachability.isConnectedToNetwork() == true) {
                pageNumber = pageNumber + 1
                spinner.color = hexStringToUIColor(hex: MyColors.casual)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: albumTableView.bounds.width, height: CGFloat(10))
                self.albumTableView.tableFooterView = spinner
                self.albumTableView.tableFooterView?.isHidden = false
                self.getData()
            } else {
                showToast(message: Constants.NO_Internet_MSG)
            }
        } else {
            cellHeights[indexPath] = cell.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        
        if let cell : MainTableViewCell = self.albumTableView.cellForRow(at: IndexPath.init(item: index, section: 0)) as? MainTableViewCell{
            cell.optionsButton.isHidden = false
            cell.optionsTap.isHidden  = false
            if self.checkIsUserLoggedIn() {
                self.getUserMetaDataNew()

            }
          //  if currentList._id == contentId //rupali
          //  {
                if GlobalFunctions.checkContentPurchaseId(id: contentId!)
                {
                    
                    cell.unlockImageView.isHidden = false
                    cell.unlockdView.isHidden = false
                  //  cell.blurView.isHidden = false
                }

           // }
        }
//        self.showToast(message: "Unlocked Successfully")
        
        
    }
    
    
    func didTapButton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let CommentTableViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        if let dict = self.dataArray[sender.tag] as? List {
            let postId = dict._id
            CommentTableViewController.postId = postId ?? ""
            CommentTableViewController.screenName = self.albumName
        
            self.navigationController?.pushViewController(CommentTableViewController, animated: true)
        }
        
    }
    
    func didShareButton(_ sender: UIButton) {
        if !Reachability.isConnectedToNetwork() {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
            return
        }
        
        let content = dataArray[sender.tag]
        var params: String = " "
        params += "&bucket_code=" + "\(self.codes)"//"\(content.bucket_id ?? "")"
        params += "&content_id=" + "\(content._id ?? "")"
        
         CustomBranchHandler.shared.shareContentBranchLink(content: content, bucketCode: self.codes ,inViewController: self)
        
    /*    let stringUrl: String = Constants.officialWebSitelink + params
        let link: URL = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
         if let components = DynamicLinkComponents(link: link, domainURIPrefix:  Constants.appLink) {
        components.iOSParameters = DynamicLinkIOSParameters(bundleID:
           Constants.appBundleID)
        components.androidParameters = DynamicLinkAndroidParameters(packageName:
            Constants.androidPackageID)
        
        
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
        
        }*/
        let payloadDict = NSMutableDictionary()
        payloadDict.setObject(content._id, forKey: "content_id" as NSCopying)
        CustomMoEngage.shared.sendEvent(eventType: MoEventType.share, action: "", status: "Success", reason: "Album Photo", extraParamDict: payloadDict)
    }
    
    func didTapOpenPurchase(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true
        {
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
                popOverVC.selectedBucketName = pageList?.name ?? ""
                
                
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
        
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
                _ = self.getOfflineUserData()
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
                guard let cell =  self.albumTableView.cellForRow(at: indexPath) as? MainTableViewCell else {
                    return
                }
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
                if ( self.arrStoredDetails != nil && self.arrStoredDetails.count > 0) {
                    
                    self.arrStoredDetails.removeObject(at: indexPath.row)
                    self.imgArr.removeObject(at: indexPath.row)
                }
                self.dataArray.remove(at: indexPath.row)
                
                _ = self.getOfflineUserData()
                self.albumTableView.reloadData()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    func didLikeButton(_ sender: UIButton) {
        
        let socialPost = self.dataArray[sender.tag]
        
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:  "User not logged in", extraParamDict: nil)
            return
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
      
        guard let cell =  self.albumTableView.cellForRow(at: indexPath) as? MainTableViewCell else {
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
                            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:  error?.localizedDescription ?? "", extraParamDict: nil)
                            return
                        }
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("Photo json \(String(describing: json))")
                            
                            DispatchQueue.main.async {
                        
                                if !self.likeSelectedArray.contains(cell.likeTap.tag) {
                                    self.likeSelectedArray.append(cell.likeTap.tag)
                                }
                                
                                GlobalFunctions.saveLikesIdIntoDatabase(content_id: socialPost._id ?? "")
                                CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Success", reason: "", extraParamDict: nil)
                            }
                            
                        } catch let error as NSError {
                            print(error)
                             CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:  error.localizedDescription, extraParamDict: nil)
                            
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
//            navigationController?.setNavigationBarHidden(true, animated: true)
//        } else {
//            navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (dataArray != nil && dataArray.count > 0) {
            selectedTableIndex = indexPath.row
            if let currentList = dataArray[indexPath.item] as? List{
                 if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0{
                     CustomMoEngage.shared.sendEventForLockedContent(id: currentList._id ?? "")
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
                    self.addChild(popOverVC)
                    popOverVC.delegate = self
                    popOverVC.contentIndex = indexPath.item
                    popOverVC.currentContent = currentList
                    popOverVC.selectedBucketCode = pageList?.code ?? ""
                    popOverVC.selectedBucketName = pageList?.name ?? ""
                    if let contentId = currentList._id{
                        popOverVC.contentId = contentId
                        popOverVC.coins = currentList.coins ?? 0
                        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        self.view.addSubview(popOverVC.view)
                        popOverVC.didMove(toParent: self)
                    }
                    
                }
                    
                else {
                    
                    if currentList.type == "video" {
                        if Reachability.isConnectedToNetwork() {
                            if currentList.video?.player_type == "internal" {
                                
                                if let url = currentList.video?.url  {
                                    let videoURL = URL(string: url)
                                    if let player = AVPlayer(url: videoURL!) as? AVPlayer {
                                        self.playerViewController.player = player
                                        NotificationCenter.default.addObserver(self, selector: #selector(AlbumViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                        self.present(playerViewController, animated: true) {
                                            
                                            self.playerViewController.player?.play()
                                            
                                        }
                                        self.addObeserVerOnPlayerViewController()
                                    }
                                }
                            } else {
                                if let url = currentList.video?.url  {
                                    self.addCloseButton()
                                    
                                }
                            }
                            
                        } else
                        {
                            self.showToast(message: Constants.NO_Internet_MSG)
                        }
                        
                    } else {
                        
                        
                        let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                        let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
                        SingleImageScrollViewController.storeDetailsArray = self.dataArray
                        SingleImageScrollViewController.pageIndex = indexPath.row
                        SingleImageScrollViewController.selectedBucketCode = pageList?.code ?? ""
                        SingleImageScrollViewController.selectedBucketName = pageList?.name ?? ""
                        SingleImageScrollViewController.isFromAlbum = true
                        self.pushAnimation()
                        self.navigationController?.pushViewController(SingleImageScrollViewController, animated: false)
                        
                        
                    }
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
                   
                    
                    if let currentList = self.dataArray[self.selectedTableIndex] as? List {
                        CustomMoEngage.shared.sendEventViewVide(id: currentList._id ?? "", coins: currentList.coins ?? 0, bucketCode:pageList?.code ?? "", bucketName: pageList?.name ?? "", videoName: currentList.caption ?? "", type: currentList.commercial_type ?? "", percent: percentage)
                    }
                }
            }
        }
    }

}

