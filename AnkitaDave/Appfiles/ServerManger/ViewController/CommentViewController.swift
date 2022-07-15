import UIKit
import SDWebImage
import IQKeyboardManagerSwift
import TPKeyboardAvoiding

class CommentViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate,CommentGiftControllerDelegate,PurchaseContentProtocol {


    @IBOutlet weak var noCommentLabel: UILabel!
    @IBOutlet var internetConnectionLostView: UIView!
    @IBOutlet var retryAgainButton: UIButton!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var commentBoarderView: UIView!
    @IBOutlet weak var giftHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var CommentTextHorizontalView: UICollectionView!
    var database : DatabaseManager!
    @IBOutlet weak var uiviewBottomHeight: NSLayoutConstraint!
    private var overlayView = LoadingOverlay.shared
    let spinner = UIActivityIndicatorView(style: .white)
    let reachability = Reachability()!
    var comment_id : String!
    var screenName : String = ""
    var isFirstTime = true
    @IBOutlet weak var tableVIewHeight: NSLayoutConstraint!
    var commentSendFlag = true
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    var postId = ""
    var isLogin = false
    let seconds = 1.5
    //    var numberOfCells : NSInteger = 0
    //    var states : Array<Bool>!

    var arrData : [Comments] = [Comments]() {
        didSet {
            commentTableView.reloadData()
        }
    }

    var commentTextArrayData = ["Hey Hottie!!","Beautiful Woman!","Yo Womaniya!","Chalti kya 9 se 12","Come to me Baby"]
    var commentArray =  RCValues.sharedInstance.comment(forKey: .array_suggestions) as? Array<String>
    var commentText = ""
    var selectedIndexVal: Int!
    var giftView : UIView!

    var ContentId: String = ""
    var isNewDataLoading = true
    private let refreshControl = UIRefreshControl()
    var giftsDataArray = [Gift]() {
        didSet {
            commentTableView.reloadData()
        }
    }
    var quantityArray : Array<Any>!
    var delegate: CommentGiftControllerDelegate?
    var getGiftsData = true
    var stickerPrice = 0
    var isFromSocialPhoto: Bool?

    @IBOutlet weak var giftsHorizontalView: UICollectionView!
    @IBOutlet weak var giftHorizontalView: UIView!
    var relounchFlag: Bool = false

    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var closeStickerButton: UIButton!
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        getStickers()
        giftHorizontal()
         commentTextHorizontal()
//        self.giftHorizontalView.isHidden = false
        //        self.view.setGradientBackground()

        self.internetConnectionLostView.isHidden = true

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

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.isTranslucent = false

        }

        if CustomerDetails.picture != nil {

            self.profileImage.sd_imageIndicator?.startAnimatingIndicator()
            self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.profileImage.sd_imageTransition = .fade
            self.profileImage.sd_setImage(with: URL(string:CustomerDetails.picture), placeholderImage: UIImage(named: "profileph"), options: .refreshCached, context: nil)
        }

        else{
            profileImage.image =  UIImage(named: "profileph")

        }
        commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentcell")

        commentTableView.register(UINib(nibName: "CommentGiftTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentGiftTableViewCell")

        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true
        profileImage.backgroundColor = UIColor.clear
        self.profileImage.contentMode = .scaleAspectFill
        database = DatabaseManager.sharedInstance
        IQKeyboardManager.shared.enable = false
        self.scrollView.isScrollEnabled  = false
        self.navigationItem.backBarButtonItem?.title = ""

        self.commentTextField.delegate = self
        //Long Press
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.commentTableView.addGestureRecognizer(longPressGesture)

        self.tabBarController?.tabBar.isHidden = true
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            } else {
                self.isLogin = false
            }
        } else {
            self.isLogin = false
        }
        //        if #available(iOS 11.0, *) {
        //            self.textViewBottomConstraint.constant = view.safeAreaInsets.bottom
        //            // ...
        //        }
        self.tableVIewHeight.constant = self.view.frame.height - 64 - self.commentView.frame.height


            if UIDevice().userInterfaceIdiom == .phone {
             switch UIScreen.main.nativeBounds.height {
             case 1136:
                 print("iPhone 5 or 5S or 5C")

                 self.tableVIewHeight.constant = 370

             case 1334:
                 print("iPhone 6/6S/7/8")
                 self.tableVIewHeight.constant = 468

             case 1920, 2208:
                 print("iPhone 6+/6S+/7+/8+")

                 self.tableVIewHeight.constant = 625


             case 2436:
                 print("iPhone X,IPHONE XS")

                 uiviewBottomHeight.constant = 25
                 self.tableVIewHeight.constant = self.view.frame.height - 200 - self.commentView.frame.height

             case 2688:
                 print("IPHONE XS_MAX")

                 uiviewBottomHeight.constant = 25
                 self.tableVIewHeight.constant = self.view.frame.height - 200 - self.commentView.frame.height

             case 1792:
                 print("IPHONE XR")

                 uiviewBottomHeight.constant = 25
                 self.tableVIewHeight.constant = self.view.frame.height - 200 - self.commentView.frame.height

             default:
                 print("unknown")
             }
         }


        postButton.alpha = 0.5

        self.navigationController?.isNavigationBarHidden = false

        self.navigationItem.rightBarButtonItem = nil
        //        commentTableView.tableFooterView =

        //        self.navigationItem.title = "COMMENTS"
        //        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setNavigationView(title: "COMMENTS")
        //        self.view.backgroundColor = .white
        arrData.removeAll()
        postButton.isEnabled = false
        commentTextField.delegate = self
        //        commentTextField.text = ""
        //        commentTextField.textColor = UIColor.lightGray
        commentBoarderView.tintColor = UIColor.gray
        commentTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

