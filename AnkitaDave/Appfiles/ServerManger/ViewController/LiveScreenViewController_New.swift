//
//  LiveScreenViewController_New.swift
//  AnveshiJain
//
//  Created by developer2 on 14/06/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit
import AgoraRtcKit
import IQKeyboardManagerSwift
import StoreKit
import AgoraRtmKit
import Pulley
import Alamofire

//MARK:- LiveSchedulerView
protocol  getDataDelegate  {
    func getDataFromTermsVC()
    func getDataFromPrivacyVC()
}
class LiveSchedulerView: UIScrollView {

    @IBOutlet weak var imgViewEventPic: UIImageView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblScheduledDate: UILabel!
    @IBOutlet weak var lblScheduledTime: UILabel!
    @IBOutlet weak var viewScheduled: UIView!
    @IBOutlet weak var lblRemainingDays: UILabel!
    @IBOutlet weak var lblRemainigHours: UILabel!
    @IBOutlet weak var lblRemainigMin: UILabel!
    @IBOutlet weak var lblRemainigSec: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var lblCast: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewCotent: UIView!
    @IBOutlet weak var policybutton: UIButton!
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var viewTermsCondCotent: UIView!
    @IBOutlet weak var viewRemainingTime: UIView!
    @IBOutlet weak var lblRemainingTimeLabel: UILabel!
    @IBOutlet weak var timeRemainingTimeLabel: UILabel!
    
  
    var isChannelLive = false
    var eventDetails: LiveEventModel? = nil
    var timerRemaining: Timer? = nil
    var timerRemainingCounter = 0
    var dateScheduled: Date? = nil
    var delegateCustom : getDataDelegate?
    let IST: TimeInterval = 19800
    var dateInCurrentZone: Date? = nil

    // MARK: - Utility Methods
    //    func setInitMethod()  { //test method
    //        viewCotent.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: viewCotent.frame.size.height)
    //        self.contentSize = viewCotent.frame.size
    //        self.addSubview(viewCotent)
    //    }
    func setDetails(event: LiveEventModel) {

        viewCotent.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.contentSize = viewCotent.frame.size
        self.addSubview(viewCotent)

        if !isChannelLive {

            btnPay.isHidden = true
            viewTermsCondCotent.isHidden = true
        }

        self.eventDetails = event

        imgViewEventPic.layer.cornerRadius = imgViewEventPic.frame.size.height/2
        imgViewEventPic.layer.borderColor = UIColor.white.cgColor
        imgViewEventPic.layer.borderWidth = 1.0
        imgViewEventPic.layer.masksToBounds = true

        viewScheduled.layer.cornerRadius = 4.0
        viewScheduled.layer.masksToBounds = true

        btnPay.layer.cornerRadius = 4.0
        btnPay.layer.masksToBounds = true

        if let photo = event.photo {

            if let small = photo.small {

                imgViewEventPic.sd_setImage(with: URL(string: small), completed: nil)
            }
        }

        if let name = event.name {

            lblEventName.text = name
        }

        if let scheduledDate = event.schedule_at {

            if let date = getDateFromString(strDate: scheduledDate) {

                self.dateScheduled = date

                if let strDate = getDateStringFromDate(date: date) {

                    lblScheduledDate.text = strDate
                }

                if let strTime = getTimeStringFromDate(date: date) {

                    lblScheduledTime.text = "at " + strTime + " (IST)"
                }

                dateInCurrentZone = getDateFromStringInCurrent(strDate: scheduledDate)

                self.setupRemainingDuration()
                startTimerRemaining()
            }
        }

        if let coins = event.coins {
            if coins == 0 {
                btnPay.setTitle("Enter Room", for: UIControl.State.normal)
            } else {
                btnPay.setTitle(" PAY \(coins) COINS NOW", for: UIControl.State.normal)
            }

        }

        if let arrCasts = eventDetails?.casts {

            var strCasts = ""

            if arrCasts.count == 0 {
                lblCast.text = ""
            } else {
                for cast in arrCasts {

                    if strCasts.count > 0 {

                        strCasts = strCasts + ", "
                    }

                    if let fname = cast.first_name?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {

                        strCasts = strCasts + fname
                    }
                    if let lname = cast.last_name?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {

                        strCasts = strCasts + " " + lname
                    }
                }

                lblCast.text = "Cast: " + strCasts
            }

        }
        else {

            lblCast.text = ""
        }

        if let desc = self.eventDetails?.desc {

            lblDesc.text = desc
        }
        else {

            lblDesc.text = ""
        }
    }
    @IBAction func termsconditions(_ sender: UIButton) {
        delegateCustom?.getDataFromTermsVC()

       }
    @IBAction func policyBtnAction(_ sender: Any) {
        delegateCustom?.getDataFromPrivacyVC()

       }
    func setupRemainingDuration() {

        let diff = getDateDiff(date: self.dateInCurrentZone!)

        lblRemainingDays.text = numberToString(diff.days)
        lblRemainigHours.text = numberToString(diff.hours)
        lblRemainigMin.text = numberToString(diff.minutes)
        lblRemainigSec.text = numberToString(diff.seconds)

        if diff.days <= 0 && diff.hours <= 0 && diff.minutes <= 0 && diff.seconds <= 0 {

            stopTimerRemaining()

            viewRemainingTime.isHidden = true
            lblRemainingTimeLabel.isHidden = true
            timeRemainingTimeLabel.isHidden = true
        }
    }

