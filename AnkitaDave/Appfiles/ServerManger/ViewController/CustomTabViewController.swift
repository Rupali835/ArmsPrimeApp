//
//  CustomTabViewController.swift
//  SakshiChopra
//
//  Created by webwerks on 26/08/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import UIKit
import Instructions
import MoEngage
import MOInApp
import SwiftyJSON
import SwiftyStoreKit
import Pulley

public class downloadeImages
{
    var name: String!
    var image: UIImage!
    var order_id: Int!
    var tabList : List!
    
    init(image: UIImage, id: Int, name: String, tabList : List) {
        self.image = image
        self.order_id = id
        self.name = name
        self.tabList = tabList
    }
}


class CustomTabViewController: UITabBarController {
    var coachMarkService: CoachMarkService?
    var downloadImageArr = [downloadeImages]()
    var bucketsArray : [List]!
    var tabMenuArray : [List]!
    var previousVC : UIViewController?
    var liveButton = UIButton()
    var pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:40, position:.zero)
    var c: UILabel?
    var coin = ""
    var isCommingFromRewardView = false
    var isShowRewardPopUp: Bool = true
    var rewardPopUp : RewardMessageViewController?
    fileprivate let coachMarksController = CoachMarksController()
    var descMsg: String?
    var timer = Timer()
    var liveIconClick: Bool = true
    let refreshManager = RefreshManager.shared
    var cheerView = CheerView()
    var navigateToStory: Bool = false
    var customLoader: CustomLoaderViewController?
    var liveData: [String: Any] = [String: Any]()
    var isNeedToShowMobileVerification: Bool = true
    var isNeedToRefreshCoinData: Bool = true
    var isNotShowingCoachMark: Bool = true

    let containerView = UIView()
    var exmpleForSomeoneElseView : UIView!
    let label = UILabel()
    let imageView = UIImageView()

    var myView = UIView()
    var list = [JSON]()
    var strServerTime : String?
    var strNewID : String?
    var strNewDuration : String?
    var strNewTimeSlots : String?
    var strNewDate : String?
    var strnNewCustomer : String?
    var videoCallRequestID : String? = " "
    var strVideoCallCoin : String? = " "
    var status : String?
    var coinsLabel = UILabel()
    
    var joinVCCollectionView: UICollectionView!
    var artistConfig = ArtistConfiguration.sharedInstance()
    var age_difference : Int? = 0
    
    var minimumAccepetancePolicy: Double?
    var acceptedAcceptancePolicyVersion: Double?
    var artistConfigLoaderHandler: ((Bool?) -> ())?

      
      var items = [1,2,3,4,5]
      /*
      private lazy var paginationManager: HorizontalPaginationManager = {
          let manager = HorizontalPaginationManager(scrollView: self.joinVCCollectionView)
          manager.delegate = self
          return manager
      }()
    */
      
      private var isDragging: Bool {
        return self.joinVCCollectionView.isDragging
      }

    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        self.getVideoCallList()
        self.setupCollectionView()
       // self.setupPagination()
       // self.fetchItems()
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(CustomTabViewController.handleLiveButtonImage), name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.liveStarted), name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.liveEnded), name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFeedbackForm(notification:)), name: NSNotification.Name.init(Constants.LIVE_FEEDBACK), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatedCoin(_:)), name: NSNotification.Name(rawValue: "updatedCoins"), object: nil)
        
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = false
        addSideMeuBarButton()
        
        if isCommingFromRewardView == true {
            if isShowRewardPopUp == true{
                isShowRewardPopUp = false
                showRewardPopUp()
            }
            isCommingFromRewardView = false
        }
        
        if RCValues.sharedInstance.bool(forKey: .isServerUnderMaintenanceIOS) == true {
            let alert = UIAlertController(title: "Message", message: RCValues.sharedInstance.string(forKey: .serverMessageIOS), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .destructive, handler: { action in
                
              //  exit(0)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
//

        MOInApp.sharedInstance().show()

        //setTabMenu()
        self.getBuketData()
        self.delegate = self
 //       self.navigationItem.title = tabMenuArray.count != 0 ? tabMenuArray[0].caption ?? "" : ""
        setProfileImageOnBarButton()
        
        // Do any additional setup after loading the view.

        
        setInitForCustomLoader()
          
    }
    
    
    func getUsersMetaData(completion: @escaping (Bool)->()) {
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.META_ID + Constants.artistId_platform , extraHeader: nil, closure: { (result) in
            
            switch result {
                
            case .success(let data):
                print(data)
                if data["error"].boolValue{
                    //  self.showToast(message: "Something went wrong. Please try again!")
                    return
                    
                } else {
                    if  let purchaseContentIds = data["data"]["purchase_content_ids"].arrayObject, let blockContentIds = data["data"]["block_content_ids"].arrayObject{
                        //                        if let likeIds = likeContentIds as? [String]{
                        if let purchaseId = purchaseContentIds as? [String], let blockIds = blockContentIds as? [String]{
                            DatabaseManager.sharedInstance.storeLikesAndPurchase( purchaseIds: purchaseId, block_ids: blockIds)
                          
                            self.acceptedAcceptancePolicyVersion = data["data"]["accepted_customer_acceptance_policy_version"].double
                            
                            completion(true)
                            self.artistConfigLoaderHandler?(true)
                          
                        }
                        //  }
                    }
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
        
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getCoins, extraHeader: nil) { (result) in
            switch result {
            case .success(let data):
                print(data)
                if (data["error"] as? Bool == true) {
                    // self.showToast(message: "Something went wrong. Please try again!")
                    return
                    
                } else {
                    if let coins = data["data"]["coins"].int {
                        CustomerDetails.coins = coins
                        let database = DatabaseManager.sharedInstance
                        database.updateCustomerCoins(coinsValue: coins)
                    }
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func artistData(completion: @escaping (Bool)->()) {
        print(#function)
        if Reachability.isConnectedToNetwork()
        {
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.ARTIST_DATA + Constants.artistId_platform, extraHeader: nil, closure: { (result) in
                switch result {
                case .success(let data):
                    print(data)
                    
                    if (data["error"] as? Bool == true) {
                        completion(false)
                        return
                        
                    } else {
                       
                        
                        self.artistConfig.MinimumTNCVersion = data["data"]["artistconfig"]["minimum_acceptance_policy_version"].double
                        
                        self.artistConfig.AcceptedTNCVersion = data["data"]["artistconfig"]["accepted_acceptance_policy_version"].double
                        
                       
                        completion(true)
                        self.artistConfigLoaderHandler?(true)
                    }
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            })
        }
    }
    
    public func delay(_ delay: Double, closure: @escaping () -> Void) {
        let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(
            deadline: deadline,
            execute: closure
        )
    }

    func setBottomView(){
            if selectedIndex == 0{
               // self.getVideoCallList()
               myView.frame.origin.y = 100;
                
                myView.frame = CGRect(x: 0, y: self.view.frame.height - 260, width: self.view.frame.width, height: 100)
                myView.backgroundColor = .gray
            //self.view.addSubview(myView)
                
               /* let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                       layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                       layout.itemSize = CGSize(width: view.frame.width, height: 20)

                       joinVCCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
                       joinVCCollectionView.dataSource = self
                       joinVCCollectionView.delegate = self
                joinVCCollectionView.register(HorizontalCollectionCell.self, forCellWithReuseIdentifier: "HorizontalCollectionCell")
                       joinVCCollectionView.showsVerticalScrollIndicator = false
                      joinVCCollectionView.backgroundColor = .white
                       self.myView.addSubview(joinVCCollectionView)*/
            
                  
            }
        }
    
        func moengagePassCutomerId(){
    //        _ = self.getOfflineUserData()
            let custId = CustomerDetails.custId ?? ""
            ServerManager.sharedInstance().getRequestCustomerId(postData: nil, apiName:Constants.CustomerBucket + custId + "/" + "\(Constants.CELEB_ID)?" + "&platform=ios" + "&v=\(Constants.VERSION)" , extraHeader: nil, closure: { (result) in
                
                switch result {
                    
                case .success(let data):
                    print(data)
                    if data["error"].boolValue{
                        //  self.showToast(message: "Something went wrong. Please try again!")
                        return
                        
                    }else{
                        let customerBucket =  data["data"]["bucket"].string
                        UserDefaults.standard.set(customerBucket, forKey: "customerstatus")
                        UserDefaults.standard.synchronize()
                        CustomMoEngage.shared.updateMoEngageCustomerBucketAttribute(customerbucket:customerBucket ?? "")
                        
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    @objc func methodOfReceivedNotification(notification: Notification) {

        if CustomerDetails.profile_completed == true {
            
            
        guard let object = notification.object as? [String:Any] else {
            return
        }
        let messageCopy = object["message"] as? String

                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CongratsPopPopViewController") as! CongratsPopPopViewController
                    popOverVC.Messages = messageCopy ?? ""
                    self.addChild(popOverVC)
                    popOverVC.view.frame = self.view.frame
                    let screenSize: CGRect = UIScreen.main.bounds
                    self.exmpleForSomeoneElseView = popOverVC.view
                    self.exmpleForSomeoneElseView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:screenSize.height)
                    UIApplication.shared.keyWindow?.addSubview(self.exmpleForSomeoneElseView)
                    popOverVC.didMove(toParent: self)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier"), object: nil)
        }else{
           
            NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier"), object: nil)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getUsersMetaData { (mediaStatus) in
            if mediaStatus
            {
               self.artistData { (status) in
                
                if status {
                    if self.artistConfig.MinimumTNCVersion == self.acceptedAcceptancePolicyVersion  // accepted_customer_acceptance_policy_version
                    {

                        //self.navigationController?.navigationBar.isHidden = false
                        self.navigationController?.navigationBar.isUserInteractionEnabled = true

                        print("terms and condition accepted")
                    }else{
                       // self.navigationController?.navigationBar.isHidden = true
                        self.navigationController?.navigationBar.isUserInteractionEnabled = false
                        
                        self.TncPopup()
                    }
                    
                    
                } else {
                   
                }
                
              
            }
         }
        }
        
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        self.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false

        setProfileImageOnBarButton()
        
        if !self.checkIsUserLoggedIn() {
            
        } else {
            refreshManager.loadDataIfNeeded() { success in
                print(success)
                if success == true {
                    moengagePassCutomerId()
                } else {
                    
                }
            }
        }

           setBottomView()
        getOfflineUserData()
        

        if isNeedToRefreshCoinData {
            getUserDetails { (result) in
                if result {
                    self.isNeedToRefreshCoinData = false
                    self.handleMobileVerification()
                }
            }
        } else {
            handleMobileVerification()
        }
    }
    
    func TncPopup(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TnCAcceptViewController") as! TnCAcceptViewController
//            self.addChild(popOverVC)
//           popOverVC.view.frame = self.view.bounds
//          self.view.clipsToBounds = true
//            self.view.addSubview(popOverVC.view)
//            popOverVC.didMove(toParent: self)
      //  popOverVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(popOverVC, animated: false)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationItem.title = ""
        coachMarksController.stop(immediately: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !ShoutoutConfig.UserDefaultsManager.hasShoutoutCoachMarkShowedBefore() {
            self.isNotShowingCoachMark = false
            ShoutoutConfig.UserDefaultsManager.updateShoutoutCoachMarkStatusAsShown()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] () in
                self.coachMarksController.start(in: .currentWindow(of: self))
            }
        }
        
     
    }

    func showAnimation() {
        
        cheerView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        cheerView.frame = view.bounds
        view.addSubview(cheerView)
        cheerView.start(duration: 0.3)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(CustomTabViewController.closeAnimation), userInfo: nil, repeats: false)
    }
    
    func setInitForCustomLoader() {
        
        customLoader = Storyboard.main.instantiateViewController(viewController: CustomLoaderViewController.self)
        customLoader?.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @objc func closeAnimation() {
        cheerView.stop()
        cheerView.removeFromSuperview()
    }
    //
    //    func setTabMenu()  {
    //        self.bucketsArray = [List]()
    //        let database = DatabaseManager.sharedInstance
    //
    //        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    //        let writePath = documents + "/ConsumerDatabase.sqlite"
    //        database.dbPath = writePath
    //
    //        self.bucketsArray =  database.getBucketListing()
    //        printBucketData(arr: bucketsArray)
    //        if bucketsArray.count  == 0 {
    //            getBuketData()
    //        }
    //        self.bucketsArray = bucketsArray.sorted(by: { $0.ordering! < $1.ordering! })
    //
    //        tabMenuArray = [List]()
    //        for list in bucketsArray {
    //            if tabMenuArray.count < 3 {
    //               tabMenuArray.append(list)
    //            } else { break }
    //        }
    //        tabMenuArray = tabMenuArray.sorted(by: { $0.ordering! < $1.ordering! })
    //
    //
    //
    //        var viewControllers = [UIViewController]()
    //        for list in tabMenuArray {
    //                let tabBarItem = UITabBarItem.init()
    //                tabBarItem.image = UIImage(named: setUnSelectedTabImage(code: list.code ?? ""))?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    //                tabBarItem.selectedImage = UIImage(named: setSelectedTabImage(code: list.code ?? ""))?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    //                tabBarItem.title = list.name ?? ""
    //                tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -4, right: 0)
    //
    //
    //                if let viewController = setViewControllerAsPerBucket(list: list) {
    //                    viewController.tabBarItem = tabBarItem
    //                    viewControllers.append(viewController)
    //                }
    //            }
    //
    //
    //        let tabBarItem = UITabBarItem.init()
    //        tabBarItem.image = UIImage(named: "menuUnclick")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    //        tabBarItem.selectedImage = UIImage(named: "menuClick")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    //        tabBarItem.title = "Menu"
    //        tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -4, right: 0)
    //
    //        let viewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
    //        viewController!.tabBarItem = tabBarItem
    //        viewControllers.append(viewController!)
    //
    //
    //        let selectedColor   = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    //        let unselectedColor = hexStringToUIColor(hex: MyColors.tabBarUnSelectedTextColor)
    //
    //
    //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
    //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    //
    //        self.tabBar.tintColor = .white
    //        self.tabBar.unselectedItemTintColor = unselectedColor
    ////        self.tabBar.barTintColor = .white
    //
    //        let colors: [CGColor] = [hexStringToUIColor(hex: Colors.lightMaroon.rawValue).cgColor, hexStringToUIColor(hex: Colors.black.rawValue).cgColor]
    //        self.tabBar.setGradientBackground(colors: colors)
    //
    //
    ////        self.tabBar.isTranslucent = false
    //
    //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: AppFont.medium.rawValue, size: 9)!], for: .normal)
    //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: AppFont.medium.rawValue, size: 9)!], for: .selected)
    //
    //
    //        self.viewControllers = viewControllers
    //
    //        // Setup Coach Marks
    //        if let _ = tabMenuArray.firstIndex(where: { $0.code == ShoutoutConstants.shoutoutBucketCode } ) {
    //            coachMarksController.dataSource = self
    //            coachMarksController.delegate = self
    //            coachMarksController.overlay.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.75)
    //            coachMarksController.overlay.allowTap = true
    //        }
    //    }
  
    
    func SetMenuData()
    {
     //   self.bucketsArray = [List]()
        let database = DatabaseManager.sharedInstance
        
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
  //        database.deleteBuckets()
        
  //      self.bucketsArray = database.getBucketListing()
        

        if bucketsArray.count == 0 {
            getBuketData()
        } else {
            checkStoryExistAtLaunch()
        }
        
    //    self.bucketsArray = bucketsArray.sorted(by: { $0.ordering! < $1.ordering! })
        
        tabMenuArray = [List]()
        
        for list in bucketsArray {
            if tabMenuArray.count < AppConstants.numberOfBucketItemsInTab {
                tabMenuArray.append(list)
            } else { break }
        }
        print("BUCKET ARRAY= \(bucketsArray)")
        print("TABS = \(tabMenuArray)")
    //    tabMenuArray = tabMenuArray.sorted(by: { $0.ordering! < $1.ordering! })
        
        if tabMenuArray.count > 0 {
            self.setNavigationView(title: tabMenuArray[0].caption ?? "")
        }
        
        //   var tabimagesArr = [UIImage]()
        
        let imageCache = NSCache<AnyObject, AnyObject>()
        
        for  list in tabMenuArray
               {
                   
                   if let imageUrl = list.photo?.cover { //rupali
                       print("URL = \(imageUrl)")
                       
                       //self.image = nil
                       
                       //check cache for image first
                       if let cachedImage = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
                           //self.image = cachedImage
                        let resizedImage = self.resizeImage(image: cachedImage, targetSize: .init(width: 20, height: 20))
                           
                        let lcDownloadImage = downloadeImages(image: resizedImage!, id: list.ordering!, name: list.name!, tabList: list)
                           
                           self.downloadImageArr.append(lcDownloadImage)
                           
                           if self.downloadImageArr.count == AppConstants.numberOfBucketItemsInTab
                          {
                              // self.downloadImageArr = self.downloadImageArr.sorted(by: { $0.order_id < $1.order_id })
                            self.setTabMenu()
                           }
                          
                           return
                       }
                       
                       guard let url = URL(string: imageUrl) else { return  }
                       // download the image asynchronously
                       let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                           if let err = error {
                               print(err)
                               return
                           }
                           
                           
                           DispatchQueue.main.async {
                               // create UIImage
                               let image = UIImage(data: data!)
                               
                               let resizedImage = self.resizeImage(image: image!, targetSize: .init(width: 20, height: 20))
                               
                            let lcDownloadImage = downloadeImages(image: resizedImage!, id: list.ordering!, name: list.name!, tabList: list)
                               
                               imageCache.setObject(image!, forKey: imageUrl as AnyObject)
                               
                               self.downloadImageArr.append(lcDownloadImage)
           
                               if self.downloadImageArr.count == AppConstants.numberOfBucketItemsInTab
                               {
                                   self.downloadImageArr = self.downloadImageArr.sorted(by: { $0.order_id < $1.order_id })
                                self.setTabMenu()
                               }
                             
                           }
                       }
                       
                       task.resume()
                       
                   }
                   
               }
    }
    
    
    func setTabMenu()  {
        
        
        var viewControllers = [UIViewController]()
        
        
        for downloadImage in downloadImageArr
        {
                  
          let tabBarItem = UITabBarItem.init()
                        
            tabBarItem.image = downloadImage.image
            tabBarItem.selectedImage =  downloadImage.image
                        
            tabBarItem.title = downloadImage.name?.uppercased() ?? ""
                        
            tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -4, right: 0)
                        
            if let viewController = self.setViewControllerAsPerBucket(list: downloadImage.tabList) {
                            viewController.tabBarItem = tabBarItem
               //
                            viewControllers.append(viewController)
                        }
                        
                        self.viewControllers = viewControllers
                        
                    }
          
        //            tabBarItem.image = UIImage(named: setUnSelectedTabImage(code: list.code ?? ""))?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        //            tabBarItem.selectedImage = UIImage(named: setSelectedTabImage(code: list.code ?? ""))?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let selectedColor   = BlackThemeColor.yellow
        let unselectedColor = BlackThemeColor.tabGray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        self.tabBar.tintColor = selectedColor
        self.tabBar.unselectedItemTintColor = unselectedColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: AppFont.light.rawValue, size: 9)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: AppFont.light.rawValue, size: 9)!], for: .selected)
        
        let colors: [CGColor] = [hexStringToUIColor(hex: Colors.lightMaroon.rawValue).cgColor, hexStringToUIColor(hex: Colors.black.rawValue).cgColor]
        self.tabBar.barTintColor = BlackThemeColor.darkBlack
        //        self.tabBar.setGradientBackground(colors: colors)
        self.viewControllers = viewControllers
        
        // Setup Coach Marks
        if let _ = tabMenuArray.firstIndex(where: { $0.code == ShoutoutConstants.shoutoutBucketCode } ) {
            coachMarksController.dataSource = self
            coachMarksController.delegate = self
            coachMarksController.overlay.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.75)
            coachMarksController.overlay.allowTap = true
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
         let size = image.size
         let widthRatio  = targetSize.width  / size.width
         let heightRatio = targetSize.height / size.height
         var newSize: CGSize
         if(widthRatio > heightRatio) {
             newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
         } else {
             newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
         }
         let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
         UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
         image.draw(in: rect)
    
        
      //  let newcode = UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), false, 0)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return newImage
     }
   
    
    func printBucketData(arr:[List]) {
        let blankStr = ""
        for bucket in arr {
            print("order [\(bucket.ordering ?? 0) ] name => \(bucket.name ?? blankStr) code \(bucket.code ?? blankStr)")
        }
    }
    
    func setViewControllerAsPerBucket(list: List) -> UIViewController? {
        switch list.code {
        case "home":
            let vc =  UIStoryboard(name: "Home", bundle:nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
           
            
            return vc

        case "private-video-call":
            let headerPlayerController = Storyboard.wardrobe.instantiateViewController(viewController: HeaderVideoPlayerViewController.self)
            headerPlayerController.playerSate = .fromOnetoOne
            if let videoUrlPath = ArtistConfiguration.sharedInstance().privateVideoCallURL?.videoURL, let url = URL(string:videoUrlPath) {
                headerPlayerController.viewState = BannerState.video(videoUrl: url)
            }
            let newCelebyteController = Storyboard.main.instantiateViewController(viewController: NewCelebyteVideoViewController.self)
            newCelebyteController.stateChangeClouser = { state in
                headerPlayerController.changeSoundStatus(with: state)
            }

            let pulleyController = PulleyViewController(contentViewController: headerPlayerController, drawerViewController: newCelebyteController)
            pulleyController.drawerCornerRadius = 20
           
            return pulleyController

        case "wardrobe":
            let headerPlayerController = Storyboard.wardrobe.instantiateViewController(viewController: HeaderVideoPlayerViewController.self)
            headerPlayerController.playerSate = .fromWadrable
            let wardrobeVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobeViewController.self)
            wardrobeVC.stateChangeClouser = { state in
                headerPlayerController.changeSoundStatus(with: state)
            }
            let pulleyController = PulleyViewController(contentViewController: headerPlayerController, drawerViewController: wardrobeVC)
            pulleyController.drawerCornerRadius = 20

            return pulleyController
        case "directline":
            let vc = storyboard?.instantiateViewController(withIdentifier: "DirectLinkViewController") as? DirectLinkViewController
            return vc
        case "top-fans":
            let resultViewController = Storyboard.main.instantiateViewController(viewController: MyFavoriteFansViewController.self)
            return resultViewController
        case ShoutoutConstants.shoutoutBucketCode:
            let headerPlayerController = Storyboard.wardrobe.instantiateViewController(viewController: HeaderVideoPlayerViewController.self)
            headerPlayerController.playerSate = .fromCelebyte
            if let videoUrlPath = ShoutoutConfig.howItWorksVideoURL, let url = URL(string:videoUrlPath) {
                headerPlayerController.viewState = BannerState.video(videoUrl: url)
            }

            let videoGreetingController = Storyboard.videoGreetings.instantiateViewController(viewController: CeleByteViewController.self)
            videoGreetingController.stateChangeClouser = {  state in
                headerPlayerController.changeSoundStatus(with: state)
            }

        let pulleyController = PulleyViewController(contentViewController: headerPlayerController, drawerViewController: videoGreetingController)
            pulleyController.drawerCornerRadius = 20
            return pulleyController

        default:
            let vc = Storyboard.main.instantiateViewController(viewController: TravelingViewController.self)
            vc.pageList = list
            return vc
//            let vc =  UIStoryboard(name: "HomeStoryboard", bundle:nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
//                           return vc
        }
    }
    
    func setSelectedTabImage(code:String) -> String {
        switch code {
        case "private-video-call":
            return "VideoCallClick"
        case "home":
            return "homeClick"
        case "wardrobe":
            return "wardrobeClick"
        case "directline":
            return "DirectLineClick"
        case "social-life":
            return "newsFeedClicked"
        case "photos":
            return "photoClick"
        case "videos":
            return "videoClick"
        case "calendar-2020":
            return "defaultClick"
        case "travel":
            return "gandiBatClick"
        case "events":
            return "defaultClick"
        case "top-fans":
            return "leaderbordSelected"
        case ShoutoutConstants.shoutoutBucketCode:
            return "VG_Shoutout_TabIcon"
        default:
            return "defaultClick"
        }
    }

    func setUnSelectedTabImage(code:String) -> String {
        switch code {
        case "private-video-call":
            return "VideoCallUnClick"
        case "home":
            return "homeUnselected"
        case "wardrobe":
            return "WardrobeUnselected"
        case "directline":
            return "DLUnselected"
        case "social-life":
            return "newsFeedUnclick"
        case "photos":
            return "PhotosUnselected"
        case "videos":
            return "VideosUnselected"
        case "calendar-2020":
            return "defaultUnClick"
        case "travel":
            return "gandiBatUnClick"
        case "events":
            return "defaultUnClick"
        case "top-fans":
            return "top-fans_menu"
        case ShoutoutConstants.shoutoutBucketCode:
            return "VG_ShoutoutsIconBeforeClick"
        default:
            return "defaultUnClick"
        }
    }
    
    //MARK:- Loader
    func showCustomLoader(window: UIWindow?) {
        
        DispatchQueue.main.async {
            if let loader = self.customLoader,
                let win = window {
                win.addSubview(loader.view)
            }
        }
    }
    
    func removeCustomLoader() {
        
        DispatchQueue.main.async {
            if let loader = self.customLoader {
                loader.view.removeFromSuperview()
            }
        }
    }
    
    //MARK:- LIVE
    func setProfileImageOnBarButton() {
        
        liveButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        liveButton.addTarget(self, action:#selector(self.openLiveScreen), for: .touchUpInside)
        
        if let image = UIImage(named: "liveCeleb") {
            
            let color = UIColor(patternImage: image)
            liveButton.backgroundColor = color
            
            let barButton = UIBarButtonItem()
            barButton.customView = liveButton
            
            if let loginStatus = UserDefaults.standard.object(forKey: "LoginSession") as? String, loginStatus == "LoginSessionIn" {
                let coinsBarButton = UIBarButtonItem(customView: coinsBarButtonView())
                self.navigationItem.rightBarButtonItems = [barButton,coinsBarButton]
            } else {
                self.navigationItem.rightBarButtonItems = [barButton]
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
        }
    }
    
    func getOfflineUserData(){
        
        var customer : Customer!
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let writePath  = documents + "/ConsumerDatabase.sqlite"
        print(writePath)
        var database : DatabaseManager!
        if( !fileManager.fileExists(atPath : writePath)){
            
        }else{
           database = DatabaseManager.sharedInstance
            database.initDatabase(path: writePath)
            customer = database.getCustomerData()
            CustomerDetails.customerData = customer
            CustomerDetails.custId = customer._id
            CustomerDetails.firstName = customer.first_name
            CustomerDetails.mobile_verified = UserDefaults.standard.bool(forKey: "mobile_verified")
            CustomerDetails.email_verified = UserDefaults.standard.bool(forKey: "email_verified")
            CustomerDetails.profile_completed = UserDefaults.standard.bool(forKey: "profile_completed")
            CustomerDetails.coins = customer.coins
            CustomerDetails.email = customer.email
            CustomerDetails.lastName = customer.last_name
            CustomerDetails.picture = customer.picture
            CustomerDetails.purchase_stickers = customer.purchaseStickers
            CustomerDetails.mobileNumber = customer.mobile
            CustomerDetails.directline_room_id = customer.directline_room_id
            CustomerDetails.gender = customer.gender
            CustomerDetails.badges = customer.badges
            CustomerDetails.identity = customer.identity
            CustomerDetails.lastVisited = customer.last_visited
            CustomerDetails.status = customer.status
            CustomerDetails.dob = customer.dob
            CustomerDetails.mobile_code = customer.mobile_code
        }
        
    }
    fileprivate func coinsBarButtonView() -> UIView {
        getOfflineUserData()
        containerView.frame = CGRect(x: 0.0, y: 0.0, width: 45.0, height: 40.0)

        imageView.contentMode = .scaleAspectFit
        if CustomerDetails.profile_completed == true {
            imageView.image = #imageLiteral(resourceName: "armsCoin")
        }else {
            imageView.image = #imageLiteral(resourceName: "profile_completed")
           configureCoachMarkService()
        }
        
        if let coins = CustomerDetails.coins {
            label.text  = "\(coins)"
        }else{
            
            ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getCoins, extraHeader: nil) { (result) in
                
                switch result {
                    
                case .success(let data):
                    print("Tab : \(#function) => \(data)")
                    
                    if let error = data["error"].bool {
                        if error {
                            return
                        }
                    }
                    
                    if let coins = data["data"]["coins"].int {
                        CustomerDetails.coins = coins
                        DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins ?? 0)
                        CustomMoEngage.shared.updateMoEngageCoinAttribute()
                        self.coinsLabel.text = "\(coins)"
                        self.label.text = "\(coins)"
                    }
               
                case .failure(let error):
                    print(error)
                }
            }
        }
        label.font = UIFont.init(name: AppFont.bold.rawValue, size: 8)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = 1.0
        stackView.distribution  = .fill
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        let actionButton = UIButton(type: .custom)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(actionButton)
        containerView.bringSubviewToFront(actionButton)
        actionButton.addTarget(self, action: #selector(didTapCoinsBarButton), for: .touchUpInside)
        
        actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        actionButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        return containerView
    }
    @objc func didTapCoinsBarButton() {
           print("didTapCoinsBarButton")
           if CustomerDetails.profile_completed == true {
               let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                      let walletNavigate = mainstoryboad.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
                      walletNavigate.hidesBottomBarWhenPushed = true
                      self.navigationController?.pushViewController(walletNavigate, animated: false)
           }else{
               let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EarnMoreCoinsPopPopViewController") as! EarnMoreCoinsPopPopViewController
               self.addChild(popOverVC)
               popOverVC.view.frame = self.view.frame
               let screenSize: CGRect = UIScreen.main.bounds
               self.exmpleForSomeoneElseView = popOverVC.view
               self.exmpleForSomeoneElseView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:screenSize.height)
               UIApplication.shared.keyWindow?.addSubview(self.exmpleForSomeoneElseView)
               popOverVC.didMove(toParent: self)
           }
          
       }
    
    func loginPopPops() {
        liveIconClick = false
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPopPopViewController") as! LoginPopPopViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        popOverVC.textLabel.text = "Hey there! log in right now to connect with me"
        popOverVC.coinsView.isHidden = true
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    @objc func updatedCoin(_ notification: NSNotification) {
        
        if let coins = CustomerDetails.coins {
            
            self.coinsLabel.text = "\(coins)"
            self.label.text = "\(coins)"
            let database = DatabaseManager.sharedInstance
            database.updateCustomerCoins(coinsValue: CustomerDetails.coins)
        } else {
            self.coinsLabel.text = "0"
        }
        
        if notification.userInfo == nil {
            checkMobileVerification()
        }
    }
    
    @objc func openLiveScreen() {
        if !self.checkIsUserLoggedIn() {
            if liveIconClick == true{
                self.loginPopPops()
            }
            return
        }
        
        if !(Reachability.isConnectedToNetwork()) {
            self.showToast(message: Constants.NO_Internet_MSG)
            return
        }
        
        checkAgoraChannelExist()
    }
    
    func checkAgoraChannelExist() {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if appDelegate.isCheckAgoraChannelExecuting == true { return }
            appDelegate.isCheckAgoraChannelExecuting = true
            
            let apiName = Constants.WEB_CHECK_AGORA_CHANNEL + "\(artistConfig.agora_id ?? "")" + "/\(artistConfig.channel_namespace ?? "")"
            
            if Reachability.isConnectedToNetwork() {
                
                self.showCustomLoader(window: appDelegate.window)
                
                ServerManager.sharedInstance().getRequestAgora(postData: nil, apiName: apiName, extraHeader: nil) { (result) in
                    
                    self.removeCustomLoader()
                    
                    appDelegate.isCheckAgoraChannelExecuting = false
                    
                    DispatchQueue.main.async {
                        
                        switch result {
                        case .success(let data):
                            if let dictData = data["data"].dictionaryObject {
                                
                                if let channel_exist = dictData["channel_exist"] as? Bool {
                                    
                                    if channel_exist == true {
                                        
                                        if let arrBroadcasters = dictData["broadcasters"] as? [Any] {
                                            
                                            if arrBroadcasters.count > 0 {
                                                
                                                self.liveData = dictData
                                                print("channel is live --------------->>>>")
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
                                            }
                                            else {
                                                
                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                                            }
                                        }
                                        else {
                                            
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                                        }
                                    }
                                    else {
                                        
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                                    }
                                }
                                else
                                {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                                }
                            }
                            else {
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                            }
                            
                        case .failure(let error):
                            print(error)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                        }
                        
                        self.handleLiveButton()
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                    self.handleLiveButton()
                }
            }
        }
    }
    
    @objc func handleLiveButtonImage() {
        
        DispatchQueue.main.async {
            
            self.pulseEffect.removeFromSuperlayer()
            
            if UserDefaults.standard.bool(forKey: "liveStatus") {
                
                if let image = UIImage(named: "liveCeleb") {
                    let color = UIColor(patternImage: image)
                    self.liveButton.backgroundColor = color
                }
                self.pulseEffect.position = self.liveButton.center
                self.liveButton.layer.insertSublayer(self.pulseEffect, below: self.liveButton.layer)
                
            } else if UserDefaults.standard.bool(forKey: "storyStatus") {
                
                if let image = UIImage(named: "storyCeleb") {
                    let color = UIColor(patternImage: image)
                    self.liveButton.backgroundColor = color
                }
            }
        }
    }
    
    func handleLiveButton() {
        
        DispatchQueue.main.async {
            if UserDefaults.standard.bool(forKey: "liveStatus") {
                self.gotoLiveVC()
            } else if UserDefaults.standard.bool(forKey: "storyStatus") {
                self.gotoStoryVC()
            } else {
                self.gotoLiveVC()
            }
        }
    }
    
    func gotoLiveVC() {
        
        DispatchQueue.main.async {
            CustomMoEngage.shared.sendEventUIComponent(componentName: "Home_Live", extraParamDict: nil)
            
            let liveVC = Storyboard.main.instantiateViewController(viewController: LiveScreenViewController_New.self)
            liveVC.hidesBottomBarWhenPushed = true
            liveVC.isComingFromLiveButton = true
            liveVC.liveAgoraData = self.liveData
            self.pushAnimation()
            self.navigationController?.pushViewController(liveVC, animated: false)
        }
    }
    
    func gotoStoryVC() {
        
        DispatchQueue.main.async {
            if let image = UIImage(named: "storyCeleb") {
                let color = UIColor(patternImage: image)
                self.liveButton.backgroundColor = color
            }
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let story = appDelegate.story,
                let story_copy = try? story.copy() {
                
                let storyPreviewScene = APMStoryPreviewController.init(story: story_copy)
                storyPreviewScene.modalPresentationStyle = .fullScreen
                storyPreviewScene.delegate = self
                self.present(storyPreviewScene, animated: true, completion: nil)
            }
        }
    }
    
    func handleMobileVerification() {
        
        if self.isNeedToShowMobileVerification && self.isNotShowingCoachMark {
            self.checkMobileVerification()
        }
    }
    
    func checkMobileVerification() {
        
        if self.checkIsUserLoggedIn() {
            let isRequiredMobileVerifyPopup = RCValues.sharedInstance.bool(forKey: .showMobileVerifyPopupIos)
            let isMobileVerificationMandatory = RCValues.sharedInstance.bool(forKey: .isMobileVerificationMandatoryIos)
            let isMobileVerified = UserDefaults.standard.bool(forKey: "mobile_verified")
            
            if  let CustomerType = UserDefaults.standard.value(forKey: "customerstatus") as? String {
            if CustomerType == "epu" {
            if isRequiredMobileVerifyPopup && !isMobileVerified {
                isNeedToShowMobileVerification = false
                openMobileVerificationPopUp(isMandatory: isMobileVerificationMandatory)
            }
                }
            }
        }
    }
    
    func openMobileVerificationPopUp(isMandatory: Bool) {
        
        DispatchQueue.main.async {
            let mobilePopUpVC = Storyboard.main.instantiateViewController(viewController: MobileVerificationViewController.self)
            mobilePopUpVC.modalPresentationStyle = .custom
            mobilePopUpVC.transitioningDelegate = self
            mobilePopUpVC.isMandatory = isMandatory
            
            if let rootVC = UIApplication.topViewController() {
                if !rootVC.isKind(of: MobileVerificationViewController.self) {
                    rootVC.present(mobilePopUpVC, animated: true)
                }
            }
        }
    }
    
    func checkStoryExistAtLaunch() {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if appDelegate.isCheckStoryExecuting == true { return }
            appDelegate.isCheckStoryExecuting = true
            
            if let bucket = GlobalFunctions.returnBucketListFormBucketCode(code: "story", isForStory: true),
                let bucketID = bucket._id {
                
                let paramters = ["bucket_id": bucketID,
                                 "is_story": true] as [String : Any]
                
                WebServiceHelper.shared.callGetMethod(endPoint: Constants.bucketContent, parameters: paramters, responseType: APMStoryResponse.self, showLoader: false, baseURL: Constants.cloud_base_url) { (response, error) in
                    
                    appDelegate.isCheckStoryExecuting = false
                    
                    if let story = response?.data,
                        let snaps = story.snaps, snaps.count > 0 {
                        appDelegate.story = story
                        
                        UserDefaults.standard.set(true, forKey: "storyStatus")
                        UserDefaults.standard.synchronize()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
                        
                        if self.navigateToStory {
                            self.navigateToStory = false
                            self.gotoStoryVC()
                        }
                    } else {
                        UserDefaults.standard.set(false, forKey: "storyStatus")
                        UserDefaults.standard.synchronize()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
                    }
                }
            }
        }
    }
    
    func showToast(message : String) {
        DispatchQueue.main.async {
            self.showOnlyAlert(title: "", message: message)
        }
    }
    
    func pushAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .fade//CATransitionType.push
        //        transition.subtype =  CATransitionSubtype.fromRight
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
    
    @objc func liveStarted() {
        UserDefaults.standard.set(true, forKey: "liveStatus")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
    }
    
    @objc func liveEnded() {
        UserDefaults.standard.set(false, forKey: "liveStatus")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveButtonImage"), object: nil)
    }
    
    //MARK:- bucketList API
    func getBuketData() {
        
        if Reachability.isConnectedToNetwork() == true{
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.HOME_SCREEN_DATA + Constants.artistId_platform, extraHeader: nil, closure: { (result) in
                switch result {
                case .success(let data):
                    if (data["error"] as? Bool == true) {
                        
                        return
                        
                    } else {
                        self.bucketsArray = [List]()
                        if (data != nil) {
                            let arrayList =  data["data"]["list"].arrayObject
                            for dict in arrayList! {
                                
                                let list : List = List(dictionary: dict as! NSDictionary)!
                                self.bucketsArray.append(list)
                                BucketValues.bucketIdArray.append(list._id ?? "")
                                
                            }
                            if (data["data"]["list"].arrayObject != nil) {
                                BucketValues.bucketContentArr = NSMutableArray(array: data["data"]["list"].arrayObject!)
                                
                            }
                            self.addBucketListingToDatabase(bucketArray: self.bucketsArray)
                            print(data)
                            self.SetMenuData()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                
            })
        } else {
            //            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    open func getUserDetails(completion: @escaping(_ result: Bool)->()) {
        
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getCoins, extraHeader: nil) { (result) in
            
            switch result {
                
            case .success(let data):
                print("Tab : \(#function) => \(data)")
                
                if let error = data["error"].bool {
                    if error {
                        return
                    }
                }
                
                if let coins = data["data"]["coins"].int {
                    CustomerDetails.coins = coins
                    DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins)
                    CustomMoEngage.shared.updateMoEngageCoinAttribute()
                    self.coinsLabel.text = "\(coins)"
                }
                
                if let mobile_verified = data["data"]["mobile_verified"].bool {
                    CustomerDetails.mobile_verified = mobile_verified
                    UserDefaults.standard.set(CustomerDetails.mobile_verified, forKey: "mobile_verified")
                    UserDefaults.standard.synchronize()
                }
                
                if let mobile = data["data"]["mobile"].string {
                    if mobile != "" {
                        CustomerDetails.mobileNumber = mobile
                        DatabaseManager.sharedInstance.updateMobileNumber(mobileNumber: mobile)
                    }
                }
                
                completion(true)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addBucketListingToDatabase(bucketArray: [List]) {
        
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        /*if let dbURL = GlobalFunctions.createDatabaseUrlPath() {
         database.dbPath = dbURL.path
         }*/
        
        database.createStatsTable()
        database.createBucketListTable()
        database.addBucketColum()
        
        for list in bucketArray {
            database.insertIntoBucketListTable(list: list)
        }
        
        checkStoryExistAtLaunch()
    }
}

//MARK:- UITabBarControllerDelegate
extension CustomTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tabBar.isHidden = false
        if selectedIndex == 0{
                   myView.isHidden = false
                   self.setBottomView()
               }else {
                   myView.isHidden = true
               }
        if tabMenuArray.count != 0 {
            self.navigationItem.title = tabMenuArray[tabBarController.selectedIndex].name
//            if tabBarController.selectedIndex > 3 {
//                self.navigationItem.title = Constants.celebrityName
//            } else {
//                self.navigationItem.title = tabMenuArray[tabBarController.selectedIndex].name ?? ""
//            }
            
        }
        
        if let rootViewController = UIApplication.topViewController() {
            print("tab bar didSelect photo called")
            if (rootViewController.isKind(of: PhotosTableViewController.self) && previousVC != nil &&  (previousVC?.isKind(of: PhotosTableViewController.self))!) {
                let vc : PhotosTableViewController = rootViewController as! PhotosTableViewController
                if (vc.PhotoViewTable != nil && vc.isTableLoaded) {
                    let numberOfSections = vc.PhotoViewTable.numberOfSections
                    let numberOfRows = vc.PhotoViewTable.numberOfRows(inSection:numberOfSections-1)
                    
                    
                    if (numberOfRows > 0) {
                        vc.PhotoViewTable.scrollToRow(at:IndexPath.init(row: 0, section: 0) , at: .top, animated: true)
                    }
                }
            }
            else if (rootViewController.isKind(of: VideosViewController.self) &&  previousVC != nil && (previousVC?.isKind(of: VideosViewController.self))!) {
                print("tab bar didSelect video called")
                let vc : VideosViewController = rootViewController as! VideosViewController
                if (vc.videoTableView != nil && vc.isTableLoaded) {
                    let numberOfSections = vc.videoTableView.numberOfSections
                    let numberOfRows = vc.videoTableView.numberOfRows(inSection:numberOfSections-1)
                    
                    if (numberOfRows > 0) {
                        vc.videoTableView.scrollToRow(at:IndexPath.init(row: 0, section: 0) , at: .top, animated: true)
                    }
                    
                }
            } else if (rootViewController.isKind(of: SocialJunctionViewController.self) && previousVC != nil &&  (previousVC?.isKind(of: SocialJunctionViewController.self))!) {
                print("tab bar didSelect newsfeed called")
                let vc : SocialJunctionViewController = rootViewController as! SocialJunctionViewController
                if (vc.socialTableView != nil && vc.isTableLoaded) {
                    let numberOfSections = vc.socialTableView.numberOfSections
                    let numberOfRows = vc.socialTableView.numberOfRows(inSection:numberOfSections-1)
                    
                    if (numberOfRows > 0) {
                        vc.socialTableView.scrollToRow(at:IndexPath.init(row: 0, section: 0) , at: .top, animated: true)
                        
                    }
                }
            } else if (rootViewController.isKind(of: TravelingViewController.self) && previousVC != nil &&  (previousVC?.isKind(of: TravelingViewController.self))!) {
                print("tab bar didSelect newsfeed called")
                let vc : TravelingViewController = rootViewController as! TravelingViewController
                if (vc.travelingTableView != nil) { //&& vc.isTableLoaded) {
                    let numberOfSections = vc.travelingTableView.numberOfSections
                    let numberOfRows = vc.travelingTableView.numberOfRows(inSection:numberOfSections-1)
                    
                    if (numberOfRows > 0) {
                        vc.travelingTableView.scrollToRow(at:IndexPath.init(row: 0, section: 0) , at: .top, animated: true)
                        
                    }
                }
            }
            previousVC = rootViewController
        }
    }
}
//MARK:- RewardMessageViewControllerDelegate
extension CustomTabViewController: RewardMessageViewControllerDelegate {
    func closeRewardPopUp(_ sender: UIButton) {
        if rewardPopUp != nil {
            rewardPopUp!.view.removeFromSuperview()
        }
    }
    
    func showRewardPopUp() {
        rewardPopUp = RewardMessageViewController.loadFromNib()
        rewardPopUp?.view.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        rewardPopUp?.delegate = self
        rewardPopUp?.descMsg = descMsg
        self.view.addSubview(rewardPopUp!.view)
        rewardPopUp?.didMove(toParent: self)
        
        showAnimation()
    }
    
}
extension UIViewController {
    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
}
// MARK: - Live Event Feedback Notification
extension CustomTabViewController {
    
    @objc func showFeedbackForm(notification: Notification) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: "LiveFeedbackViewController") as! LiveFeedbackViewController
            if let event = notification.object as? LiveEventModel {
                feedbackVC.eventDetails = event
            }
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController?.present(feedbackVC, animated: true, completion: nil)
        }
    }
}
// MARK: - Handle Coach Marks | CoachMarksControllerDataSource
extension CustomTabViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachMarkBodyView = CustomCoachMarkBodyView()
        var coachMarkArrowView: CustomCoachMarkArrowView?
        
        let width: CGFloat = 35.0
        
        coachMarkBodyView.titleLabel.text = "Greetings"
        coachMarkBodyView.hintLabel.text = "Get Personalized Videos From The \(Constants.celebrityName).\nRequest here!"
        
        // We create an arrow only if an orientation is provided (i. e., a cutoutPath is provided).
        // For that custom coachmark, we'll need to update a bit the arrow, so it'll look like
        // it fits the width of the view.
        if let arrowOrientation = coachMark.arrowOrientation {
            coachMarkArrowView = CustomCoachMarkArrowView(orientation: arrowOrientation)
            
            // If the view is larger than 1/3 of the overlay width, we'll shrink a bit the width
            // of the arrow.
            let oneThirdOfWidth = (view.window?.frame.size.width ?? view.frame.width) / 3
            let adjustedWidth = width >= oneThirdOfWidth ? width - 2 * coachMark.horizontalMargin : width
            
            if coachMarkArrowView != nil {
                coachMarkArrowView!.plate.addConstraint(NSLayoutConstraint(item: coachMarkArrowView!.plate, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: adjustedWidth))
            }
        }
        
        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        // This will create cutout path matching perfectly the given view.
        // No padding!
        let flatCutoutPathMaker = { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(rect: frame)
        }
        
        var coachMark: CoachMark = coachMarksController.helper.makeCoachMark()
        guard let tabBarItems = tabBar.items else { return coachMark }
        
        guard let shoutoutIndex = tabMenuArray.firstIndex(where: { $0.code == ShoutoutConstants.shoutoutBucketCode } ) else { return coachMark }
        let tabItemWidth = tabBar.frame.width / CGFloat(tabBarItems.count)
        let itemWidth: CGFloat = 35.0
        let xOffset: CGFloat = CGFloat(shoutoutIndex) * tabItemWidth
        let xCord: CGFloat = xOffset + (itemWidth * 0.5) + (tabItemWidth - itemWidth) * 0.5
        
        switch index {
        case 0:
            // Coach Mark for Shoutout
            let contestItemPoint = CGPoint(x: xCord, y: tabBar.center.y - 30.0)
            coachMark = coachMarksController.helper.makeCoachMark(for: tabBar, pointOfInterest: contestItemPoint, cutoutPathMaker: flatCutoutPathMaker)
            coachMark.arrowOrientation = .bottom
            
        default:
            coachMark = coachMarksController.helper.makeCoachMark()
        }
        
        coachMark.gapBetweenCoachMarkAndCutoutPath = 6.0
        return coachMark
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return tabMenuArray.firstIndex(where: { $0.code == ShoutoutConstants.shoutoutBucketCode } ) != nil ? 1 : 0
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
        self.isNotShowingCoachMark = true
       
        if isNeedToShowMobileVerification && self.isNotShowingCoachMark {
            checkMobileVerification()
        }
    }
}


// MARK: - APMStoryPreviewProtocol
extension CustomTabViewController: APMStoryPreviewProtocol {
    
    func didTapPromotionButton(index: Int) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let story = appDelegate.story,
            let snaps = story.snaps {
            
            if index < snaps.count {
                if let promotionType = snaps[index].promotion_type {
                    
                    if promotionType != "external_url" {
                        
                        let bucketIndex: Int = GlobalFunctions.findIndexOfBucketCode(code: promotionType) ?? -1
                        
                        if bucketIndex > -1 {
                            if bucketIndex < 4 {
                                
                                if let _ = navigationController?.viewControllers.last as? CustomTabViewController {
                                    tabBar.isHidden = false
                                    selectedIndex = bucketIndex
                                    navigationItem.title = tabMenuArray[bucketIndex].caption ?? ""
                                } else if let tab = navigationController?.viewControllers.filter( { $0 is CustomTabViewController}).first as? CustomTabViewController {
                                    tabBar.isHidden = false
                                    selectedIndex = bucketIndex
                                    
                                    
                                    navigationItem.title = tabMenuArray[bucketIndex].caption ?? ""
                                    self.navigationController?.popToViewController(tab, animated: false)
                                    
                                }
                            } else {
                                
                                if let _ = navigationController?.viewControllers.last as? CustomTabViewController {
                                    tabBar.isHidden = false
                                    selectedIndex = 4
                                    navigationItem.title = tabMenuArray[4].caption ?? ""
                                } else if let tab = navigationController?.viewControllers.filter( { $0 is CustomTabViewController}).first as? CustomTabViewController {
                                    tabBar.isHidden = false
                                    selectedIndex = 4
                                    navigationItem.title = tab.tabMenuArray[4].caption ?? ""
                                    self.navigationController?.popToViewController(tab, animated: false)
                                }
                                if promotionType == "shoutout" {
                                    let celebyteVC = ShoutoutConfig.UserDefaultsManager.shouldShowWelcomeScreen() ? Storyboard.videoGreetings.instantiateViewController(viewController: ShoutoutWelcomeViewController.self) : Storyboard.videoGreetings.instantiateViewController(viewController: VideoGreetingsViewController.self)
                                    
                                    self.navigationController?.pushViewController(celebyteVC, animated: false)
                                } else if promotionType == "directline" {
                                    let wardrobeVC = Storyboard.main.instantiateViewController(viewController: DirectLinkViewController.self)
                                    self.navigationController?.pushViewController(wardrobeVC, animated: false)
                                } else if promotionType == "wardrobe" {
                                    let wardrobeVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobeViewController.self)
                                    self.navigationController?.pushViewController(wardrobeVC, animated: false)
                                } else if promotionType == "wallet" {
                                    let walletVC = Storyboard.main.instantiateViewController(viewController: PurchaseCoinsViewController.self)
                                    self.navigationController?.pushViewController(walletVC, animated: false)
                                } else {
                                    let resultVC = Storyboard.main.instantiateViewController(viewController: TravelingViewController.self)
                                    
                                    if let list = GlobalFunctions.returnBucketListFormBucketCode(code: promotionType) {
                                        resultVC.pageList = list
                                        resultVC.selectedIndexVal = 4
                                        resultVC.navigationTittle = list.name ?? ""
                                        resultVC.selectedBucketCode = list.code
                                        
                                        self.navigationController?.pushViewController(resultVC, animated: false)
                                    }
                                }
                            }
                        }
                    } else if let url = snaps[index].promotion_value {
                        
                        let termeAndConditionsVC = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
                        termeAndConditionsVC.navigationTitle = snaps[index].webview_label ?? ""
                        termeAndConditionsVC.openUrl = url
                        
                        self.navigationController?.pushViewController(termeAndConditionsVC, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension CustomTabViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        var height: CGFloat = 425
        
        // Increase height if Device has notch
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                height += window.safeAreaInsets.bottom
            }
        }
        
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: .dark, modalHeight: height)
    }
}

extension CustomTabViewController {
    func configureCoachMarkService() {
//        if let tabbarController = self.tabBarController as? CustomTabViewController,
//        let rightBarbutton = self.navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView {
          configureCoachMarkService(rightBarButtonView: containerView)
//        }
       
    }
}

extension CustomTabViewController {

    func configureCoachMarkService(rightBarButtonView:UIView) {
    let coachMarkText = [CoachMarkText.coinPurchase]
           coachMarkService = CoachMarkService(coachMarkTextArray: coachMarkText, coachMarkViewArray: [rightBarButtonView], fromController: self)
           coachMarkService?.startInstruction()
      
    }
}


extension CustomTabViewController {
    private func getVideoCallList() {
        if Reachability.isConnectedToNetwork(){
           // self.showLoader()
            ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getVideoCallList, extraHeader: nil) { [weak self] (result) in
                guard let `self` = self else {return}
                print(result)
                switch result {
                case .success(let data):
                    print(data)
                   // self.stopLoader()
                    //   self.list.removeAll()
                    if(data["error"] as? Bool == true){
                      //  self.stopLoader()
                        return
                    }else {
                        self.strServerTime = data["data"]["server_time"]["ist"].stringValue
                        
                        self.list.append(contentsOf: data["data"]["list"].arrayValue)
                        
                        //                    if self.list.count == 0 {
                        //                        self.lblNoTransaction.isHidden = false
                        //                        self.lblNoTransaction.text? = "No Transaction History"
                        //                        self.lblNoTransaction.adjustsFontSizeToFitWidth = true
                        //                        self.lblNoTransaction.textAlignment = NSTextAlignment.center
                        //                    }
                    }
                    DispatchQueue.main.async {
                      //  self.joinVCCollectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                   // self.stopLoader()
                }
            }
        }
    }
}


extension CustomTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        self.joinVCCollectionView?.delegate = self
        self.joinVCCollectionView?.dataSource = self
        self.joinVCCollectionView?.alwaysBounceHorizontal = true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HorizontalCollectionCell",
            for: indexPath
            ) as! HorizontalCollectionCell
        let jsonObject = self.list[indexPath.row]
       // cell.loadData(jsonObject: jsonObject, serverTime: strServerTime ?? "")
       // cell.btnJoinCall?.tag = indexPath.row
       // cell.btnJoinCall?.addTarget(self, action: #selector(clickOnJoinVideoCall(sender:)), for: .touchUpInside)
        self.videoCallRequestID = jsonObject["_id"].stringValue
        self.strNewDuration = jsonObject["duration"].stringValue
        self.strnNewCustomer = jsonObject["customer"]["name"].stringValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
    
    @objc func clickOnJoinVideoCall(sender: UIButton) {
        
        let videoCallVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallViewController.self)
        videoCallVC.videoCallreRuestIdOnAcceptedCall = videoCallRequestID
        videoCallVC.strVideoCallCoin = strVideoCallCoin
        videoCallVC.completionCallEnded = { [weak self] in
            //self?.showVideoCallFeedbackScreen(videoCallRequestID)
        }
        videoCallVC.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(videoCallVC, animated: true)
        
    }
    
}

extension CustomTabViewController: HorizontalPaginationManagerDelegate {
    
   /* private func setupPagination() {
        self.paginationManager.refreshViewColor = .clear
        self.paginationManager.loaderColor = .white
    }
    
    private func fetchItems() {
        self.paginationManager.initialLoad()
    }*/
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
        delay(2.0) {
            self.items = [1, 2, 3, 4, 5]
            self.joinVCCollectionView.reloadData()
            completion(true)
        }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        delay(2.0) {
            self.items.append(contentsOf: [6, 7, 8, 9, 10])
            self.joinVCCollectionView.reloadData()
            completion(true)
        }
    }
}