//        commentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
//        commentView.layer.shadowOffset = CGSize(width: 0, height: -5)
//        commentView.layer.shadowOpacity = 0.5
//        commentView.layer.shadowRadius = 5.0
//        commentView.layer.masksToBounds = false
//        commentView.layer.cornerRadius = 4.0

        commentTableView.dataSource = self
        commentTableView.delegate = self

        self.getData()

        //        self.commentTableView.estimatedRowHeight = 44
        self.commentTableView.rowHeight = UITableView.automaticDimension

        self.commentTextField.resignFirstResponder()
        commentTextField.placeholder = "Tap to add a comment..."
        commentTextField.returnKeyType = UIReturnKeyType.done

        NotificationCenter.default.addObserver(self, selector: #selector(resignKeyboard(_ :)), name: NSNotification.Name(rawValue: "RESIGN_KEYBOARD"), object: nil)
        self.database.createCommentsTable()
        commentTextField.tintColor = UIColor.darkGray
    }

    func commentTextHorizontal(){
//
//                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//    //            layout.sectionInset = UIEdgeInsets(top: 8, left: 10, bottom: 10, right: 8)
//                layout.itemSize = CGSize(width: 180, height: 50)
//                layout.minimumInteritemSpacing = 5
//                layout.minimumLineSpacing = 5
//                layout.scrollDirection = .horizontal
//                self.CommentTextHorizontalView.collectionViewLayout = layout
                self.CommentTextHorizontalView.showsHorizontalScrollIndicator = false
                self.CommentTextHorizontalView.dataSource = self
                self.CommentTextHorizontalView.delegate = self
                self.CommentTextHorizontalView.isPagingEnabled = true
                self.CommentTextHorizontalView.backgroundColor = UIColor.clear
                self.CommentTextHorizontalView.register(UINib.init(nibName: "CommentTextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"commentTextCell" )

            }

    func giftHorizontal(){

//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        layout.itemSize = CGSize(width: 80, height: 80)
//        layout.minimumInteritemSpacing = 5
//        layout.minimumLineSpacing = 5
//        layout.scrollDirection = .horizontal
//        self.giftsHorizontalView.collectionViewLayout = layout
        self.giftsHorizontalView.showsHorizontalScrollIndicator = false
        self.giftsHorizontalView.dataSource = self
        self.giftsHorizontalView.delegate = self
        self.giftsHorizontalView.isPagingEnabled = true
//        self.giftsHorizontalView.backgroundColor = UIColor.groupTableViewBackground
        self.giftsHorizontalView.register(UINib.init(nibName: "GiftsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"GiftCellID" )

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.giftsHorizontalView {

            return CGSize(width: 80, height: 80)

        }else{

            if commentArray! == [""]{

                               let cell =  self.commentTableView.cellForRow(at: indexPath) as? CommentTextCollectionViewCell

                               cell?.commentLabel.text = commentTextArrayData[indexPath.item]
                                           cell?.commentLabel.sizeToFit()
                               return CGSize(width: cell?.commentLabel.frame.width ?? 180, height: 50)

            }else{
               let cell =  self.commentTableView.cellForRow(at: indexPath) as? CommentTextCollectionViewCell

                                         cell?.commentLabel.text = commentArray?[indexPath.item]
                                         cell?.commentLabel.sizeToFit()
                             return CGSize(width: cell?.commentLabel.frame.width ?? 180, height: 50)
            }

        }



    }

    func contentPurchaseSuccessful(index: Int, contentId: String?) {

        self.showToast(message: "Stickers Purchase Successful")

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: ["text": "Stickers Purchase Successful"])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
    }


    func sendGift(giftImage: String, giftId: String,giftCoin:Int) {
        if !self.checkIsUserLoggedIn() {
              self.loginPopPop()
            return
        }
        //        _ = self.getOfflineUserData()


        let giftPrice = Int(giftCoin)

        if let currentCoins = CustomerDetails.coins, currentCoins >= giftPrice{
            let dict = ["content_id": postId , "comment": giftImage, "commented_by": "customer","type": "stickers", "gift_id":giftId, "total_quantity":"1","v":Constants.VERSION, "artist_id": Constants.CELEB_ID, "platform": Constants.PLATFORM_TYPE] as [String: Any]
            self.showLoader()
//            self.stopUserInterAction(stop: true)
            self.hideUpGiftsView(userInterAction: true, alpha: 0.5)
            ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.SEND_STICKER_COMMENT, extraHeader: nil) { (response) in
                switch response {
                case .success(let data):
                    print(data)
//                    self.stopUserInterAction(stop: false)
                    if data["error"].boolValue {
                        self.stopLoader()
                        self.hideUpGiftsView(userInterAction: true, alpha: 1.0)
                        if let arrErr = data["error_messages"].object as? [String] {
                            if let strErr = arrErr.first {
                                self.showToast(message:strErr)
                            }else{
                                self.showToast(message:"Something went wrong, Please try again")
                            }
                        }
                        let  payloadDict = NSMutableDictionary()
                        payloadDict.setObject(giftId, forKey: "content_id" as NSCopying)
                        payloadDict.setObject(giftImage, forKey: "comment" as NSCopying)
                        CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment, action: "Sticker", status: "Failed", reason: "error \(data["error"])", extraParamDict: payloadDict)
                    } else {
                        //                        if let dictData = data["data"]["comment"].dictionaryObject{
                        //                            if let comments = dictData["comment"]as? String {
                        DispatchQueue.main.async {
                            //                            self.stopLoader()
                            self.noCommentLabel.isHidden = true
//                            if UIDevice().userInterfaceIdiom == .phone {
//                                switch UIScreen.main.nativeBounds.height {
//                                case 1136:
//                                    print("iPhone 5 or 5S or 5C")
//
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.tableVIewHeight.constant = 450
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                case 1334:
//                                    print("iPhone 6/6S/7/8")
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.tableVIewHeight.constant = 548
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                case 1920, 2208:
//                                    print("iPhone 6+/6S+/7+/8+")
//
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.tableVIewHeight.constant = 625
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//
//                                case 2436:
//                                    print("iPhone X,IPHONE XS")
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.uiviewBottomHeight.constant = 25
//                                        self.tableVIewHeight.constant = self.view.frame.height - 110 - self.commentView.frame.height
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                case 2688:
//                                    print("IPHONE XS_MAX")
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.uiviewBottomHeight.constant = 25
//                                        self.tableVIewHeight.constant = self.view.frame.height - 100 - self.commentView.frame.height
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                case 1792:
//                                    print("IPHONE XR")
//
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.uiviewBottomHeight.constant = 25
//                                        self.tableVIewHeight.constant = self.view.frame.height - 110 - self.commentView.frame.height
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//
//                                default:
//                                    print("unknown")
//                                }
//                            }

                            let firstName = CustomerDetails.firstName
                            let lastName = CustomerDetails.lastName
                            let contentId = self.postId
                            let date = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                            dateFormatter.timeZone = TimeZone.current
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            dateFormatter.calendar = Calendar.current

                            let dateStr =  dateFormatter.string(from: date)
                            let commentObject = Comments(dict: ["_id" : "" , "date_diff_for_human" : "Now", "comment" : giftImage, "entity_id" : contentId,"created_at" : dateStr,"type":"stickers","contentId": self.postId])
                            //                                    let commentObject : Comments = Comments(dict: dictData as [String : Any])
                            //                                    commentObject.contentId = commentObject.entityId
                            //                                    commentObject.date_diff_for_human = "Now"
                            //                                    commentObject.created_at = self.getCurrentDateAndTime()

                            let user = Users(dict: ["_id" : CustomerDetails.custId , "first_name" : firstName ?? "", "last_name" : lastName ?? "", "picture" : CustomerDetails.picture ?? ""])
                            commentObject.user = user
                            if  let coins_after_purchase = data["data"]["coins_after_txn"].int{
                                CustomerDetails.coins = coins_after_purchase
                                DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins)
                                CustomMoEngage.shared.updateMoEngageCoinAttribute()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
                            }


                            self.arrData.insert(commentObject, at: 0)
                            //                            self.getCommentsFromDatabase()
                            if(self.arrData.count > 0 ){
                                let indexpath = IndexPath(row: 0, section: 0)
                                self.commentTableView.reloadData()
                                self.commentTableView.scrollToRow(at: indexpath, at: .top, animated: false)

                            }
                            let  payloadDict = NSMutableDictionary()
                            payloadDict.setObject(giftId, forKey: "content_id" as NSCopying)
                            payloadDict.setObject(giftImage, forKey: "comment" as NSCopying)
                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment, action: "Sticker", status: "Success", reason: "", extraParamDict: payloadDict)
                            //                            self.commentTableView.reloadData()
                            self.stopLoader()
                            self.hideUpGiftsView(userInterAction: true, alpha: 1.0)
                        }
                        //                            }
                        //                        }

                    }
                case .failure(let error):
                    print(error)
//                     self.stopUserInterAction(stop: false)
                    self.stopLoader()
                    self.hideUpGiftsView(userInterAction: true, alpha: 1.0)
                    self.showToast(message: "Something went wrong, Please try again")
                    let  payloadDict = NSMutableDictionary()
                    payloadDict.setObject(giftId, forKey: "content_id" as NSCopying)
                    payloadDict.setObject(giftImage, forKey: "comment" as NSCopying)
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment, action: "Sticker", status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
                }
            }
        } else {
            self.showToast(message: "Not enough coins please recharge")
        }

    }

    func getCurrentDateAndTime() -> Date? {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let dateFromString = dateFormatter.date(from: dateString)
        return dateFromString
    }

    func getStickers() {
        if Reachability.isConnectedToNetwork() {

            self.giftsDataArray = [Gift]()

            ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.COMMENT_GIFTS + Constants.artistId_platform + "&type=all&live_type=stickers" , extraHeader: nil, closure: { (result) in
                self.showLoader()
                switch result {

                case .success(let data):
                    print(data)
                    if data["error"].boolValue{
                        self.showToast(message: "Something went wrong. Please try again!")
                        return

                    }else{
                        if let resultArray : Array = data["data"]["list"].arrayObject {
                            self.giftsDataArray.removeAll()
                            if let stickerPrice = data["data"]["stickers_price"].int {
                                self.stickerPrice = stickerPrice
                            }

                            //                        UserDefaults.standard.set(stickerPrice, forKey: "StickerPrice")
                            UserDefaults.standard.synchronize()
                            for dict in resultArray{
                                let gift : Gift = Gift.init(dict: dict as? [String : Any])
                                self.giftsDataArray.append(gift)
                            }
                            if self.giftsDataArray.count == 0{
                                self.giftHorizontalView.isHidden = true
                                self.giftHeightConstraint.constant = 0
                            }else{
                                self.giftHorizontalView.isHidden = false
                                self.giftHeightConstraint.constant = 80
                            }
                                self.giftsHorizontalView.reloadData()
                                self.CommentTextHorizontalView.reloadData()

                            self.stopLoader()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })

        }else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }

    func setSticketViewHeight() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")

                self.tableVIewHeight.constant = 240

            case 1334:
                print("iPhone 6/6S/7/8")

                self.tableVIewHeight.constant = 340

            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")

                self.tableVIewHeight.constant = 410

            case 2436:
                print("iPhone X,IPHONE XS")

                self.tableVIewHeight.constant = 460

            case 2688:
                print("IPHONE XS_MAX")

                self.tableVIewHeight.constant = 550

            case 1792:
                print("IPHONE XR")

                self.tableVIewHeight.constant = 550

            default:
                print("unknown")
            }
        }
    }

    @IBAction func giftSendAction(_ sender: Any) {
        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            return
        }
        self.commentTextField.resignFirstResponder()
        self.giftHorizontalView.isHidden = true
        self.giftHeightConstraint.constant = 0
        //        let database =  DatabaseManager.sharedInstance
        //        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //        let writePath  = documents + "/ConsumerDatabase.sqlite"
        //        database.dbPath = writePath
        //
        //        self.giftsDataArray = [Gift]()
        //        self.giftsDataArray = database.getGiftsFromDatabase()

        if let giftsView = self.giftView, self.view.subviews.contains(giftsView) {
            self.giftView.isHidden = false
            setSticketViewHeight()
            self.view.bringSubviewToFront(giftsView)
            return
        }

        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let giftsVC = story.instantiateViewController(withIdentifier: "CommentGiftViewController") as! CommentGiftViewController

        giftsVC.delegate = self
        giftsVC.giftsDataArray = self.giftsDataArray
        giftsVC.quantityArray = self.quantityArray
        giftsVC.giftPrice = self.stickerPrice
        setSticketViewHeight()
        self.giftView = giftsVC.view
        self.view.addSubview(self.giftView)
        self.view.bringSubviewToFront(self.giftView)

        //        UserDefaults.standard.set(self.quantityArray, forKey: "GIFT_QUANTITY")
        //        UserDefaults.standard.synchronize()
        giftsVC.view.frame = CGRect(x: 0, y: self.view.frame.size.height
            - 210, width: self.view.frame.size.width, height: 210)
        //         self.addGiftsDataToDatabase()

    }

    func addGiftsDataToDatabase(){

        let database =  DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let writePath  = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath

        if(database != nil){
            database.createGiftsTable()
        }
        for var gift in self.giftsDataArray{
            database.insertIntoGifts(gift: gift)
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
                if(arrData.count == 0) {
                    self.internetConnectionLostView.isHidden = false
                }
                print("Network not reachable")
            }
        }
    }

    @IBAction func retryAgainClick(_ sender: UIButton){

        if self.arrData.count == 0 {
            self.getData()
            if  self.arrData.count > 0 {
                self.internetConnectionLostView.isHidden = true
            }
        }

    }


    override func viewDidAppear(_ animated: Bool) {

        //        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }

    @objc func resignKeyboard(_ sender : Notification){

        self.commentTextField.resignFirstResponder()
    }

    @objc func editingChanged(_ textField: UITextField) {

        if textField.text?.count == 1 {
            if textField.text?.substring(to: 0) == " " {
                textField.text = ""
                return
            }
        }
        guard
            let habit = commentTextField.text, !habit.isEmpty
            else {
                self.postButton.isEnabled = false
                self.postButton.alpha = 0.5
                return
        }
        postButton.isEnabled = true
        postButton.alpha = 1

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        if(commentTextField.text == "Tap to add a comment..."){
            commentTextField.text = ""

        }
        commentTextField.textColor = UIColor.darkGray
        commentBoarderView.backgroundColor = UIColor.lightGray
        commentSendFlag = true
        self.giftHorizontalView.isHidden = true
//        if relounchFlag == true{
//            self.giftHorizontalView.isHidden = false
//        }else{
//            self.giftHorizontalView.isHidden = true
//        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if commentTextField.text == "" {
            commentTextField.text = "Tap to add a comment..."
            commentTextField.textColor = UIColor.gray
            commentBoarderView.backgroundColor = UIColor.groupTableViewBackground
        }
    }

    func resignGiftView(){

        self.giftHorizontalView.isHidden = false
        self.giftHeightConstraint.constant = 80

        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")

                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableVIewHeight.constant = 370

                }
            case 1334:
                print("iPhone 6/6S/7/8")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableVIewHeight.constant = 468

                }

            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")

                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableVIewHeight.constant = 625

                }

            case 2436:
                print("iPhone X,IPHONE XS")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.uiviewBottomHeight.constant = 25
                    self.tableVIewHeight.constant = self.view.frame.height - 200 - self.commentView.frame.height

                }

            case 2688:
                print("IPHONE XS_MAX")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.uiviewBottomHeight.constant = 25

                   self.tableVIewHeight.constant = self.view.frame.height - 200 - self.commentView.frame.height

                }

            case 1792:
                print("IPHONE XR")

                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.uiviewBottomHeight.constant = 25
                    self.tableVIewHeight.constant = self.view.frame.height - 200 - self.commentView.frame.height

                }


            default:
                print("unknown")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.giftHorizontalView.isHidden = false