    func getCurrentDate() -> Date {

        let date = Date()

        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: date))

        let diff = IST - seconds

        return Date(timeInterval: diff, since: date)
    }

    func getDateFromString(strDate: String) -> Date? {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        formatter.timeZone = TimeZone.current"

        return formatter.date(from: strDate)
    }

    func getDateFromStringInCurrent(strDate: String) -> Date? {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "IST")

        return formatter.date(from: strDate)
    }

    func getDateStringFromDate(date: Date) -> String? {

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        //        formatter.timeZone = TimeZone.current

        return formatter.string(from: date)
    }

    func getTimeStringFromDate(date: Date) -> String? {

        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        //        formatter.timeZone = TimeZone.current

        return formatter.string(from: date)
    }

    func getDateDiff(date: Date) -> (days: Int, hours: Int,minutes: Int, seconds: Int) {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]

        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: Date(), to: date)

        return (difference.day!, difference.hour!, difference.minute!, difference.second!)
    }

    func startTimerRemaining() {

        stopTimerRemaining()
        timerRemaining = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerRemaining), userInfo: nil, repeats: true)
    }

    func stopTimerRemaining() {

        if timerRemaining != nil {

            if timerRemaining!.isValid {

                timerRemaining?.invalidate()
                timerRemaining = nil
            }
        }
    }

    @objc func updateTimerRemaining() {

        self.setupRemainingDuration()
    }

    func numberToString(_ number: Int) -> String {

        if abs(number) > 9 {

            return "\(number)"
        }
        else if number < 0 {

            return "\(number)"
        }
        else {

            return "0\(number)"
        }
    }
}

//MARK:- CLASS LiveScreenViewController_New
class LiveScreenViewController_New: BaseViewController,getDataDelegate {
   
