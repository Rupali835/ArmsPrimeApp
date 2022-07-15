//
//  AskViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 23/05/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AVKit
import SDWebImage

class AskViewController: BaseViewController{
  
    @IBOutlet weak var askTableView: UITableView!
    @IBOutlet weak var askTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    var navigationTittle = ""
    var flagNoInternetMsg = true
    var flagIsFromLocalOrServer = false

    @IBOutlet weak var headerInfoLabel: UILabel!
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
     var viewActivityLarge : SHActivityView?

    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView!
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var selectedlikeButton = [IndexPath]()
    var pageList: List?
    var bucketid: String = ""
    var postId = ""
    var bucketId: String?
    var isLogin = false
    var pageNumber = 0
    var currentPage = 0
    var totalPages = 0
    var totalItems = 0
    var lastPage = 0
    var bucketsArray : [List]!
    
    var dataArray : [List]! = [List]()
    let database = DatabaseManager.sharedInstance
    var arrSinglePhotoData = NSMutableArray()
    var selectedBucketCode:String?
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageNumber = 1
        askTableView.register(UINib(nibName: "AskTableViewCell", bundle: nil), forCellReuseIdentifier: "AskCell")
        //        self.socialTableView.estimatedRowHeight = 447
        self.askTableView.rowHeight = UITableView.automaticDimension
        self.askTableView.estimatedRowHeight = askTableView.rowHeight
        self.askTableView.layoutIfNeeded()
        
        
        arrStoredDetails.removeAllObjects()
        arrData.removeAllObjects()
        imgArr.removeAllObjects()
        imageArray.removeAllObjects()
        self.dataArray = [List]()

        self.askTableView.reloadData()
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        self.bucketsArray = [List]()
        
        self.bucketsArray = database.getBucketListing()
        
        if (self.bucketsArray != nil && self.bucketsArray.count > 0) {
            for list in self.bucketsArray{
                BucketValues.bucketTitleArr.append(list.caption ?? "")
                BucketValues.bucketIdArray.append(list._id ?? "")
            }
            self.getData()
            self.displayLayout()


        } else if BucketValues.bucketContentArr.count > 0 {
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
        
        askTableView.allowsMultipleSelection = false
        

        
        askTextView.delegate = self
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            } else {
                self.isLogin = false
            }
        } else {
            self.isLogin = false
        }
        
