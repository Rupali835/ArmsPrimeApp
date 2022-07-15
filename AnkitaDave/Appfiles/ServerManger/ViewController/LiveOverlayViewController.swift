//
//  LiveOverlayViewController.swift
//  Live
//
//  Created by leo on 16/7/12.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON
import XMPPFramework
//import GoogleMobileAds
import AudioToolbox
import PubNub
//import IHKeyboardAvoiding

protocol liveOvelayPrototcol {
    
    func isLiveStarted()
    func didSelectedSingleVideoCall(type: AgoraRTMConnection.commercialType, requestId: String)
    func didSelectedTermsConditions()
    func didSelectedPrivacyPolicy()
    func didFoundLowBalance()
    func didSelectNavigation(title: String)
}

class LiveOverlayViewController: BaseViewController {
    
    //    GADBannerViewDelegate,GADInterstitialDelegate
    @IBOutlet weak var emitterViewVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var commentsViewSpacing: NSLayoutConstraint!
    @IBOutlet weak var emojiButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var giftButton: DesignableButton!
    var delegate : liveOvelayPrototcol?
    @IBOutlet weak var upvoteBtn: DesignableButton!
    @IBOutlet weak var gesturesView: UIView!
    @IBOutlet weak var sendContentView: UIView!
    @IBOutlet weak var liveView: UILabel!
    @IBOutlet weak var isLiveView: UIView!
    @IBOutlet weak var timerContentView: UIView!
    @IBOutlet weak var viewersView: UIView!
    @IBOutlet weak var closeUsersView: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var currentUsersViewButton: UIButton!
    @IBOutlet weak var numberOfViewsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    var liveImageView: UIImageView!
    var usersCollectionView: UICollectionView!
    var showCollectionView : Bool!
    @IBOutlet weak var emitterView: WaveEmitterView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var giftArea: GiftDisplayArea!
    @IBOutlet weak var emojisVIew: UIView!
    @IBOutlet weak var emojiHeight: NSLayoutConstraint!
    @IBOutlet weak var emojiScrollView: UIScrollView!
    @IBOutlet weak var emojiButtonsView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var viewCallRequest: PHCallRequestView!
    
    @IBOutlet weak var viewCeleByte: UIView!
    @IBOutlet weak var viewDirectLine: UIView!
    @IBOutlet weak var viewWardrobe: UIView!
    
    @IBOutlet weak var btnCeleByte: UIButton!
    @IBOutlet weak var btnDirectLine: UIButton!
    @IBOutlet weak var btnWardrobe: UIButton!
    
    @IBOutlet weak var lblCeleByte: UILabel!
    @IBOutlet weak var lblDirectLine: UILabel!
    @IBOutlet weak var lblWardrobe: UILabel!
    @IBOutlet weak var lblUserID: UILabel!

   
    var pubnubPublishkey : String?
    var pubnubSubscribekey : String?
    var giftChannelnm : String?
    var commentChannelNm : String?
    
    var giftsDataArray : [Gift]!
    var quantityArray : Array<Any>!
    var liveOverlayTimer: Timer!
    var getGiftsData = true
    var client: PubNub!
    var timer4LiveAnim = Timer()
    var currentTotalUsers : Int64!
    var comments: [LiveComment] = []
    var isLogin = false
    var xmppController: XMPPController?
    //    var socket: SocketIOClient!
    var paidGiftArray = [JSON]()
    var coins = 0
    
    var time : TimeInterval!
    //    var giftView : UIView!
    var isEmojiHidden : Bool!
    var tapOnSelf : UITapGestureRecognizer!
    var xPosInputContainer : CGFloat!,xPoslikeBtn : CGFloat!, xPosEmojiview:CGFloat!, xPosviewersView:CGFloat!, xPosLiveView:CGFloat!, xPostimerLabel:CGFloat! , xPosTableview : CGFloat!, xPosGiftsTable : CGFloat!, xPosEmitter : CGFloat!, xPosGiftBtn : CGFloat!, xPosCallRequestView : CGFloat!, xPosCeleByteView : CGFloat!, xPosDirectLineView : CGFloat!, xPosWardrobeView : CGFloat!
    
    var commentTimer = Timer()
    var giftTimer = Timer()
    var tableScrollTimer = Timer()
    var startDate = NSNumber(value: Date().timeIntervalSince1970)
    var loadGifts = false
    var isFirstTime = true
    
    var giftsVC:GiftsViewController? = nil
    
    weak var liveController: LiveScreenViewController_New? = nil
    
    var shouldShowCallRequest = false
 
    @IBOutlet weak var commentView: UIView!
    //    var adMobBannerView = GADBannerView()
    //    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-9248196622572221~9609729393"
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CustomerDetails.customerData._id != nil {
                   self.lblUserID.text = CustomerDetails.customerData._id ?? ""
               }
        
//        view.removeGradient()
        
        //      adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
        //        adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
        
        //        self.textField.textColor = UIColor.white
        //        textField.contentVerticalAlignment = .center
        inputContainer.layer.cornerRadius = inputContainer.frame.height/2
        sendContentView.roundCorners(corners: [.topRight,.bottomRight], radius: 20)
        textField.roundCorners(corners: [.topLeft,.bottomLeft], radius: 20)
        sendButton.roundCorners(corners: [.topRight,.bottomRight], radius: 20)
        configureEmojiView()
        currentTotalUsers = 0
        isEmojiHidden = false
        //        textField.roundCorners(corners: [.bottomLeft], radius: 20)
        