    var pubPublishKey = String()
    var pubSubscribeKey = String()
    var giftchannelnm = String()
    var commentchannelnm = String()

    
    func getDataFromPrivacyVC() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
           resultViewController.navigationTitle = "Privacy Policy"
           resultViewController.openUrl = artistConfig.static_url?.privacy_policy
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }

    func getDataFromTermsVC() {
                   CustomMoEngage.shared.sendEventUIComponent(componentName: "Register_Term_n_condtn", extraParamDict: nil)
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                   resultViewController.navigationTitle = "Terms & Conditions"
                   resultViewController.openUrl = artistConfig.static_url?.terms_conditions

        self.navigationController?.pushViewController(resultViewController, animated: false)
    }
    @IBOutlet weak var remoteContainerView: UIView!
    @IBOutlet weak var containerControls: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewChannelClosed: UIView!
    @IBOutlet weak var lblChannelClosedDesc: UILabel!
    @IBOutlet weak var btnChannelClosed: UIButton!

    var overlayVC: LiveOverlayViewController? = nil

    var agoraToken : String? = nil
    //    var agoraUid : UInt? = nil
    var agoraUid : Int64? = nil
    var rtmToken: String = ""

    let viewLayouter = VideoViewLayouter()

    var timerForChannel: Timer? = nil

    var videoSessions = [VideoSession]() {
        didSet {
            guard remoteContainerView != nil else {
                return
            }
            updateInterface(withAnimation: true)
        }
    }

    var fullSession: VideoSession? {
        didSet {
            if fullSession != oldValue && remoteContainerView != nil {
                updateInterface(withAnimation: true)
            }
        }
    }

    @IBOutlet weak var viewScheduler: LiveSchedulerView!

    var liveEvent: LiveEventModel? = nil
    var isChannelLive = false
    var customLoader: CustomLoaderViewController?

    var isComingFromLiveButton: Bool = false
    var liveAgoraData: [String: Any] = [String: Any]()

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        viewScheduler.isHidden = true
        viewScheduler.delegateCustom = self
        lblChannelClosedDesc.text = Constants.AgoraChannleClosed

        viewChannelClosed.isHidden = true
        btnChannelClosed.layer.cornerRadius = btnChannelClosed.bounds.size.height/2
        btnChannelClosed.layer.masksToBounds = true

        btnBack.layer.cornerRadius = btnBack.frame.size.height/2
        btnBack.layer.masksToBounds = true

        self.containerControls.isHidden = true
        setInitForCustomLoader()
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.inAppPackages.rawValue)

        self.startAgoraEngine()

        if isComingFromLiveButton {
            handleLive()
        } else {
            checkAgoraChannelExist()
        }

        self.navigationController?.isNavigationBarHidden = true;

        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChangedNotification(notification:)), name: .reachabilityChanged, object: nil)
    }

    func setInitForCustomLoader() {
        customLoader = Storyboard.main.instantiateViewController(viewController: CustomLoaderViewController.self)
    }

    func showCustomLoader() {
        DispatchQueue.main.async {
            if self.customLoader != nil {
                self.view.addSubview(self.customLoader!.view)
            }
        }
    }

    func removeCustomLoader() {
        DispatchQueue.main.async {
            if self.customLoader != nil {
                self.customLoader?.view.removeFromSuperview()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        IQKeyboardManager.shared.enableAutoToolbar = false
        UIApplication.shared.isIdleTimerDisabled = true
//        self.view.setGradientBackground()
        self.navigationController?.isNavigationBarHidden = true;
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)

        IQKeyboardManager.shared.enableAutoToolbar = true
        UIApplication.shared.isIdleTimerDisabled = false

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - IBActions
    @IBAction func closeBtnClicked() {

        var isInCall = false

        for session in videoSessions {

            if session.uid == 0 {

                isInCall = true
            }
        }

        if isInCall {

            utility.alert(title: "Confirmation", message: stringConstants.msgCutCall, delegate: self, buttons: [stringConstants.yes], cancel: stringConstants.no) { [weak self] (btn) in

                if btn == stringConstants.yes {
                    self?.closeSession()
                }
            }
        }
        else {

            closeSession()
        }
    }

    // MARK: - Utility Methods
    func closeSession(feedbackRequired: Bool = true) {

        self.view.endEditing(true)
        leaveChannel()

        if feedbackRequired {
            self.navigationController?.popViewController(animated: true)
        }

        if viewChannelClosed.isHidden == false {

            if feedbackRequired {
                NotificationCenter.default.post(name: NSNotification.Name.init(Constants.LIVE_FEEDBACK), object: self.liveEvent)
            }

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
        }
    }

    func showChannelNotFoundAlert() {

        self.view.endEditing(true)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)

        if self.agoraToken != nil {
            showChannelClosedScreen()
            return
        }

        addGestures()
        viewScheduler.isHidden = true
        viewChannelClosed.isHidden = true
        self.overlayVC?.showNoChannel()
        self.containerControls.isHidden = false
    }

    func startTimerForChannel() {

        stopTimerForChannel()
        timerForChannel = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateChannelDetails), userInfo: nil, repeats: true)
    }

    @objc func updateChannelDetails() {

        checkAgoraChannelExist()
    }

    func stopTimerForChannel() {

        if timerForChannel != nil {

            if timerForChannel!.isValid {

                timerForChannel?.invalidate()
                timerForChannel = nil
            }
        }
    }

    func showChannelClosedScreen() {

        viewChannelClosed.isHidden = false
        self.view.bringSubviewToFront(viewChannelClosed)
        leaveChannel()
        //        if #available( iOS 10.3,*) {
        //            SKStoreReviewController.requestReview()
        //        }


    }

    @objc func reachabilityChangedNotification(notification: Notification) {

        print("rechabilityChangedNotification ---------->")

        let reachability = notification.object as! Reachability

        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }

    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "overlaySegue" {

            if let vc = segue.destination as? LiveOverlayViewController {

                self.overlayVC = vc
                self.overlayVC?.delegate = self
                self.overlayVC?.viewCallRequest?.delegate = self
                self.overlayVC?.liveController = self
            }
        }
    }
}

// MARK: - WebService Methods
extension LiveScreenViewController_New {

