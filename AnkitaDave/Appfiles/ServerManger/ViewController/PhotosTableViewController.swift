//
//  PhotosTableViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 18/05/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import AlamofireImage
import SDWebImage
import Shimmer
import FirebaseDynamicLinks
import StoreKit

import CoreSpotlight
import MobileCoreServices
import SafariServices

class PhotosTableViewController: BaseViewController, PurchaseContentProtocol{
  
    @IBOutlet var PhotoViewTable: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var imageview: UIView!
    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var imageview1: UIView!
    @IBOutlet weak var daysView1: UIView!
    @IBOutlet weak var captionView1: UIView!
    @IBOutlet var internetConnectionLostView: UIView!
    @IBOutlet var retryAgainButton: UIButton!
    
    var isTableLoaded = false
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
    var flagIsFromLocalOrServer = false
    var isNewDataLoading = false
    var is_like = [String]()
    var isFirstTime = true
    var bucketsArray : [List] = [List]()
    var dataArray : [List] = [List]()
    let database = DatabaseManager.sharedInstance
    let spinner = UIActivityIndicatorView(style: .white)

    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    var prevPageValue = 0
    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView!
    private var overlayView = LoadingOverlay.shared
    let activityView = UIActivityIndicatorView(style: .whiteLarge)
    var selectedlikeButton = [IndexPath]()
    var cellHeights: [IndexPath : CGFloat] = [:]
    var bucketid: String = ""
    var postId = ""
    var bucketId: String?
    var isLogin = false
    let reachability = Reachability()!
    var index = 0
    var pageNumber = 0
    var currentPage = 0
    var totalPages = 0
    var totalItems = 0
    let bottomRefreshController = UIRefreshControl()
    let task = DispatchWorkItem { print("stop time") }
    var shimme1 = FBShimmeringView()
    var shimme2 = FBShimmeringView()
    var shimme3 = FBShimmeringView()
    var shimme4 = FBShimmeringView()
    var shimme5 = FBShimmeringView()
    var shimme6 = FBShimmeringView()
    var contetid:String = ""
    var selectedBucketCode = "photos"
    var pageList: List?
    var projects:[[String]] = []

    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
      
        PhotoViewTable.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        PhotoViewTable.register(UINib(nibName: "PollTableViewCell", bundle: nil), forCellReuseIdentifier: "PollTableViewCell")
        PhotoViewTable.dataSource = self
        PhotoViewTable.delegate = self
        
