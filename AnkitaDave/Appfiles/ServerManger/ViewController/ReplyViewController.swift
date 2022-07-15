import UIKit
import SDWebImage
import IQKeyboardManagerSwift
import TPKeyboardAvoiding


class ReplyViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,CommentGiftControllerDelegate,PurchaseContentProtocol {


    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var noReplyLabel: UILabel!
    @IBOutlet var internetConnectionLostView: UIView!
    @IBOutlet var retryAgainButton: UIButton!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentViewBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var replyTableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImagereply: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var statusView: UITextView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var commentBoarderView: UIView!
    @IBOutlet weak var giftHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var CommentTextHorizontalView: UICollectionView!
    var commentText = ""
    var commentTextArrayData = ["Hey Hottie!!","Beautiful Woman!","Yo Womaniya!","Chalti kya 9 se 12","Come to me Baby"]
     var commentArray =  RCValues.sharedInstance.comment(forKey: .array_suggestions) as? Array<String>
    var flagIsFromLocalOrServer = false
    @IBOutlet weak var uiviewBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    let seconds = 1.5
    var comment_id : String!
    var  database : DatabaseManager!
    var perPage: Int? = 20
    var CurrentPageValue: Int? = 1
    var noOfPages: Int? = 1
    var totalImagesCount: Int? = 0
    var prevPageValue : Int? = 0
    private var overlayView = LoadingOverlay.shared
    var commentSendFlag = true
    let reachability = Reachability()!
    var giftView : UIView!
    var giftsDataArray = [Gift]()
    var quantityArray : Array<Any>!
    var delegate: CommentGiftControllerDelegate?
    var comment = ""
    var iconUrl = ""
    var commentName = ""
    var days = ""
    var arrData : [Reply] = [Reply]()
    var contentId = ""
    var postId = ""
    var contentIds = ""
    var type = ""
    var isLogin = false
    var stickerPrice = 0
    //    let textViewMaxHeight: CGFloat = 50
    @IBOutlet var giftHorizontalView: UIView!
    @IBOutlet weak var giftsHorizontalView: UICollectionView!
    var relounchFlag: Bool = false

    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    let errorMsgStr = ""
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        //        getStickers()
        giftHorizontal()
        commentTextHorizontal()
        self.internetConnectionLostView.isHidden = true
        self.giftHorizontalView.isHidden = false
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
        if self.giftsDataArray.count == 0{
                   self.giftHorizontalView.isHidden = true
               }else{
                   self.giftHorizontalView.isHidden = false
               }


        uiView.layer.cornerRadius = 10
        //        statusView.delegate = self
        database  = DatabaseManager.sharedInstance
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
        IQKeyboardManager.shared.enable = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")

                self.tableViewHeight.constant = 340

            case 1334:
                print("iPhone 6/6S/7/8")

                self.tableViewHeight.constant = 365

            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")

                self.tableViewHeight.constant = 510

            case 2436:
                print("iPhone X,IPHONE XS")
                self.tableViewHeight.constant = 530
                self.commentViewBottomHeight.constant = 5

            case 2688:
                print("IPHONE XS_MAX")
                self.tableViewHeight.constant = 530
                self.commentViewBottomHeight.constant = 5

            case 1792:
                print("IPHONE XR")
                self.tableViewHeight.constant = 530
                self.commentViewBottomHeight.constant = 5


            default:
                print("unknown")
            }
        }
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        //        longPressGesture.delegate = self
        self.replyTableView.addGestureRecognizer(longPressGesture)
        //        self.scrollView.isScrollEnabled  = false
        //        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView(_ : )))
        //        self.view.addGestureRecognizer(tapGesture)
        //statusView.isUserInteractionEnabled = false

        IQKeyboardManager.shared.enable = false
        //        self.scrollView.isScrollEnabled  = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        statusView.isEditable = false
        statusView.sizeToFit()

        self.navigationItem.rightBarButtonItem = nil

        //        self.navigationItem.title = "REPLY"
        //        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setNavigationView(title: "REPLY")

        self.giftImage.isHidden = true

        if type == "text" {

            self.statusView.text = comment

        }else{

            self.giftImage.isHidden = false
            self.giftImage.sd_imageIndicator?.startAnimatingIndicator()
          self.giftImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.giftImage.sd_imageTransition = .fade
            if type.lowercased() == "stickers" {
                //                let gifURL : String = "https://dl.kraken.io/web/5f925f7147af4c608025dba22ec136cd/ic_loading_icon.gif"
//                let imageURL = UIImage.gifImageWithURL(comment)
//                if let image = imageURL {
//                    self.giftImage.image = image
//                } else {
//                    self.giftImage.image =  UIImage(named: "emoji-icon")
//                }
                                 self.giftImage.sd_setImage(with: URL(string:comment), placeholderImage: UIImage(named: "emoji-icon2"), options: .refreshCached, context: nil)
            } else {
                //                let gifURL : String = "https://dl.kraken.io/web/5f925f7147af4c608025dba22ec136cd/ic_loading_icon.gif"
//                let imageURL = UIImage.gifImageWithURL(iconUrl)
//                if let image = imageURL {
//                    self.giftImage.image = image
//                } else {
//                    self.giftImage.image =  UIImage(named: "emoji-icon")
//                }
                               self.giftImage.sd_setImage(with: URL(string:iconUrl), placeholderImage: UIImage(named: "emoji-icon2"), options: .refreshCached, context: nil)
            }

//            self.statusView.backgroundColor = BlackThemeColor.darkBlack
//            self.uiView.backgroundColor = BlackThemeColor.darkBlack
            self.giftImage.contentMode = .scaleAspectFit
            self.giftImage.clipsToBounds = true

        }
        if commentName == "Anonymous" || commentName == " "
        {
            self.NameLabel.text = "Anonymous"
        }else{
            self.NameLabel.text = commentName

        }
        self.daysLabel.text = days
        self.profileImage.sd_setImage(with: URL(string:iconUrl), placeholderImage: UIImage(named: "profileph"), options: .refreshCached, context: nil)
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.clipsToBounds = true