    func getUpcomingLiveEvents() {
        //        let apiName = "https://apistg.apmedia.app/api/1.0/" + Constants.WEB_UPCOMING_LIVE_EVENTS + "artist_id=\(Constants.CELEB_ID)" + "&platform=ios" + "&v=\(Constants.VERSION)"
        let apiName = Constants.App_BASE_URL + Constants.WEB_UPCOMING_LIVE_EVENTS + "artist_id=\(Constants.CELEB_ID)" + "&platform=ios" + "&v=\(Constants.VERSION)"
        print("api name = \(apiName)")
        if Reachability.isConnectedToNetwork() {

            self.showCustomLoader()

            ServerManager.sharedInstance().getRequestFromUpcomingEvent(postData: nil, apiName: apiName, extraHeader: nil) { (result) in

                DispatchQueue.main.async {

                    self.removeCustomLoader()

                    switch result {
                    case .success(let data):
                        print("data for Upcoming event => : \(data)")

                        if let dictData = data["data"].object as? [String:Any] {
                            if let arrlist = dictData["list"] as? [[String:Any]] {
                                if arrlist.count == 0 {
                                    //Normal board cast
                                    if self.isChannelLive {
                                        self.getAgoraToken()
                                    } else {
                                        self.showChannelNotFoundAlert()
                                    }

                                } else {
                                    if let dictSchedule = arrlist.first {

                                        if let liveEvent = LiveEventModel.object(dictSchedule) {

                                            self.liveEvent = liveEvent

                                            print(liveEvent.name!)

                                            if GlobalFunctions.checkContentPurchaseLiveId(id: liveEvent.id!) && self.isChannelLive && self.liveEvent?.coins != 0
                                            {

                                                self.getAgoraToken()
                                            }
                                            else {

                                                self.showSchedulerScreen(event: liveEvent)
                                            }
                                            if let comment_box = self.liveEvent?.comment_box, comment_box == true {
                                                
                                                self.overlayVC?.enableCommentBox()
                                            }
                                            else {
                                                
                                                self.overlayVC?.disableCommentBox()
                                            }
                                        }
                                        else {

                                            // No Event
                                            self.overlayVC?.disableCommentBox()
                                            self.showChannelNotFoundAlert()
                                        }
                                    }
                                    else {

                                        // No Event
                                        self.overlayVC?.disableCommentBox()
                                        self.showChannelNotFoundAlert()
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        print(error)
                       // self.showToast(message: "Oops! Something went wrong. Please try again!")
                    }
                    
//                    if let comment_box = self.liveEvent?.comment_box, comment_box == true {
//
//                        self.overlayVC?.enableCommentBox()
//                    }
//                    else {
//
//                        self.overlayVC?.disableCommentBox()
//                    }
                }
            }
        }
        else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }

    func checkAgoraChannelExist() {

        let apiName = Constants.WEB_CHECK_AGORA_CHANNEL + "\(artistConfig.agora_id ?? "")" + "/\(artistConfig.channel_namespace ?? "")"

        if Reachability.isConnectedToNetwork() {

            if self.agoraToken == nil {
                self.showCustomLoader()
            }

            ServerManager.sharedInstance().getRequestAgora(postData: nil, apiName: apiName, extraHeader: nil) { (result) in

                DispatchQueue.main.async {

                    if self.agoraToken == nil {
                        self.removeCustomLoader()
                    }

                    switch result {
                    case .success(let data):
                        print("Check agora channel exits => : \(data)")

                        if let dictData = data["data"].dictionaryObject {

                            if let channel_exist = dictData["channel_exist"] as? Bool {

                                if channel_exist == true {

                                    if let arrBroadcasters = dictData["broadcasters"] as? [Any] {

                                        if arrBroadcasters.count > 0 {

                                            print("channel is live --------------->>>>")

                                            self.showChannelDetails(dictData)
                                            self.isChannelLive = true
                                            if self.agoraToken == nil {
                                                self.getUpcomingLiveEvents()
                                            }
                                        }
                                        else {
                                            self.isChannelLive = true
                                            if self.agoraToken == nil {
                                                self.getUpcomingLiveEvents()
                                            }
                                            else {
                                                self.showChannelNotFoundAlert()
                                            }
                                        }
                                    }
                                    else {

                                        if self.agoraToken == nil {
                                            self.getUpcomingLiveEvents()
                                        }
                                        else {
                                            self.showChannelNotFoundAlert()
                                        }
                                    }
                                }
                                else {

                                    if self.agoraToken == nil {
                                        self.getUpcomingLiveEvents()
                                    }
                                    else {
                                        self.showChannelNotFoundAlert()
                                    }
                                }
                            }
                            else
                            {
                                if self.agoraToken == nil {
                                    self.getUpcomingLiveEvents()
                                }
                                else {
                                    self.showChannelNotFoundAlert()
                                }
                            }
                        }
                        else {

                            if self.agoraToken == nil {
                                self.getUpcomingLiveEvents()
                            }
                            else {
                                self.showChannelNotFoundAlert()
                            }
                        }

                        self.containerControls.isHidden = false

                    case .failure(let error):
                        print(error)

                        //self.showToast(message: Constants.NO_Internet_MSG)
                    }
                }
            }
        }
        else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }

    func handleLive() {

        DispatchQueue.main.async {
            if UserDefaults.standard.bool(forKey: "liveStatus") {
                self.overlayVC?.showHideViews(flag: false)
                self.showChannelDetails(self.liveAgoraData)
                self.isChannelLive = true
                if self.agoraToken == nil {
                    self.getUpcomingLiveEvents()
                }
            } else {
                self.overlayVC?.showHideViews(flag: true)
      //          self.isChannelLive = true
                if self.agoraToken == nil {
                    self.getUpcomingLiveEvents()
                } else {
                    self.showChannelNotFoundAlert()
                }
            }
            self.containerControls.isHidden = false
        }
    }

    func getAgoraToken() {

            //        let randomInt = UInt.random(in: 0..<100000)

            //        let apiName = Constants.WEB_GET_AGORA_ACCESS_TOKEN + "?channel=\(channelName)" + "&artist_id=\(Constants.CELEB_ID)" + "&customer_id=\(randomInt)" + "&v=\(Constants.VERSION)" + "&platform=ios"

        let apiName = Constants.WEB_GET_AGORA_ACCESS_TOKEN_NEW + "?channel=\(artistConfig.channel_namespace!)" + "&artist_id=\(Constants.CELEB_ID)" + "&v=\(Constants.VERSION)" + "&platform=ios" +
                "&customer_id=\(CustomerDetails.custId ?? "")"

        print(apiName)
            if Reachability.isConnectedToNetwork() {

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveStarted"), object: nil)

                self.showCustomLoader()

                ServerManager.sharedInstance().getRequest(postData: nil, apiName: apiName, extraHeader: nil) { (result) in

                    DispatchQueue.main.async { [self] in

                        self.removeCustomLoader()

                        switch result {
                        case .success(let data):
                            print("get agora token => : \(data)")

                            if let dictData = data["data"].dictionaryObject {

    //                             if let token = dictData["token"] as? String, let uid = dictData["uid"] as? Int64 {

                                if let token = dictData["access_token"] as? String, let uid = dictData["customer_uid"] as? Int64, let rtmToken = dictData["rtm_token"] as? String {

                                    self.overlayVC?.removeNoChannelView()
                                    self.containerControls.isHidden = false
                                    self.viewScheduler.isHidden = true
                                    
                                    self.giftchannelnm = dictData["gift_channel"] as? String ?? ""
                                    
                                    self.commentchannelnm = dictData["comment_channel"] as? String ?? ""
                                    
                                    self.pubPublishKey = dictData["pubnub_publish_key"] as? String ?? ""
                                  
                                    self.pubSubscribeKey = dictData["pubnub_subcribe_key"] as? String ?? ""
                                
                                   
                                    
                                   self.getAuthKey()
                              //     self.overlayVC?.joinPubNub()

                                    self.rtmToken = rtmToken
                                    self.setupRTMConnection()

                                    self.agoraToken = token
                                    //self.agoraUid = randomInt
                                    self.agoraUid = uid
                                    self.loadAgoraKit()
                                }
                            }
                        case .failure(let error):
                            print(error)

                            self.showToast(message: "There might be some problem on server, Please try again later.")
                        }
                    }
                }
            }
            else
            {
                self.showToast(message: Constants.NO_Internet_MSG)
            }
        }
    
    func getAuthKey()
    {
       
        let strChannelName = "\(self.giftchannelnm),\(self.commentchannelnm)"
       
        let authurl = Constants.App_BASE_URL + "accounts/pubnub/aggregator/dynamickey?artist_id=\(Constants.CELEB_ID)&platform=ios&v=1.1&product=apm&channel=\(strChannelName)"
        
        print(authurl)
       // CustomerDetails.giftChannelName
        let header = [
            "apiKey" : Constants.API_KEY,
               
            "Authorization" : Constants.TOKEN,
                     
            "Product" : "apm"]
        
        Alamofire.request(authurl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let alldata = resp.result.value as? NSDictionary
                if let data = alldata?["data"] as? NSDictionary
                {
                   let auth_key = data["auth_key"] as! String
                    print("authkey = \(auth_key)")
                    
                self.overlayVC?.setPubvalues(publishkey: self.pubPublishKey, subscribekey: self.pubSubscribeKey, giftnm: self.giftchannelnm, commentnm: self.commentchannelnm)
                    
                   self.overlayVC?.joinPubNub(authkey: auth_key)
                
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)
              //  self.getAuthKey()
                break
            }
             
        }
      
    }
    
}

// MARK: - Agora Utility Methods
extension LiveScreenViewController_New {

    func showSchedulerScreen(event: LiveEventModel) {
        addGestures()
        viewScheduler.isHidden = false
        viewScheduler.btnPay.addTarget(self, action: #selector(self.payBtnClicked), for: UIControl.Event.touchUpInside)
        viewScheduler.isChannelLive = self.isChannelLive
        viewScheduler.setDetails(event: event)
    }

    func showChannelDetails(_ dictData: [String: Any]) {

        var isChannelExist = false

        if let audience_total = dictData["audience_total"] as? Int64{
            overlayVC?.currentTotalUsers = audience_total
            overlayVC?.showAudienceCount()
        }

        if var arrBroadcasters = dictData["broadcasters"] as? [Int] {

            if self.agoraUid != nil {
                arrBroadcasters.removeAll(where: { $0 == self.agoraUid!})
            }

            if arrBroadcasters.count > 0 {
                isChannelExist = true
            }
        }

        if isChannelExist == false {

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)

            showChannelClosedScreen()
        }
    }

    func leaveChannel() {

        stopTimerForChannel()

        setIdleTimerActive(true)

        self.agoraEngine?.setupLocalVideo(nil)
        self.agoraEngine?.leaveChannel(nil)

        for session in videoSessions {
            session.hostingView.removeFromSuperview()
        }
        videoSessions.removeAll()

        leaveRTMConnetion()
    }

    func updateInterface(withAnimation animation: Bool) {
        if animation {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.updateInterface()
                self?.view.layoutIfNeeded()
            })
        } else {
            updateInterface()
        }
    }

    func updateInterface() {

        var displaySessions = videoSessions

        if !displaySessions.isEmpty {
//            displaySessions.removeFirst()
        }

        viewLayouter.layout(sessions: displaySessions, fullSession: fullSession, inContainer: remoteContainerView)

        setStreamType(forSessions: displaySessions, fullSession: fullSession)
        //        highPriorityRemoteUid = highPriorityRemoteUid(in: displaySessions, fullSession: fullSession)
    }

    func setStreamType(forSessions sessions: [VideoSession], fullSession: VideoSession?) {
        if let fullSession = fullSession {
            for session in sessions {
                if session == fullSession {
                    self.agoraEngine?.setRemoteVideoStream(fullSession.uid, type: .high)
                } else {
                    self.agoraEngine?.setRemoteVideoStream(session.uid, type: .low)
                }
            }
        } else {
            for session in sessions {
                self.agoraEngine?.setRemoteVideoStream(session.uid, type: .high)
            }
        }
    }

    func loadAgoraKit() {

        startTimerForChannel()
        self.agoraEngine?.delegate = self
        self.agoraEngine?.setChannelProfile(.liveBroadcasting)

        // Warning: only enable dual stream mode if there will be more than one broadcaster in the channel
        self.agoraEngine?.enableDualStreamMode(false)

        self.agoraEngine?.enableVideo()

        let config = AgoraVideoEncoderConfiguration(
            size: AgoraVideoDimension1280x720,
            frameRate: .fps15,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .fixedPortrait
        )

        self.agoraEngine?.setVideoEncoderConfiguration(config)

        self.agoraEngine?.setClientRole(AgoraClientRole.audience)

        //        if isBroadcaster {
        //            rtcEngine.startPreview()
        //        }

//        addLocalSession()

        let code = self.agoraEngine?.joinChannel(byToken: agoraToken!, channelId: artistConfig.channel_namespace!, info: nil, uid: UInt(self.agoraUid!)) { (channel, uid, elapsed) in

            print("channel=\(channel), uid=\(uid), elapsed=\(elapsed)")

            self.stopLoader()
        }

        if code == 0 {
            setIdleTimerActive(false)
            self.agoraEngine?.setEnableSpeakerphone(true)
        } else {
            DispatchQueue.main.async(execute: {
                if let code = code {
                    self.showToast(message: "Join channel failed: \(code)")
                }
            })
        }
    }

    func addLocalSession() {

        let localSession = VideoSession.localSession()
        videoSessions.append(localSession)
        self.agoraEngine?.setupLocalVideo(localSession.canvas)
    }

    func setIdleTimerActive(_ active: Bool) {

        UIApplication.shared.isIdleTimerDisabled = !active
    }

    func videoSession(ofUid uid: UInt) -> VideoSession {
        if let fetchedSession = fetchSession(ofUid: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid)
            videoSessions.append(newSession)
            return newSession
        }
    }