        self.PhotoViewTable.rowHeight = UITableView.automaticDimension
        self.PhotoViewTable.setNeedsUpdateConstraints()


//        if contetid != "" {
//            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
//            let BucketContentDetailsViewController = mainstoryboad.instantiateViewController(withIdentifier: "BucketContentDetailsViewController") as! BucketContentDetailsViewController
//            BucketContentDetailsViewController.contedID = contetid
//            self.navigationController?.pushViewController(BucketContentDetailsViewController, animated: true)
//        }
        
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
      
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
//        self.navigationItem.title = "PHOTOS"
        self.navigationItem.backBarButtonItem?.title = ""
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.white]
        self.setNavigationView(title: "PHOTOS")
        self.internetConnectionLostView.isHidden = true
        
        self.dataArray = [List]()
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        /*self.bucketsArray = [List]()
        self.bucketsArray =  database.getBucketListing()
        if (self.bucketsArray != nil && self.bucketsArray.count > 0) {
            for list in self.bucketsArray{
                BucketValues.bucketTitleArr.append(list.caption ?? "")
                BucketValues.bucketIdArray.append(list._id ?? "")
            }
            self.getData()
           
        } else if BucketValues.bucketContentArr.count > 0 {
            self.getData()
        } else {
            self.getBuketData(completion: { (result) in
                if let id = result["data"]["list"][1]["_id"].string {
                    self.bucketId = id
                }
                BucketValues.bucketContentArr = NSMutableArray(array: result["data"]["list"].arrayObject!)
                self.getData()
            })
        }*/
       
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }

        
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
        
       self.getData()
    }
    
    @IBAction func retryAgainClick(_ sender: UIButton) {
        if self.dataArray.count == 0 {
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
            if  self.dataArray.count > 0 {
                self.internetConnectionLostView.isHidden = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if #available(iOS 10.0, *) {
            PhotoViewTable.refreshControl = refreshControl
        } else {
            PhotoViewTable.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
        refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)
//        self.view.backgroundColor = hexStringToUIColor(hex: MyColors.primaryDark)
   }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTableLoaded = true
        if let index = GlobalFunctions.sortedTabMenuArrayIndex(code: pageList?.code ?? "") {
            if index < 3 {
                self.tabBarController?.viewControllers?[index].tabBarItem.badgeValue = nil
            }
        }
        GlobalFunctions.screenViewedRecorder(screenName: "Home Photos Screen")
         CustomMoEngage.shared.sendEventUIComponent(componentName: "Home_Photos_Tab", extraParamDict: nil)
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
        self.dataArray.removeAll()
        _ = self.getOfflineUserData()
        self.getData()
     
    }
    
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        let currentList : List = self.dataArray[index]
        if let type = currentList.type , type == "poll"{
            self.PhotoViewTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            projects.append(([String(describing: type)]))

        } else {
            if let cell : MainTableViewCell = self.PhotoViewTable.cellForRow(at: IndexPath.init(item: index, section: 0)) as? MainTableViewCell{
                cell.optionsButton.isHidden = false
                cell.optionsTap.isHidden  = false
                cell.blurView.isHidden = true
                cell.unlockImageView.isHidden = false
                cell.unlockdView.isHidden = false
            }
        }
        