//        self.navigationItem.title = navigationTittle.uppercased()
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setNavigationView(title: navigationTittle.uppercased())
       self.navigationController?.isNavigationBarHidden = false
        
        askTextView.delegate = self
        askTextView.text = "POST YOUR QUESTION..."
        askTextView.textColor = UIColor.black
        
        self.askTextView.layer.borderWidth = 2
        self.askTextView.layer.cornerRadius = 5
        self.askTextView.layer.borderColor = UIColor.clear.cgColor
        self.askTextView.layer.masksToBounds = false
        self.askTextView.clipsToBounds = true
        
        self.shareButton.layer.borderWidth = 2
        self.shareButton.layer.cornerRadius = 5
        self.shareButton.layer.borderColor = UIColor.white.cgColor
        self.shareButton.layer.masksToBounds = false
        self.shareButton.clipsToBounds = true
        
        self.postButton.layer.borderWidth = 2
        self.postButton.layer.cornerRadius = 5
        self.postButton.layer.borderColor = UIColor.white.cgColor
        self.postButton.layer.masksToBounds = false
        self.postButton.clipsToBounds = true
        
        headerInfoLabel.font = UIFont(name: AppFont.regular.rawValue, size: 20.0)
        postButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 17.0)
        shareButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 17.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 10.0, *) {
            askTableView.refreshControl = refreshControl
        } else {
            askTableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
        refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GlobalFunctions.screenViewedRecorder(screenName: "Ask Celeb Screen")
        self.setNavigationView(title: "ASK Ankita Dave")
        
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
        self.getData()
        
    }
    func hideContent(sender: UIButton) {
        
        if (Reachability.isConnectedToNetwork() == true) {

            let alert = UIAlertController(title: "You won't see this content again.", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if self.isLogin {

                _ = self.getOfflineUserData()
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
                guard let cell =  self.askTableView.cellForRow(at: indexPath) as? AskTableViewCell else {
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
                self.askTableView.reloadData()
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        } else {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
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
 

   
    func getData()
    {
        if isFirstTime == true {
            self.showLoader()
        }
       bucketId = pageList?._id ?? ""
        if Reachability.isConnectedToNetwork() == true
        {
            
            if let bucketId = self.bucketId {
                
                var strUrl = Constants.cloud_base_url + Constants.LEVEL_1_BUCKET_CONTENTS + Constants.artistId_platform + "&bucket_id=\(bucketId)" + "&visibility=customer" + "&page=\(pageNumber)" + "&v=\(Constants.VERSION)"
                strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let url = URL(string: strUrl)
                let request = NSMutableURLRequest(url: url!)
                
                    request.httpMethod = "GET"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                    request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "ArtistId")
                    request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
                    request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                        self.isFirstTime = false
                        if error != nil{
                            print(error?.localizedDescription)
                            DispatchQueue.main.async {
                            self.stopLoader()
                            
                            self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: "ask")
                                DispatchQueue.main.async {
                                    self.askTableView.reloadData()
                                }
                            }
                            self.flagIsFromLocalOrServer = true
                            return
                        }
                        
                        
                        do {
                            if (data != nil) {

                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print("Photo json \(String(describing: json))")
                            //need to store total val & fetch it & add to arr & load tbl view
                            
                            if json?.object(forKey: "error") as? Bool == true
                            {
                                DispatchQueue.main.async {
                                    self.stopLoader()
                                    let arr = json?.object(forKey: "error_messages")! as! NSMutableArray
//                                    self.showToast(message: arr[0] as! String)
                                    self.flagIsFromLocalOrServer = true
                                    self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: "ask")
                                    self.askTableView.reloadData()
                                }
                                
                            } else if (json?.object(forKey: "status_code") as? Int == 200) {
                                    if let AllData = json?.object(forKey: "data") as? NSMutableDictionary
                                    {
//                                        if let contentPart = AllData.object(forKey: "contents") as? NSMutableDictionary
//                                        {
                                        if  let paginationData = AllData.object(forKey: "paginate_data") as? NSMutableDictionary{
                                            self.totalItems  = paginationData.object(forKey: "total") as! Int
                                            self.totalPages  = paginationData.object(forKey: "last_page") as! Int
                                            self.currentPage  = paginationData.object(forKey: "current_page") as! Int
                                        }
//                                        }
                                    }
                                    
                                    DispatchQueue.main.async {
                                        
                                        
                                        if let dictData = json?.object(forKey: "data") as? NSMutableDictionary{
//                                        let contentsDict = dictData.object(forKey: "contents") as! NSMutableDictionary
                                            if let photoDetailsArr = dictData.object(forKey: "list") as? NSMutableArray{
                                        self.database.createSocialJunctionTable()
                                        self.database.createStatsTable()
                                        self.database.createVideoTable()
                                        for dict in photoDetailsArr{
                                            
                                            let list : List = List.init(dictionary: dict as! NSDictionary)!
                                            if (!GlobalFunctions.checkContentBlockId(id: list._id!)) {
//                                                if GlobalFunctions.checkContentsLockId(list: list) == true {
                                                    self.database.insertIntoSocialTable(list:list, datatype: "ask")
                                                    self.dataArray.append(list)
//                                                }
                                            }
                                        }
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
                                        
                                    }
                                DispatchQueue.main.async {
                                    self.stopLoader()
                                    
                                   
                                }
                            }
                            }
                          
                            
                        } catch let error as NSError {
                            print(error)
                            
                            DispatchQueue.main.async {
                            self.stopLoader()
                            self.flagIsFromLocalOrServer = true
                            self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: "ask")
                            self.askTableView.reloadData()
                            }
                        }
                        DispatchQueue.main.async {
                            
                            self.refreshControl.endRefreshing()
                            
                        }
                        
                    }
                    task.resume()
                
            }
            
            
        } else
        {
            self.flagIsFromLocalOrServer = true
            self.showToast(message: Constants.NO_Internet_MSG)
            self.stopLoader()
            self.refreshControl.endRefreshing()
            self.dataArray =  self.database.getSocialJunctionFromDatabase(datatype: "ask")
            self.askTableView.reloadData()
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
            self.askTableView.reloadData()
        }
        
        
    }
    
    func displayLayout() {
        if arrData.count > 0
        {
           
                for i in 0...arrData.count - 1
                {
                    if let dict = self.arrData.object(at: i) as? NSMutableDictionary{

                    if (!GlobalFunctions.checkContentBlockId(id: dict.value(forKey: "_id") as! String)) {
                    if let states = dict.object(forKey: "stats") as? NSMutableDictionary {
//                        if GlobalFunctions.checkContentsLock(dictionary: dict) {
//                        if dict.object(forKey: "locked")as? Bool == false  {
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
                                                //                                    if (dict.object(forKey: "locked") as! String) == "true"
                                                //                                    {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                                //                                }
                                            } else
                                            {
                                                newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": "", "selectedImage": photoDetails.object(forKey: "cover") as! String, "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                            }
                                        }
                                        
                                        //                        }
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
                                
                                var newDict = NSMutableDictionary()
                                if dict.object(forKey: "is_album") as! String == "true"
                                {
                                    //                               if dict.object(forKey: "locked") as! String == "true"
                                    //                               {
                                    
                                    if ((dict.object(forKey: "is_album") as Any) as AnyObject).intValue == 1
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": true, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    } else
                                    {
                                        newDict = ["parentId": dict.object(forKey: "_id")!, "is_album": false, "albumCaption": dict.object(forKey: "name") as! String, "selectedImage": "NA", "video": false, "url": "", "videoType": "","albumCaptions": dict.object(forKey: "date_diff_for_human") as! String, "like": likes, "comments": comments, "shares": shares,"coins" : dict.object(forKey: "coins")!, "commercial_type" : dict.object(forKey: "commercial_type")!]
                                    }
                                    //                            }
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
                }
                if (arrStoredDetails.count == 0 ) {
                    pageNumber = pageNumber + 1
                    self.getData()
                }
                DispatchQueue.main.async {
                    self.askTableView.reloadData()
                }
           
        }
        
        
    }
    //MARK:- All button Action
    @IBAction func PostButtonAction(_ sender: Any) {
        if !self.checkIsUserLoggedIn() {
                  self.loginPopPop()
                   return
               }
        
        if askTextView.text == "POST YOUR QUESTION..." {
            showToast(message: "Please enter a Question in the box.")
            return
        }
        
        if isLogin {
            
            if !(askTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
            {
                let sv = UIViewController.displaySpinner(onView: self.view)
                if Reachability.isConnectedToNetwork()
                {
                    let dict = ["question": askTextView.text!] as [String: Any] //
                    print(dict)
                    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                        
                        let url = NSURL(string: Constants.App_BASE_URL + Constants.ASK_ARTIST)!
                        let request = NSMutableURLRequest(url: url as URL)
                        
                        request.httpMethod = "POST"
                        request.httpBody = jsonData
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                        request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "artistid")
                        request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")
                        request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")
                        
                        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                            if error != nil{
                                self.showToast(message: error?.localizedDescription ?? "The Internet connection appears to be offline.")
                                return
                            }
                            do {
                                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                                print("Photo json \(String(describing: json))")
                                
                                DispatchQueue.main.async {
                                    self.askTextView.resignFirstResponder()
                                    let message = "Dear \(CustomerDetails.firstName ?? ""), We have received your question. \(Constants.celebrityName) will reply based on your posted question. Please stay tuned.\n Thank You!!"
                                    let alert = UIAlertController(title: "Alert", message :message , preferredStyle: .alert)
                                    
                                    let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (alert) in
                                        
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    //                                  self.showToast(message: "Your question is Submitted Successfully")
                                    self.askTextView.text = ""
                                    
                                }
                                UIViewController.removeSpinner(spinner: sv)
                            } catch let error as NSError {
                                print(error)
                                UIViewController.removeSpinner(spinner: sv)
                                
                            }
                            DispatchQueue.main.async {
                                
                            }
                            
                        }
                        task.resume()
                    }
                    //    }
                } else
                {
                    UIViewController.removeSpinner(spinner: sv)
                    self.showToast(message: Constants.NO_Internet_MSG)
                    
                }
            } else {
                showToast(message: "Please enter a Question in the box.")
            }
        } else {
            showToast(message: "Please Login to submit the Question.")
        }
        
        
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,Constants.appStoreLink], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view
        self.present(viewController, animated: true, completion: nil)
        
    }
}
//MARK: - PurchaseContentProtocol
extension AskViewController: PurchaseContentProtocol {
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        if let cell : AskTableViewCell = self.askTableView.cellForRow(at: IndexPath.init(item: index, section: 0)) as? AskTableViewCell{
            cell.optionsButton.isHidden = false
            cell.optionsTap.isHidden  = false
            //            cell.optionsButton.alpha = 0.20
            //            cell.optionsButton.backgroundColor = UIColor.black.withAlphaComponent(0.20)
            cell.blurView.isHidden = true
            cell.unlockImageView.isHidden = false
            cell.unlockdView.isHidden = false
        }
//        self.showToast(message: "Unlocked Successfully")
    }
    
}
//MARK: - UITextViewDelegate
extension AskViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if askTextView.textColor == UIColor.black {
            askTextView.text = ""
            askTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if askTextView.text == "" {
            
            askTextView.text = "POST YOUR QUESTION..."
            askTextView.textColor = UIColor.black
        }
    }
}
//MARK: - AskTableViewCellDelegate
extension AskViewController: AskTableViewCellDelegate{
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
                popOverVC.selectedBucketCode = selectedBucketCode
                popOverVC.selectedBucketName = navigationTittle
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
        
    }
    func didTapButton(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let CommentTableViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        //            let dict = self.arrStoredDetails.object(at: sender.tag) as! NSMutableDictionary
        let currentList = self.dataArray[sender.tag]
        let postId = currentList._id!
        CommentTableViewController.postId = postId
        CommentTableViewController.screenName = "Ask Celeb Screen"
        
        self.navigationController?.pushViewController(CommentTableViewController, animated: true)
        
        
    }
    
    func didShareButton(_ sender: UIButton) {
        if !Reachability.isConnectedToNetwork() {
            self.showToast(message: Constants.NO_Internet_Connection_MSG)
            return
        }
        
        let viewController = UIActivityViewController(activityItems:[Constants.appStoreLink], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view
        self.present(viewController, animated: true, completion: nil)
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
    func didTapVideoPlay(_ sender: UIButton) {
        
        let index = sender.tag
        
        if Reachability.isConnectedToNetwork() {
            
            if (arrStoredDetails != nil && arrStoredDetails.count > 0) {
                
                if let dict = arrStoredDetails.object(at: index) as? NSMutableDictionary {
                    if (GlobalFunctions.isContentsPaidWithDict(dict: dict as! Dictionary<String, Any>)) {
                        CustomMoEngage.shared.sendEventForLockedContent(id: dict.value(forKey: "parentId") as! String ?? "")
                        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
                        self.addChild(popOverVC)
                        popOverVC.delegate = self
                        popOverVC.contentIndex = index
//                        popOverVC.currentContent = currentList
                        popOverVC.selectedBucketCode = selectedBucketCode
                        popOverVC.selectedBucketName = navigationTittle
                        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        self.view.addSubview(popOverVC.view)
                        popOverVC.contentId = dict.value(forKey: "parentId") as! String
                        popOverVC.coins  = dict.value(forKey: "coins") as! Int
                        popOverVC.didMove(toParent: self)
                        
                    } else {
                        let isVideo = (dict.object(forKey: "video") as? NSNumber)?.boolValue
                        if isVideo!{
                            if let videoType = dict.object(forKey: "videoType") as? String {
                                if videoType == "internal" {
                                    if let url = dict.object(forKey: "url") as? String {
                                        let videoURL = URL(string: url)
                                        let player = AVPlayer(url: videoURL!)
                                        self.playerViewController.player = player
                                        NotificationCenter.default.addObserver(self, selector: #selector(AskViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                        self.present(playerViewController, animated: true) {
                                            
                                            self.playerViewController.player?.play()
                                            
                                        }
                                    }
                                } else {
                                    if let url = dict.object(forKey: "url") as? String {

                                        //                    self.navigationController?.navigationBar.isHidden = true

                                        self.addCloseButton()
                                        
                                    }
                                }
                            }
                        } else {
                            
                            
                            if let dict = arrStoredDetails.object(at: index) as? NSMutableDictionary {
                                
                                let destViewController : AlbumViewController = self.storyboard!.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
                                
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
                                if dict.object(forKey: "is_album") as! Int == 1 || dict.object(forKey: "is_album") as! Bool == true
                                {
                                    destViewController.isAlbum = true
                                    destViewController.albumName = dict.object(forKey: "albumCaption") as! String
                                    destViewController.lvl1ImgString = dict.object(forKey: "selectedImage") as! String
                                } else {
                                    
                                    destViewController.isAlbum = false
                                    let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                                    let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
                                    SingleImageScrollViewController.storeDetailsArray = self.dataArray
                                    
                                    SingleImageScrollViewController.pageIndex = index
                                    SingleImageScrollViewController.selectedBucketCode = "ask"
                                    SingleImageScrollViewController.selectedBucketName = "ask"
                                    self.navigationController?.pushViewController(SingleImageScrollViewController, animated: true)
                                    
                                }
                                if dict.object(forKey: "is_album") as! Bool == true {
                                    let topViewController : UIViewController = self.navigationController!.topViewController!
                                    destViewController.selectedIndexVal = selectedIndexVal
                                    destViewController.navigationItem.backBarButtonItem?.title = ""
                                    let backItem = UIBarButtonItem()
                                    backItem.title = ""
                                    navigationItem.backBarButtonItem = backItem
                                    
                                    if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!) {
                                        print("Same VC")
                                    } else {
                                        self.navigationController!.pushViewController(destViewController, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
            
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
        
        
        guard let cell =  self.askTableView.cellForRow(at: indexPath) as? AskTableViewCell else {
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
                            GlobalFunctions.trackEvent(eventScreen: "Ask Celeb Screen", eventName: "Like", eventPostTitle: "Error : \(error?.localizedDescription ?? "")", eventPostCaption: "", eventId: socialPost._id!)
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
                                GlobalFunctions.trackEvent(eventScreen: "Ask Celeb Screen", eventName: "Like", eventPostTitle: errorString, eventPostCaption: "", eventId: socialPost._id!)
                                CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Failed", reason: errorString, extraParamDict: nil)
                            } else if (json?.object(forKey: "status_code") as? Int == 200)
                            {
                                GlobalFunctions.trackEvent(eventScreen: "Ask Celeb Screen", eventName: "Like", eventPostTitle: "Success", eventPostCaption: "", eventId: socialPost._id!)
                                DispatchQueue.main.async {
                                    
                                    
                                    if !self.likeSelectedArray.contains(cell.shareTapButton.tag) {
                                        self.likeSelectedArray.append(cell.shareTapButton.tag)
                                    }
                                    
                                    GlobalFunctions.saveLikesIdIntoDatabase(content_id: socialPost._id ?? "")
                                }
                                  CustomMoEngage.shared.sendEventForLike(contentId: socialPost._id ?? "", status: "Success", reason: "", extraParamDict: nil)
                            }
                            
                        } catch let error as NSError {
                            print(error)
                            GlobalFunctions.trackEvent(eventScreen: "Ask Celeb Screen", eventName: "Like", eventPostTitle: "Error : \(error.localizedDescription)", eventPostCaption: "", eventId: socialPost._id!)
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
        
        //                }
        
        
    }

}
//MARK: - UITableViewDataSource
extension AskViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
        let cell = askTableView.dequeueReusableCell(withIdentifier: "AskCell", for: indexPath) as!  AskTableViewCell
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        cell.playVideoIcon.isHidden = true
        cell.delegate = self
        cell.likeButton.imageView?.image = nil
        cell.profileImage.image = nil
        cell.unlockImageView.isHidden = true
        cell.unlockdView.isHidden = true
        
        if self.dataArray.count > 0
        {
            if  let currentList = self.dataArray[indexPath.row] as? List{
                cell.blurView.isHidden = true
                
                if (!GlobalFunctions.checkContentBlockId(id: currentList._id!)) {
                    
                    if self.dataArray.count > 0 && self.dataArray.count >= indexPath.row
                    {
                        let currentList : List = self.dataArray[indexPath.row]
                        cell.blurView.isHidden = true
                        
                        if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0 {
                            
                            cell.blurView.isHidden = false
                            cell.optionsButton.isHidden = true
                            cell.optionsTap.isHidden  = true
                            //                cell.optionsButton.alpha = 0
                            let strCoins : String = "\(currentList.coins ?? 0)"
                            cell.unlockPriceLabel.text = "Unlock premium content for \(strCoins) coins."
                            
                        } else {
                            
                            if (GlobalFunctions.isContentsPurchased(list: currentList)) {
                                cell.unlockImageView.isHidden = false
                                cell.unlockdView.isHidden = false
                            }
                            cell.optionsButton.isHidden = false
                            cell.optionsTap.isHidden  = false
                            //                cell.optionsButton.backgroundColor = UIColor.black.withAlphaComponent(0.20)
                        }
                        if currentList != nil
                        {
                            cell.profileImage.sd_imageIndicator?.startAnimatingIndicator()
                            cell.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.profileImage.sd_imageTransition = .fade
                            
                            if (currentList.type == "video") {
                                if let urlString = currentList.video?.cover as? String {
                                    cell.profileImage.sd_setImage(with: URL(string: urlString), placeholderImage: nil) { (image: UIImage?, error: Error?, cacheType:SDImageCacheType!, imageURL: URL?) in
                                        
                                        guard let image = image else { return }
                                        print("Image arrived!")
                                        cell.profileImage.image = image
                                        cell.profileImage.contentMode = .scaleAspectFill
                                        cell.profileImage.clipsToBounds = true
                                        
                                        cell.profileImage.layoutIfNeeded()
                                        cell.profileImage.setNeedsUpdateConstraints()
                                    }
                                }
                            }
                        }
                        
                        cell.shareTapButton.tag = indexPath.row
                        cell.likeTapButton.tag = indexPath.row
                        cell.commentTapButton.tag = indexPath.row
                        cell.playVideoIcon.tag = indexPath.row
                        cell.optionsTap.tag = indexPath.row
                        cell.delegate = self
                        
                        if (self.isLogin) {
                            if (GlobalFunctions.checkContentLikeId(id: currentList._id!) || self.is_like.contains(currentList._id!)) {
                                cell.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
                            } else {
                                cell.likeButton.setImage(UIImage(named: "newUnlike"), for: .normal)
                            }
                            
                        }
                        cell.shareTapButton.tag = indexPath.row
                        cell.likeTapButton.tag = indexPath.row
                        cell.commentTapButton.tag = indexPath.row
                        cell.delegate = self
                        
                        //                    let isVideo = currentList.type == "video"
                        if currentList.type == "video" {
                            cell.playVideoIcon.isHidden = false
                        }
                        if let isCaption = currentList.date_diff_for_human
                        {
                            cell.profileDaysLabel.isHidden = false
                            cell.profileDaysLabel.text = (isCaption as? String)?.captalizeFirstCharacter()
                        }
                        
                        
                        if currentList.name != ""
                        {
                            cell.profileNameLabel.isHidden = false
                            cell.profileNameLabel.text = currentList.name
                            cell.profileNameLabel.text = cell.profileNameLabel.text?.uppercased()
                        }
                        if let likes = currentList.stats?.likes as? Int{
                            
                            cell.likeCountLabel.text = likes.roundedWithAbbreviations //formatPoints(num: Double(likes)) //
                            
                        }
                        if let comments = currentList.stats?.comments as? Int{
                            
                            cell.commentCountLabel.text = comments.roundedWithAbbreviations //formatPoints(num: Double(comments)) //
                        }
                        
                        if let likes = currentList.stats?.likes{
                            
                            cell.likeCountLabel.text = likes.roundedWithAbbreviations //formatPoints(num: Double(likes)) //
                            
                        }
                        if let comments = currentList.stats?.comments{
                            
                            cell.commentCountLabel.text = comments.roundedWithAbbreviations //formatPoints(num: Double(comments)) //
                        }
                        //                }
                    }
                }
                
            }
            
        }
        self.configure(cell: cell, forRowAtIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: AskTableViewCell, forRowAtIndexPath indexPath: IndexPath) {
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
}
//MARK: - UITableViewDelegate
extension AskViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.checkIsUserLoggedIn() {
                         self.loginPopPop()
                         return
                     }
        if Reachability.isConnectedToNetwork() {
            
            if (dataArray != nil && dataArray.count > 0) {
                
                if let currentList = self.dataArray[indexPath.row] as? List{
                    
                    if (GlobalFunctions.isContentsPaidCoins(list: currentList)) {
                        CustomMoEngage.shared.sendEventForLockedContent(id: currentList._id ?? "")
                        if !self.checkIsUserLoggedIn() {
                         self.loginPopPop()
                            return
                        }
                        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
                        self.addChild(popOverVC)
                        popOverVC.delegate = self
                        popOverVC.contentIndex = indexPath.item
                        popOverVC.currentContent = currentList
                        popOverVC.selectedBucketCode = selectedBucketCode
                        popOverVC.selectedBucketName = navigationTittle
                        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        self.view.addSubview(popOverVC.view)
                        popOverVC.contentId = currentList._id
                        popOverVC.coins  = currentList.coins
                        popOverVC.didMove(toParent: self)
                        
                    } else {
                        //        let isVideo = (dict.object(forKey: "video") as? NSNumber)?.boolValue
                        if currentList.type == "video" {
                            
                            if let videoType = currentList.video?.player_type {
                                if videoType == "internal" {
                                    if let url = currentList.video?.url {
                                        let videoURL = URL(string: url)
                                        let player = AVPlayer(url: videoURL!)
                                        self.playerViewController.player = player
                                        NotificationCenter.default.addObserver(self, selector: #selector(AskViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                                        self.present(playerViewController, animated: true) {
                                            
                                            self.playerViewController.player?.play()
                                            
                                        }
                                    }
                                } else {
                                    if let url = currentList.video?.url  {

                                        //                    self.navigationController?.navigationBar.isHidden = true

                                        self.addCloseButton()
                                    }
                                }
                            }
                        } else {
                            
                            
                            //            if let dict = arrStoredDetails.object(at: indexPath.row) as? NSMutableDictionary {
                            
                            let destViewController : AlbumViewController = self.storyboard!.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
                            
                            if let parentId =  currentList._id as? String
                            {
                                destViewController.parentId = parentId //dict.object(forKey: "parentId") as! String
                                
                            }
                            //            destViewController.isAlbum = (dict.object(forKey: "is_album") != nil)
                            if currentList.is_album == "true"
                            {
                                destViewController.isAlbum = true
                                destViewController.albumName = currentList.name as! String
                                destViewController.lvl1ImgString = currentList.photo?.cover as! String
                            } else {
                                
                                destViewController.isAlbum = false
                                let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                                let SingleImageScrollViewController = mainstoryboad.instantiateViewController(withIdentifier: "SingleImageScrollViewController") as! SingleImageScrollViewController
                                SingleImageScrollViewController.storeDetailsArray = self.dataArray
                                SingleImageScrollViewController.pageIndex = indexPath.row
                                SingleImageScrollViewController.selectedBucketCode = "ask"
                                SingleImageScrollViewController.selectedBucketName = "ask"
                                self.navigationController?.pushViewController(SingleImageScrollViewController, animated: true)
                                
                            }
                            if currentList.is_album as? String == "true" {
                                let topViewController : UIViewController = self.navigationController!.topViewController!
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
                }
            }
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
            
        }
        //
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.dataArray.count - 1 && self.totalPages > pageNumber {
            if ( Reachability.isConnectedToNetwork() == true) {
                pageNumber = pageNumber + 1
                spinner.color = UIColor.gray
                
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.askTableView.bounds.width, height: CGFloat(10))
                
                self.askTableView.tableFooterView = spinner
                self.askTableView.tableFooterView?.isHidden = false
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
                self.dataArray.removeAll()
                
                self.getData()
                flagIsFromLocalOrServer = false
            }
        }
    }
}