//        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: MyColors.navigationnBar)
        self.setNavigationView(title: "COMMENTS")
        //        self.view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.isTranslucent = false

        }

        if #available(iOS 10.0, *) {
            commentTableView.refreshControl = refreshControl
        } else {
            commentTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
        refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)

        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        self.navigationItem.backBarButtonItem?.title = ""

        self.tabBarController?.tabBar.isHidden = true

        //        if relounchFlag == true{
        //            let relaunch =  UserDefaults.standard.string(forKey: "relaunch")
        //            if relaunch == "first" {
        //                self.giftHorizontalView.isHidden = false
        //            }else{
        //                self.giftHorizontalView.isHidden = true
        //            }
        //        }else{
        //            self.giftHorizontalView.isHidden = true
        //        }

        if !relounchFlag {
            let relaunch =  UserDefaults.standard.string(forKey: "relaunch")
            if relaunch == "first" {
                self.giftHorizontalView.isHidden = false
                relounchFlag = true
            }else{
                self.giftHorizontalView.isHidden = true
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.commentTextField.resignFirstResponder()
        IQKeyboardManager.shared.enable = true

        IQKeyboardManager.shared.enableAutoToolbar = false

        if isFromSocialPhoto != nil {
            if isFromSocialPhoto! {
                let colors: [UIColor] = [UIColor.black,UIColor.black]
//                self.navigationController!.navigationBar.setGradientBackground(colors: colors)
            }
        }

    }
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.commentTableView)
        let indexPath = self.commentTableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizer.State.began) {
            print("Long press on row, at \(indexPath!.row)")

            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

            alert.addAction(UIAlertAction(title: "Give Feedback Or Report Comment", style: .default) { action in

                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackReportPopUpViewController") as! FeedbackReportPopUpViewController
                self.addChild(popOverVC)
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.titleLabel.text = "Give feedback on this content"
                popOverVC.didMove(toParent: self)

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
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if relounchFlag == true{
            self.giftHorizontalView.isHidden = false
        }else{
            self.giftHorizontalView.isHidden = true
        }


        self.commentTextField.resignFirstResponder()

        return true
    }

    @objc private func refreshPhotosData(_ sender: Any) {

        guard Reachability.isConnectedToNetwork() else {
            self.showToast(message: Constants.NO_Internet_MSG)
            self.refreshControl.endRefreshing()
            return
        }
        self.CurrentPageValue = 1
        self.arrData.removeAll()
        self.getData()
    }

    var perPage: Int = 10
    var CurrentPageValue: Int = 1
    var noOfPages: Int = 1
    var totalImagesCount: Int = 0
    var prevPageValue = 0

    func getData()
    {
        if Reachability.isConnectedToNetwork()
        {
            if isFirstTime == true {
                self.showLoader()
            }
            var strUrl = Constants.cloud_base_url + Constants.COMMENT + Constants.artistId_platform + "&content_id=\(postId)" + "&page=\(CurrentPageValue)" + "&v=\(Constants.VERSION)"

            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!// .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

            let url = URL(string: strUrl)
            let request = NSMutableURLRequest(url: url!)

            request.httpMethod = "GET"
            //                request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
            //                request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")

            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                guard let data = data, error == nil else {
                    print(error ?? "Unknown error")
                    return
                }
                if error != nil{
                    DispatchQueue.main.async {

                        if  self.arrData.count > 0 {
                            self.internetConnectionLostView.isHidden = true
                        }

                        //                        self.showToast(message: error?.localizedDescription ?? "The Internet connection appears to be offline.")
                        DispatchQueue.main.async {
                            self.getCommentsFromDatabase()
                            self.refreshControl.endRefreshing()


                        }
                        return
                    }
                }
                do {


                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                        //                        print("Photo json \(String(describing: json))")

                        if json.object(forKey: "error") as? Bool == true {
                            DispatchQueue.main.async {

                                if  self.arrData.count > 0 {
                                    self.internetConnectionLostView.isHidden = true
                                }
                                self.stopLoader()
                                self.spinner.stopAnimating()
                                //                            self.isFirstTime = false


                                if (json.object(forKey: "error_messages") as? NSMutableArray) != nil {

                                }
                                //                            self.showToast(message: arr[0] as! String)
                                self.getCommentsFromDatabase()


                            }

                        } else if (json.object(forKey: "status_code") as? Int == 200) {

                            if let AllData = json.object(forKey: "data") as? NSMutableDictionary
                            {

                                if  let paginationData = AllData.object(forKey: "paginate_data") as? NSMutableDictionary{
                                    self.totalImagesCount   = paginationData["total"] as! Int
                                    self.noOfPages  = paginationData["last_page"] as! Int
                                    self.CurrentPageValue  = paginationData["current_page"] as! Int
                                }

                            }


                            DispatchQueue.main.async {
                                if  let dictData = json.object(forKey: "data") as? NSMutableDictionary {
                                    if let commentArr = dictData.object(forKey: "list") as? NSMutableArray {
                                        if commentArr.count > 0
                                        {
                                            //                                self.isWating = false
                                            self.spinner.stopAnimating()
                                            self.refreshControl.endRefreshing()
                                            for dictionary in commentArr{

                                                let commentObj : Comments = Comments(dict: dictionary as! [String : Any])
                                                self.arrData.append(commentObj)
                                                commentObj.contentId = self.postId
                                                self.database.createCommentsTable()

                                                if(self.database != nil){
                                                    self.database.insertIntoComments(commentObj: commentObj)
                                                }

                                            }

                                            self.arrData = self.database.getCommentsData(comment_id: self.postId)
                                            self.arrData =  self.arrData.sorted(by: { $0.created_at! > $1.created_at! })
                                            self.commentTableView.reloadData()
                                            //
                                            //                                if(self.arrData.count > 0 && self.isFirstTime){
                                            //                                    let indexpath = IndexPath(row: self.arrData.count-1, section: 0)
                                            //                                    self.commentTableView.scrollToRow(at: indexpath, at: .bottom, animated: false)
                                            //                                }
                                            self.isFirstTime = false

                                        }else{
                                            self.arrData = self.database.getCommentsData(comment_id: self.postId)
                                            self.arrData =  self.arrData.sorted(by: { $0.created_at! > $1.created_at! })
                                            self.commentTableView.reloadData()

                                        }

                                        if commentArr.count > 0 || self.arrData.count > 0{
                                            self.noCommentLabel.isHidden = true
                                        }else{
                                            self.noCommentLabel.isHidden = false
                                        }

                                        //                                        if commentArr.count > 0{
                                        //
                                        //                                            self.noCommentLabel.isHidden = false
                                        //                                        }else{
                                        //                                            self.noCommentLabel.isHidden = true
                                        //                                        }


                                        self.refreshControl.endRefreshing()
                                        self.stopLoader()
                                        self.spinner.stopAnimating()

                                        if  self.arrData.count > 0 {
                                            self.internetConnectionLostView.isHidden = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
                    self.stopLoader()
                    self.spinner.stopAnimating()
                    self.isFirstTime = false
                    self.refreshControl.endRefreshing()

                    if  self.arrData.count > 0 {
                        self.internetConnectionLostView.isHidden = true
                    }
                }

            }

            task.resume()
        }else
        {
            self.spinner.stopAnimating()
            //            self.showToast(message: Constants.NO_Internet_MSG)
            self.stopLoader()
            self.refreshControl.endRefreshing()
            self.spinner.stopAnimating()
            self.getCommentsFromDatabase()

            if  self.arrData.count > 0 {
                self.internetConnectionLostView.isHidden = true
            }
        }
    }

    func showToasts(message : String) {
        DispatchQueue.main.async {

            let toastLabel = UILabel(frame: CGRect(x: 10, y: 300, width: self.view.frame.size.width - 20, height: 35))
            //        let toastLabel = UILabel(frame: CGRect(x: 10, y: 350, width: self.view.frame.size.width - 20, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: AppFont.light.rawValue, size: 11.0)
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

    func getCommentsFromDatabase(){

        if(self.database != nil){

            var array = self.database.getCommentsData(comment_id: self.postId)

            array =  array.sorted(by: { $0.created_at! > $1.created_at! })

            if(array != nil){

                self.arrData = array

                self.commentTableView.reloadData()

            }

            if(self.arrData.count > 0){
                let indexpath = IndexPath(row: self.arrData.count-1, section: 0)
                self.commentTableView.scrollToRow(at: indexpath, at: .bottom, animated: false)
            }
        }
    }


        func commentSendText(){
                    if !self.checkIsUserLoggedIn() {

                        let  payloadDict = NSMutableDictionary()
                        payloadDict.setObject(postId, forKey: "content_id" as NSCopying)
                        payloadDict.setObject(commentTextField.text ?? "", forKey: "comment" as NSCopying)
                        CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment, action: "", status: "Failed", reason: "User not logged in", extraParamDict: payloadDict)
                          self.loginPopPop()
                        return
                    }
                    if isLogin {

                            if Reachability.isConnectedToNetwork()
                            {
    //                            if(commentSendFlag){

    //                                commentSendFlag = false
                                    self.showLoader()
                                    var commentString = self.commentText//commentTextField.text
                                    let dict = ["content_id": postId , "comment": commentString ?? "", "commented_by": "customer","type":"text"] as [String: Any] //
                                    print(dict)
                                    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {

                                        let url = NSURL(string: Constants.App_BASE_URL + Constants.COMMENT_SAVE)!
                                        let request = NSMutableURLRequest(url: url as URL)

                                        request.httpMethod = "POST"
                                        request.httpBody = jsonData
                                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                        request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                                        request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "artistid")
                                        request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")

                                        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                                            if error != nil{
                                                print(error?.localizedDescription as Any)
                                                self.stopLoader()
                                                GlobalFunctions.trackEvent(eventScreen: self.screenName, eventName: "Comment", eventPostTitle: "Error : \(error?.localizedDescription ?? "" )", eventPostCaption: "", eventId: self.postId)
                                                let  payloadDict = NSMutableDictionary()
                                                payloadDict.setObject(self.postId , forKey: "content_id" as NSCopying)
                                                payloadDict.setObject(commentString ?? "", forKey: "comment" as NSCopying)
                                                CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment, action: "", status: "Failed", reason: "Error : \(error?.localizedDescription ?? "" )", extraParamDict: payloadDict)
                                                return
                                            }
                                            do {

                                                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                                                if json?.object(forKey: "error") as? Bool == true {

                                                    DispatchQueue.main.async {
                                                        self.stopLoader()
                                                        if let arr = json?.object(forKey: "error_messages")! as? NSMutableArray {
                                                        self.showToast(message: arr[0] as! String)
                                                        GlobalFunctions.trackEvent(eventScreen: self.screenName, eventName: "Comment", eventPostTitle: "Error", eventPostCaption: "", eventId: self.postId)
                                                            let  payloadDict = NSMutableDictionary()
                                                            payloadDict.setObject(self.postId , forKey: "content_id" as NSCopying)
                                                            payloadDict.setObject(commentString ?? "", forKey: "comment" as NSCopying)
                                                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment, action: "", status: "Failed", reason: "Error : \(arr[0])", extraParamDict: payloadDict)
                                                    }
                                                    }

                                                }else if (json?.object(forKey: "status_code") as? Int == 200) {
                                                    print("Photo json \(String(describing: json))")
                                                    GlobalFunctions.trackEvent(eventScreen: self.screenName, eventName: "Comment", eventPostTitle: "Success", eventPostCaption: "", eventId: self.postId)

                                                    let  payloadDict = NSMutableDictionary()
                                                    payloadDict.setObject(self.postId ?? "", forKey: "content_id" as NSCopying)
                                                    payloadDict.setObject(commentString ?? "", forKey: "comment" as NSCopying)
                                                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment
                                                        , action: "", status: "Success", reason: "", extraParamDict: payloadDict)

            //                                        if  let dictData = json?.object(forKey: "data") as? NSMutableDictionary {
            //                                        if let contentsDict = json?.object(forKey: "comment") as? NSMutableDictionary {

            //                                        if let comments = contentsDict.object(forKey: "comment") as? String {
                                                        DispatchQueue.main.async {
                                                            self.commentTextField.resignFirstResponder()
                                                            self.commentTextField.text = ""
                                                            self.noCommentLabel.isHidden = true
//                                                            if UIDevice().userInterfaceIdiom == .phone {
//                                                                switch UIScreen.main.nativeBounds.height {
//                                                                case 1136:
//                                                                    print("iPhone 5 or 5S or 5C")
//
//                                                                    if(self.giftView != nil){
//                                                                        self.giftView.isHidden = true
//                                                                        self.tableVIewHeight.constant = 370
//                                                                    }
//
//                                                                case 1334:
//                                                                    print("iPhone 6/6S/7/8")
//                                                                    if(self.giftView != nil){
//                                                                        self.giftView.isHidden = true
//                                                                        self.tableVIewHeight.constant = 468
//                                                                    }
//
//                                                                case 1920, 2208:
//                                                                    print("iPhone 6+/6S+/7+/8+")
//
//                                                                    if(self.giftView != nil){
//                                                                        self.giftView.isHidden = true
//                                                                        self.tableVIewHeight.constant = 625
//
//                                                                    }
//
//                                                                case 2436:
//                                                                    print("iPhone X,IPHONE XS")
//                                                                    if(self.giftView != nil){
//                                                                        self.giftView.isHidden = true
//                                                                        self.uiviewBottomHeight.constant = 25
//                                                                        self.tableVIewHeight.constant = self.view.frame.height - 200 - self.commentView.frame.height
//                                                                    }
//
//                                                                case 2688:
//                                                                    print("IPHONE XS_MAX")
//                                                                    if(self.giftView != nil){
//                                                                        self.giftView.isHidden = true
//                                                                        self.uiviewBottomHeight.constant = 25
//                                                                        self.tableVIewHeight.constant = self.view.frame.height - 200 - self.commentView.frame.height
//                                                                    }
//
//                                                                case 1792:
//                                                                    print("IPHONE XR")
//
//                                                                    if(self.giftView != nil){
//                                                                        self.giftView.isHidden = true
//                                                                        self.uiviewBottomHeight.constant = 25
//                                                                        self.tableVIewHeight.constant = self.view.frame.height - 200
//                                                                        self.commentView.frame.height
//                                                                    }
//
//
//                                                                default:
//                                                                    print("unknown")
//                                                                }
//                                                            }


                                                            let firstName = CustomerDetails.firstName
                                                            let lastName = CustomerDetails.lastName
                                                            let contentId = self.postId
            //                                                let idVal = contentsDict.value(forKey: "_id")
                                                            let date = Date()
                                                            let dateFormatter = DateFormatter()
                                                            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                                                            dateFormatter.timeZone = TimeZone.current
                                                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                                            dateFormatter.calendar = Calendar.current
                                                           let dateStr =  dateFormatter.string(from: date)
                                                            //
                                                            let commentObject = Comments(dict: ["_id" : contentId , "date_diff_for_human" : "Now", "comment" : commentString ?? "", "entity_id" : contentId,"created_at" : dateStr,"type":"text","contentId": self.postId])

                                                            let user = Users(dict: ["_id" : CustomerDetails.custId , "first_name" : firstName ?? "", "last_name" : lastName ?? "" , "picture" : CustomerDetails.picture ?? ""])
                                                            commentObject.user = user
                                                            self.database.insertIntoComments(commentObj: commentObject)
                                                            self.arrData.insert(commentObject, at: 0)
            //                                                self.getCommentsFromDatabase()
            //                                                if(self.arrData.count > 0 ){
            //                                                    let indexpath = IndexPath(row: 0, section: 0)
            //                                                    self.commentTableView.scrollToRow(at: indexpath, at: .top, animated: false)
            //                                                }
                                                            //                                    self.getData()

                                                        }

            //                                        }
            //                                    }
                                            }
            //                                    }
                                                self.stopLoader()
                                                DispatchQueue.main.async {
                                                    self.commentTableView.reloadData()
                                                }
                                            } catch let error as NSError {
                                                print(error)
                                                self.stopLoader()
                                                GlobalFunctions.trackEvent(eventScreen: self.screenName, eventName: "Comment", eventPostTitle: "Error : \(error.localizedDescription)", eventPostCaption: "", eventId: self.postId)

                                            }

                                        }
                                        task.resume()
                                    }
    //                            }
                            }else
                            {
                                self.showToast(message: Constants.NO_Internet_MSG)
                                self.stopLoader()
                            }

                    }else{
                        let alert = UIAlertController(title: "Not Logged In.Please log in to continue", message: "", preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

                        // show the alert
                        self.present(alert, animated: true, completion: nil)


                        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            if #available(iOS 11.0, *) {
                                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                self.navigationController?.pushViewController(resultViewController, animated: true)
                            }
                        })
                    }


        }

    @IBAction func commentSendButton(_ sender: Any) {


    }


    //    var isWating = false


    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("comment array \(arrData)")
        if  arrData.count > 0
        {
            return arrData.count
        }else
        {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        //        if (indexPath.row == 0 && self.arrData.count > 0 && self.noOfPages > self.CurrentPageValue) {
        if (indexPath.row == 0 && self.arrData.count > 0 && self.noOfPages > self.CurrentPageValue) {
            //                isWating = true
            self.CurrentPageValue = self.CurrentPageValue + 1
            spinner.color = UIColor.gray

            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: commentTableView.bounds.width, height: CGFloat(10))

            self.commentTableView.tableFooterView = spinner
            self.commentTableView.tableFooterView?.isHidden = false
            self.getData()
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

               if arrData.count > 0 {
                   //        let reverseIndex = arrData.count-indexPath.row-1


                   if let commentObj = arrData[indexPath.row] as? Comments {

                       if commentObj.types == "text" {

                           let cell : CommentTableViewCell = commentTableView.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath)as!CommentTableViewCell


                           cell.profileStatusLabel.text = " "

                           self.comment_id = commentObj._id
                           if let comment = commentObj.comment {

                               cell.profileStatusLabel.text = comment

                           }
                           cell.replyCount.text = ""

                           cell.verifyArtistTickImage.isHidden = true

                           if commentObj.commented_by  == "producer"{

                               cell.verifyArtistTickImage.isHidden = false

                           }
                           if commentObj.stats != nil  {
                               if let replyCounts = commentObj.stats?.replies{

                                   if(replyCounts > 0){
                                       cell.replyCount.text = "\(replyCounts ?? 0) replies"
                                   }
                               }
                           }
                           if let hours = commentObj.date_diff_for_human as? String {

                               cell.hourseLabel.text = hours

                           }

                           if let customer = commentObj.user{
                               if let iconimage = customer.picture as? String{
                                   cell.profilePicImage.sd_imageIndicator?.startAnimatingIndicator()
                                   cell.profilePicImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                   cell.profilePicImage.sd_imageTransition = .fade
                                   cell.profilePicImage.sd_setImage(with: URL(string: iconimage)) { (image : UIImage?, err : Error?, SDImageCacheTypeNone , url : URL?) in
                                       cell.profilePicImage.image = image
                                       if(err != nil){
                                           cell.profilePicImage.image = UIImage(named: "profileph")

                                       }
                                   }
                                   cell.profilePicImage.contentMode = .scaleAspectFill
                                   cell.profilePicImage.clipsToBounds = true
                               }else{
                                   cell.profilePicImage.image = UIImage(named: "profileph")
                               }

                               if commentObj.user != nil{

                                   if let firstname = customer.first_name as? String , firstname != ""{
                                       if let lastname = customer.last_name as? String{

                                           cell.profileNameLabel.text = firstname+" "+lastname

                                       }
                                   }else{
                                       cell.profileNameLabel.text = "Anonymous"

                                   }

                               }

                           }
                           return cell
                           }else {

                               let giftCell : CommentGiftTableViewCell = commentTableView.dequeueReusableCell(withIdentifier: "CommentGiftTableViewCell", for: indexPath)as!CommentGiftTableViewCell

                               self.comment_id = commentObj._id
                               if let comment = commentObj.comment as? String {

                                   giftCell.sendGiftImage.sd_imageIndicator?.startAnimatingIndicator()
                                   giftCell.sendGiftImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                   giftCell.sendGiftImage.sd_imageTransition = .fade



                                   giftCell.sendGiftImage.sd_setImage(with: URL(string: comment)) { (image : UIImage?, err : Error?, SDImageCacheTypeNone , url : URL?) in
                                       giftCell.sendGiftImage.image = image
                                       if(err != nil){
                                           giftCell.sendGiftImage.image = UIImage(named: "emoji-icon")

                                       }
                                   }
                                   giftCell.sendGiftImage.contentMode = .scaleAspectFit
                                   giftCell.sendGiftImage.clipsToBounds = true

                               }

                               if let customer = commentObj.user{

                                   if let iconimage = customer.picture as? String{
                                       giftCell.profilePicImage.sd_imageIndicator?.startAnimatingIndicator()
                                       giftCell.profilePicImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                       giftCell.profilePicImage.sd_imageTransition = .fade

                                       giftCell.profilePicImage.sd_setImage(with: URL(string: iconimage)) { (image : UIImage?, err : Error?, SDImageCacheTypeNone , url : URL?) in
                                           giftCell.profilePicImage.image = image
                                           if(err != nil){
                                               giftCell.profilePicImage.image = UIImage(named: "profileph")

                                           }
                                       }
                                       giftCell.profilePicImage.contentMode = .scaleAspectFill
                                       giftCell.profilePicImage.clipsToBounds = true
                                   }else{
                                       giftCell.profilePicImage.image = UIImage(named: "profileph")
                                   }

                                   if commentObj.user != nil{

                                       if let firstname = customer.first_name as? String , firstname != ""{
                                           if let lastname = customer.last_name as? String{

                                               giftCell.profileNameLabel.text = firstname+" "+lastname

                                           }
                                       }else{

                                           giftCell.profileNameLabel.text = "Anonymous"

                                       }

                                   }
                               }
                           giftCell.replyCount.text = ""

                           giftCell.verifyArtistTickImage.isHidden = true
                           if commentObj.commented_by  == "producer"{

                               giftCell.verifyArtistTickImage.isHidden = false

                           }

                           if let replyDict = commentObj.stats  {
                               if let replyCounts = commentObj.stats?.replies as? Int{

                                   if(replyCounts > 0){
                                       giftCell.replyCount.text = "\(replyCounts ?? 0) replies"
                                   }
                               }
                           }

                               if let hours = commentObj.date_diff_for_human as? String {

                                   giftCell.hourseLabel.text = hours

                               }
                               return giftCell
                           }
                   }
               }
               return UITableViewCell()

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //        let reverseIndex = arrData.count-indexPath.row-1



        if let comment : Comments = arrData[indexPath.row] as? Comments{

            self.comment_id = comment._id

            if(self.comment_id != nil){

                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let replyCollectionViewController = storyBoard.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController

                replyCollectionViewController.giftsDataArray = self.giftsDataArray
                replyCollectionViewController.stickerPrice = self.stickerPrice

                if let customer = comment.user {
                    if let iconimage = comment.user?.picture as? String{
                        replyCollectionViewController.iconUrl = iconimage
                    }
                }
                replyCollectionViewController.contentId = self.comment_id!
                replyCollectionViewController.postId = comment.entityId!
                replyCollectionViewController.comment_id = comment._id
                replyCollectionViewController.type = comment.types!

                if let customer = comment.user {

                    if let nameStr = comment.user?.first_name as? String{
                        let lastName = comment.user?.last_name as? String ?? ""
                        replyCollectionViewController.commentName = nameStr + " " +  lastName
                    }else{
                        replyCollectionViewController.commentName = "Anonymous"
                    }
                }
                replyCollectionViewController.comment = comment.comment ?? ""
                replyCollectionViewController.days = comment.date_diff_for_human ?? ""
                self.navigationController?.pushViewController(replyCollectionViewController, animated: true)
            }

        }
        resignGiftView()

    }


    @IBAction func stickerClosedButtonAction(_ sender: Any) {
        self.giftHorizontalView.isHidden = true
        UserDefaults.standard.removeObject(forKey: "relaunch")
        relounchFlag = false
    }
}
extension CommentViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if collectionView == self.giftsHorizontalView{
         if giftsDataArray.count <= 10{
           return giftsDataArray.count
         }else{
               return 10
           }
       }else if commentArray! == [""] {
           return commentTextArrayData.count

       }else{
            return commentArray!.count
           }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if collectionView == self.giftsHorizontalView {
              let cell : GiftsCollectionViewCell = giftsHorizontalView.dequeueReusableCell(withReuseIdentifier: "GiftCellID", for: indexPath) as! GiftsCollectionViewCell


          let giftDict: Gift = self.giftsDataArray[indexPath.item]

          let photoDict = giftDict.spendingPhoto
          let strImageUrl : URL? = URL(string: photoDict?.thumb ?? "")
          cell.giftsImageView.sd_imageIndicator?.startAnimatingIndicator()
          cell.giftsImageView.sd_imageTransition = .fade
          cell.giftsImageView.sd_setImage(with: strImageUrl)
          cell.giftsImageView.layer.cornerRadius = cell.giftsImageView.frame.size.height/2

          cell.armsCoinImage.isHidden = false
          if giftDict.type == "paid"{
              let coin = giftDict.coins
              cell.armsCoinImageWidth.constant = 15
              cell.coins.text = coin?.roundedWithAbbreviations
          }else{
              cell.armsCoinImage.isHidden = true
              cell.coins.text = "Free"
              cell.armsCoinImageWidth.constant = 0
          }

        cell.layer.borderColor = UIColor.clear.cgColor
          return cell
          }else{
              let cell : CommentTextCollectionViewCell = CommentTextHorizontalView.dequeueReusableCell(withReuseIdentifier: "commentTextCell", for: indexPath) as! CommentTextCollectionViewCell


          if commentArray! == [""]{
              cell.commentLabel.text = commentTextArrayData[indexPath.row]

          }else{

              cell.commentLabel.text = commentArray![indexPath.row]

          }
          return cell
          }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if !self.checkIsUserLoggedIn() {
                            self.loginPopPop()
                          return
                      }

              if collectionView == self.giftsHorizontalView {
        //        _ = self.getOfflineUserData()

                let currentList = giftsDataArray[indexPath.item]
                let coin = currentList.coins
                let giftPrice = coin
                let giftId =  currentList.id
                let giftImage = currentList.spendingPhoto?.thumb

                 if let currentCoins = CustomerDetails.coins, currentCoins >= giftPrice!{
                           let dict = ["content_id": postId , "comment": giftImage, "commented_by": "customer","type": "stickers", "gift_id":giftId, "total_quantity":"1","v":Constants.VERSION, "artist_id": Constants.CELEB_ID, "platform": Constants.PLATFORM_TYPE] as [String: Any]
                    self.showLoader()
                    ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.SEND_STICKER_COMMENT, extraHeader: nil) { (response) in
                        switch response {
                        case .success(let data):
                            print(data)
                            if data["error"].boolValue {
                                self.stopLoader()
                                if let arrErr = data["error_messages"].object as? [String] {
                                    if let strErr = arrErr.first {
                                        self.showToast(message:strErr)
                                    }else{
                                        self.showToast(message:"Something went wrong, Please try again")
                                    }
                                }
                                let  payloadDict = NSMutableDictionary()
                                payloadDict.setObject(giftId, forKey: "content_id" as NSCopying)
                                payloadDict.setObject(giftImage, forKey: "comment" as NSCopying)
                                CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment, action: "Sticker", status: "Failed", reason: "error \(data["error"])", extraParamDict: payloadDict)
                            } else {
                                //                        if let dictData = data["data"]["comment"].dictionaryObject{
                                //                            if let comments = dictData["comment"]as? String {
                                DispatchQueue.main.async {
                                    self.stopLoader()
                                    self.noCommentLabel.isHidden = true
                                    let firstName = CustomerDetails.firstName
                                    let lastName = CustomerDetails.lastName
                                    let contentId = self.postId
                                    let date = Date()
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                                    dateFormatter.timeZone = TimeZone.current
                                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                    dateFormatter.calendar = Calendar.current
                                    let coins_after_purchase = data["data"]["coins_after_txn"].int
                                    let dateStr =  dateFormatter.string(from: date)
                                    let commentObject = Comments(dict: ["_id" : contentId , "date_diff_for_human" : "Now", "comment" : giftImage, "entity_id" : contentId,"created_at" : dateStr,"type":"stickers","contentId": self.postId])

                                    let user = Users(dict: ["_id" : CustomerDetails.custId , "first_name" : firstName ?? "", "last_name" : lastName ?? "", "picture" : CustomerDetails.picture ?? ""])
                                    commentObject.user = user
                                    CustomerDetails.coins = currentCoins - giftPrice!
        //                            let coin = coins_after_purchase as? Int
        //                            CustomerDetails.coins = coin
        //                            if currentList.coins == 0{
        //
        //                            }else{
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
        //                            }
                                     self.commentTextField.resignFirstResponder()
                                    self.database.insertIntoComments(commentObj: commentObject)
        //                            self.getCommentsFromDatabase()
                                    self.arrData.insert(commentObject, at: 0)
        //                            if(self.arrData.count > 0 ){
        //                                let indexpath = IndexPath(row: 0, section: 0)
        //                                self.commentTableView.scrollToRow(at: indexpath, at: .top, animated: false)
        //
        //                            }
                                    let  payloadDict = NSMutableDictionary()
                                    payloadDict.setObject(giftId, forKey: "content_id" as NSCopying)
                                    payloadDict.setObject(giftImage, forKey: "comment" as NSCopying)
                                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment, action: "Sticker", status: "Success", reason: "", extraParamDict: payloadDict)
                                    self.stopLoader()
                                    self.giftsHorizontalView.isUserInteractionEnabled = false
                                    self.giftsHorizontalView.alpha = 0.5
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.seconds) {
                                        // Put your code which should be executed with a delay here
                                        self.giftsHorizontalView.isUserInteractionEnabled = true
                                        self.giftsHorizontalView.alpha = 1.0
                                }
                                                            }
                                //                        }
                                self.stopLoader()
                                DispatchQueue.main.async {
                                    self.commentTableView.reloadData()
                                }
                            }
                        case .failure(let error):
                            print(error)
                            self.stopLoader()
                            self.showToast(message: "Something went wrong, Please try again")
                            let  payloadDict = NSMutableDictionary()
                            payloadDict.setObject(giftId, forKey: "content_id" as NSCopying)
                            payloadDict.setObject(giftImage, forKey: "comment" as NSCopying)
                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.comment, action: "Sticker", status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
                        }
                    }
                } else {
                    self.showToast(message: "Not Enough coins please recharge")
                }
            }else{


                    if commentArray! == [""]{

                        let currentLists = commentTextArrayData[indexPath.item]
                        self.commentText = currentLists


                    }else{

                        let currentList = commentArray?[indexPath.item]
                        self.commentText = currentList ?? ""
                    }

                      commentSendText()
                   }

    }

    func stopUserInterAction(stop:Bool = false) {
        DispatchQueue.main.async {
          self.giftsHorizontalView.isUserInteractionEnabled = !stop
            self.commentTextField.isUserInteractionEnabled = !stop
            self.giftButton.isUserInteractionEnabled = !stop
            self.postButton.isUserInteractionEnabled = !stop
            self.commentTableView.isUserInteractionEnabled = !stop
            self.closeStickerButton.isUserInteractionEnabled = !stop
        }
    }

    func hideUpfrontSticker(userInterAction: Bool, alpha: CGFloat){
        DispatchQueue.main.async {
            self.giftsHorizontalView.isUserInteractionEnabled = userInterAction
            self.giftsHorizontalView.alpha = alpha
            if UIDevice().userInterfaceIdiom == .phone {
                       switch UIScreen.main.nativeBounds.height {
                       case 1136:
                           print("iPhone 5 or 5S or 5C")

                           if(self.giftView != nil){
                               self.giftView.isHidden = true
                               self.tableVIewHeight.constant = 450

                           }
                       case 1334:
                           print("iPhone 6/6S/7/8")
                           if(self.giftView != nil){
                               self.giftView.isHidden = true
                               self.tableVIewHeight.constant = 548

                           }

                       case 1920, 2208:
                           print("iPhone 6+/6S+/7+/8+")

                           if(self.giftView != nil){
                               self.giftView.isHidden = true
                               self.tableVIewHeight.constant = 625

                           }

                       case 2436:
                           print("iPhone X,IPHONE XS")
                           if(self.giftView != nil){
                               self.giftView.isHidden = true
                           }
                           self.uiviewBottomHeight.constant = 15
                           self.tableVIewHeight.constant = self.view.frame.height - 110 - self.commentView.frame.height

                       case 2688:
                           print("IPHONE XS_MAX")
                           if(self.giftView != nil){
                               self.giftView.isHidden = true
                           }

                           self.uiviewBottomHeight.constant = 15
                           self.tableVIewHeight.constant = self.view.frame.height - 100 - self.commentView.frame.height
                           print("height of tableview \(self.tableVIewHeight.constant)")
                       case 1792:
                           print("IPHONE XR")

                           if(self.giftView != nil){
                               self.giftView.isHidden = true
                           }

                           self.uiviewBottomHeight.constant = 15
                           self.tableVIewHeight.constant = self.view.frame.height - 110 - self.commentView.frame.height


                       default:
                           print("unknown")
                       }
                   }

        }

    }

    func hideUpGiftsView(userInterAction: Bool, alpha: CGFloat){
        DispatchQueue.main.async {
            self.giftView.isUserInteractionEnabled = userInterAction
            self.giftView.alpha = alpha
        }
    }
}