    func fetchSession(ofUid uid: UInt) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }

        return nil
    }
}

// MARK: - AgoraEngine Delegate Methods
extension LiveScreenViewController_New: AgoraRtcEngineDelegate {

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {

        if errorCode == .invalidChannelId
        {
            print("no broadcasting found")
        }

        print("didOccurError = \(errorCode)")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionStateType, reason: AgoraConnectionChangedReason) {

        print("connectionChangedTo")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {

        print("didLeaveChannelWith")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {

        print("didOccurWarning = \(warningCode)")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute error: Int, api: String, result: String) {

        print("didApiCallExecute error= \(error), api= \(api), result= \(result)")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {

        let userSession = videoSession(ofUid: uid)
        self.agoraEngine?.setupRemoteVideo(userSession.canvas)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        if let _ = videoSessions.first {
            updateInterface(withAnimation: false)
        }
    }

    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {

        print("rtcEngineConnectionDidLost")
    }

    func rtcEngineRequestToken(_ engine: AgoraRtcEngineKit) {

        print("rtcEngineRequestToken")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole) {

        print("didClientRoleChanged")

        if newRole == .audience {

            var indexToDelete: Int?
            for (index, session) in videoSessions.enumerated() {

                if session.uid == UInt(self.agoraUid!) || session.uid == 0 {
                    indexToDelete = index
                }
            }

            if let indexToDelete = indexToDelete {
                let deletedSession = videoSessions.remove(at: indexToDelete)
                deletedSession.hostingView.removeFromSuperview()

                if deletedSession == fullSession {
                    fullSession = nil
                }
            }
        }
        else {

            addLocalSession()

            updateBalanceForRequestCall()
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {

        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() {
            if session.uid == uid {
                indexToDelete = index
            }
        }

        if let indexToDelete = indexToDelete {
            let deletedSession = videoSessions.remove(at: indexToDelete)
            deletedSession.hostingView.removeFromSuperview()

            if deletedSession == fullSession {
                fullSession = nil
            }
        }

        if videoSessions.count == 1 {

            if let session = videoSessions.first, session.uid == 0 {

                endCall()

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)

                showChannelClosedScreen()
            }
        }
        else {

            if videoSessions.count == 0 {

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)

                showChannelClosedScreen()
            }
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, networkTypeChangedTo type: AgoraNetworkType) {

        if type == .disconnected {

            self.agoraEngine?.setClientRole(AgoraClientRole.audience)
        }
    }
}
// MARK: - Swipe Gesture Methods
extension LiveScreenViewController_New {

    func addGestures() {

        let swipeDownGes = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture(gesture:)))
        swipeDownGes.direction = .down
        self.overlayVC?.view.addGestureRecognizer(swipeDownGes)

        let schedulerViewSwipeDownGes = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture(gesture:)))
        schedulerViewSwipeDownGes.direction = .down
        self.viewScheduler.addGestureRecognizer(schedulerViewSwipeDownGes)
    }