        self.tableView.register(UINib.init(nibName: "LiveCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        //        if UserDefaults.standard.bool(forKey: "liveStatus") {
        //            //                    self.connectToXmmpp()
        //            self.joinPubNub()
        //        }
        //        else {
        //
        //            showNoChannel()
        //        }
        textField.tintColor = .white
        textField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LiveOverlayViewController.tick(_:)), userInfo: nil, repeats: true)
        
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(LiveOverlayViewController.handleTap(_:)))
        //        view.addGestureRecognizer(tap)
        timer4LiveAnim = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.animateLiveIcon), userInfo: nil, repeats: true)
        tapOnSelf = UITapGestureRecognizer.init(target: self, action: #selector(didTapOnView(_ :)))
        tapOnSelf.numberOfTapsRequired = 1
        tapOnSelf.cancelsTouchesInView = true
        self.gesturesView.tag = 5050
        tapOnSelf.delegate = self
        self.gesturesView.addGestureRecognizer(tapOnSelf)
        
        self.emitterView.isUserInteractionEnabled = true
        self.emitterView.tag = 5051
        
        let  tapOnEmitter : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapOnEmitterView(_ :)))
        self.emitterView.addGestureRecognizer(tapOnEmitter)
        let  tapOnGiftarea : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapOnGiftArea(_ :)))
        self.giftArea.addGestureRecognizer(tapOnGiftarea)
        
        let  tapOnCommentTable : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapOnCommentTable(_ :)))
        self.tableView.addGestureRecognizer(tapOnCommentTable)
        
        let rightSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(didSwipeRight(_ :)))
        rightSwipe.direction = .right
        
        let leftSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(didSwipeLeft(_ :)))
        leftSwipe.direction = .left
        self.gesturesView.addGestureRecognizer(rightSwipe)
        self.gesturesView.addGestureRecognizer(leftSwipe)
        
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
        
        textField.attributedPlaceholder = NSAttributedString(string: "Comment...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: ShoutoutFont.light.withSize(size: .medium)])
        
        if ArtistConfiguration.sharedInstance().oneToOne?.visibility == "true" {
            
            viewCallRequest.isHidden = false
        }
        else {
            
            viewCallRequest.isHidden = true
        }
        
        if #available(iOS 13.0, *) {}
        else {
            
            var titleInsets = btnCeleByte.titleEdgeInsets
            titleInsets.left = -40
            btnCeleByte.titleEdgeInsets = titleInsets
            
            titleInsets = btnDirectLine.titleEdgeInsets
            titleInsets.left = -40
            btnDirectLine.titleEdgeInsets = titleInsets
            
            titleInsets = btnWardrobe.titleEdgeInsets
            titleInsets.left = -40
            btnWardrobe.titleEdgeInsets = titleInsets
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GlobalFunctions.screenViewedRecorder(screenName: "Celeb Live Screen")
    }
    
    func setPubvalues(publishkey: String, subscribekey: String, giftnm: String, commentnm: String)
    {
        self.pubnubPublishkey = publishkey
        self.pubnubSubscribekey = subscribekey
        self.giftChannelnm = giftnm
        self.commentChannelNm = commentnm
    }
    
    func handleNavigationButtons(_ flag: Bool) {
        
        var isCeleByte = false
        var isDirectLine = false
        var isWardrobe = false
        
        viewCeleByte.isHidden = true
        viewDirectLine.isHidden = true
        viewWardrobe.isHidden = true
        
        if flag == false {
            
            if let bucket = GlobalFunctions.returnBucketListFormBucketCode(code: "shoutout"),
                let _ = bucket._id {
                isCeleByte = true
            }
            
            if let bucket = GlobalFunctions.returnBucketListFormBucketCode(code: "directline"),
                let _ = bucket._id {
                isDirectLine = true
            }
            
            if let bucket = GlobalFunctions.returnBucketListFormBucketCode(code: "wardrobe"),
                let _ = bucket._id {
                isWardrobe = true
            }
            
            if isCeleByte && isDirectLine && isWardrobe {
                viewCeleByte.isHidden = false
                viewDirectLine.isHidden = false
                viewWardrobe.isHidden = false
            } else if isCeleByte && isDirectLine {
                viewCeleByte.isHidden = false
                viewDirectLine.isHidden = false
            } else if isCeleByte && isWardrobe {
                viewCeleByte.isHidden = false
                viewDirectLine.isHidden = false
                btnDirectLine.setImage(UIImage(named: "icon_wardrobe"), for: .normal)
                lblDirectLine.text = "Wardrobe"
                btnDirectLine.setTitle("Wardrobe", for: .normal)
            } else if isDirectLine && isWardrobe {
                viewCeleByte.isHidden = false
                viewDirectLine.isHidden = false
                btnCeleByte.setImage(UIImage(named: "icon_directline"), for: .normal)
                btnDirectLine.setImage(UIImage(named: "icon_wardrobe"), for: .normal)
                lblCeleByte.text = "Directline"
                lblDirectLine.text = "Wardrobe"
                btnCeleByte.setTitle("Directline", for: .normal)
                btnDirectLine.setTitle("Wardrobe", for: .normal)
            } else if isCeleByte {
                viewCeleByte.isHidden = false
            } else if isDirectLine {
                viewCeleByte.isHidden = false
                btnCeleByte.setImage(UIImage(named: "icon_directline"), for: .normal)
                lblCeleByte.text = "Directline"
                btnCeleByte.setTitle("Directline", for: .normal)
            } else if isWardrobe {
                viewCeleByte.isHidden = false
                btnCeleByte.setImage(UIImage(named: "icon_wardrobe"), for: .normal)
                lblCeleByte.text = "Wardrobe"
                btnCeleByte.setTitle("Wardrobe", for: .normal)
            }
        }
    }
    
    func joinPubNub(authkey: String)
   // func joinPubNub()
    {
         
        let configuration = PNConfiguration(publishKey: self.pubnubPublishkey!, subscribeKey: self.pubnubSubscribekey!)
        
   //     let configuration = PNConfiguration(publishKey: artistConfig.pubnub_publish_key!, subscribeKey: artistConfig.pubnub_subcribe_key!)
    
        configuration.uuid = Constants.DEVICE_ID ?? ""
        
      //  configuration.authKey = authkey
        
        
        if let authkeyStatus = artistConfig.pn_auth_key {

            if authkeyStatus == true
            {
                configuration.authKey = authkey
            }

        }

        self.client = PubNub.clientWithConfiguration(configuration)
        self.client.addListener(self)
        
    
        self.client.subscribeToChannels([self.giftChannelnm ?? "\(Constants.CELEB_ID).g.0"], withPresence: false)
      
        self.commentTimer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(self.loadComments(timer:)), userInfo: nil, repeats: true)
        self.giftTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.loadGifts(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func loadComments(timer: Timer) {
        let endTime = NSNumber(value: Date().timeIntervalSince1970)
        
        self.client.historyForChannel(self.commentChannelNm ?? "\(Constants.CELEB_ID).c.0", start: startDate, end: endTime, limit: 10) { (result, status) in
            
            print(result)
            print(status)
            
            self.startDate = endTime
            if status == nil {
                guard let messages = result?.data.messages else { return }
                for message in messages {
                    self.newMessage(message: message)
                    if !self.tableScrollTimer.isValid {
                        self.tableScrollTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.automaticScroll(timer:)), userInfo: nil, repeats: true)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func automaticScroll(timer: Timer) {
        if self.tableView.contentOffset.y >= 0 && self.tableView.contentOffset.y < (self.tableView.contentSize.height - tableView.frame.size.height) {
            let points = CGPoint(x: self.tableView.contentOffset.x, y: self.tableView.contentOffset.y + 50)
            self.tableView.setContentOffset(points, animated: true)
        } else {
            self.tableScrollTimer.invalidate()
        }
    }
    
    @objc func loadGifts(timer: Timer) {
        if loadGifts {
            loadGifts = false
        } else {
            loadGifts = true
        }
        
    }
    
    func connectToXmmpp() {
        self.isLogin = true
        if CustomerDetails.firstName != nil {
            var userName = CustomerDetails.firstName.lowercased()
            
            userName = userName.components(separatedBy: .whitespaces).joined()
            try! self.xmppController = XMPPController(hostName: "razrooh.com",
                                                      userJIDString:"\(userName)_\(UIDevice.current.identifierForVendor!.uuidString)",
                password: "123456")
            self.xmppController?.connect()
            self.xmppController?.messageDelegate = self
            
        } else if CustomerDetails.email != nil{
            
            let userName = CustomerDetails.email.components(separatedBy: "@")
            if userName.count > 0 && userName[0] != nil {
                try! self.xmppController = XMPPController(hostName: "razrooh.com",
                                                          userJIDString: "\(userName[0].lowercased())_\(UIDevice.current.identifierForVendor!.uuidString))",
                    password: "123456")
                self.xmppController?.connect()
                self.xmppController?.messageDelegate = self
            }
        } else if let usersName = UserDefaults.standard.value(forKey: "username") as? String{
            var userName = usersName.lowercased()
            userName = userName.components(separatedBy: .whitespaces).joined()
            try! self.xmppController = XMPPController(hostName: "razrooh.com", userJIDString: "\(userName)_\(UIDevice.current.identifierForVendor!.uuidString)", password: "123456")
            self.xmppController?.connect()
            self.xmppController?.messageDelegate = self
        } else if let email = UserDefaults.standard.value(forKey: "useremail") as? String{
            let userName = email.components(separatedBy: "@")
            if userName.count > 0 && userName[0] != nil {
                try! self.xmppController = XMPPController(hostName: "razrooh.com", userJIDString: "\(userName[0].lowercased())_\(UIDevice.current.identifierForVendor!.uuidString))", password: "123456")
                self.xmppController?.connect()
                self.xmppController?.messageDelegate = self
            }
            
        } else {
            self.getUserDetails(completion: { (isSuccess) in
                if isSuccess && CustomerDetails.firstName != nil{
                    try! self.xmppController = XMPPController(hostName: "razrooh.com",
                                                              userJIDString: "\(CustomerDetails.firstName.lowercased())_\(UIDevice.current.identifierForVendor!.uuidString))",
                        password: "123456")
                } else if CustomerDetails.email != nil{
                    let userName = CustomerDetails.email.components(separatedBy: "@")
                    if userName.count > 0 && userName[0] != nil {
                        try! self.xmppController = XMPPController(hostName: "razrooh.com",
                                                                  userJIDString: "\(userName[0].lowercased())_\(UIDevice.current.identifierForVendor!.uuidString))",
                            password: "123456")
                    }
                }
                self.xmppController?.connect()
                self.xmppController?.messageDelegate = self
            })
        }
    }
    
    @objc func checkLiveStatus(_ timer : Timer) {
        //        http://d2fy11zd7yuyoz.cloudfront.net
        URLTester.verifyURLOnLiveScreen(urlPath: "http://d2fy11zd7yuyoz.cloudfront.net/\(self.artistConfig.key ?? "sherlynchopra")/myStream/playlist.m3u8") { (isOk) in
            if isOk {
                self.liveOverlayTimer.invalidate()
                DispatchQueue.main.async {
                    //                    self.connectToXmmpp()
               //     self.joinPubNub()
                    self.liveImageView.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    self.showHideViews(flag: false)
                    self.delegate?.isLiveStarted()
                    UserDefaults.standard.set(true, forKey: "liveStatus")
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveIsOn"), object: nil)
                }
                
            } else {
                print("CELEB IS NOT LIVE YET")
            }
        }
    }
    
    @objc func didTapOnEmitterView(_ sender : UIGestureRecognizer) {
        
        if ( sender.view?.tag == 5051) {
            if (self.giftsVC != nil) {
                self.giftsVC?.view.isHidden = true
            }
        }
        self.textField.resignFirstResponder()
    }
    @objc func didTapOnView(_ sender : UIGestureRecognizer) {
        
        if (sender.view?.tag == 5050  || sender.view?.tag == 5051) {
            if (self.giftsVC != nil) {
                self.giftsVC?.view.isHidden = true
            }
        }
        self.textField.resignFirstResponder()
    }
    @objc func didTapOnGiftArea(_ sender : UIGestureRecognizer) {
        if (self.giftsVC != nil) {
            self.giftsVC?.view.isHidden = true
        }
        self.textField.resignFirstResponder()
    }
    @objc func didTapOnCommentTable(_ sender : UIGestureRecognizer) {
        if (self.giftsVC != nil) {
            self.giftsVC?.view.isHidden = true
        }
        self.textField.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer4LiveAnim.invalidate()
    }
    
    func configureEmojiView() {
        currentTotalUsers = 1
        self.numberOfViewsLabel.text = String.init(format: "%d", currentTotalUsers)
        self.tableView.sectionHeaderHeight = 0.0
        self.tableView.separatorStyle = .none
        showCollectionView = true
        self.viewersView.alpha = 0.6
        self.viewersView.layer.cornerRadius = self.viewersView.frame.size.height/2
        self.emojisVIew.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        //       liveImageView.layer.cornerRadius = liveImageView.frame.size.height/2
        self.currentUsersViewButton.layer.borderWidth = 2.0
        self.currentUsersViewButton.layer.borderColor = UIColor.red.cgColor
        self.isLiveView.layer.cornerRadius = self.isLiveView.frame.size.height/2
        self.liveView.layer.cornerRadius = self.liveView.frame.size.height/2
        self.timerContentView.layer.cornerRadius=self.timerContentView.frame.size.height/2
        self.timerLabel.layer.cornerRadius = self.timerLabel.frame.size.height/2
        self.sendContentView.roundCorners(corners:[ .topRight , .bottomRight], radius: 20.0)
        time = 0
        self.emojiScrollView.isScrollEnabled = true
        currentUsersViewButton.layer.cornerRadius = currentUsersViewButton.frame.size.height/2
        closeUsersView.layer.cornerRadius = 13.0
        var x = 0, width = 60, height = 35;
        let emojisArray : [String]  = ["hello","\u{0001F60A}","\u{0001F60D}","\u{0001F604}","\u{0001F61A}","\u{0001F618}","\u{0002764}","\u{0001F60B}","\u{0001F633}","\u{000270B}"]
        for var i in 0...8{
            
            if (i == 0) {
                let helloButton = UIButton.init(frame: CGRect(x: 7, y: 0, width:width , height:height ))
                helloButton.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
                
                helloButton.setTitle("Hello", for: UIControl.State.normal)
                helloButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
                helloButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                helloButton.layer.cornerRadius = CGFloat(height/2)
                helloButton.addTarget(self, action:#selector(didSelectEmoji(_:)), for: .touchUpInside)
                self.emojiButtonsView.addSubview(helloButton)
                x = x + 7
            } else {
                let emojiButton = UIButton.init(frame: CGRect(x: x, y: 0, width: width, height:height ))
                emojiButton.setTitle(emojisArray[i], for: UIControl.State.normal)
                emojiButton.layer.cornerRadius = CGFloat(height/2)
                emojiButton.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
                emojiButton.addTarget(self, action:#selector(didSelectEmoji(_:)), for: .touchUpInside)
                self.emojiButtonsView.addSubview(emojiButton)
            }
            x = x +  7 + width
            
        }
        
        self.emojiButtonsView.backgroundColor = UIColor.clear
        self.emojiScrollView.backgroundColor = UIColor.clear
        self.emojisVIew.backgroundColor = UIColor.clear
        
        self.emojiScrollView.contentSize = CGSize(width: x, height: 30)
        self.emojiScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 35)
        self.emojiButtonWidth.constant = CGFloat(x + 20)
//        self.emojiButtonsView.frame = CGRect(x: 0, y: 0, width: x, height: 35)
        
    }
    
    @objc func didSelectEmoji(_ sender : UIButton) {
        if let text = sender.titleLabel?.text , text != ""  {
            
            var consumerName = " "
            
            if let name = CustomerDetails.firstName {
                
                consumerName = name
            }
            
            var profileImage = " "
            
            if let picture = CustomerDetails.picture {
                
                profileImage = picture
            }
            
            var uids = ""
            
            if let deviceId = Constants.DEVICE_ID {
                
                uids = deviceId
            }
            
            let timestamp = NSDate().timeIntervalSince1970
            let myTimeInterval = TimeInterval(timestamp)
            let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
            
            let message: [String : Any] = ["userComment": text, "userProfilePic": profileImage, "userName": consumerName, "userTimeStamp": "\(time)", "userUid": uids]
            
            var commentChannelName = "\(Constants.CELEB_ID).c.0"
            
            if let channelName = self.commentChannelNm {
                
                commentChannelName = channelName
            }
            
            client.publish(message, toChannel: commentChannelName, withCompletion: nil)
            
            let comment: LiveComment = LiveComment(dict: message)
            self.comments.append(comment)
            textField.text = ""
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.tableView!.numberOfRows(inSection: 0) - 1 , section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
        }
        self.emojisVIew.isHidden = true
        self.emojiHeight.constant = 0
        isEmojiHidden = true
        //                            commentsViewSpacing.constant = 5.0
        // emitterViewVerticalSpacing.constant = 5.0
    }
    
    @objc func animateLiveIcon()
    {
        self.isLiveView.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.curveEaseInOut, .autoreverse, .repeat], animations: {() -> Void in
            self.isLiveView.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
        })
    }
    
    func createUUID() -> String {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuid) as String
        return uuidString;
    }
    
    //    func presenceReceived(_ currentViews: Int) {
    //
    //        self.numberOfViewsLabel.text = String.init(format: "%d", currentViews)
    //
    //    }
    
    func handleData(message: [String : Any]) {
        if (message["message"] != nil) {
            if let nameAndMessageStr: String =  message["message"] as? String { //msgInfo.object(forKey: "text") as! String
                if let messageArray = nameAndMessageStr.components(separatedBy: "~") as? NSArray, messageArray.count > 1{
                    if let gift = messageArray.lastObject as? String, gift == "gift" {
                        print("Gift")
                        self.showGifts(string: nameAndMessageStr)
                        
                    } else {
                        if let userEmail = messageArray[1] as? String, userEmail != CustomerDetails.email {
                            let userComment = [
                                "text": messageArray[0],
                                "fName": messageArray[2],
                                "picture" : messageArray[3]
                                ] as [String: AnyObject]
                            //                            let comment: Comment = Comment(dict: userComment)
                            let comment: LiveComment = LiveComment(dict: userComment)
                            self.comments.append(comment)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func showGifts(string: String) {
        let gifts = string.components(separatedBy: "~")
        if gifts.count > 1 {
            let giftUrl = gifts[0]
            let imgURL = gifts[5]
            if gifts.count > 4 {
                let comboCount = gifts[2].components(separatedBy: "x")
                if comboCount[1] == ""{ return }
                if let userEmail = gifts[1] as? String, userEmail != CustomerDetails.email {
                    let userGift = ["giftImage": gifts[0], "userEmail": gifts[1], "comboType": Int(comboCount[1]) ?? 1, "giftCost": "\(gifts[3])", "userName": gifts[4], "userImage": gifts[5]] as [String: AnyObject]
                    let gift: GiftEvent = GiftEvent(dict: userGift)
                    self.giftArea.pushGiftEvent(gift)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.startPreventingRecording()
        tableView.contentInset.top = tableView.bounds.height
        tableView.reloadData()
        
        if shouldShowCallRequest {
            
            shouldShowCallRequest = false
            performSegue(withIdentifier: "callRequest", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.giftTimer.invalidate()
        self.tableScrollTimer.invalidate()
        self.commentTimer.invalidate()
        if (client != nil) {
            self.client.unsubscribeFromAll()
        }
        //        self.xmppController?.disconnect()
        if (self.liveOverlayTimer != nil) {
            self.liveOverlayTimer.invalidate()
        }
    }
    
    
    func startPreventingRecording() {
        NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: UIScreen.main, queue: OperationQueue.main) { (notification) in
            let isCaptured =  UIScreen.main.isCaptured
            if isCaptured {
                self.agoraEngine?.disableAudio()
                self.agoraEngine?.disableVideo()
               // self.agoraEngine?.disableExternalAudioSource()
                self.agoraEngine?.adjustAudioMixingPlayoutVolume(0)
                self.agoraEngine?.stopAudioRecording()
                self.agoraEngine?.adjustPlaybackSignalVolume(0)
                self.agoraEngine?.adjustRecordingSignalVolume(0)
                self.agoraEngine?.disableExternalAudioSink()
                self.agoraEngine?.stopChannelMediaRelay()
                
            }else{
                self.agoraEngine?.enableAudio()
                self.agoraEngine?.enableVideo()
             //  self.agoraEngine?.enableExternalAudioSource(withSampleRate: 0, channelsPerFrame: 0)
                self.agoraEngine?.adjustAudioMixingPlayoutVolume(400)
            }
        }
    }
    
    func getCoins() {
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getCoins, extraHeader: nil) { (result) in
            switch result {
            case .success(let data):
                print(data)
                if (data["error"] as? Bool == true) {
                    self.showToast(message: "Something went wrong. Please try again!")
                    return
                    
                } else {
                    if let coins = data["data"]["coins"].int {
                        self.coins = coins
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func tick(_ timer: Timer) {
        
        time = time + 1
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        self.timerLabel.text = String(format:"%02i:%02i", minutes, seconds)
        
        guard comments.count > 0 else {
            return
        }
        if tableView.contentSize.height > tableView.bounds.height {
            tableView.contentInset.top = 0
        }
        
        if self.tableView.numberOfRows(inSection: 0) > 0{
            //            tableView.scrollToRow(at: IndexPath(row: comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    
    @IBAction func giftButtonPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func upvoteButtonPressed(_ sender: AnyObject) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Live_like", extraParamDict: nil)
        
        let heartImage = UIImage(named: "newLike")
        self.emitterView.emitImage(heartImage!)
        //        let like = ["like": "like"]
        //        socket.emit("razrcorp", like)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            if let text = textField.text , text != "" {
                CustomMoEngage.shared.sendEventUIComponent(componentName: "Live_Comment", extraParamDict: nil)
                
                var consumerName = ""
                
                if let name = CustomerDetails.firstName {
                    
                    consumerName = name
                }
                
                var profileImage = ""
                
                if let picture = CustomerDetails.picture {
                    
                    profileImage = picture
                }
                
                var uids = ""
                
                if let deviceId = Constants.DEVICE_ID {
                    
                    uids = deviceId
                }
                
                let timestamp = NSDate().timeIntervalSince1970
                let myTimeInterval = TimeInterval(timestamp)
                let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
                
                var commentChannelName = "\(Constants.CELEB_ID).c.0"
                
                if let channelName = self.commentChannelNm {
                    
                    commentChannelName = channelName
                }
                
                let message: [String : Any] = ["userComment": text, "userProfilePic": profileImage, "userName": consumerName, "userTimeStamp": "\(time)", "userUid": uids]
                
              //  client.publish(message, toChannel: commentChannelName, withCompletion: nil)
                
                client.publish(message, toChannel: self.commentChannelNm!, withCompletion: nil)

                
                let comment: LiveComment = LiveComment(dict: message)
                self.comments.append(comment)
                
                textField.text = ""
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: self.tableView!.numberOfRows(inSection: 0) - 1 , section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
            }
            
        } else {
            self.showToast(message: "Please write comment..")
        }
    }
    
    @IBAction func closeCurrentUsersViewButtonPressed(_ sender: Any) {
        
        if (self.usersCollectionView != nil) {
            self.usersCollectionView.isHidden = true
            self.closeUsersView.isHidden = true
            self.currentUsersViewButton.frame = CGRect(x: self.usersCollectionView.frame.origin.x - 27 , y: 2, width: 20, height: 20)
            
        }
    }
    @IBAction func showHideCurrentUsersView(_ sender: Any) {
        
        //        self.usersCollectionView = UICollectionView.init(frame: CGRect(x: self.currentUsersViewButton.frame.size.width + self.currentUsersViewButton.frame.origin.x, y: 4, width: self.contentView.frame.size.width, height: 30))
        
        if (showCollectionView) {
            
            if (self.usersCollectionView == nil) {
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
                layout.itemSize = CGSize(width: 25, height: 25)
                layout.minimumInteritemSpacing = 2
                layout.minimumLineSpacing = 2
                layout.scrollDirection = .horizontal
                self.usersCollectionView = UICollectionView.init(frame:CGRect(x: self.currentUsersViewButton.frame.origin.x + 30 , y: -3, width: self.contentView.frame.size.width - 120, height: 30) , collectionViewLayout: layout)
                self.usersCollectionView.showsHorizontalScrollIndicator = false
                self.usersCollectionView.collectionViewLayout = layout
                self.usersCollectionView.dataSource = self
                self.usersCollectionView.delegate = self
                self.contentView.backgroundColor = UIColor.clear
                self.usersCollectionView.backgroundColor = UIColor.clear
                self.contentView.addSubview(self.usersCollectionView)
                self.usersCollectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UserCell")
                self.usersCollectionView.setNeedsDisplay()
            } else {
                self.usersCollectionView.reloadData()
            }
            self.usersCollectionView.isHidden = false
            self.currentUsersViewButton.frame = CGRect(x: self.usersCollectionView.frame.size.width + self.usersCollectionView.frame.origin.x + 5, y: 2, width: 20, height: 20)
            self.currentUsersViewButton.setNeedsDisplay()
            self.closeUsersView.isHidden = false
            
        } else {
            self.currentUsersViewButton.frame = CGRect(x: self.usersCollectionView.frame.origin.x - 27 , y: 2, width: 20, height: 20)
            self.closeUsersView.isHidden = true
            if (self.usersCollectionView != nil) {
                self.usersCollectionView.isHidden = true
            }
        }
        self.usersCollectionView.isHidden = !showCollectionView
        showCollectionView = !showCollectionView
    }
    
    @IBAction func timerButtonOnPressed(_ sender: Any) {
        
        let timerView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.height - self.view.frame.height*0.10 , width:self.view.frame.width, height: self.view.frame.height*0.10))
        
        self.view.addSubview(timerView)
    }
    
    @IBAction func giftButtonOnPressed(_ sender: Any) {

            self.textField.resignFirstResponder()
            let story = UIStoryboard.init(name: "Main", bundle: nil)

            if giftsVC != nil {

                giftsVC?.view.removeFromSuperview()
                giftsVC = nil
            }

            giftsVC = story.instantiateViewController(withIdentifier: "GiftsViewController") as? GiftsViewController

            let database = DatabaseManager.sharedInstance
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let writePath = documents + "/ConsumerDatabase.sqlite"
            database.dbPath = writePath

            self.giftsDataArray = [Gift]()
    //        self.giftsDataArray = database.getGiftsFromDatabase()

            if(self.giftsDataArray.count <= 0) {

    //            if(getGiftsData){

    //                getGiftsData = false
                    let params = ["type":""]
                    self.giftsDataArray = [Gift]()

                    ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.GIFTS + Constants.artistId_platform + "&type=&live_type=general", extraHeader: nil, closure: { (result) in
                        switch result {
                        case .success(let data):
                            print(data)
                            if(data["error"] as? Bool == true){
                                self.showToast(message: "Something went wrong. Please try again!")
                                return

                            }else{
                                let resultArray : Array = data["data"]["list"].arrayObject!

                                for dict in resultArray{

                                    let gift : Gift = Gift.init(dict: dict as! [String : Any])
                                    self.giftsDataArray.append(gift)
                                }
                                self.giftsVC?.delegate = self
                                self.giftsVC?.giftsDataArray = self.giftsDataArray
                                self.quantityArray = data["data"]["quantities"].arrayObject
                                self.giftsVC?.quantityArray = self.quantityArray
                                UserDefaults.standard.set(self.quantityArray, forKey: "GIFT_QUANTITY")
                                UserDefaults.standard.synchronize()
                                self.giftsVC?.view.frame = CGRect(x: 0, y: self.view.frame.size.height
                                    - 300, width: self.view.frame.size.width, height: 300)
                                self.giftsVC?.view.clipsToBounds = true
                                self.giftsVC?.view.roundCorners(corners: [.topLeft,.topRight], radius: 10.0,color: BlackThemeColor.yellow)
                               // self.giftsVC?.view.layer.borderColor = BlackThemeColor.yellow.cgColor
                                //self.giftsVC?.view.layer.borderWidth = 1
                                //                            self.giftView = giftsVC.view


                                self.addGiftsDataToDatabase()

                                self.view.addSubview(self.giftsVC!.view)
                                self.view.bringSubviewToFront(self.giftsVC!.view)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
    //            }
            }else{
                giftsVC = story.instantiateViewController(withIdentifier: "GiftsViewController") as! GiftsViewController
                self.giftsVC?.giftsDataArray = self.giftsDataArray
                self.quantityArray = UserDefaults.standard.array(forKey: "GIFT_QUANTITY")
                giftsVC?.quantityArray = self.quantityArray
                giftsVC?.view.frame = CGRect(x: 0, y: self.view.frame.size.height
                    - 300, width: self.view.frame.size.width, height: 300)
                giftsVC?.delegate = self
                self.giftsVC?.view.clipsToBounds = true
                self.giftsVC?.view.roundCorners(corners: [.topLeft,.topRight], radius: 10.0,color: BlackThemeColor.yellow)

          //      self.giftsVC?.view.layer.borderColor = BlackThemeColor.yellow.cgColor
              //  self.giftsVC?.view.layer.borderWidth = 1
                //            self.giftView = giftsVC.view
                self.view.addSubview(self.giftsVC!.view)
                self.view.bringSubviewToFront(self.giftsVC!.view)
                self.addGiftsDataToDatabase()
            }
        }
    
    @IBAction func didTapNavigate(_ sender: UIButton) {
        
        if var title = sender.titleLabel?.text?.lowercased() {
            if title == "celebyte" {
                title = "shoutout"
            }
            print("title:\(title)")
            didSelectNavigation(title: title)
        }
    }
    
    func addGiftsDataToDatabase() {
        
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        if (database != nil) {
            database.createGiftsTable()
        }
        for var gift in self.giftsDataArray{
            database.insertIntoGifts(gift: gift)
        }
    }
    
    @objc func didSwipeRight(_ sender : UISwipeGestureRecognizer) {
        
        if let giftVc = self.giftsVC {
            if !giftVc.view.isHidden {
                return
            }
        }
        
        if self.viewersView.frame.origin.x < 50 {
            self.xPosviewersView = self.viewersView.frame.origin.x
            self.xPostimerLabel = self.timerLabel.frame.origin.x
            self.xPosLiveView = self.isLiveView.frame.origin.x
            self.xPoslikeBtn = self.upvoteBtn.frame.origin.x
            self.xPosTableview = self.tableView.frame.origin.x
            self.xPosGiftsTable = self.giftArea.frame.origin.x
            self.xPosInputContainer = self.inputContainer.frame.origin.x
            self.xPosEmojiview = self.emojisVIew.frame.origin.x
            self.xPosEmitter = self.emitterView.frame.origin.x
            self.xPosGiftBtn = self.giftButton.frame.origin.x
            self.xPosCallRequestView = self.viewCallRequest.frame.origin.x
            self.xPosCeleByteView = self.viewCeleByte.frame.origin.x
            self.xPosDirectLineView = self.viewDirectLine.frame.origin.x
            self.xPosWardrobeView = self.viewWardrobe.frame.origin.x
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.inputContainer.frame.origin.x = self.view.frame.width
            self.emojisVIew.frame.origin.x = self.view.frame.width
            self.viewersView.frame.origin.x = self.view.frame.width
            self.timerLabel.frame.origin.x = self.view.frame.width
            self.isLiveView.frame.origin.x = self.view.frame.width
            self.upvoteBtn.frame.origin.x = self.view.frame.width
            self.tableView.frame.origin.x = self.view.frame.width
            self.giftArea.frame.origin.x = self.view.frame.width
            self.emitterView.frame.origin.x = self.view.frame.width
            self.giftButton.frame.origin.x = self.view.frame.width
            self.commentView.backgroundColor = .clear
            self.viewCallRequest.frame.origin.x = self.view.frame.width
            self.viewCeleByte.frame.origin.x = self.view.frame.width
            self.viewDirectLine.frame.origin.x = self.view.frame.width
            self.viewWardrobe.frame.origin.x = self.view.frame.width
        }) { (true) in
            self.showHideViews(flag: true)
        }
    }
    
    @objc func didSwipeLeft(_ sender : UISwipeGestureRecognizer) {
        
        if (self.xPosInputContainer != nil ) {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.viewersView.frame.origin.x = self.xPosviewersView
                self.timerLabel.frame.origin.x = self.xPostimerLabel
                self.isLiveView.frame.origin.x = self.xPosLiveView
                self.upvoteBtn.frame.origin.x = self.xPoslikeBtn
                self.tableView.frame.origin.x = self.xPosTableview
                self.giftArea.frame.origin.x = self.xPosGiftsTable
                self.inputContainer.frame.origin.x = self.xPosInputContainer
                self.emojisVIew.frame.origin.x = self.xPosEmojiview
                self.emitterView.frame.origin.x = self.xPosEmitter
                self.giftButton.frame.origin.x = self.xPosGiftBtn
                self.commentView.backgroundColor = .clear
                self.viewCallRequest.frame.origin.x = self.xPosCallRequestView
                self.viewCeleByte.frame.origin.x = self.xPosCeleByteView
                self.viewDirectLine.frame.origin.x = self.xPosDirectLineView
                self.viewWardrobe.frame.origin.x = self.xPosWardrobeView
            }, completion: { (true) in
                self.showHideViews(flag: false)
            })
        }
    }
    
    func showHideViews(flag: Bool) {
        if (isEmojiHidden) {
            self.emojisVIew.isHidden  = isEmojiHidden
        } else {
            self.emojisVIew.isHidden  = flag
        }
   //     self.inputContainer.isHidden = flag
        self.timerLabel.isHidden = flag
        self.viewersView.isHidden = flag
        self.upvoteBtn.isHidden = flag
        self.isLiveView.isHidden = flag
        self.tableView.isHidden = flag
        self.giftArea.isHidden = flag
        self.emitterView.isHidden = flag
        self.giftButton.isHidden = flag
        self.commentView.isHidden = flag
        self.viewCallRequest.isHidden = flag
        disableCommentBox()
        handleNavigationButtons(flag)
    }
    
    // MARK: - Utility Methods
    func showNoChannel() {
        
        liveImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        liveImageView.image = UIImage(named: "liveOffline.jpg")
        liveImageView.contentMode = .scaleAspectFill
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        contentView.backgroundColor = UIColor.clear
        contentView.isOpaque = true
        let noLiveLabel = UILabel(frame: CGRect(x: 30, y: 0, width: self.view.frame.width - 60, height: 65))
        noLiveLabel.text = "There is no live broadcast right now."

        contentView.addSubview(noLiveLabel)
        noLiveLabel.center = CGPoint(x:liveImageView.center.x , y: liveImageView.center.y + 220)
        noLiveLabel.textAlignment = .center
        noLiveLabel.font = UIFont.boldSystemFont(ofSize: 21)
        noLiveLabel.textColor = UIColor.white
        noLiveLabel.numberOfLines = 0
        let noLiveLabelTwo = UILabel(frame: CGRect(x: 30, y: noLiveLabel.frame.origin.y + 50 , width: self.view.frame.width - 60, height: 100))
        noLiveLabelTwo.text = "You will receive notification whenever \(Constants.celebrityName) goes live"
        contentView.addSubview(noLiveLabelTwo)
        noLiveLabelTwo.font = UIFont.systemFont(ofSize: 16)
        noLiveLabelTwo.numberOfLines = 0
        noLiveLabelTwo.textAlignment = .center
        noLiveLabelTwo.textColor = UIColor.white
        
        //                    let contentViews = UIView(frame: CGRect(x: (self.view.frame.size.width-320)/2, y: view.frame.size.height-50, width: 320, height: 50))
        //                    contentViews.backgroundColor = UIColor.blue
        //                    contentView.addSubview(contentViews)
        
        //                    if UIDevice.current.userInterfaceIdiom == .phone {
        //                        // iPhone
        //                        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
        //                        adMobBannerView.frame = CGRect(x: (self.view.frame.size.width-320)/2, y: view.frame.size.height-50, width: 320, height: 50)
        ////                        adMobBannerView.backgroundColor = UIColor.blue
        //                    } else  {
        //                        // iPad
        //                        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
        //                        adMobBannerView.frame = CGRect(x: (self.view.frame.size.width-468)/2, y: view.frame.size.height-60, width: 468, height: 60)
        //                    }
        //
        //                    self.adMobBannerView.adUnitID = "ca-app-pub-9248196622572221/8188575505"
        //                    //ADMOB_BANNER_UNIT_ID
        //                    adMobBannerView.rootViewController = self
        //                    adMobBannerView.delegate = self
        //                    contentView.addSubview(adMobBannerView)
        
        //                    let request = GADRequest()
        //                    adMobBannerView.load(request)
        
        liveImageView.addSubview(contentView)
        liveImageView.isUserInteractionEnabled  = true
        self.view.addSubview(liveImageView)
        self.view.bringSubviewToFront(liveImageView)
        self.showHideViews(flag: true)
        self.view.isUserInteractionEnabled = true
    }
    
    func removeNoChannelView() {
        
        if liveImageView != nil {
            liveImageView.removeFromSuperview()
            self.showHideViews(flag: false)
        }
    }
    
    func showAudienceCount() {
        self.numberOfViewsLabel.text = "\(currentTotalUsers!)"
    }
}

//MARK:- MessageDelegate
extension LiveOverlayViewController: MessageDelegate{
    func presenceReceived(_ presence: XMPPPresence) {
        
        if (presence != nil) {
            
            if (presence.type == "available") {
                currentTotalUsers = currentTotalUsers + 1
            } else if (presence.type == "unavailable" && currentTotalUsers > 0) {
                currentTotalUsers = currentTotalUsers - 1
            }
        }
        //        self.numberOfViewsLabel.text = String.init(format: "%d", currentTotalUsers)
    }
    func messageReceived(_ message: [String : Any]?) {
        self.handleData(message: message!)
    }
}

//MARK:- GiftsViewControllerDelegate
extension LiveOverlayViewController: GiftsViewControllerDelegate {
    
    func sendGift(giftImage: String, giftId: String, combo: String, cost: Int) {
        var consumerName = " "
        
        if let name = CustomerDetails.firstName {
            
            consumerName = name
        }
        
        var profileImage = " "
        
        if let picture = CustomerDetails.picture {
            
            profileImage = picture
        }
        var deviceUid = ""
        
        if let deviceId = Constants.DEVICE_ID {
            
            deviceUid = deviceId
        }
        
        var giftChannelName = "\(Constants.CELEB_ID).g.0"
        
        if let channelName = self.giftChannelnm {
            
            giftChannelName = channelName
        }
        
        let userGift = ["giftUrl": giftImage, "userUid": deviceUid, "giftComboCount": combo, "giftCost": "\(cost)", "userName": consumerName, "userProfilePic": profileImage, "userTimeStamp" : "\(time)"] as [String: Any]
        
        client.publish(userGift, toChannel: giftChannelName, withCompletion: nil)
        
        let gift: GiftEvent = GiftEvent(dict: userGift)
        self.sendGiftToServer(gift_id: giftId, quantity: "\(combo)", gift: gift)
        
    }
    
    func sendGiftToServer(gift_id: String, quantity: String, gift: GiftEvent) {
        let parameter = ["gift_id": gift_id, "total_quantity": quantity, "v": Constants.VERSION]
        self.giftArea.pushGiftEvent(gift)
        ServerManager.sharedInstance().postRequest(postData: parameter, apiName: Constants.SEND_GIFT, extraHeader: nil) { (result) in
            switch result {
            case .success(let data):
                print(data)
                if (data["error"] as? Bool == true) {
                    self.showToast(message: "Something went wrong. Please try again!")
                    return
                    
                } else {
                    guard data["status_code"].int == 200 else {
                        self.showToast(message: "Not Enough coins please recharge")
                        return
                    }
                    //                coins_after_purchase
                    if let updatedCoins = data["data"]["purchase"]["coins_after_txn"].int {
                        CustomerDetails.coins = updatedCoins
                        DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins)
                        CustomMoEngage.shared.updateMoEngageCoinAttribute()
                        let coinDict:[String: Int] = ["updatedCoins": updatedCoins]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: coinDict)
                    }
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK:- UIGestureRecognizerDelegate
extension LiveOverlayViewController : UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return touch.view?.tag == 5050
    }
}
//MARK:- UICollectionViewDataSource
extension LiveOverlayViewController : UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.usersCollectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath)
        
        cell.layer.cornerRadius = 10.0
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        
        imageView.image = UIImage.init(named: "AppIcon")
        imageView.roundCorners(corners: [.topLeft,.bottomLeft,.topRight,.bottomRight], radius: 10)
        cell.addSubview(imageView)
        
        return cell
    }
}

//MARK:- PNObjectEventListener
extension LiveOverlayViewController: PNObjectEventListener {
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        print("[pubnub msgs = \(message)")
        if message.data.channel != message.data.subscription {
            
        } else {
            
        }
        
        guard let dictMessage = message.data.message as? [String: Any] else {return}
        
        if let commentBox = dictMessage["COMMENT_BOX_VISIBLE"] as? Bool {
            
            if commentBox == true {
                
                enableCommentBox()
            }
            else {
                
                disableCommentBox()
            }
            
            return
        }
        
        if loadGifts {
            guard let giftData = message.data.message as? [String: Any] else {return}
            let giftObject = GiftEvent(dict: giftData)
            if giftObject.userUid == Constants.DEVICE_ID {return}
            self.giftArea.pushGiftEvent(giftObject)
            //            self.newMessage(message: message.data.message)
        }
    }
    
    public func newMessage(message: Any?)  {
        guard let messageData = message as? [String: Any] else {return}
        let comments = LiveComment(dict: messageData as [String : Any])
        if comments.userUid == Constants.DEVICE_ID { return }
        self.comments.append(comments)
        //        let reloadIndexPath = IndexPath(item: self.comments.count - 1, section: 0)
        //        self.tableView.beginUpdates()
        //        self.tableView.insertRows(at: [reloadIndexPath], with: .fade)
        //        self.tableView.endUpdates()
        //        self.scrollToBottom()
    }
    
    func scrollToBottom() {
        guard self.comments.count > 0 else {
            return
        }
        if self.tableView.contentSize.height > self.tableView.bounds.height {
            self.tableView.contentInset.top = 0
        }
        let lastRowIndex = self.tableView!.numberOfRows(inSection: 0) - 1
        if lastRowIndex >= 0 {
            let pathToLastRow = IndexPath.init(row: lastRowIndex, section: 0)
            self.tableView.scrollToRow(at: pathToLastRow, at: .none, animated: true)
        }
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout, state-change).
        if event.data.channel != event.data.subscription {
            
            // Presence event has been received on channel group stored in event.data.subscription.
        }
        else {
            
            // Presence event has been received on channel stored in event.data.channel.
        }
        
        if event.data.presenceEvent != "state-change" {
            //            self.numberOfViewsLabel.text = "\(event.data.presence.occupancy)"
            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) on \(event.data.channel) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
        else {
            
            print("\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) on \(event.data.channel) to:\n" +
                "\(event.data.presence.state)");
        }
    }
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        if status.operation == .subscribeOperation {
            
            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                
                if let subscribeStatus: PNSubscribeStatus = status as? PNSubscribeStatus {
                    if subscribeStatus.category == .PNConnectedCategory {
                        if  let targetChannel = client.channels().first {

                        }
                    }
                    else {
                    
                    }
                }
            }
            else if status.category == .PNUnexpectedDisconnectCategory {
                
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {
                
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {
                    
                    /**
                     This means that PAM does allow this client to subscribe to this channel and channel group
                     configuration. This is another explicit error.
                     */
                }
                else {
                    
                    /**
                     More errors can be directly specified by creating explicit cases for other error categories
                     of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                     `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                     or `PNNetworkIssuesCategory`
                     */
                }
            }
        }
    }
}

//MARK:- UITextFieldDelegate
extension LiveOverlayViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}

//MARK:- UITableview
extension LiveOverlayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! LiveCommentTableViewCell
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LiveCommentTableViewCell
        cell.comment = comments[(indexPath as NSIndexPath).row]
        cell.contentView.clipsToBounds = true
        return cell
    }
}

//MARK:- CommentCell
class CommentCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentContainer: UIView!
    
    var comment: LiveComment! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentContainer.layer.cornerRadius = 3
    }
    
    func updateUI() {
        //        titleLabel.attributedText = comment.text.attributedComment()
        titleLabel.text = comment.text
    }
    
}

extension UITextField {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.paste(_:)) ?
            false : super.canPerformAction(action, withSender: sender)
    }
}

// MARK: - SendCallRequst Delegate Methods
extension LiveOverlayViewController: SendCallRequestDelegate {
    
    func sendRequestWith(type: AgoraRTMConnection.commercialType, requestId: String) {
        
        delegate?.didSelectedSingleVideoCall(type: type, requestId: requestId)
    }
    
    func didSelectedTermsConditions() {
        
        shouldShowCallRequest = true
        delegate?.didSelectedTermsConditions()
    }
    
    func didSelectedPrivacyPolicy() {
        
        shouldShowCallRequest = true
        delegate?.didSelectedPrivacyPolicy()
    }
    
    func didFoundLowBalance() {
        
        delegate?.didFoundLowBalance()
    }
    
    func didSelectNavigation(title: String) {
        viewDidDisappear(false)
        viewWillDisappear(false)
        delegate?.didSelectNavigation(title: title)
    }
    
}

// MARK: - Segue Methods
extension LiveOverlayViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "callRequest" {
            
            if viewCallRequest?.timerSendRequestTimeout == nil {
                
                return true
            }
            else {
                
                utility.showToast(msg: stringConstants.msgCallRequestInQueue)
                
                return false
            }
        }
        
        return true
    }
}

// MARK: - Enable / Disable Comment Box Methods
extension LiveOverlayViewController {
    
    func enableCommentBox() {
        
        self.textField.attributedPlaceholder = NSAttributedString(string: "Comment...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: ShoutoutFont.light.withSize(size: .small)])
        self.sendContentView.isHidden = false
        self.emojiScrollView.isHidden = false
        self.inputContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.inputContainer.isUserInteractionEnabled = true
    }
    
    func disableCommentBox() {
        
        self.textField.attributedPlaceholder = NSAttributedString(string: "Comments disabled", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: ShoutoutFont.light.withSize(size: .small)])
        self.sendContentView.isHidden = true
        self.emojiScrollView.isHidden = true
        self.view.endEditing(true)
        self.inputContainer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.inputContainer.isUserInteractionEnabled = false
    }
}