//        self.commentView.layer.borderWidth = 1
//        self.commentView.layer.cornerRadius = 5
//        self.commentView.layer.borderColor = UIColor.lightGray.cgColor
//        self.commentView.clipsToBounds = true

        //        self.profileImage.layer.borderWidth = 2
        //        self.profileImage.layer.borderColor = UIColor.black.cgColor
        self.profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        self.profileImage.layer.masksToBounds = false
        self.profileImage.clipsToBounds = true
        self.profileImage.backgroundColor = UIColor.clear


        replyTableView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "ReplyCell")

        replyTableView.register(UINib(nibName: "CommentGiftTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentGiftTableViewCell")

        self.replyTableView.estimatedRowHeight = 44
        self.replyTableView.rowHeight = UITableView.automaticDimension
        replyTableView.dataSource = self
        replyTableView.delegate = self
        self.getData()

        self.commentTextField.resignFirstResponder()

        postButton.isEnabled = false
        postButton.alpha = 0.5
        commentTextField.delegate = self
        commentTextField.placeholder = "Tap to add a comment..."
        //        commentTextField.textColor = UIColor.lightGray
        commentBoarderView.tintColor = UIColor.gray
        commentTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

//        commentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
//        commentView.layer.shadowOffset = CGSize(width: 5, height: 5)
//        commentView.layer.shadowOpacity = 1.0
//        commentView.layer.shadowRadius = 9.0
//        commentView.layer.masksToBounds = false
//        commentView.layer.cornerRadius = 4.0

        if CustomerDetails.picture != nil {

            self.profileImagereply.sd_imageIndicator?.startAnimatingIndicator()
            self.profileImagereply.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.profileImagereply.sd_imageTransition = .fade
            self.profileImagereply.sd_setImage(with: URL(string:CustomerDetails.picture), placeholderImage: UIImage(named: "profileph"), options: .refreshCached, context: nil)
            self.profileImagereply.contentMode = .scaleAspectFill
            self.profileImagereply.clipsToBounds = true
        }

        else{
            profileImagereply.image =  UIImage(named: "profileph")
        }

        profileImagereply.layer.cornerRadius = profileImagereply.frame.size.width / 2
        profileImagereply.layer.masksToBounds = false
        profileImagereply.clipsToBounds = true
        profileImagereply.backgroundColor = UIColor.clear
        commentTextField.returnKeyType = UIReturnKeyType.done
        NotificationCenter.default.addObserver(self, selector: #selector(resignKeyboard(_ :)), name: NSNotification.Name(rawValue: "RESIGN_KEYBOARD"), object: nil)

//        uiView.backgroundColor = BlackThemeColor.darkBlack
        NameLabel.textColor = BlackThemeColor.white
        daysLabel.textColor = BlackThemeColor.white
        statusView.textColor = BlackThemeColor.white
        statusView.backgroundColor = .clear

        NameLabel.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        daysLabel.font = UIFont(name: AppFont.medium.rawValue, size: 11.0)
        statusView.font = UIFont(name: AppFont.medium.rawValue, size: 11.0)

        self.database.createRepliesTable()
        commentTextField.tintColor = UIColor.darkGray
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

                               let cell =  self.replyTableView.cellForRow(at: indexPath) as? CommentTextCollectionViewCell

                               cell?.commentLabel.text = commentTextArrayData[indexPath.item]
                                           cell?.commentLabel.sizeToFit()
                               return CGSize(width: cell?.commentLabel.frame.width ?? 180, height: 50)

            }else{
               let cell =  self.replyTableView.cellForRow(at: indexPath) as? CommentTextCollectionViewCell

                                         cell?.commentLabel.text = commentArray?[indexPath.item]
                                         cell?.commentLabel.sizeToFit()
                             return CGSize(width: cell?.commentLabel.frame.width ?? 180, height: 50)
            }

        }



    }

    func resignView(){
         self.giftHorizontalView.isHidden = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")

                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableViewHeight.constant = 340
                    self.commentViewBottomHeight.constant = 1
                    self.commentTextField.resignFirstResponder()
                    self.commentTextField.text = ""
                }

            case 1334:
                print("iPhone 6/6S/7/8")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableViewHeight.constant = 365
                    self.commentViewBottomHeight.constant = 1
                    self.commentTextField.resignFirstResponder()
                    self.commentTextField.text = ""
                }

            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableViewHeight.constant = 510
                    self.commentViewBottomHeight.constant = 1
                    self.commentTextField.resignFirstResponder()
                    self.commentTextField.text = ""
                }

            case 2436:
                print("iPhone X,IPHONE XS")

                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableViewHeight.constant = 530
                    self.commentViewBottomHeight.constant = -1
                    self.commentTextField.resignFirstResponder()
                    self.commentTextField.text = ""
                }

            case 2688:
                print("IPHONE XS_MAX")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableViewHeight.constant = 530
                    self.commentViewBottomHeight.constant = -1
                    self.commentTextField.resignFirstResponder()
                    self.commentTextField.text = ""
                }

            case 1792:
                print("IPHONE XR")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableViewHeight.constant = 530
                    self.commentViewBottomHeight.constant = -1
                    self.commentTextField.resignFirstResponder()
                    self.commentTextField.text = ""
                }

            default:
                print("unknown")
            }
        }
    }

     func commentTextHorizontal(){

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

    func setSticketViewHeight() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")

                //                self.tableVIewHeight.constant = 270
                self.tableViewHeight.constant = 220
                self.commentViewBottomHeight.constant = -210

            case 1334:
                print("iPhone 6/6S/7/8")

                self.tableViewHeight.constant = 235
                self.commentViewBottomHeight.constant = -210

            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")

                self.tableViewHeight.constant = 370
                self.commentViewBottomHeight.constant = -210
            case 2436:
                print("iPhone X,IPHONE XS")
                self.tableViewHeight.constant = 450
                self.commentViewBottomHeight.constant = -176

            case 2688:
                print("IPHONE XS_MAX")
                self.tableViewHeight.constant = 450
                self.commentViewBottomHeight.constant = -176

            case 1792:
                print("IPHONE XR")
                 self.tableViewHeight.constant = 450
                self.commentViewBottomHeight.constant = -176
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
        giftsVC.giftPrice = self.stickerPrice
        giftsVC.giftsDataArray = self.giftsDataArray
        giftsVC.quantityArray = self.quantityArray
        setSticketViewHeight()

        self.giftView = giftsVC.view
        self.view.addSubview(self.giftView)
        self.view.bringSubviewToFront(self.giftView)

        giftsVC.view.frame = CGRect(x: 0, y: self.view.frame.size.height
            - 210, width: self.view.frame.size.width, height: 210)
        //       self.addGiftsDataToDatabase()
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

    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        self.showToast(message: "Stickers Purchase Successfull")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
    }


    func sendGift(giftImage: String, giftId: String,giftCoin:Int) {
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            return
        }
        //        _ = self.getOfflineUserData()
        let firstName = CustomerDetails.firstName
        let lastName = CustomerDetails.lastName
        let giftPrice = Int(giftCoin)
        if let currentCoins = CustomerDetails.coins, currentCoins >= giftPrice{

            let dict = ["content_id": postId ,"parent_id": contentId, "comment": giftImage, "replied_by": "customer","type": "stickers","gift_id":giftId, "total_quantity":"1","v":Constants.VERSION,"artist_id":Constants.CELEB_ID,"platform":"ios"] as [String: Any]
            self.showLoader()
//            self.stopUserInterAction(stop: true)
            self.hideUpGiftsView(userInterAction: false, alpha: 0.5)
            ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.SEND_STICKER_REPLY, extraHeader: nil) { (response) in
                switch response {
                case .success(let data):
                    print(data)

//                    self.stopUserInterAction(stop: false)
                    self.stopLoader()
                    self.hideUpGiftsView(userInterAction: true, alpha: 1.0)
                    if data["error"].boolValue {

                        if let arrErr = data["error_messages"].object as? [String] {
                            if let strErr = arrErr.first {
//                                self.showToast(message:strErr)
                                /**
                                Handle for If Error coming but user want to reply on instant comment , this is not paid sticker
                                **/
                                if giftPrice > 0 {
                                    self.showToast(message:"Please try again")
                                } else {
                                    let commentObject = Reply(dict: ["first_name" : firstName ?? "", "last_name" : lastName ?? "" , "_id" : "" , "date_diff_for_human" : "Now", "comment" : giftImage  ?? "", "entity_id" :"", "parent_id" : self.contentId ??  "","created_at" : "","type":"stickers"] )
                                    let user = Users(dict: ["id" : CustomerDetails.custId , "first_name" : firstName ?? "", "last_name" : lastName ?? "", "picture" : CustomerDetails.picture ?? ""])
                                      commentObject.user = user
                                      self.arrData.insert(commentObject, at: 0)
                                    DispatchQueue.main.async {
                                        self.replyTableView.reloadData()
                                    }
                                }

                            }else{
                                self.showToast(message:" Please try again")
                            }
                        }
                    } else {

                        DispatchQueue.main.async {

                            self.noReplyLabel.isHidden = true
//                            if UIDevice().userInterfaceIdiom == .phone {
//                                switch UIScreen.main.nativeBounds.height {
//                                case 1136:
//                                    print("iPhone 5 or 5S or 5C")
//
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.tableViewHeight.constant = 340
//                                        self.commentViewBottomHeight.constant = 1
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                case 1334:
//                                    print("iPhone 6/6S/7/8")
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.tableViewHeight.constant = 445
//                                        self.commentViewBottomHeight.constant = 1
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                case 1920, 2208:
//                                    print("iPhone 6+/6S+/7+/8+")
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.tableViewHeight.constant = 510
//                                        self.commentViewBottomHeight.constant = 1
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                case 2436:
//                                    print("iPhone X,IPHONE XS")
//
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.commentViewBottomHeight.constant = -1
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                case 2688:
//                                    print("IPHONE XS_MAX")
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.commentViewBottomHeight.constant = 25//-1
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                case 1792:
//                                    print("IPHONE XR")
//                                    if(self.giftView != nil){
//                                        self.giftView.isHidden = true
//                                        self.commentViewBottomHeight.constant = -1
//                                        self.commentTextField.resignFirstResponder()
//                                        self.commentTextField.text = ""
//                                    }
//
//                                default:
//                                    print("unknown")
//                                }
//                            }
                            DispatchQueue.main.async {

                                self.noReplyLabel.isHidden = true
                                self.commentTextField.resignFirstResponder()
                                self.database.createRepliesTable()

                                //                                        let parentId = data["data"]["comment"]["parent_id"].string
                                //                                let id = contentsDict.value(forKey: "_id")
                                let enitytId = data["data"]["entity_id"].string
                                let id = data["data"]["_id"].string

                                //                                        dictData.value(forKey: "entity_id")
                                let date = Date()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                                dateFormatter.timeZone = TimeZone.current
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                dateFormatter.calendar = Calendar.current
                                let dateStr =  dateFormatter.string(from: date)

                                let commentObject = Reply(dict: ["first_name" : firstName ?? "", "last_name" : lastName ?? "" , "_id" : id ?? "" , "date_diff_for_human" : "Now", "comment" : giftImage  ?? "", "entity_id" : enitytId ?? "", "parent_id" : self.contentId ??  "","created_at" : dateStr,"type":"stickers"] )
                                let user = Users(dict: ["id" : CustomerDetails.custId , "first_name" : firstName ?? "", "last_name" : lastName ?? "", "picture" : CustomerDetails.picture ?? ""])
                                commentObject.user = user
                                if let coins_after_purchase = data["data"]["coins_after_txn"].int{
                                    CustomerDetails.coins = coins_after_purchase
                                    DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins)
                                    CustomMoEngage.shared.updateMoEngageCoinAttribute()

                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
                                }

                                //                                        }
                                self.database.insertIntoReply(commentObj: commentObject)
                                self.arrData.insert(commentObject, at: 0)
                                self.replyTableView.reloadData()
                                self.commentTextField.text = ""

                            }

                             self.stopLoader()
                            self.hideUpGiftsView(userInterAction: true, alpha: 1.0)
                        }

                    }
                case .failure(let error):
                    print(error)
                    self.stopLoader()
                    self.hideUpGiftsView(userInterAction: true, alpha: 1.0)
//                    self.showToast(message: "Something went wrong, Please try again")
                    /**
                    Handle for If Error coming but user want to reply on instant comment , this is not paid sticker
                    **/
                    if giftPrice > 0 {
                        self.showToast(message:"Something went wrong, Please try again")
                    } else {
                    let commentObject = Reply(dict: ["first_name" : firstName ?? "", "last_name" : lastName ?? "" , "_id" : "" , "date_diff_for_human" : "Now", "comment" : giftImage  ?? "", "entity_id" :"", "parent_id" : self.contentId ??  "","created_at" : "","type":"stickers"] )
                       let user = Users(dict: ["id" : CustomerDetails.custId , "first_name" : firstName ?? "", "last_name" : lastName ?? "", "picture" : CustomerDetails.picture ?? ""])
                        commentObject.user = user
                          self.arrData.insert(commentObject, at: 0)
                    DispatchQueue.main.async {
                        self.replyTableView.reloadData()
                        }

                    }
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


    @objc func reachabilityChanged(note: Notification) {

        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .wifi:

            print("Reachable via WiFi")
        case .cellular:

            print("Reachable via Cellular")
        case .none:
            if(arrData.count == 0){
                self.internetConnectionLostView.isHidden = false
            }
            print("Network not reachable")
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


    @objc func resignKeyboard(_ sender : Notification){

        self.commentTextField.resignFirstResponder()
    }

    @objc func didTapOnView(_ sender : UITapGestureRecognizer){

        if(sender.view?.classForCoder != ReplyTableViewCell.classForCoder()){
            self.commentTextField.resignFirstResponder()
        }
    }

    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.substring(to: 0) == " " {//sayali
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
        commentSendFlag = true
        self.giftHorizontalView.isHidden = false
        commentTextField.placeholder = ""
        if(commentTextField.text == "Tap to add a comment..."){
            commentTextField.text = ""

        }
        commentTextField.textColor = UIColor.darkGray
        commentBoarderView.backgroundColor = UIColor.lightGray
        if(self.giftView != nil){
            self.giftView.isHidden = true

        }
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


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if relounchFlag == true{
            self.giftHorizontalView.isHidden = false
        }else{
            self.giftHorizontalView.isHidden = true
        }
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")

                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableViewHeight.constant = 340
                    self.commentViewBottomHeight.constant = 1

                }

            case 1334:
                print("iPhone 6/6S/7/8")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableViewHeight.constant = 445
                    self.commentViewBottomHeight.constant = 1

                }

            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.tableViewHeight.constant = 510
                    self.commentViewBottomHeight.constant = 1
                    self.commentTextField.resignFirstResponder()
                    self.commentTextField.text = ""
                }


            case 2436:
                print("iPhone X,IPHONE XS")

                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.commentViewBottomHeight.constant = -1

                }

            case 2688:
                print("IPHONE XS_MAX")

                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.commentViewBottomHeight.constant = -1

                }

            case 1792:
                print("IPHONE XR")
                if(self.giftView != nil){
                    self.giftView.isHidden = true
                    self.commentViewBottomHeight.constant = -1

                }

            default:
                print("unknown")
            }
        }
        self.commentTextField.resignFirstResponder()
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.giftHorizontalView.isHidden = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = true
        self.setNavigationView(title: "REPLY")
        //        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        //        if relounchFlag == true{
        //            let relaunch =  UserDefaults.standard.string(forKey: "relaunchReply")
        //            if relaunch == "firstReplay" {
        //                self.giftHorizontalView.isHidden = false
        //            }else{
        //                self.giftHorizontalView.isHidden = true
        //            }
        //        }else{
        //            self.giftHorizontalView.isHidden = true
        //        }

        if !relounchFlag {
            let relaunch =  UserDefaults.standard.string(forKey: "relaunchReply")
            if relaunch == "firstReplay" {
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

        IQKeyboardManager.shared.enableAutoToolbar = false
    }


    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.replyTableView)
        let indexPath = self.replyTableView.indexPathForRow(at: p)
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
                popOverVC.titleLabel.text = "Give feedback on this comment"

                popOverVC.didMove(toParent: self)

            })
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        }
    }
    func getData()
    {
        if Reachability.isConnectedToNetwork()
        {
            self.showLoader()
            let dict = ["content_id": postId,"page": "\(CurrentPageValue)", "perpage": "\(perPage)"] as [String: Any] //
            print(dict)

            var strUrl = Constants.cloud_base_url + Constants.COMMENT_GET_REPLY + "comment_id=\(self.comment_id ?? "")" + "&page=\(CurrentPageValue!)"+"&\(Constants.artistId_platform)"
            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!// .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

            let url = URL(string: strUrl)
            let request = NSMutableURLRequest(url: url!)

            request.httpMethod = "GET"
            //                request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
            request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "artistid")
            request.addValue(Constants.PLATFORM_TYPE, forHTTPHeaderField: "Platform")

            request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")

            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    self.showToast(message: Constants.NO_Internet_MSG)
                    self.stopLoader()
                    DispatchQueue.main.async {

                        if  self.arrData.count > 0 {
                            self.internetConnectionLostView.isHidden = true
                        }

                        if(self.database != nil){
                            self.arrData =  self.database.getReplyData(comment_Id: self.comment_id)
                        }
                    }
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                        print("Photo json \(String(describing: json))")

                        if json.object(forKey: "error") as? Bool == true {
                            DispatchQueue.main.async {

                                //                                if  self.arrData.count > 0 {
                                //                                    self.internetConnectionLostView.isHidden = true
                                //                                }
                                self.stopLoader()


                                let arr = json.object(forKey: "error_messages")! as! NSMutableArray
                                //                            self.showToast(message: arr[0] as! String)
                                //                                self.showToast(message: Constants.NO_Internet_MSG)



                                //                                if(self.database != nil){
                                //                                    self.arrData =  self.database.getReplyData(comment_Id: self.comment_id)
                                //                                }
                            }

                        }else if (json.object(forKey: "status_code") as? Int == 200) {
                            if let AllData = json.object(forKey: "data") as? NSMutableDictionary
                            {
                                if  let paginationData = AllData.object(forKey: "paginate_data") as? NSMutableDictionary{
                                    self.totalImagesCount   = paginationData["total"] as? Int
                                    self.noOfPages  = paginationData["last_page"] as? Int
                                    self.CurrentPageValue  = paginationData["current_page"] as? Int
                                }

                            }


                            DispatchQueue.main.async {
                                if let dictData = json.object(forKey: "data") as? NSMutableDictionary {
                                    if let commentArr = dictData.object(forKey: "list") as? NSMutableArray {

                                        if commentArr.count > 0
                                        {
                                            for dictionary in commentArr{

                                                let commentObj : Reply = Reply(dict: dictionary as! [String : Any])
                                                self.arrData.append(commentObj)
                                                if(self.database != nil){

                                                    self.database.createRepliesTable()
                                                    self.database.insertIntoReply(commentObj: commentObj)
                                                }
                                            }
                                            self.arrData =  self.database.getReplyData(comment_Id: self.comment_id)


                                        }
                                        else{
                                            self.arrData =  self.database.getReplyData(comment_Id: self.comment_id)
                                            self.arrData =  self.arrData.sorted(by: { $0.created_at! > $1.created_at! })
                                            self.replyTableView.reloadData()

                                        }

                                        if commentArr.count > 0 || self.arrData.count > 0{
                                            self.noReplyLabel.isHidden = true
                                        }else{
                                            self.noReplyLabel.isHidden = false
                                        }


                                        self.stopLoader()

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
                    //                    if  self.arrData.count > 0 {
                    //                        self.internetConnectionLostView.isHidden = true
                    //                    }
                }
                DispatchQueue.main.async {

                    self.replyTableView.reloadData()

                }

            }
            task.resume()

        }else
        {
            self.stopLoader()
            //            self.showToast(message: Constants.NO_Internet_MSG)

            if(self.database != nil){
                self.arrData =  self.database.getReplyData(comment_Id: self.comment_id)
            }
            if  self.arrData.count > 0 {
                self.internetConnectionLostView.isHidden = true
            }
        }
    }
    func replyTextSend(){
            if !self.checkIsUserLoggedIn() {
                          self.loginPopPop()
                        return
                    }
    //                if !(commentTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
    //                {
                        if Reachability.isConnectedToNetwork()
                        {
    //                        if(commentSendFlag){
                                self.showLoader()
    //                            commentSendFlag = false
                                 var commentString = self.commentText
                                let dict = ["content_id": postId , "comment": commentString ?? "", "replied_by": "customer", "parent_id": contentId,"type":"text"] as [String: Any] //
                                print(dict)
                                if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {

                                    let url = NSURL(string: Constants.App_BASE_URL + Constants.COMMENT_REPLY)!
                                    let request = NSMutableURLRequest(url: url as URL)

                                    request.httpMethod = "POST"
                                    request.httpBody = jsonData
                                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                    request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
                                    //    request.addValue(Constants.CELEB_ID, forHTTPHeaderField: "artistid")
                                    request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")

                                    let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                                        if error != nil{
                                            print(error?.localizedDescription)
                                            self.stopLoader()
                                            return
                                        }
                                        do {
                                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                                            print("Photo json \(String(describing: json))")
                                            if json?.object(forKey: "error") as? Bool == true {

                                                DispatchQueue.main.async {
                                                    self.flagIsFromLocalOrServer = true
                                                    self.stopLoader()
                                                    let arr = json?.object(forKey: "error_messages")! as! NSMutableArray
                                                    self.showToast(message: arr[0] as! String)
                                                }

                                            }else if (json?.object(forKey: "status_code") as? Int == 200) {

                                                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                                                print("Photo json \(String(describing: json))")

                                                if let dictData = json?.object(forKey: "data") as? NSMutableDictionary{

                                                    if let contentsDict = dictData.object(forKey: "comment") as? NSMutableDictionary {

                                                    //                        self.contentIds = contentsDict["_id"] as! String

                                                    DispatchQueue.main.async {

                                                        self.noReplyLabel.isHidden = true
                                                        self.commentTextField.resignFirstResponder()
    //
                                                        self.database.createRepliesTable()
                                                        let firstName = CustomerDetails.firstName
                                                        let lastName = CustomerDetails.lastName
                                                        let parentId = contentsDict.value(forKey: "parent_id")
                                                        let contentId = contentsDict.value(forKey: "content_id")
                                                        let enitytId = contentsDict.value(forKey: "entity_id")
                                                        let date = Date()
                                                        let dateFormatter = DateFormatter()
                                                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                                                        dateFormatter.timeZone = TimeZone.current
                                                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                                        dateFormatter.calendar = Calendar.current
                                                        let dateStr =  dateFormatter.string(from: date)

                                                        let commentObject = Reply(dict: ["first_name" : firstName ?? "", "last_name" : lastName ?? "" , "_id" : contentsDict.value(forKey: "_id") ?? "" , "date_diff_for_human" : "Now", "comment" : contentsDict.value(forKey: "comment")  ?? "", "entity_id" : enitytId ?? "", "parent_id" : parentId ?? "","created_at" : dateStr,"type":"text","content_id": self.postId])
                                                        let user = Users(dict: ["id" : CustomerDetails.custId , "first_name" : firstName ?? "", "last_name" : lastName ?? "", "picture" : CustomerDetails.picture ?? ""])
                                                        commentObject.user = user
                                                        self.database.insertIntoReply(commentObj: commentObject)

                                                        self.arrData.insert(commentObject, at: 0)
                                                        self.replyTableView.reloadData()
                                                        self.commentTextField.text = ""

                                                    }
                                                }
                                                }
                                            }

                                            self.stopLoader()
                                        } catch let error as NSError {
                                            print(error)
                                            self.stopLoader()
                                        }
                                        DispatchQueue.main.async {

                                            self.replyTableView.reloadData()

                                        }

                                    }
                                    task.resume()
                                }
    //                        }
                        }else
                        {
                            self.stopLoader()
                            self.showToast(message: Constants.NO_Internet_MSG)

                        }
    //                }else{
    //                    showToast(message: "Please write comment..")
    //                }

        }
    @IBAction func replySendButton(_ sender: Any) {

    }

    //    func getCommentsFromDatabase(){
    //
    //        if(self.database != nil){
    //
    //            var array = self.database.getReplyData(comment_Id: self.comment_id)
    //
    //            array =  array.sorted(by: { $0.created_at! > $1.created_at! })
    //
    //            if(array != nil){
    //
    //                self.arrData = array
    //
    //                self.replyTableView.reloadData()
    //
    //            }
    //
    //            if(self.arrData.count > 0){
    //                let indexpath = IndexPath(row: self.arrData.count-1, section: 0)
    //                self.replyTableView.scrollToRow(at: indexpath, at: .bottom, animated: false)
    //            }
    //        }
    //    }

    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        cell.alpha = 0
    //
    //        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
    //        cell.layer.transform = transform
    //
    //        UIView.animate(withDuration: 1.0, animations: {
    //            cell.alpha = 1.0
    //            cell.layer.transform = CATransform3DIdentity
    //        })
    //    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  arrData.count > 0
        {
            return arrData.count
        }else
        {
            return 0
        }
    }


    @IBAction func stickerClosedButtonTapped(_ sender: Any) {
        self.giftHorizontalView.isHidden = true
        UserDefaults.standard.removeObject(forKey: "relaunchReply")
        relounchFlag = false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {



        if arrData.count > 0 {
            //        let reverseIndex = arrData.count-indexPath.row-1

            if let reply = arrData[indexPath.row] as? Reply{

                if reply.types == "text" {

                    let cell = replyTableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath)as! ReplyTableViewCell

                    if let comment = reply.comment as? String {

                        cell.profileStatusLabel.text = comment

                    }
                    if let hours = reply.date_diff_for_human as? String {

                        cell.hourseLabel.text = hours

                    }

                    if let customer = reply.user as? Users{

                        if let iconimage = customer.picture as? String{
                            cell.profilePicImage.sd_imageIndicator?.startAnimatingIndicator()
                            cell.profilePicImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.profilePicImage.sd_imageTransition = .fade
                            cell.profilePicImage.sd_setImage(with: URL(string: iconimage)) { (image : UIImage?, err : Error?, SDImageCacheTypeDisk , url : URL?) in
                                cell.profilePicImage.image = image
                                if(err != nil){
                                    cell.profilePicImage.image = UIImage(named: "profileph")

                                }
                            }

                        } else {
                            let placeHolderImage = UIImage(named: "profileph")
                            cell.profilePicImage.image = placeHolderImage
                        }

                        cell.verifyArtistTickImage.isHidden = true
                        if reply.replied_by  == "producer"{
                            cell.verifyArtistTickImage.isHidden = false

                        }

                        cell.profilePicImage.contentMode = .scaleAspectFill
                        cell.profilePicImage.clipsToBounds = true

                        if let firstname = customer.first_name as? String{
                            if let lastname = customer.last_name as? String{

                                cell.profileNameLabel.text = firstname+" "+lastname

                            }
                        }


                    }
                    return cell
                }else {
                    let giftCell : CommentGiftTableViewCell = replyTableView.dequeueReusableCell(withIdentifier: "CommentGiftTableViewCell", for: indexPath)as!CommentGiftTableViewCell

                    giftCell.replyCount.isHidden = true
                    giftCell.replylabel.isHidden = true
                    giftCell.imageLeftConstraint.constant = 70
                    //                self.comment_id = reply._id

                    if let comment = reply.comment as? String {
                        giftCell.replylabel.isHidden = true
                        giftCell.replyCount.isHidden = true
                        giftCell.sendGiftImage.sd_imageIndicator?.startAnimatingIndicator()
                        giftCell.sendGiftImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        giftCell.sendGiftImage.sd_imageTransition = .fade
                        giftCell.sendGiftImage.sd_setImage(with: URL(string: comment)) { (image : UIImage?, err : Error?, SDImageCacheTypeNone , url : URL?) in
                            giftCell.sendGiftImage.image = image
                            if(err != nil){
                                giftCell.sendGiftImage.image = UIImage(named: "emoji-icon")

                            }
                        }

                                giftCell.verifyArtistTickImage.isHidden = true
                            if reply.replied_by  == "producer"{
                                giftCell.verifyArtistTickImage.isHidden = false

                                }

                        giftCell.sendGiftImage.contentMode = .scaleAspectFit
                        giftCell.sendGiftImage.clipsToBounds = true
                        //                        let gifURL : String = "https://dl.kraken.io/web/5f925f7147af4c608025dba22ec136cd/ic_loading_icon.gif"
                        //                        let imageURL = UIImage.gifImageWithURL(comment)
                        //                        if let image = imageURL {
                        //                            giftCell.sendGiftImage.image = image
                        //                        } else {
                        //                            giftCell.sendGiftImage.image =  UIImage(named: "emoji-icon")
                        //                        }

                    }

                    if let customer = reply.user{

                        if let iconimage = customer.picture as? String{
                            giftCell.profilePicImage.sd_imageIndicator?.startAnimatingIndicator()
                            giftCell.profilePicImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
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

                        if reply.user != nil{

                            if let firstname = customer.first_name as? String , firstname != ""{
                                if let lastname = customer.last_name as? String{

                                    giftCell.profileNameLabel.text = firstname+" "+lastname

                                }
                            }else{

                                giftCell.profileNameLabel.text = "Anonymous"

                            }

                        }
                    }

                    if let hours = reply.date_diff_for_human as? String {

                        giftCell.hourseLabel.text = hours

                    }
                    return giftCell
                }


            }
        }
        //        cell.layoutIfNeeded()

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resignView()
    }

}
extension ReplyViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

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

            if(self.giftsDataArray != nil) {
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

            }else{
                self.giftHorizontalView.isHidden = true
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

                    let dict = ["content_id": postId ,"parent_id": contentId, "comment": giftImage, "replied_by": "customer","type": "stickers","gift_id":giftId, "total_quantity":"1","v":Constants.VERSION, "artist_id":Constants.CELEB_ID,"platform":Constants.PLATFORM_TYPE] as [String: Any]
                    self.showLoader()
                    ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.SEND_STICKER_REPLY, extraHeader: nil) { (response) in
                        switch response {
                        case .success(let data):
                            print(data)
                            if data["error"].boolValue {
                                if let arrErr = data["error_messages"].object as? [String] {
                                    if let strErr = arrErr.first {
                                        self.showToast(message:strErr)
                                    }else{
                                        self.showToast(message:"Something went wrong, Please try again")
                                    }
                                }
                            } else {

                                DispatchQueue.main.async {
                                    self.stopLoader()
                                    self.noReplyLabel.isHidden = true
                                    DispatchQueue.main.async {

                                        self.noReplyLabel.isHidden = true
                                        self.commentTextField.resignFirstResponder()
                                        self.database.createRepliesTable()
                                        let firstName = CustomerDetails.firstName
                                        let lastName = CustomerDetails.lastName
                                        let enitytId = data["data"]["entity_id"].string
                                        let id = data["data"]["_id"].string
                                        let coins_after_purchase = data["data"]["coins_after_txn"].int
                                        let date = Date()
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                                        dateFormatter.timeZone = TimeZone.current
                                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                        dateFormatter.calendar = Calendar.current
                                        let dateStr =  dateFormatter.string(from: date)

                                        let commentObject = Reply(dict: ["first_name" : firstName ?? "", "last_name" : lastName ?? "" , "_id" : id ?? "" , "date_diff_for_human" : "Now", "comment" : giftImage  ?? "", "entity_id" : enitytId ?? "", "parent_id" : self.contentId ??  "","created_at" : dateStr,"type":"stickers"] )
                                        let user = Users(dict: ["id" : CustomerDetails.custId , "first_name" : firstName ?? "", "last_name" : lastName ?? "", "picture" : CustomerDetails.picture ?? ""])
                                        commentObject.user = user
                                        CustomerDetails.coins = currentCoins - giftPrice!
        //                                let coin = coins_after_purchase as? Int
        //                                CustomerDetails.coins = coin
        //                                if currentList.coins == 0{
        //
        //                                }else{
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
        //                                }
                                        self.database.insertIntoReply(commentObj: commentObject)
                                        self.arrData.insert(commentObject, at: 0)
        //                                self.arrData =  self.arrData.sorted(by: { $0.created_at! > $1.created_at! })
                                        self.giftsHorizontalView.isUserInteractionEnabled = false
                                        self.giftsHorizontalView.alpha = 0.5
                                        DispatchQueue.main.asyncAfter(deadline: .now() + self.seconds) {
                                            // Put your code which should be executed with a delay here
                                            self.giftsHorizontalView.isUserInteractionEnabled = true
                                            self.giftsHorizontalView.alpha = 1.0

                                        }

                                        self.replyTableView.reloadData()
                                        self.commentTextField.text = ""

                                    }

                                    self.stopLoader()
                                }

                            }
                        case .failure(let error):
                            print(error)
                            self.stopLoader()
                            self.showToast(message: "Something went wrong, Please try again")
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

                       replyTextSend()

                 }
    }
    func stopUserInterAction(stop:Bool = false) {
        DispatchQueue.main.async {
            self.giftsHorizontalView.isUserInteractionEnabled = !stop
            self.commentTextField.isUserInteractionEnabled = !stop
            self.giftButton.isUserInteractionEnabled = !stop
            self.postButton.isUserInteractionEnabled = !stop
            self.replyTableView.isUserInteractionEnabled = !stop
            self.closeButton.isUserInteractionEnabled = !stop
        }
    }

    func hideUpfrontSticker(userInterAction: Bool, alpha: CGFloat){
        DispatchQueue.main.async {
            self.giftsHorizontalView.isUserInteractionEnabled = userInterAction
            self.giftsHorizontalView.alpha = alpha
        }

    }

    func hideUpGiftsView(userInterAction: Bool, alpha: CGFloat){
        DispatchQueue.main.async {
            self.giftView.isUserInteractionEnabled = userInterAction
            self.giftView.alpha = alpha
        }
    }
}