    @objc func swipeDownGesture(gesture: UISwipeGestureRecognizer) {

        if gesture.direction == .down {

            self.closeBtnClicked()
        }
    }

    func removeGestures() {


    }
}
// MARK: - Pay Methods
extension LiveScreenViewController_New: PurchaseContentProtocols {
    func contentPurchaseSuccessful() {
        Constants.setPurchasedEventId(viewScheduler.eventDetails!.id!)
        self.getAgoraToken()

        removeGestures()
    }

    func contentFunished() {


    }

    @objc func payBtnClicked() {

        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            return
        }

        guard let contentId = viewScheduler.eventDetails?.id, let coins = viewScheduler.eventDetails?.coins else {

            print("-------- No enough details ------------")
            return
        }

        if coins == 0 {
            self.getAgoraToken()
        } else {
            if !GlobalFunctions.checkContentPurchaseLiveId(id: contentId) {

                /*let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
                self.addChild(popOverVC)
                popOverVC.delegate = self
                popOverVC.contentIndex = 0
                popOverVC.isComingFrom = "live_event_purchase"
                popOverVC.contentId = contentId
                popOverVC.coins = Int(coins)
                popOverVC.contentName = viewScheduler.eventDetails?.name ?? ""
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)*/
                let popOverVC = Storyboard.main.instantiateViewController(viewController: PurchaseLiveViewController.self)
                self.addChild(popOverVC)
                popOverVC.delegate = self
                popOverVC.contentId = contentId
                popOverVC.coins = Int(coins)
                popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        }
    }
}