//        self.showToast(message: "Unlocked Successfully")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
//            navigationController?.setNavigationBarHidden(true, animated: true)
//        } else {
//            navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//    }
    
    
    func hideContent(sender: UIButton) {
        if (Reachability.isConnectedToNetwork() == true) {
            
            let alert = UIAlertController(title: "You won't see this content again.", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if self.isLogin {
                    
                    _ = self.getOfflineUserData()
                    
                   
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    guard let cell =  self.PhotoViewTable.cellForRow(at: indexPath) as? MainTableViewCell else {
                        return
                    }
                    let dict : List = self.dataArray[indexPath.row]
                    let contentId = dict._id
                    let customerId = CustomerDetails.custId
                    self.projects.append(([String(describing: dict)]))
                    self.projects.append(([String(describing: contentId)]))
                    self.projects.append(([String(describing: customerId)]))
                    self.index(item: 0)
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
                    self.PhotoViewTable.reloadData()
                    
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
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
//        if (BucketValues.bucketContentArr.count > 0) {
//
//            if let dataDict = BucketValues.bucketContentArr.object(at: 1) as? Dictionary<String, Any> {
//                bucketId = dataDict["_id"] as? String
//            }
//        }
//
//        bucketId = BucketValues.bucketIdArray[1]
//        selectedBucketCode = BucketValues.bucketTitleArr[1]
        
        guard let codeId = pageList?._id else {
            self.showToast(message: "Something went wrong please try again.")
            return
        }
        
        if Reachability.isConnectedToNetwork() == true
        {
            
//            if let bucketId = self.bucketId {
                //calculate per page value if gets time
                
                var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(codeId)" + "&visibility=customer" + "&page=\(pageNumber)" + "&v=\(Constants.VERSION)"
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
                    self.isNewDataLoading = false
                    
                    if error != nil{
                        print(error?.localizedDescription)
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
                            
                            self.placeholderView.isHidden = true
                            
                        }
                        
                        
                        self.flagIsFromLocalOrServer = true
                        if (self.database != nil) {
                        
                            self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                            if (self.dataArray.count > 0) {
                                DispatchQueue.main.async {
                                self.internetConnectionLostView.isHidden = true
                                }
                                
                            }
                            DispatchQueue.main.async {
                            self.PhotoViewTable.reloadData()
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
                                self.flagIsFromLocalOrServer = true
                                
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
                                //                                self.stopLoader()
                                let arr = json?.object(forKey: "error_messages")! as! NSMutableArray
                                //                                self.showToast(message: arr[0] as! String)
                                if (self.database != nil) {
                                    
                                    self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                                    if (self.dataArray.count > 0) {
                                        self.internetConnectionLostView.isHidden = true
                                    }
                                    self.PhotoViewTable.reloadData()
                                }
                                self.spinner.stopAnimating()
                            }
                            
                        } else if (json?.object(forKey: "status_code") as? Int == 200) {
                            if let AllData = json?.object(forKey: "data") as? NSMutableDictionary
                            {
                                //                                        if let contentPart = AllData.object(forKey: "contents") as? NSMutableDictionary
                                //                                        {
                                if  let paginationData = AllData.object(forKey: "paginate_data") as? NSMutableDictionary{
                                    self.totalItems  = paginationData["total"] as! Int
                                    self.totalPages  = paginationData["last_page"] as! Int
                                    self.currentPage  = paginationData["current_page"] as! Int
                                    self.projects.append(([String(describing: paginationData)]))
                                    self.projects.append(([String(describing: self.totalItems)]))
                                    self.projects.append(([String(describing: self.totalPages)]))
                                    self.projects.append(([String(describing: self.currentPage)]))
                                    self.index(item: 0)
                                }
                                let gai = GAI.sharedInstance()
                                if let event = GAIDictionaryBuilder.createEvent(withCategory: "Home Photos Screen ios", action: "API Pagination Number \(self.currentPage) (ios) ", label: "Success", value: nil).build() as? [AnyHashable : Any] {
                                    gai?.defaultTracker.send(event)
                                    
                                }
                                
                                //                                        }
                            }
                            
                            DispatchQueue.main.async {
                                
                                
                                if let dictData = json?.object(forKey: "data") as? NSMutableDictionary{
                                    
                                    if let photoDetailsArr = dictData.object(forKey: "list") as? NSMutableArray{
                                        
                                        self.database.createSocialJunctionTable()
                                        self.database.createStatsTable()
                                        self.database.createVideoTable()
                                        
                                        for dict in photoDetailsArr{
                                            
                                            let list : List = List.init(dictionary: dict as! NSDictionary)!
                                            if (!GlobalFunctions.checkContentBlockId(id: list._id!)) {
                                                //                                                        if GlobalFunctions.checkContentsLockId(list: list) == true {
                                                self.database.insertIntoSocialTable(list:list, datatype: self.pageList?.code ?? "")
                                                let pollStat = self.database.getPollData(content_Id: list._id ?? "")
                                                if pollStat.count > 0 {
                                                    list.pollStat = pollStat
                                                }
                                                self.dataArray.append(list)
                                                //                                                        }
                                            }
                                        }
                                        if (self.dataArray.count > 0) {
                                            self.internetConnectionLostView.isHidden = true
                                        }
                                        self.dataArray = self.dataArray.unique{$0._id ?? ""}
                                        self.PhotoViewTable.reloadData()
                                        
                                        if photoDetailsArr.count > 0
                                        {
                                            
                                            self.arrData = photoDetailsArr
                                            self.displayLayout()
                                        }
                                        else
                                        {
                                            //                                               self.showToast(message: "No Data Available")
                                        }
                                    }
                                }
                                self.spinner.stopAnimating()
                            }
                            DispatchQueue.main.async {
                                self.spinner.stopAnimating()
                                self.refreshControl.endRefreshing()
                                
                            }
                            //                                    }
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
                            
                            self.placeholderView.isHidden = true
                        }
                        
                        
                        
                    } catch let error as NSError {
                        print(error)
                        
                        self.isNewDataLoading = false
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
                            
                            self.placeholderView.isHidden = true
                        }
                        
                        self.flagIsFromLocalOrServer = true
                        if (self.database != nil) {
                            
                            self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: self.pageList?.code ?? "")
                            if (self.dataArray.count > 0) {
                                self.internetConnectionLostView.isHidden = true
                            }
                            DispatchQueue.main.async {
                            self.PhotoViewTable.reloadData()
                            }
                        }
                        
                    }
                   
                }
                task.resume()
                
//            }
            
        } else
        {
            
            self.isNewDataLoading = false
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
                if (self.dataArray.count > 0) {
                    self.internetConnectionLostView.isHidden = true
                }
                DispatchQueue.main.async {
                self.PhotoViewTable.reloadData()
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
            self.PhotoViewTable.reloadData()
        }
        
        
    }
    
    
    
    func displayLayout()
        
    {
        if arrData.count > 0
        {
            
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
                            
                            projects.append(([String(describing: states)]))
                            projects.append(([String(describing: comments)]))
                            projects.append(([String(describing: likes)]))
                            projects.append(([String(describing: shares)]))
                            projects.append(([String(describing: type)]))
                            index(item: 0)
                            
                            
                            
                            if type == "photo"{
                                if let photoDetails = (dict.object(forKey: "photo") as? NSMutableDictionary)
                                {
                                    imgArr.add(photoDetails.object(forKey: "cover") as? String)
                                    
                                    statusArray.add(statusDict)
                                    projects.append(([String(describing: type)]))
                                    index(item: 0)
                                    
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
                                            newDict.setValue(videoType, forKey: "videoType")
                                            imgArr.add(converImage)
                                            projects.append(([String(describing: videosDict)]))
                                            projects.append(([String(describing: videoType)]))
                                            projects.append(([String(describing: converImage)]))
                                            projects.append(([String(describing: url)]))
                                            projects.append(([String(describing: newDict)]))
                                            index(item: 0)
                                        }
                                    } else {
                                        if let embedCode = videosDict.object(forKey: "embed_code") as? String {
                                            newDict.setValue(true, forKey: "video")
                                            let youtubeUrl = "https://www.youtube.com/embed/\(embedCode)"
                                            newDict.setValue(youtubeUrl, forKey: "url")
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
            }
            
            if (arrStoredDetails.count == 0 ) {
                pageNumber = pageNumber + 1
                self.getData()
            }
            DispatchQueue.main.async {
                self.PhotoViewTable.reloadData()
                
            }
            
            
        }
        
        
    }
}
//MARK:- MainTableViewCellDelegate
extension PhotosTableViewController: MainTableViewCellDelegate{
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
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    }
    
    func didTapButton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let CommentTableViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        if (self.dataArray != nil && self.dataArray.count > 0) {
            
            let dict : List = self.dataArray[sender.tag]
            CommentTableViewController.postId = dict._id ?? ""
            CommentTableViewController.screenName = "Home Photos Screen"
            
            self.navigationController?.pushViewController(CommentTableViewController, animated: true)
        }
    }
    
    func didLikeButton(_ sender: UIButton) {
         let socialPost = self.dataArray[sender.tag]
        
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:"User not logged in", extraParamDict: nil)
            projects.append(([String(describing:  self.showAlert)]))
            index(item: 0)
            return
        }
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
       
        guard let cell =  self.PhotoViewTable.cellForRow(at: indexPath) as? MainTableViewCell else {
            return
        }
        if let socialPostId = socialPost._id, self.is_like.contains(socialPostId) {
            self.animateDidLikeButton(cell.likeButton)
            return
        }
        if let likeCount = Int(cell.likeCountLabel.text!) {
            cell.likeCountLabel.text = (likeCount + 1).roundedWithAbbreviations
            projects.append(([String(cell.likeCountLabel.text ?? "")]))
            index(item: 0)
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
            
            if (dataArray != nil && dataArray.count > 0) {
                
                let contentId = dataArray[indexPath.row]._id
                GlobalFunctions.saveLikesIdIntoDatabase(content_id: contentId as! String)
                if (!self.is_like.contains(contentId ?? "")) {
                    self.is_like.append(contentId ?? "")
                }
                
            }
        }
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
        
        let stringUrl: String = Constants.officialWebSitelink + params
        let link: URL = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        projects.append(([String(describing: stringUrl)]))
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
                projects.append( [pageList?.code ?? ""] )
                projects.append( [pageList?.name ?? ""] )
                projects.append( [currentList._id ??  ""] )
                projects.append( [pageList?.type ?? ""] )
                projects.append( [pageList?.is_album ?? ""] )
                projects.append(([String(describing: pageList?.stats?.childrens ?? 0)]))
                projects.append(([String(describing: currentList.coins)]))
                projects.append(([String(describing: currentIndex)]))
                projects.append(([String(describing: currentList)]))
                
                index(item: 0)

                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        } else {
            showToast(message: Constants.NO_Internet_MSG)
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
}
//MARK:- UITableViewDataSource
extension PhotosTableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArray != nil && self.dataArray.count > 0
        {
            return self.dataArray.count
        } else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentList : List = self.dataArray[indexPath.row]
        if let type = currentList.type , type == "poll"{
            let cell = PhotoViewTable.dequeueReusableCell(withIdentifier: "PollTableViewCell", for: indexPath) as! PollTableViewCell
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
            let cell = PhotoViewTable.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)as!MainTableViewCell
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
//                        cell.unlockPriceLabel.text = "Unlock premium content for \(strCoins) coins."
                        
                    } else {
                        if (GlobalFunctions.isContentsPurchased(list: currentList)) {
                            cell.unlockImageView.isHidden = false
                            cell.unlockdView.isHidden = false
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
}

//MARK:- UITableViewDelegate
extension PhotosTableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (dataArray != nil && dataArray.count > 0) {
            let currentList = dataArray[indexPath.item]
             let project = currentList
            if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0 {
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
                
                projects.append( [pageList?.code ?? ""] )
                projects.append( [pageList?.type ?? ""] )
                projects.append( [pageList?.is_album ?? ""] )
                projects.append( [pageList?.code ?? ""] )
                projects.append( [pageList?.name ?? ""] )

                projects.append(([String(describing: pageList?.stats?.childrens ?? 0)]))
                projects.append(([String(describing: currentList)]))
                projects.append(([String(describing: indexPath.item)]))
                index(item: 0)

                
                if let contentId = currentList._id{
                    popOverVC.contentId = contentId
                    popOverVC.coins = currentList.coins ?? 0
                    popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParent: self)
                }
                
            } else {
                
                if currentList.type == "video" {
                    CustomMoEngage.shared.sendEventUIComponent(componentName: "Photos_video", extraParamDict: nil)
                    if Reachability.isConnectedToNetwork() {
                        if currentList.video?.player_type == "internal" {
                            
                            if let url = currentList.video?.cover  {
                                let videoURL = URL(string: url)
                                if let player = AVPlayer(url: videoURL!) as? AVPlayer {
                                    self.playerViewController.player = player
                                    NotificationCenter.default.addObserver(self, selector: #selector(PhotosTableViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                    self.present(playerViewController, animated: true) {
                                        
                                        self.playerViewController.player?.play()
                                        
                                    }
                                }
                               
                            }
                        } else {
                            if let url = currentList.video?.cover  {

                                //                    self.navigationController?.navigationBar.isHidden = true
                                
                                self.addCloseButton()
                                
                            }
                        }
                        
                    } else {
                        showToast(message: Constants.NO_Internet_MSG)
                    }
                }
                else {

                    let destViewController : AlbumViewController = self.storyboard!.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
                    destViewController.albumName = currentList.name
                    destViewController.pageList = pageList
                    if (GlobalFunctions.checkPartialPaidContentList(list: currentList)) {
                        destViewController.checkContentLock = true
                    } else {
                        destViewController.checkContentLock = false
                        
                    }
                    if let parentId =  currentList._id
                    {
                        destViewController.parentId = parentId
                        
                    }
                    if (currentList.is_album == "true")
                    {
//                        destViewController.bucketId = self.bucketId!
                        destViewController.isAlbum = true
                        destViewController.codes = "photos"
                        destViewController.albumName = currentList.name
                    } else {
                         CustomMoEngage.shared.sendEventUIComponent(componentName: "Photos_Photo", extraParamDict: nil)
                        destViewController.isAlbum = false
                        let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                        let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
                        SingleImageScrollViewController.storeDetailsArray = self.dataArray
                        SingleImageScrollViewController.pageIndex = indexPath.row
                        SingleImageScrollViewController.selectedBucketCode = pageList?.code ?? ""
                        SingleImageScrollViewController.selectedBucketName = pageList?.name ?? ""
                        projects.append( [pageList?.code ?? ""] )
                        index(item: 0)
                        self.pushAnimation()
                        self.navigationController?.pushViewController(SingleImageScrollViewController, animated: false)
                        
                    }
                    if currentList.is_album  == "true" {
                         CustomMoEngage.shared.sendEventUIComponent(componentName: "Photos_Photo_album", extraParamDict: nil)
                        if let topViewController : UIViewController = self.navigationController?.topViewController{
//                            destViewController.selectedIndexVal = 1
                            destViewController.navigationItem.backBarButtonItem?.title = ""
                            let backItem = UIBarButtonItem()
                            //                                backItem.title = "Back"
                            navigationItem.backBarButtonItem = backItem
                            
//                            if (topViewController.restorationIdentifier == destViewController.restorationIdentifier) {
//                                print("Same VC")
//                            } else {
                                self.navigationController!.pushViewController(destViewController, animated: true)
//                            }
                        }
                    }
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.row == self.dataArray.count - 1 &&  self.totalPages > pageNumber)
        {
            if ( Reachability.isConnectedToNetwork() == true) {
                
                
                pageNumber = pageNumber + 1
                
                spinner.color = hexStringToUIColor(hex: MyColors.casual)
                
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: PhotoViewTable.bounds.width, height: CGFloat(10))
                self.PhotoViewTable.tableFooterView = spinner
                self.PhotoViewTable.tableFooterView?.isHidden = false
                if !self.isNewDataLoading {
                    self.isNewDataLoading = true
                    UIView.animate(withDuration: 2.0, animations: {
                        DispatchQueue.main.async {
                            self.getData()
                        }
                    })
                    //                    self.getData()
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
                
                self.dataArray.removeAll()
                
                spinner.color = hexStringToUIColor(hex: MyColors.casual)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: PhotoViewTable.bounds.width, height: CGFloat(10))
                self.PhotoViewTable.tableFooterView = spinner
                self.PhotoViewTable.tableFooterView?.isHidden = false
                if !self.isNewDataLoading {
                    self.isNewDataLoading = true
                    self.getData()
                }
                flagIsFromLocalOrServer = false
            }
        } else {
            cellHeights[indexPath] = cell.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
}
//MARK:- PollTableViewCellDelegate
extension PhotosTableViewController:PollTableViewCellDelegate {
    func didLikePollButton(_ sender: UIButton) {
        let socialPost = self.dataArray[sender.tag]
        
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason:"User not logged in", extraParamDict: nil)
            return
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        guard let cell =  self.PhotoViewTable.cellForRow(at: indexPath) as? PollTableViewCell else {
            return
        }
        if let socialPostId = socialPost._id, self.is_like.contains(socialPostId) {
            self.animateDidLikeButton(cell.likeButton)
            return
        }
        if let likeCount = Int(cell.likeCountLabel.text!) {
            cell.likeCountLabel.text = (likeCount + 1).roundedWithAbbreviations
            projects.append(([String(cell.likeCountLabel.text ?? "")]))
            index(item: 0)
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
        PhotoViewTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
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

// MARK: - Custom Methods.
extension PhotosTableViewController {
    func index(item:Int) {
        
        let project = dataArray.count
        let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attrSet.title = String (project)
        //attrSet.contentDescription = project[1]
        attrSet.contentDescription = String (project)
        
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
