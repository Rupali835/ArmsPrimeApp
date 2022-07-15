//
//  MenuViewController.swift
//  ZareenKhanConsumer
//
//  Created by Razr on 8/10/17.
//  Copyright (c) 2017 Razr. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import AlamofireImage
import GoogleSignIn
import FBSDKLoginKit
import MoEngage
import Branch
import Pulley

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: BaseViewController {
    
    @IBOutlet weak var profilebackgroundblureffect: UIImageView!
    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet var outerView: UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var armsView: UIView!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var reachargeLabel: UILabel!
    @IBOutlet var tblMenuOptions : UITableView!
    @IBOutlet weak var armsId: UILabel!
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var appVersionNo: UILabel!
    @IBOutlet var ivProfileImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    //    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    //  @IBOutlet weak var editView: UIView!
    @IBOutlet var editButton : UIButton!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var daysLabelWidth: NSLayoutConstraint!
    //    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblVersionNo: UILabel!
    @IBOutlet var viwForBg: UIView!
    
    @IBOutlet weak var poweredByLabel: UILabel!
    @IBOutlet weak var coinView: UIView!
    @IBOutlet weak var nameView: UIView!
    var arrayMenuOptions = [Dictionary<String,String>]()
    private var overlayView = LoadingOverlay.shared
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    var arrTitle: NSMutableArray = ["HOME","LOGIN", "MY SOCIAL LIFE","PHOTO DIARY","MY WORK","TRAVEL DIARY","MY SHOWS","TOP FAN","MONSTER"]
    var arrTitleIcon: [String] = ["airplane", "woman", "fan-1","logout"]
    var arrViewCtrl: NSMutableArray = ["HomeCollectionViewController","LoginViewController","SocialLifeCollectionViewController","PhotoDiaryCollectionViewController","MyWorkCollectionViewController","TravelDiaryCollectionViewController","MyShowCollectionViewController","TopFanCollectionViewController","MonsterCollectionViewController"]
    var arrData : [Any]! = [Any]()
    var bucketsArray : [List] = [List]()
    var codeArr = [String]()
    var captionArray = [String]()
    var isLoggedIn = false
    var last_updated_buckets = ""
    var exmpleForSomeoneElseView : UIView!
    var DyanamicMenuArr : [String]!
    var DyanamicCustomArr: [String]!
    var downloadImageArr = [downloadeImages]()
    
    @IBOutlet weak var accountBalHeaderLabel: UILabel!
    var isVGCellExpanded: Bool = false
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInView: UIView!
    //MARK:-
    override func viewDidLoad() {
        print(#function)
         self.hideRightBarButtons = true
        super.viewDidLoad()
        outerView.layer.cornerRadius = 2
        if let armsId = CustomerDetails.email, armsId != "" {
            self.armsId.text = "Armsprime id: \(armsId) "
        } else {
            armsId.text = nil
        }
        reachargeLabel.font = UIFont(name: AppFont.light.rawValue, size: 18.0)
        tblMenuOptions.registerNib(withCell: VGMenuTableViewCell.self)
        //        self.walletView.layer.cornerRadius = walletView.frame.size.width / 2
        //        self.walletView.layer.masksToBounds = false
        //        self.walletView.clipsToBounds = true
        
        self.navigationController?.isNavigationBarHidden = true
        
        //        self.navigationItem.title = "Anveshi Jain"
        //        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.white]
//        self.setNavigationView(title: Constants.celebrityName.uppercased())
        //        viwForBg.setGradientBackground()
        //        editButton.isHidden = false
        nameView.layer.cornerRadius = 4
        coinView.layer.cornerRadius = 4
        //        walletView.isHidden = false
        //        walletLabel.isHidden = false
        
        //        self.walletView.layer.cornerRadius = walletView.frame.size.width / 2
        //        self.walletView.layer.borderWidth = 1
        //        self.walletView.layer.borderColor = UIColor.white.cgColor
        //        self.walletView.layer.masksToBounds = false
        //        self.walletView.clipsToBounds = true
        //
        //        self.armsView.layer.cornerRadius = armsView.frame.size.width / 2
        //        self.armsView.layer.borderWidth = 1
        //        self.armsView.layer.borderColor = UIColor.white.cgColor
        //        self.armsView.layer.masksToBounds = false
        //        self.armsView.clipsToBounds = true
        self.tabBarController?.tabBar.isHidden = false
        
        userName.isUserInteractionEnabled = false
        arrData.removeAll()
        //         self.getData()
        tblMenuOptions.tableFooterView = UIView()
        if let lastSeen = ArtistConfiguration.sharedInstance().date_diff_for_human {
            self.daysLabel.text =  "\(Constants.celebrityName) Last Seen: \(lastSeen) "
        }
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.lblVersionNo.text = "App version \(version)"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCoins(_:)), name: NSNotification.Name(rawValue: "updatedCoins"), object: nil)
        
        ivProfileImage.layer.cornerRadius = self.ivProfileImage.frame.size.width / 2
        ivProfileImage.layer.masksToBounds = false
        ivProfileImage.clipsToBounds = true
        ivProfileImage.layer.borderColor = UIColor.white.cgColor
        ivProfileImage.layer.borderWidth = 1
        
        userName.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        armsId.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        accountBalHeaderLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        walletBalanceLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        daysLabel.font = UIFont(name: AppFont.light.rawValue, size: 13.0)
        lblVersionNo.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        //        nameView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
        //        coinView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
        
//        MoEngage.sharedInstance().handleInAppMessage()
//        MoEngage.sharedInstance().delegate = self
        signInButton.layer.cornerRadius = 25
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.titleLabel?.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        signInButton.titleLabel?.textColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

//        self.addBackButton()

    }

    @objc func btnBackClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        print(#function)
        print("viewWillAppear login status = \(UserDefaults.standard.object(forKey: "LoginSession") ?? "default")")
        super.viewWillAppear(animated)
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Home_Menu", extraParamDict: nil)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
//        self.setNavigationView(title: Constants.celebrityName.uppercased())
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        if (FileManager.default.fileExists(atPath: writePath)) {
            //self.bucketsArray = database.getBucketListing()
//            self.bucketsArray = [List]()
            GlobalFunctions.showBucketArrayContent(arr: bucketsArray)
            print("db path found =>\(bucketsArray.count)")
            //            printBucketDetails(arr: bucketsArray)
            if (self.bucketsArray != nil && self.bucketsArray.count > 0) {
                
                for list in self.bucketsArray{
                    BucketValues.bucketTitleArr.append(list.caption ?? "")
                    BucketValues.bucketIdArray.append(list._id ?? "")
                }
                
                //                self.displayLayout()
                checkLastUpdatedBuckets()
                
            } else {
                print("bucket array nil")
                self.getData()
               // self.displayLayout()
            }
            
        } else {
            
            self.getData()
        }
        
        self.updateProfileInfo()
        self.tabBarController?.tabBar.isHidden = false
        self.getUserDetails { (result) in
            if result {
                self.updateProfileInfo()
            }
        }
        self.artistData()
        viwForBg.backgroundColor = BlackThemeColor.lightBlack
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationItem.title = ""
    }
    
    @objc func updateCoins(_ notification: NSNotification) {
        print(#function)
        if let coins = notification.userInfo?["updatedCoins"] as? Int {
            self.walletBalanceLabel.text = "\(coins)"
            CustomerDetails.coins = coins
            let database = DatabaseManager.sharedInstance
            database.updateCustomerCoins(coinsValue: coins)
            checkMobileVerification()
        }
    }

    @IBAction func rechargeWallet(sender: UIControl) {
       if !self.checkIsUserLoggedIn() {
           
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                   self.pushAnimation()
                   self.navigationController?.pushViewController(controller, animated: true)
            return
        }else{
        let purchaseController = Storyboard.main.instantiateViewController(viewController: PurchaseCoinsViewController.self)
        purchaseController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(purchaseController, animated: true)
        }
    }
    
    func printBucketDetails(arr: [List]) {
        var i: Int = 0
        for item in arr {
            print("[\(i)] code \(item.code) tittle \(item.caption) id \(item._id)")
            i = i + 1
        }
    }
    
    //MARK:- All button Action
    
    @IBAction func profileButtonAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    @IBAction func ArmsPrimeLinkButton(_ sender: UIButton) {
        print(#function)
        if Reachability.isConnectedToNetwork() {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ArmsPrimeWebViewController") as! ArmsPrimeWebViewController
            
            self.navigationController?.pushViewController(resultViewController, animated: true)
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    @IBAction func walletButton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
        
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    @IBAction func coinsInfo(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoinsInformationViewController") as! CoinsInformationViewController
        
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.exmpleForSomeoneElseView = popOverVC.view
        self.exmpleForSomeoneElseView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:self.view.frame.size.height)
        self.view.addSubview(self.exmpleForSomeoneElseView)
        popOverVC.didMove(toParent: self)
        
    }
    @IBAction func loginButtonClick(_ button:UIButton!) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.pushAnimation()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func historyButtonClicked(_ sender: Any) {
        if !self.checkIsUserLoggedIn() {
            self.dismiss(animated: true, completion: nil)
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                   self.pushAnimation()
                   self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        let myGreetings = Storyboard.videoGreetings.instantiateViewController(viewController: TransactionsViewController.self)
        navigationController?.pushViewController(myGreetings, animated: true)
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
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func GetImage(list: List)
    {
         let lcImageURL = list.photo?.cover
        guard let url = URL(string: lcImageURL!) else { return  }
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
                
               // self.imageArr.append(resizedImage!)
                let lcdownloadImage = downloadeImages(image: resizedImage!, id: list.ordering!, name: "", tabList: list)
                self.downloadImageArr.append(lcdownloadImage)
                
                if self.downloadImageArr.count == self.DyanamicMenuArr.count
                {
                    self.downloadImageArr = self.downloadImageArr.sorted(by: { $0.order_id! < $1.order_id! })
                    
                    for name in self.DyanamicCustomArr
                    {
                        let imageName = "\(name)_menu"
                        
                        if let image = UIImage(named: imageName)  {
                            //self.imageArr.insert(image, at: self.imageArr.count)
                          
                            let lcdownloadImage = downloadeImages(image: image, id: list.ordering!, name: "", tabList: list)
                            
                            self.downloadImageArr.insert(lcdownloadImage, at: self.downloadImageArr.count)
                            
                        }
                         
                    }
                    
                    DispatchQueue.main.async {
                        self.tblMenuOptions.reloadData()
                    }
                    
                }
            }
        }
        
        task.resume()
    }
    
    func getData() {
        print(#function)
        if Reachability.isConnectedToNetwork() == true{
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.HOME_SCREEN_DATA + Constants.artistId_platform, extraHeader: nil, closure: { (result) in
                switch result {
                case .success(let data):
                    self.refreshControl.endRefreshing()
                    if (data["error"] as? Bool == true) {
                        self.showToast(message: "Something went wrong. Please try again!")
                        return
                        
                    } else {
                        self.buckets = [List]()
                        if (data != nil) {
                            if  let arrayList = data["data"]["list"].arrayObject
                            {
                                self.bucketsArray.removeAll(keepingCapacity: false)
                                BucketValues.bucketIdArray.removeAll(keepingCapacity: false)
                                BucketValues.bucketIdArray.removeAll(keepingCapacity: false)
                                
                                for dict in arrayList {
                                    
                                    if let list: List = List.init(dictionary: dict as! NSDictionary) {
                                        self.buckets.append(list)
                                        self.bucketsArray.append(list)
                                        BucketValues.bucketIdArray.append(list._id ?? "")
                                        BucketValues.bucketTitleArr.append(list.caption ?? "")
                                    }
                                }
                                
                                if (data["data"]["list"].arrayObject != nil) {
                                    BucketValues.bucketContentArr = NSMutableArray(array: data["data"]["list"].arrayObject!)
                                }
                                
//                                self.arrData = Array(arrayList)
//                                let database = DatabaseManager.sharedInstance
//                                self.addBucketListingToDatabase(bucketArray: self.buckets)
//                                self.bucketsArray = database.getBucketListing()
//                                GlobalFunctions.showBucketArrayContent(arr: self.bucketsArray)
                                self.displayLayout()
                                
                                print("data =>\(data)")
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.refreshControl.endRefreshing()
                }
                
            })
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    func checkLastUpdatedBuckets() {
        print(#function)
        let usersName = UserDefaults.standard.value(forKey: "username") as? String
        print("last updated \(usersName)")
        let lastDate = artistConfig.last_updated_buckets
        print("updated \(lastDate)")
        
        //        if (lastDate == usersName) {
        self.displayLayout()
    }
    func addBucketListingToDatabase() {
        print(#function)
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
     //   if (database != nil) {
            database.createStatsTable()
            database.createBucketListTable()
            database.addBucketColum()
    //    }
        
        for list in self.bucketsArray {
            database.insertIntoBucketListTable(list: list)
        }
    }
    
    func displayLayout()
    {
        print(#function)
        if self.bucketsArray.count > 0
        {
            
            
            var titleArr = [String]()
            var codeArray = [String]()
            DyanamicMenuArr = [String]()
           DyanamicCustomArr = [String]()
            
            let iconArray: NSMutableArray = NSMutableArray()
            
            for i in 0...self.bucketsArray.count - 1
            {
                //                let dict = arrData[i] as! NSMutableDictionary
                //                let photoDict = dict["photo"] as! NSMutableDictionary
                //                if let converImage = photoDict["cover"] as? String {
                //                    iconArray.add(converImage)
                //                }"
                let list : List = self.bucketsArray[i]
                titleArr.append((list.name?.uppercased())!)
                codeArray.append(list.code?.lowercased() ?? "")
                //                titleArr.append((dict["caption"] as! String).uppercased())
            }
            
            //            titleArr = Array(titleArr.dropFirst(3))
            
            var indexesToRemove: [Int] = []
            for index in 0..<AppConstants.numberOfBucketItemsInTab {
                    indexesToRemove.append(index)
            }
            
            var isWardrobePresent = false
            if codeArray.contains("wardrobe") {
                isWardrobePresent = true
            }
            
            codeArray = codeArray
                .enumerated()
                .filter { !indexesToRemove.contains($0.offset) }
                .map { $0.element }
            
            titleArr = titleArr
                .enumerated()
                .filter { !indexesToRemove.contains($0.offset) }
                .map { $0.element }
            
            print(titleArr)
            
            DyanamicMenuArr = titleArr
            DyanamicMenuArr = DyanamicMenuArr.filter {
                $0 != "STORY"
            }
            
            
            if UserDefaults.standard.object(forKey: "LoginSession") == nil  ||  UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionOut" || UserDefaults.standard.value(forKey: "LoginSession") as! String == "LoginSession"  {
                print("Display layout user not logged in")
                isLoggedIn = false
                
                iconArray.insert("wallet", at: iconArray.count)
                titleArr.insert("WALLET", at: titleArr.count)
                codeArray.append("wallet")
                DyanamicCustomArr.append("wallet")
                BucketValues.bucketTitleArr.insert("WALLET", at:  BucketValues.bucketTitleArr.count)
                BucketValues.CodeArr.insert("wallet", at:  BucketValues.CodeArr.count)
                
                if RemoteConfigValues.isReferralEnableIos {
                    iconArray.insert("inviteFrnd", at: iconArray.count)
                    titleArr.insert("INVITE A FRIEND", at: titleArr.count)
                    codeArray.append("inviteAFrnd")
                    DyanamicCustomArr.append("inviteAFrnd")
                    BucketValues.bucketTitleArr.insert("INVITE A FRIEND", at:  BucketValues.bucketTitleArr.count)
                    BucketValues.CodeArr.insert("inviteAFrnd", at: BucketValues.CodeArr.count)
                }


                // SHRIRAM



                
                iconArray.insert("helpandsupport", at: iconArray.count)
                //                titleArr.insert("HELP & SUPPORT", at: titleArr.count)
                codeArray.append("helpandsupport")
                titleArr.insert("SETTINGS", at: titleArr.count)
                //                BucketValues.bucketTitleArr.insert("HELP & SUPPORT", at:  BucketValues.bucketTitleArr.count)
                BucketValues.bucketTitleArr.insert("SETTINGS", at:  BucketValues.bucketTitleArr.count)
                BucketValues.CodeArr.insert("helpandsupport", at: BucketValues.CodeArr.count)
                DyanamicCustomArr.append("helpandsupport")
                //new change sayali
                
                //  BucketValues.CodeArr.insert("login", at: 0)
            } else {
                print("Display layout user logged in")
                iconArray.insert("profile", at: iconArray.count)
                titleArr.insert("MY PROFILE", at: titleArr.count)
                codeArray.append("profile")
                DyanamicCustomArr.append("profile")
                BucketValues.bucketTitleArr.insert("MY PROFILE", at:  BucketValues.bucketTitleArr.count)
                BucketValues.CodeArr.insert("profile", at:  BucketValues.CodeArr.count)
                
                iconArray.insert("wallet", at: iconArray.count)
                titleArr.insert("WALLET", at: titleArr.count)
                codeArray.append("wallet")
                DyanamicCustomArr.append("wallet")
                BucketValues.bucketTitleArr.insert("WALLET", at:  BucketValues.bucketTitleArr.count)
                BucketValues.CodeArr.insert("wallet", at:  BucketValues.CodeArr.count)
                print("isWardrobePresent : \(isWardrobePresent)")
                if isWardrobePresent {
                    iconArray.insert("myorders", at: iconArray.count)
                    titleArr.insert("MY ORDERS", at: titleArr.count)
                    codeArray.append("myorders")
                    DyanamicCustomArr.append("myorders")
                    BucketValues.bucketTitleArr.insert("MY ORDERS", at:  BucketValues.bucketTitleArr.count)
                    BucketValues.CodeArr.insert("myorders", at:  BucketValues.CodeArr.count)
                }

                if RemoteConfigValues.isGameZoneEnable {
                                       iconArray.insert("gamezone", at: iconArray.count)
                                       titleArr.insert("GAMEZONE", at: titleArr.count)
                                       codeArray.append("gamezone")
                                       BucketValues.bucketTitleArr.insert("GAMEZONE", at:  BucketValues.bucketTitleArr.count)
                                       BucketValues.CodeArr.insert("gamezone", at: BucketValues.CodeArr.count)
                               }
                /*
                iconArray.insert("videocall", at: iconArray.count)
                //                titleArr.insert("HELP & SUPPORT", at: titleArr.count)
                titleArr.insert("VIDEOCALL", at: titleArr.count)
                codeArray.append("videocall")
                //                BucketValues.bucketTitleArr.insert("HELP & SUPPORT", at:  BucketValues.bucketTitleArr.count)
                BucketValues.bucketTitleArr.insert("VIDEOCALL", at:  BucketValues.bucketTitleArr.count)
                BucketValues.CodeArr.insert("videocall", at: BucketValues.CodeArr.count)
                
                isLoggedIn = true
               */
                
                if RemoteConfigValues.isReferralEnableIos {
                    iconArray.insert("inviteFrnd", at: iconArray.count)
                    titleArr.insert("INVITE A FRIEND", at: titleArr.count)
                    codeArray.append("inviteAFrnd")
                    DyanamicCustomArr.append("inviteAFrnd")
                    BucketValues.bucketTitleArr.insert("INVITE A FRIEND", at:  BucketValues.bucketTitleArr.count)
                    BucketValues.CodeArr.insert("inviteAFrnd", at: BucketValues.CodeArr.count)
                }
                

                
                iconArray.insert("helpandsupport", at: iconArray.count)
                //                titleArr.insert("HELP & SUPPORT", at: titleArr.count)
                titleArr.insert("SETTINGS", at: titleArr.count)
                codeArray.append("helpandsupport")
                DyanamicCustomArr.append("helpandsupport")
                //                BucketValues.bucketTitleArr.insert("HELP & SUPPORT", at:  BucketValues.bucketTitleArr.count)
                BucketValues.bucketTitleArr.insert("SETTINGS", at:  BucketValues.bucketTitleArr.count)
                BucketValues.CodeArr.insert("helpandsupport", at: BucketValues.CodeArr.count)
                
                isLoggedIn = true
            }
            if RCValues.sharedInstance.bool(forKey: .isWebEnabled) == true {
                
                titleArr.insert(RCValues.sharedInstance.string(forKey: .web_label), at: titleArr.count-1)
            }
            
            BucketValues.titleImageArray = iconArray as! [String]
            //            let content : List = bucketsArray as? List
            
            BucketValues.bucketTitleArr = titleArr
            BucketValues.CodeArr = codeArr
            self.captionArray = titleArr
            BucketValues.CodeArr = codeArray
            //init(bucketTittleArr: titleArr)
            
            if DyanamicMenuArr.count > 0
            {
                for name in DyanamicMenuArr
                {
                    
                    let lcBucketObj = bucketsArray.filter { $0.name?.lowercased() == name.lowercased() }
                    
                    print("Obj= \(lcBucketObj[0].photo?.cover)")
                    
                    if let lcImageURL = lcBucketObj[0].photo?.cover
                    {
                        GetImage(list : lcBucketObj[0])
                    }
                }
                
            }else{
                for (index,name) in self.DyanamicCustomArr.enumerated()
                {
                    
                    let imageName = "\(name)_menu"
                    
                    if let image = UIImage(named: imageName)  {
                        //self.imageArr.insert(image, at: self.imageArr.count)
                      
                        let lcdownloadImage = downloadeImages(image: image, id: index , name: "", tabList: self.bucketsArray.first!)
                        
                        self.downloadImageArr.insert(lcdownloadImage, at: self.downloadImageArr.count)
                        
                    }
                     
                }
              
                DispatchQueue.main.async {
                    self.tblMenuOptions.reloadData()
                }
            }
           
            BucketValues.bucketTitleArr = BucketValues.bucketTitleArr.filter {
                $0 != "STORY"
            }
           
        } else {
            print("display layout bucketsArray array nil")
            var titleArr = [String]()
            var codeArr = [String]()
            
            let iconArray: NSMutableArray = NSMutableArray()
            if UserDefaults.standard.object(forKey: "LoginSession") == nil  ||  UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionOut" || UserDefaults.standard.value(forKey: "LoginSession") as! String == "LoginSession"  {
                print("Display layout user not logged in  bucketsArray array nil")
                isLoggedIn = false

            } else {
                print("Display layout user logged in  bucketsArray array nil")
                if findArrayIndexOfItem(title: "LOGIN") != -1 {
                    BucketValues.bucketTitleArr.remove(at: findArrayIndexOfItem(title: "LOGIN"))
                }
                
                
                if findArrayIndexOfItem(title: "MY PROFILE") == -1 {
                    iconArray.insert("profile", at: iconArray.count)
                    titleArr.insert("PROFILE", at: titleArr.count)
                    codeArr.append("profile")
                    BucketValues.bucketTitleArr.insert("MY PROFILE", at:  BucketValues.bucketTitleArr.count)
                    BucketValues.CodeArr.insert("profile", at:  BucketValues.CodeArr.count)
                }
                
                if findArrayIndexOfItem(title: "WALLET") == -1 {
                    iconArray.insert("wallet", at: iconArray.count)
                    titleArr.insert("WALLET", at: titleArr.count)
                    codeArr.append("wallet")
                    BucketValues.bucketTitleArr.insert("WALLET", at:  BucketValues.bucketTitleArr.count)
                    BucketValues.CodeArr.insert("wallet", at:  BucketValues.CodeArr.count)
                    
                }
                
                if findArrayIndexOfItem(title: "INVITE A FRIEND") == -1 {
                    if RemoteConfigValues.isReferralEnableIos {
                        iconArray.insert("inviteFrnd", at: iconArray.count)
                        titleArr.insert("INVITE A FRIEND", at: titleArr.count)
                        codeArr.append("inviteAFrnd")
                        BucketValues.bucketTitleArr.insert("INVITE A FRIEND", at:  BucketValues.bucketTitleArr.count)
                        BucketValues.CodeArr.insert("inviteAFrnd", at: BucketValues.CodeArr.count)
                    }
                }
                //   SHRIRAm
                
                if findArrayIndexOfItem(title: "GAMEZONE") == -1 {
                    iconArray.insert("gamezone", at: iconArray.count)
                    titleArr.insert("GAMEZONE", at: titleArr.count)
                    codeArr.append("gamezone")
                    BucketValues.bucketTitleArr.insert("GAMEZONE", at:  BucketValues.bucketTitleArr.count)
                    BucketValues.CodeArr.insert("gamezone", at:  BucketValues.CodeArr.count)
                    
                }
                
                if findArrayIndexOfItem(title: "SETTINGS") == -1 {
                    iconArray.insert("helpandsupport", at: iconArray.count)
                    titleArr.insert("SETTINGS", at: titleArr.count)
                    codeArr.append("helpandsupport")
                    BucketValues.bucketTitleArr.insert("SETTINGS", at:  BucketValues.bucketTitleArr.count)
                    BucketValues.CodeArr.insert("helpandsupport", at: BucketValues.CodeArr.count)
                }
                
                
               /* if findArrayIndexOfItem(title: "VIDEOCALL") == -1 {
                    iconArray.insert("videocall", at: iconArray.count)
                    titleArr.insert("VIDEOCALL", at: titleArr.count)
                    codeArr.append("videocall")
                    BucketValues.bucketTitleArr.insert("VIDEOCALL", at:  BucketValues.bucketTitleArr.count)
                    BucketValues.CodeArr.insert("videocall", at:  BucketValues.CodeArr.count)
                    
                }*/
                
                isLoggedIn = true

            }
            
            BucketValues.CodeArr = codeArr
            
            if DyanamicMenuArr.count > 0
            {
                for name in DyanamicMenuArr
                {
                    
                    let lcBucketObj = bucketsArray.filter { $0.name?.lowercased() == name.lowercased() }
                    
                    print("Obj= \(lcBucketObj[0].photo?.cover)")
                    
                    if let lcImageURL = lcBucketObj[0].photo?.cover
                    {
                        GetImage(list : lcBucketObj[0])
                    }
                }
                
            }else{
                for (index,name) in self.DyanamicCustomArr.enumerated()
                {
                    
                    let imageName = "\(name)_menu"
                    
                    if let image = UIImage(named: imageName)  {
                        //self.imageArr.insert(image, at: self.imageArr.count)
                      
                        let lcdownloadImage = downloadeImages(image: image, id: index , name: "", tabList: self.bucketsArray.first!)
                        
                        self.downloadImageArr.insert(lcdownloadImage, at: self.downloadImageArr.count)
                        
                    }
                     
                }
              
                DispatchQueue.main.async {
                    self.tblMenuOptions.reloadData()
                }
            }
           
            BucketValues.bucketTitleArr = BucketValues.bucketTitleArr.filter {
                $0 != "STORY"
            }
           
        }
        
        
        
        print("BucketValues.CodeArr = \(BucketValues.CodeArr.description)")
        print("BucketValues.bucketTitleArr = \(BucketValues.bucketTitleArr.description)")
    }
    
    func findArrayIndexOfItem(title: String) -> Int{
        print("check the value \(BucketValues.bucketTitleArr)")
        let itemIndex = BucketValues.bucketTitleArr.index(of: title) ?? -1
        print("check the index \(itemIndex)")
        return itemIndex
    }
    func updateProfileInfo()
    {
        print(#function)
        self.ivProfileImage.layer.cornerRadius = ivProfileImage.frame.size.width / 2
        self.ivProfileImage.layer.masksToBounds = false
        self.ivProfileImage.clipsToBounds = true
        self.ivProfileImage.backgroundColor = UIColor.white
        self.ivProfileImage.image = UIImage(named: "profileph")
        self.nameView.isHidden = false
        self.signInView.isHidden = true
        
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil)
        {
            print("loginsession is not nil")
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn")
            {
            
                if Constants.TOKEN != nil
                {
                    
                    if CustomerDetails.firstName != nil && CustomerDetails.firstName != ""
                    {
                        if CustomerDetails.lastName != nil  && CustomerDetails.lastName != "" {
                            self.userName.text = CustomerDetails.firstName! + " " + CustomerDetails.lastName
                        } else {
                            self.userName.text = CustomerDetails.firstName!
                            
                        }
                    }else{
                        self.userName.text = "SUPERFAN"
                    }
                    
                    if let email = CustomerDetails.email {
                        if email != "" {
                            self.userName.text = email.components(separatedBy: "@")[0] as? String
                        }
                    }
                    
                    if CustomerDetails.picture != nil
                    {
                        self.ivProfileImage.sd_imageIndicator?.startAnimatingIndicator()
                        self.ivProfileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.ivProfileImage.sd_imageTransition = .fade
                        self.ivProfileImage.sd_setImage(with: URL(string:CustomerDetails.picture), placeholderImage: UIImage(named: "profileph"), options: .refreshCached, context: nil)
                        
                    }
                    if let coins = CustomerDetails.coins as? Int {
                        self.walletBalanceLabel.text = "\(coins)"
                    }
                    
                    
                }else{
                    
                    self.nameView.isHidden = true
                    self.signInView.isHidden = false
                }
                
                
            }else
            {
                self.nameView.isHidden = true
                self.signInView.isHidden = false
            }
            
        }else{
            self.nameView.isHidden = true
            self.signInView.isHidden = false
        }
        
    }
    
    public func toast(message: String, duration: Double) {
        let toast: UIAlertView = UIAlertView.init(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
        toast.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toast.dismiss(withClickedButtonIndex: 0, animated: true)
        }
    }
    
    @IBAction func didTapSignInButton(_ sender: Any) {
        let resultViewController = Storyboard.main.instantiateViewController(viewController: LoginViewController.self)
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
}
//MARK:- UITextFieldDelegate
extension MenuViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userName
        {
            if string == ""
            {
                return true
            }
            if (userName.text?.utf16.count)! > 15
            {
                return false
            }
        }
        return true
    }
}
//MARK:- UITableViewDataSource
extension MenuViewController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BucketValues.bucketTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (BucketValues.CodeArr.count == 0 || indexPath.row >= BucketValues.CodeArr.count) ? 45.0 : (BucketValues.CodeArr[indexPath.row].lowercased() == ShoutoutConstants.shoutoutBucketCode.lowercased() ? (isVGCellExpanded ? 120.0 : 45.0) : 45)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tblMenuOptions.dequeueReusableCell(withIdentifier: "SlideBarCell") as! SlideBarTableViewCell
        
        if BucketValues.bucketTitleArr.count > 0
        {
            let menuTitle = BucketValues.bucketTitleArr[indexPath.row]
            
            if self.downloadImageArr.count > 0
            {
                //cell.iconImage.image = self.imageArr[indexPath.row]
                let lcDownloadImage = self.downloadImageArr[indexPath.row]
                cell.iconImage.image = lcDownloadImage.image
            }
            
            cell.iconNameLabel.text = menuTitle
        }
        
        return cell
    }
}
//MARK:- UITableViewDelegate
extension MenuViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = BucketValues.bucketTitleArr[indexPath.row] as? String
        print("selected menu => \(String(describing:title!))")
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Menu_on_\(title!)", extraParamDict: nil)
        if BucketValues.bucketTitleArr.count > 0 {
//            if BucketValues.CodeArr[indexPath.row].lowercased() == ShoutoutConstants.shoutoutBucketCode.lowercased() {
//                return
//            }
            if  UserDefaults.standard.object(forKey: "LoginSession") == nil || UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionOut" || UserDefaults.standard.value(forKey: "LoginSession") as! String == "LoginSession"  {
                if  String(title!) == String("LOGIN")  {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if #available(iOS 11.0, *) {
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    }
                } else if String(title!) == String("MY PROFILE") {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                    self.navigationController?.pushViewController(resultViewController, animated: true)
                }
                else if String(title!) == String("SETTINGS") {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let resultViewController = storyBoard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                    self.navigationController?.pushViewController(resultViewController, animated: true)
                } else if let code = (BucketValues.CodeArr[indexPath.row] as? String) {
                    print("selected menu =>  code \(code)")
                    if code == "ask" && code != ""{
                        let resultViewController = Storyboard.main.instantiateViewController(viewController: AskViewController.self)
                        if let list = GlobalFunctions.returnBucketListFormBucketCode(code: code) {
                            resultViewController.pageList = list
                            resultViewController.selectedIndexVal = indexPath.row+3
                            resultViewController.navigationTittle = list.name ?? ""
                            resultViewController.selectedBucketCode = list.code
                        }; self.navigationController?.pushViewController(resultViewController, animated: true)
                    }  else if code == "home" && code != ""{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    }
                    else if code == "directline" && code != ""{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "DirectLinkViewController") as! DirectLinkViewController
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    }else if code == "private-video-call" && code != ""{
                          
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

                                self.navigationController?.pushViewController(pulleyController, animated: true)
                    } else if code == "wardrobe" && code != ""{

                        let headerPlayerController = Storyboard.wardrobe.instantiateViewController(viewController: HeaderVideoPlayerViewController.self)
                        headerPlayerController.playerSate = .fromWadrable

                        let wardrobeVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobeViewController.self)
                        wardrobeVC.stateChangeClouser = { state in
                            headerPlayerController.changeSoundStatus(with: state)
                        }

                        let pulleyController = PulleyViewController(contentViewController: headerPlayerController, drawerViewController: wardrobeVC)
                        pulleyController.drawerCornerRadius = 20
                        self.navigationController?.pushViewController(pulleyController, animated: true)
                    }
                    else if code == ShoutoutConstants.shoutoutBucketCode && code != ""{
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
                         self.navigationController?.pushViewController(pulleyController, animated: true)

                    }
                    else if code == "myorders" && code != ""{
                        let wardrobeOrderVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobeOrderViewController.self)
                        self.navigationController?.pushViewController(wardrobeOrderVC, animated: true)
                    } else if code == "top-fans" && code != ""{
                        let resultViewController = Storyboard.main.instantiateViewController(viewController: MyFavoriteFansViewController.self)
                        resultViewController.selectedIndexVal = indexPath.row+3
                        resultViewController.navigationTittle = title ?? ""
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    }
                    else if (code == "social-life" || code == "travel") && code != "" {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "TravelingViewController") as! TravelingViewController
                        
                        if let list = GlobalFunctions.returnBucketListFormBucketCode(code: code) {
                            resultViewController.pageList = list
                            resultViewController.selectedIndexVal = indexPath.row+3
                            resultViewController.navigationTittle = list.name ?? ""
                            resultViewController.selectedBucketCode = list.code
                        }
                        
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    } else {
//                        self.dismiss(animated: true) {
//
//                        }
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                    let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                        //                            self.pushAnimation()
                                                    self.navigationController?.pushViewController(controller, animated: true)

                    }
                } else {
//                    self.dismiss(animated: true) {
//
//                     }
                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                             let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    //                         self.pushAnimation()
                                             self.navigationController?.pushViewController(controller, animated: true)
                }
                return
            } else if  let name = BucketValues.bucketTitleArr[indexPath.row] as? String {
                DispatchQueue.main.async {
                    
                    if name.contains("LOGIN")  {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        if #available(iOS 11.0, *) {
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            self.navigationController?.pushViewController(resultViewController, animated: true)
                            return
                        }
                    }
                    if name.contains("LOGOUT") {
                        let alert = UIAlertController(title: "", message: "Are you sure want to Logout?", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "Log out", style: .destructive) { action in
                            CustomMoEngage.shared.sendEventDialog("Are you sure want to Logout?", "Log out", nil)
                            UserDefaults.standard.set("LoginSessionOut", forKey: "LoginSession")
                            UserDefaults.standard.synchronize()
                            Constants.TOKEN = ""
                            CustomerDetails.custId = ""
                            CustomerDetails.account_link = [:]
                            CustomerDetails.badges = ""
                            CustomerDetails.coins = 0
                            CustomerDetails.email = ""
                            CustomerDetails.firstName = ""
                            CustomerDetails.lastName = ""
                            CustomerDetails.token = ""
                            CustomerDetails.picture = ""
                            CustomerDetails.gender = ""
                            CustomerDetails.mobileNumber = ""
                            CustomerDetails.mobile_verified = false
                            UserDefaults.standard.set(false, forKey: "mobile_verified")
                            UserDefaults.standard.synchronize()
                            //                menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                            //                            UserDefaults.standard.set(nil, forKey: "kKeyImage")
                            GIDSignIn.sharedInstance().signOut()
                            AccessToken.current = nil
                            Profile.current = nil
                            LoginManager().logOut()
                            //                            self.walletBalanceLabel.text = "0"
                            let database = DatabaseManager.sharedInstance
                            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                            let writePath = documents + "/ConsumerDatabase.sqlite"
                            database.dbPath = writePath
                            database.deleteAllData()
                            //                            self.displayLayout()
                            
                            _ = self.getOfflineUserData()
                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.logOut, action: "Log Out", status: "Success", reason: "", extraParamDict: nil)
                            CustomMoEngage.shared.resetMoUserInfo()
                            Branch.getInstance().logout()
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            if #available(iOS 11.0, *) {
                                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                //                    self.toast(message: "successfully logged out", duration: 5)
                                self.pushAnimation()
                                self.navigationController?.pushViewController(resultViewController, animated: false)
                            } else {
                                // Fallback on earlier versions
                            }
                            
                        })
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                            CustomMoEngage.shared.sendEventDialog("Are you sure want to Logout?", "Cancel", nil)
                        })
                        
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            if let popoverController = alert.popoverPresentationController {
                                popoverController.sourceView = self.view
                                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                                popoverController.permittedArrowDirections = []
                            }
                        }
                        self.present(alert, animated: true, completion: nil)
                    } else if name.contains(RCValues.sharedInstance.string(forKey: .web_label)) {
                        if RCValues.sharedInstance.bool(forKey: .isWebEnabled) == true {
                            if  let name = BucketValues.bucketTitleArr[indexPath.row] as? String {
                                DispatchQueue.main.async {
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                                    resultViewController.navigationTitle = name
                                    resultViewController.openUrl = RCValues.sharedInstance.string(forKey: .web_url)
                                    self.navigationController?.pushViewController(resultViewController, animated: true)
                                }  }  }
                    } else if name.contains("PROFILE") {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    } else if name.contains("WALLET") {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    } else if name.contains("HELP & SUPPORT") {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    }
                    else if String(title!) == String("SETTINGS") {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    } else if String(title!) == String("MY ORDERS") {
                        let wardrobeOrderVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobeOrderViewController.self)
                        self.navigationController?.pushViewController(wardrobeOrderVC, animated: true)
                    } else if String(title!) == String("INVITE A FRIEND") {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    }
                        else if String(title!) == String("GAMEZONE") {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "GamesViewController") as! GamesViewController
                            self.navigationController?.pushViewController(resultViewController, animated: true)
                        }
                        
                        else if String(title!) == String("VIDEOCALL") {
                            let videoCallVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallViewController.self)
        //                           videoCallVC.videoCallreRuestIdOnAcceptedCall = videoCallRequestID
        //                        videoCallVC.strVideoCallCoin = strVideoCallCoin
        //                        videoCallVC.videoCallLink = self.hyperlink ?? ""
        //                        print("video call link = \(self.hyperlink ?? "")")
                                videoCallVC.completionCallEnded = { [weak self] in
                                   
                                       //self?.showVideoCallFeedbackScreen(videoCallRequestID)
                                   }
                                   videoCallVC.hidesBottomBarWhenPushed = false
                                   self.navigationController?.pushViewController(videoCallVC, animated: true)
                        }
                        
                   
                    
                        
                        
                    
                    
                    else if let code = (BucketValues.CodeArr[indexPath.row] as? String) {
                        print("selected menu =>  code \(code)")
                    
                        
                        if code == "music" && code != ""{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "PodcastViewController") as! PodcastViewController
                            resultViewController.selectedIndexVal = indexPath.row+3
                            resultViewController.navigationTittle = title ?? ""
                            self.navigationController?.pushViewController(resultViewController, animated: true)
                        } else if code == "directline" && code != ""{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "DirectLinkViewController") as! DirectLinkViewController
                            self.navigationController?.pushViewController(resultViewController, animated: true)
                        } else if code == "private-video-call" && code != "" {
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

                                                          self.navigationController?.pushViewController(pulleyController, animated: true)
                        }
                        else if code == "home" && code != ""{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            self.navigationController?.pushViewController(resultViewController, animated: true)
                        }
                        else if code == "wardrobe" && code != ""{
                            let headerPlayerController = Storyboard.wardrobe.instantiateViewController(viewController: HeaderVideoPlayerViewController.self)
                            headerPlayerController.playerSate = .fromWadrable
                            let wardrobeVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobeViewController.self)
                            wardrobeVC.stateChangeClouser = { state in
                                headerPlayerController.changeSoundStatus(with: state)
                            }

                            let pulleyController = PulleyViewController(contentViewController: headerPlayerController, drawerViewController: wardrobeVC)
                            pulleyController.drawerCornerRadius = 20
                            self.navigationController?.pushViewController(pulleyController, animated: true)
                        }
                        else if code == ShoutoutConstants.shoutoutBucketCode && code != ""{
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
                            self.navigationController?.pushViewController(pulleyController, animated: true)

                        }
                         else if code == "myorders" && code != ""{
                            let wardrobeOrderVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobeOrderViewController.self)
                            self.navigationController?.pushViewController(wardrobeOrderVC, animated: true)
                        } else if code == "top-fans" && code != ""{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "MyFavoriteFansViewController") as! MyFavoriteFansViewController
                            resultViewController.selectedIndexVal = indexPath.row+3
                            resultViewController.navigationTittle = title ?? ""
                            self.navigationController?.pushViewController(resultViewController, animated: true)
                        } else if code == "ask" && code != ""{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "AskViewController") as! AskViewController
                            if let list = GlobalFunctions.returnBucketListFormBucketCode(code: code) {
                                resultViewController.pageList = list
                                resultViewController.selectedIndexVal = indexPath.row+3
                                resultViewController.navigationTittle = list.name ?? ""
                                resultViewController.selectedBucketCode = list.code
                            }
                            self.navigationController?.pushViewController(resultViewController, animated: true)
                        } else if code != "" {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "TravelingViewController") as! TravelingViewController
                            
                            if let list = GlobalFunctions.returnBucketListFormBucketCode(code: code) {
                                resultViewController.pageList = list
                                resultViewController.selectedIndexVal = indexPath.row+3
                                resultViewController.navigationTittle = list.name ?? ""
                                resultViewController.selectedBucketCode = list.code
                            }
                            
                            self.navigationController?.pushViewController(resultViewController, animated: true)
                        }
                    }
                    
                }
                
            }
        }
        
    }
}