// MARK: - Purchase Delegate Methods
extension LiveScreenViewController_New: PurchaseContentProtocol {

    func rechargeCoinsPopPop() {

        let coins = ArtistConfiguration.sharedInstance().oneToOne?.coins ?? 0

        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
        self.addChild(popOverVC)
        popOverVC.delegate = self
        popOverVC.isComingFrom = "call_request"
        popOverVC.coins = Int(coins)
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(popOverVC.view)
        popOverVC.hideRightBarButtons = true
        popOverVC.didMove(toParent: self)
    }

    func contentPurchaseSuccessful(index: Int, contentId: String?) {

    }
}

// MARK: - Overlay Delegate Methods
extension LiveScreenViewController_New: liveOvelayPrototcol {

    func didSelectNavigation(title: String) {

        closeSession(feedbackRequired: false)

        let bucketIndex: Int = GlobalFunctions.findIndexOfBucketCode(code: title) ?? -1

        if bucketIndex > -1 {
            if bucketIndex < 5 {

                if let tab = navigationController?.viewControllers.last as? CustomTabViewController {
                    tab.tabBar.isHidden = false
                    tab.selectedIndex = bucketIndex
                    tab.navigationItem.title = tab.tabMenuArray[bucketIndex].caption ?? ""
                } else if let tab = navigationController?.viewControllers.filter( { $0 is CustomTabViewController}).first as? CustomTabViewController {
                    tab.tabBar.isHidden = false
                    tab.selectedIndex = bucketIndex
                    tab.navigationItem.title = tab.tabMenuArray[bucketIndex].caption ?? ""
                    self.navigationController?.popToViewController(tab, animated: false)
                }
            } else {

//                if let tab = navigationController?.viewControllers.last as? CustomTabViewController {
//                    tab.tabBar.isHidden = false
//                    tab.selectedIndex = 4
//                    tab.navigationItem.title = tab.tabMenuArray[4].caption ?? ""
//                } else if let tab = navigationController?.viewControllers.filter( { $0 is CustomTabViewController}).first as? CustomTabViewController {
//                    tab.tabBar.isHidden = false
//                    tab.selectedIndex = 4
//                    tab.navigationItem.title = tab.tabMenuArray[4].caption ?? ""
//                    self.navigationController?.popToViewController(tab, animated: false)
//                }
                if title == "shoutout" {
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
                    self.navigationController?.pushViewController(pulleyController, animated: false)
                } else if title == "directline" {
                    let wardrobeVC = Storyboard.main.instantiateViewController(viewController: DirectLinkViewController.self)
                    self.navigationController?.pushViewController(wardrobeVC, animated: false)
                } else if title == "wardrobe" {
                   let headerPlayerController = Storyboard.wardrobe.instantiateViewController(viewController: HeaderVideoPlayerViewController.self)
                    headerPlayerController.playerSate = .fromWadrable

                    let wardrobeVC = Storyboard.wardrobe.instantiateViewController(viewController: WardrobeViewController.self)
                    wardrobeVC.stateChangeClouser = { state in
                        headerPlayerController.changeSoundStatus(with: state)
                    }

                    let pulleyController = PulleyViewController(contentViewController: headerPlayerController, drawerViewController: wardrobeVC)
                    pulleyController.drawerCornerRadius = 20
                    self.navigationController?.pushViewController(pulleyController, animated: false)
                }
            }
        }
    }


    func didFoundLowBalance() {

        rechargeCoinsPopPop()
    }

    func didSelectedSingleVideoCall(type: AgoraRTMConnection.commercialType, requestId: String) {

        AgoraRTMConnection.shared.sendInvitation(to: Constants.CELEB_ID, type: AgoraRTMConnection.InvitationType.oneToone, requestType: type, requestId: requestId)
    }

    func didSelectedTermsConditions() {

        showTermaPrivacy(isTerms: true)
    }

    func didSelectedPrivacyPolicy() {

        showTermaPrivacy(isTerms: false)
    }

    func showTermaPrivacy(isTerms: Bool) {

        let termeAndCond = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)

        if isTerms {

            termeAndCond.navigationTitle = "Terms & Conditions"

            termeAndCond.openUrl = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ?? ""
        }
        else {

            termeAndCond.navigationTitle = "Privacy Policy"

            termeAndCond.openUrl = ArtistConfiguration.sharedInstance().static_url?.privacy_policy ?? ""
        }

//        termeAndCond.hideRightBarButtons = true

//        let navVC = UINavigationController(rootViewController: termeAndCond)

//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        self.present(navVC, animated: true, completion: nil)

        self.navigationController?.pushViewController(termeAndCond, animated: true)
    }

    func isLiveStarted() {


    }

    func didSelectedSingleVideoCall() {


    }



    func gotoVideoCall(channelId: String) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let singleVC = storyboard.instantiateViewController(withIdentifier: "VideoChatViewController") as! VideoChatViewController

        singleVC.channelName = channelId
        singleVC.agoraKit = agoraEngine

        if let nav = self.navigationController {

            nav.pushViewController(singleVC, animated: true)
        }
        else {

            print("no navigation controller found")
        }
    }
}

// MARK: - RTM Connection Methods
extension LiveScreenViewController_New: AgoraRTMConnectionDelegate {

    func setupRTMConnection() {

        AgoraRTMConnection.shared.token = rtmToken
        AgoraRTMConnection.shared.delegate = self
        AgoraRTMConnection.shared.startConnection()
        AgoraRTMConnection.shared.login()
    }

    func leaveRTMConnetion() {

        AgoraRTMConnection.shared.cancelInvitations(true)
    }

    func didLoggedIn(with errorCode: AgoraRtmLoginErrorCode) {

        if errorCode == .ok {

//            rtmConnection.sendInvitation(to: Constants.CELEB_ID, type: AgoraRTMConnection.InvitationType.oneToone)
        }
        else {

            //leaveRTMConnetion()
        }
    }

    func didSentInvitation(with errorCode: AgoraRtmInvitationApiCallErrorCode) {

        if errorCode == .ok {

            utility.showToast(msg: stringConstants.msgCallRequestSent)

            overlayVC?.viewCallRequest?.startSendRequestTimeOutTimer()
        }
        else {

            utility.showToast(msg: stringConstants.msgCallRequestFailed)
        }
    }

    func didAcceptedRequest(invitation: AgoraRtmLocalInvitation, response: String?) {

//        if invitation.requestContent?.commercial_type == AgoraRTMConnection.commercialType.paid.rawValue {
//
//            gotoVideoCall(channelId: response!)
//        }
//        else {

            overlayVC?.viewCallRequest?.setLayoutWithCall()

            self.agoraEngine?.setClientRole(AgoraClientRole.broadcaster)

//            updateBalanceForRequestCall()
//        }
    }

    func didReceivedCallEndRequest() {

        endCall()
    }

    func didRefusedRequest(invitation: AgoraRtmRemoteInvitation) {

    }

    func didExpiredRequest() {

//        overlayVC?.viewCallRequest?.stopSendRequestTimeOutTimer()
    }

    func endCall() {

        overlayVC?.viewCallRequest?.setLayoutWithoutCall()

        self.agoraEngine?.setClientRole(AgoraClientRole.audience)
    }

    func updateBalanceForRequestCall() {

        if let requestCoins =
            ArtistConfiguration.sharedInstance().oneToOne?.coins {

            var coinsAfterDeduction = CustomerDetails.coins - Int(requestCoins)

            if coinsAfterDeduction <= 0 {

                coinsAfterDeduction = 0
            }

            CustomerDetails.coins = coinsAfterDeduction

            let database = DatabaseManager.sharedInstance
            database.updateCustomerCoins(coinsValue: coinsAfterDeduction)

            let coinDict:[String: Int] = ["updatedCoins": coinsAfterDeduction]

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatedCoins"), object: nil, userInfo: coinDict)
        }
    }
}

// MARK: - PHCallRequstView Delegate Methods
extension LiveScreenViewController_New: PHCallRequestDelegate {

    func didSelectedShowRequest() {

    }

    func didSelectedCloseRequestCall() {

    }

    func didTimeoutCall() {

        endCall()
    }
}

