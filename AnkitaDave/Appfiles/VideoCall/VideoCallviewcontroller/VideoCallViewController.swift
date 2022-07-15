//
//  VideoCallViewController.swift
//  Producer
//
//  Created by Parikshit on 19/10/20.
//  Copyright © 2020 developer2. All rights reserved.
//

import UIKit
import AgoraRtcKit

class PHViewConnecting: UIView {
    
    @IBOutlet weak var lblConnecting: UILabel!
    
    var timerConneting: Timer? = nil
    var connectingCounter = 0
    
    // States
    let CONNECTING_TEXT = stringConstants.connecting
    let CONNECTED_TEXT = stringConstants.youAreLiveNow
    let LIVE_PAUSED = stringConstants.liveStreamingPaused
    let LIVE_AUDIO_PAUSED = stringConstants.liveAudioPaused
    let LIVE_VIDEO_PAUSED = stringConstants.liveVideoPaused
    
    let BACK_COLOR = utility.rgb(0, 0, 0, 0.5)
    
    func startConnecting() {
        
        lblConnecting.isHidden = false
        connectingCounter = 0
        lblConnecting.text = CONNECTING_TEXT
        //startConnectingTimer()
    }
    
    func startConnectingTimer() {
        
        stopConnectingTimer()
        
        timerConneting = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(updateConnectingLabel), userInfo: nil, repeats: true)
    }
    
    func stopConnectingTimer() {
        
        if timerConneting != nil {
            
            if timerConneting!.isValid {
                
                timerConneting?.invalidate()
                timerConneting = nil
            }
        }
    }
    
    @objc func updateConnectingLabel() {
        
        if connectingCounter == 0 {
            
            lblConnecting.text = CONNECTING_TEXT
            connectingCounter = connectingCounter + 1
        }
        else if connectingCounter == 1 {
            
            lblConnecting.text = CONNECTING_TEXT + "."
            connectingCounter = connectingCounter + 1
        }
        else {
            
            lblConnecting.text = CONNECTING_TEXT + ".."
            connectingCounter = 0
        }
    }
    
    func showSuccess() {
        
        stopConnectingTimer()
        
        lblConnecting.text = CONNECTED_TEXT
        
        perform(#selector(hide), with: nil, afterDelay: 1.0)
    }
    
    @objc func show(msg: String? = nil) {
        
        self.backgroundColor = BACK_COLOR
        self.isHidden = false
        self.alpha = 1.0
        
        if msg != nil {
            
            lblConnecting.isHidden = false
            lblConnecting.text = msg
        }
        else {
            
            lblConnecting.isHidden = true
        }
    }
    
    @objc func hide() {
        
        stopConnectingTimer()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.alpha = 0.0
            
        }) { (finished) in
            
            self.isHidden = true
        }
    }
}

class VideoCallViewController: UIViewController {
    
    @IBOutlet weak var viewOpponentCamera: UIView!
    @IBOutlet weak var viewMyCamera: UIView!
    @IBOutlet weak var viewConnecting: PHViewConnecting!
    @IBOutlet weak var lblLiveTime: UILabel!
    @IBOutlet weak var lblTimeRemainig: UILabel!
    @IBOutlet weak var viewControls: UIView!

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgViewNetwork: UIImageView!

    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblArtistDetails: UILabel!
    
    // Control buttons
    @IBOutlet weak var btnStartEndLive: UIButton!
    @IBOutlet weak var btnCameraFlip: UIButton!
    @IBOutlet weak var btnCameraFlash: UIButton!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    var request: VideoCallRequest!
       
//    var request: ShoutoutRequestDetails! // SK 1
    //var request: VGShoutout!
    var videoCallLink : String?
    var videoCallreRuestIdOnAcceptedCall: String?
    var strVideoCallCoin : String?
    
    // Agora
    var agoraEngine: AgoraRtcEngineKit? = nil
    var agoraToken : String? = nil
    var agoraUid : UInt? = nil
    var channelName = ""
    let isBroadcaster = true
    let viewLayouter = VideoViewLayouter()
    var videoSessions = [VideoSession]() {
        didSet {
//            guard viewOpponentCamera != nil else {
//                return
//            }
//            updateInterface(withAnimation: true)
        }
    }
    
    var timerLiveDuration: Timer? = nil
    var counterLiveDuration = 0
    var totalLiveDuration: Int = 0
    
    var timerForChannel: Timer? = nil
    
    let BTN_START_CALL_TITLE = "START CALL"
    let BTN_END_CALL_TITLE = "END CALL"

    var isFromPush = false
    var isFlashChecked = false
    var isOpponentJoined = false
    var artistConfig = ArtistConfiguration.sharedInstance()

    var completionCallEnded: (() -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Artist ID = \(Constants.CELEB_ID)")
        
        print("video call link = \(videoCallLink ?? "")")
        
         print("video call request ID = \(videoCallreRuestIdOnAcceptedCall ?? "")")
        
        print("Video Call Coins = \(strVideoCallCoin ?? "")")
        
        
        startAgoraEngine()
        
        startAgoraPreview()
        
        checkCameraPermissions()
        
        btnBack.isHidden = true
        
        setLayoutAndDesigns()
        
        self.showScreenBeforeLive()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.startPreventingRecording()
        UIApplication.shared.isStatusBarHidden = false
        
        setStatusBarStyle(isBlack: false)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.navigationItem.hidesBackButton = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
    }
    
    deinit {

        print("VideoCallViewController: deinit ----------****")
    }
    
    func startPreventingRecording() {
        NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: UIScreen.main, queue: OperationQueue.main) { (notification) in
            let isCaptured =  UIScreen.main.isCaptured
            if isCaptured {
                self.agoraEngine?.disableAudio()
                self.agoraEngine?.disableVideo()
               // self.agoraEngine?.disableExternalAudioSource()
                self.agoraEngine?.adjustAudioMixingPlayoutVolume(0)
                
            }else{
                self.agoraEngine?.enableAudio()
                self.agoraEngine?.enableVideo()
             //  self.agoraEngine?.enableExternalAudioSource(withSampleRate: 0, channelsPerFrame: 0)
                self.agoraEngine?.adjustAudioMixingPlayoutVolume(400)
            }
        }
    }
}


// MARK: - IBActions
extension VideoCallViewController {
    
    @IBAction func btnBackClicked() {
        
        leaveChannel()
        stopAgoraPreview()
        
        stopAllTimers()
        
        UIApplication.shared.isStatusBarHidden = false
        
        if isOpponentJoined {
            
            completionCallEnded?()
        }
        
        if isFromPush {
            
            self.dismiss(animated: true, completion: nil)
        }
        else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnStartEndLiveClicked() {
        
        if btnStartEndLive.tag == 0
        {
            if PHReachability.shared.isConnectedToInternet {
                
                btnStartEndLive.tag = 1
                self.startLive()
            }
            else {
                
                utility.alert(message: stringConstants.errNoInternet, delegate: self, cancel: nil, completion: nil)
            }
        }else
        {
            utility.alert(title: stringConstants.appName, message: stringConstants.agoraLiveStop, delegate: self, buttons: [stringConstants.yes], cancel: stringConstants.no) { [weak self] (title) in
                
                if title == stringConstants.yes {
                    
                    self?.btnStartEndLive.tag = 0

                    self?.endLive()
                }
            }
        }
    }
    
    @IBAction func btnCameraFlipClicked() {
        
        self.toggleCamera()
    }
    
    @IBAction func btnCameraFlashClicked() {
        
        self.toggleFlash()
    }
    
    @IBAction func btnMicClicked() {
        
        toggleMic()
    }
    
    @IBAction func btnVideoClicked() {
        
        toggleVideo()
    }
}

// MARK: - Utility Methods
extension VideoCallViewController {
    
    func setLayoutAndDesigns() {
        lblArtistName.text = Constants.celebrityName
        utility.setShadow(view: lblLiveTime, offset: CGSize.zero, opacity: 1, radius: 15, color: UIColor.black)
        
        utility.setCornerRadius(view: viewMyCamera, radius: 8.0)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        
        setRequestDetails()
    }
    
    func setRequestDetails() {
        
        if self.request !=  nil {
            
            if let durationInMin = self.request?.duration {
                
                let durationInSec = durationInMin * 60
                
                totalLiveDuration = durationInSec
            }
            else {
                
                totalLiveDuration = 0
            }
            
            self.lblLiveTime.text = utility.getTimeString(seconds: totalLiveDuration) + "s"
            
            lblArtistName.text = Constants.celebrityName //ArtistConfiguration.sharedInstance().first_name
            
            lblTimeRemainig.text = "waiting..."
        }
        else {
            
            self.lblLiveTime.text = utility.getTimeString(seconds: counterLiveDuration)
        }
    }
    
    func hideAllControls() {
        
//        lblLiveTime.isHidden = true
    }
    
    func showScreenBeforeLive() {
        
        btnBack.isHidden = true
        viewMyCamera.isHidden = false
//        lblLiveTime.isHidden = true
        viewOpponentCamera.isHidden = true
    }
    
    func showScreenAfterLive() {
            
        btnBack.isHidden = true
        viewControls.isHidden = false
//        lblLiveTime.isHidden = false
        viewOpponentCamera.isHidden = false
    }
    
    
    
    func startLive() {
        
        showScreenBeforeLive()
        
        self.view.isUserInteractionEnabled = false
        
        viewConnecting.startConnecting()
        
//        btnStartEndLive.setTitle(BTN_END_CALL_TITLE, for: UIControl.State.normal)
        
        webJoinCall()
        
//        getAgoraToken()
    }
    
    func endLive() {
        
        showScreenBeforeLive()
        
        self.stopAllTimers()
        
        self.leaveChannel()
        self.stopAgoraPreview()
        
        self.btnBack.isEnabled = true
        
//        webEndCall()
        
        btnBackClicked()
    }
    
    func stopAllTimers() {
        
        self.stopTimerForChannel()
        self.stopLiveDurationTimer()
    }
}

// MARK: - Permisstion Methods
extension VideoCallViewController {
    
    func checkCameraPermissions() {
        
        let permissionManager = PHPermissionManager()
        permissionManager.controller = self
        permissionManager.permissionType = .camera
        permissionManager.isAutoHandleNoPermissionEnabled = true
        permissionManager.completionBlock = { isGranted in
            
            if isGranted {
                
                self.checkMicrophonePermission()
            }
            else {
                
                self.btnBackClicked()
            }
        }
        
        permissionManager.askForPermission()
    }
    
    func checkMicrophonePermission() {
        
        let permissionManager = PHPermissionManager()
        permissionManager.controller = self
        permissionManager.permissionType = .microphone
        permissionManager.isAutoHandleNoPermissionEnabled = true
        permissionManager.completionBlock = { isGranted in
            
            if isGranted {
                
                self.showScreenBeforeLive()
            }
            else {
                
                self.btnBackClicked()
            }
        }
        
        permissionManager.askForPermission()
    }
}

// MARK: - Live Duration Timer
extension VideoCallViewController {
    
    func startLiveDurationTimer() {
        
        lblTimeRemainig.text = "remaining"
        
        counterLiveDuration = 0
        
        lblLiveTime.isHidden = false
        
        stopLiveDurationTimer()
        
        timerLiveDuration = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateLiveDuration), userInfo: nil, repeats: true)
    }
    
    func stopLiveDurationTimer() {
        
        if timerLiveDuration != nil {
            
            if timerLiveDuration!.isValid {
                
                timerLiveDuration?.invalidate()
                timerLiveDuration = nil
            }
        }
    }
    
    @objc func updateLiveDuration() {
        
        counterLiveDuration = counterLiveDuration + 1
        
        if request != nil {
            
            if totalLiveDuration <= 0 {
                
//                lblLiveTime.isHidden = true
                
                return
            }
            
            let diff = totalLiveDuration - counterLiveDuration
            
            if diff < 20 {
                
                lblLiveTime.textColor = UIColor.red
                utility.addScaleAnimation(inView: lblLiveTime, scale: 1.5, key: "", delegate: nil)
            }
            
            if diff < 0 {
                
                counterLiveDuration = totalLiveDuration
                self.endLive()
            }
            
            self.lblLiveTime?.text = utility.getTimeString(seconds: diff) + "s"
        }
        else {
                        
            self.lblLiveTime?.text = utility.getTimeString(seconds: counterLiveDuration)
        }
    }
}

// MARK: - Agora Utility Methods
extension VideoCallViewController {
    
    func startAgoraEngine() {
        
        self.agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: artistConfig.agora_id ?? "", delegate: self)
    }
    
    func toggleCamera()
    {
        btnCameraFlip?.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            
            self?.btnCameraFlip?.isEnabled = true
            
            self?.agoraEngine?.switchCamera()
            
            self?.checkTorchSupported()
        }
    }
    
    func checkTorchSupported() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            
            guard let engine =  self.agoraEngine else {
                
                return
            }
            
            if !engine.isCameraTorchSupported() {
                
                self.btnCameraFlash.setImage(UIImage(named: "live_flash_on_icon"), for: UIControl.State.normal)
                self.agoraEngine?.setCameraTorchOn(false)
                self.btnCameraFlash.tag = 0
                self.btnCameraFlash.isEnabled = false
            }
            else {
                
                self.btnCameraFlash.isEnabled = true
            }
        }
    }
    
    func toggleFlash() {
        
        if self.agoraEngine!.isCameraTorchSupported() {
            
            btnCameraFlash.isEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                
                self.btnCameraFlash.isEnabled = true
                
                if self.btnCameraFlash.tag == 0 {
                    
                    self.agoraEngine?.setCameraTorchOn(true)
                    self.btnCameraFlash.setImage(UIImage(named: "live_flash_off_icon"), for: UIControl.State.normal)
                    self.btnCameraFlash.tag = -1
                }
                else {
                    
                    self.btnCameraFlash.setImage(UIImage(named: "live_flash_on_icon"), for: UIControl.State.normal)
                    self.agoraEngine?.setCameraTorchOn(false)
                    self.btnCameraFlash.tag = 0
                }
            }
        }
    }
    
    func toggleMic(state: Bool? = nil) {
        
        if state != nil {
            
            self.agoraEngine?.muteLocalAudioStream(state!)
            
            btnMic.isSelected = state!
            
            return
        }
        
        btnMic.disableUserInteraction(duration: 0.5)
        
        if btnMic.isSelected {
            
            // Mic is disabled, enable it
            self.agoraEngine?.muteLocalAudioStream(false)
        }
        else {
            
            self.agoraEngine?.muteLocalAudioStream(true)
        }
        
        btnMic.isSelected = !btnMic.isSelected
        showAudioVideoStatus()
    }
    
    func toggleVideo() {
        
        btnVideo.disableUserInteraction(duration: 0.5)
        
        if btnVideo.isSelected {
            
            // Enable video
            self.agoraEngine?.muteLocalVideoStream(false)
            self.toggleMic(state: false)
        }
        else {
            
            self.agoraEngine?.muteLocalVideoStream(true)
            self.toggleMic(state: true)
        }
        
        btnVideo.isSelected = !btnVideo.isSelected
        showAudioVideoStatus()
    }
    
    func showAudioVideoStatus() {
        
        if btnVideo.isSelected && btnMic.isSelected {
            
            viewConnecting.show(msg: viewConnecting.LIVE_PAUSED)
        }
        else if btnVideo.isSelected {
            
            viewConnecting.show(msg: viewConnecting.LIVE_VIDEO_PAUSED)
        }
        else if btnMic.isSelected {
            
            viewConnecting.show(msg: viewConnecting.LIVE_AUDIO_PAUSED)
        }
        else {
            
            viewConnecting.hide()
        }
    }
    
    func showChannelDetails(_ dictData: [String:Any]) {
        
        var isChannelExist = false
        
        if let arrBroadcasters = dictData["broadcasters"] as? [Any] {
            
            if arrBroadcasters.count > 0 {
                
                isChannelExist = true
            }
        }
        
        if isChannelExist == false {
            
            //            showChannelClosedScreen()
        }
    }
    
    @objc func leaveChannel() {
        
        self.agoraToken = nil
        
        setIdleTimerAcative(true)
        
        self.agoraEngine?.leaveChannel(nil)
    }
    
    func stopAgoraPreview() {
        
        if isBroadcaster {
            
            self.agoraEngine?.stopPreview()
        }
        
        self.agoraEngine?.setupLocalVideo(nil)
        
        for session in videoSessions {
            
            session.hostingView.removeFromSuperview()
        }
                
        videoSessions.removeAll()
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
        
        if !isBroadcaster && !displaySessions.isEmpty {
            
            displaySessions.removeFirst()
        }
                
        viewLayouter.layout(sessions: displaySessions, fullSession: nil, inContainer: viewMyCamera)
        
        setStreamType(forSessions: displaySessions, fullSession: nil)
    }
    
    func setStreamType(forSessions sessions: [VideoSession], fullSession: VideoSession?) {
        
        for session in sessions {
            
            self.agoraEngine?.setRemoteVideoStream(session.uid, type: .high)
        }
    }
    
    func loadAgoraKit() {
        // SK 2
//        guard let user = User.getLoggedInUser() else {
//
//            return
//        }
        
        startTimerForChannel()
        
        let code = self.agoraEngine?.joinChannel(byToken: agoraToken!, channelId: self.request._id!, info: nil, uid: self.agoraUid!) { (channel, uid, elapsed) in
            
            print("channel=\(channel), uid=\(uid), elapsed=\(elapsed)")
            
            // self.overlayView.hideOverlayView()
            // self.viewBackLayer?.isHidden = true
        }
        
        if code == 0 {
            
            setIdleTimerAcative(false)
            
            self.agoraEngine?.setEnableSpeakerphone(true)
        }
        else {
            
            DispatchQueue.main.async(execute: {
                
                utility.showToast(msg: stringConstants.msgAgoraJoiningProblem)
                
                self.btnBackClicked()
                
                //self.showToast(message: "Join channel failed: \(code!)")
            })
        }
    }
    
    func startAgoraPreview() {
        
        self.agoraEngine?.delegate = self
        self.agoraEngine?.setChannelProfile(.liveBroadcasting)
        
        // Warning: only enable dual stream mode if there will be more than one broadcaster in the channel
        self.agoraEngine?.enableDualStreamMode(false)
        
        self.agoraEngine?.enableVideo()
        
        var config: AgoraVideoEncoderConfiguration!
        
//        if webConstants.isTesting {
//
//            config = AgoraVideoEncoderConfiguration(
//                size: AgoraVideoDimension320x240,
//                frameRate: .fps15,
//                bitrate: AgoraVideoBitrateStandard,
//                orientationMode: .fixedPortrait
//            )
//        }
//        else {
            
            config = AgoraVideoEncoderConfiguration(
                size: AgoraVideoDimension1280x720,
                frameRate: .fps15,
                bitrate: AgoraVideoBitrateStandard,
                orientationMode: .fixedPortrait
            )
//        }
        
        config.degradationPreference = .maintainFramerate
        
        config.minFrameRate = 10
        config.minBitrate = 800
        
        self.agoraEngine?.setVideoEncoderConfiguration(config)
        
        self.agoraEngine?.setClientRole(AgoraClientRole.broadcaster)
        
        if isBroadcaster {
                
            self.agoraEngine?.startPreview()
        }
        
        self.agoraEngine?.setBeautyEffectOptions(true, options: AgoraBeautyOptions.init())
        
        addLocalSession()
        
        if !isFlashChecked {
            
            self.checkTorchSupported()
            isFlashChecked = true
        }
    }
    
    func addLocalSession() {
        
        let localSession = VideoSession.localSession()
        videoSessions.append(localSession)
        localSession.hostingView = viewMyCamera

        self.agoraEngine?.setupLocalVideo(localSession.canvas)
    }
    
    func setIdleTimerAcative(_ active: Bool) {
        
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
    
    func showErrorAlert(msg: String, completion: (() -> Void)? = nil) {
        
        utility.alert(title: stringConstants.error, message: msg, delegate: self, buttons: nil, cancel: stringConstants.back) { (btn) in
            
            if btn == stringConstants.retry {
                
                completion?()
            }
            else {
                
                self.btnBackClicked()
            }
        }
    }
}

// MARK: - AgoraEngine Delegate Methods
extension VideoCallViewController: AgoraRtcEngineDelegate {
    
    func rtcEngineCameraDidReady(_ engine: AgoraRtcEngineKit) {
        
        print("----------- rtcEngineCameraDidReady ---------------")
                
        if agoraToken == nil {
            
            btnBack.isEnabled = true
            
            self.btnStartEndLiveClicked()
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        
        if errorCode == .invalidChannelId
        {
            print("no broadcasting found")
        }
        
        print("didOccurError = \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionStateType, reason: AgoraConnectionChangedReason) {
        
        print("connectionChangedTo = \(state.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        
        print("didLeaveChannelWith")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode){
        
        print("didOccurWarning = \(warningCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute error: Int, api: String, result: String) {
        
        print("didApiCallExecute error= \(error), api= \(api), result= \(result)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        
        let userSession = videoSession(ofUid: uid)
        userSession.hostingView = viewOpponentCamera
        self.agoraEngine?.setupRemoteVideo(userSession.canvas)
        
        self.startLiveDurationTimer()
        
        isOpponentJoined = true
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        
        if let _ = videoSessions.first {
            
//            updateInterface(withAnimation: false)
        }
    }
    
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        
        print("rtcEngineConnectionDidLost")
    }
    
    func rtcEngineRequestToken(_ engine: AgoraRtcEngineKit) {
        
        print("rtcEngineRequestToken")
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
        }
        //User Quiets  // Shriram kadam
        if reason.rawValue == 0 {
            self.endLive()
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, networkTypeChangedTo type: AgoraNetworkType) {
        
        if type == .disconnected {
            
            utility.showToast(msg: stringConstants.errNoInternet)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, networkQuality uid: UInt, txQuality: AgoraNetworkQuality, rxQuality: AgoraNetworkQuality) {
        
        if txQuality == .good || txQuality == .excellent {
            
            imgViewNetwork.image = UIImage(named: "network_excellent")
        }
        else if txQuality == .poor {
            
            imgViewNetwork.image = UIImage(named: "network_medium")
        }
        else if txQuality == .bad || txQuality == .vBad {
            
            imgViewNetwork.image = UIImage(named: "network_poor")
        }
        else if txQuality == AgoraNetworkQuality.down {
            
            imgViewNetwork.image = UIImage(named: "network_not_available")
        }
        else {
            
            // detecting, Unknown, Unsupported
            imgViewNetwork.image = UIImage(named: "network_detecting")
        }
        
        var quality = ""
        
        if txQuality == AgoraNetworkQuality.unknown {
            
            quality = "unknown"
        }
        else if txQuality == AgoraNetworkQuality.excellent {

            quality = "excellent"
        }
        else if txQuality == AgoraNetworkQuality.good {

            quality = "good"
        }
        else if txQuality == AgoraNetworkQuality.poor {

            quality = "poor"
        }
        else if txQuality == AgoraNetworkQuality.bad {

            quality = "bad"
        }
        else if txQuality == AgoraNetworkQuality.vBad {

            quality = "vBad"
        }
        else if txQuality == AgoraNetworkQuality.down {

            quality = "down"
        }
        else if txQuality == AgoraNetworkQuality.unsupported {
            
            quality = "unsupported"
        }
        else if txQuality == AgoraNetworkQuality.detecting {

            quality = "detecting"
        }
        
//        print("------------ \(quality) ------------")
    }
}

// MARK: - WebService Methods
extension VideoCallViewController {
    
    func checkAgoraChannelExist() {
   
        let api = Constants.agoraChannelExist + artistConfig.agora_id! + artistConfig.channel_namespace!
        
         let web = WebServiceApp(showInternetProblem: false, isCloud: false, loaderView: nil)
//        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)

        web.shouldPrintLog = true
        
        web.execute(type: .agora, name: api, params: nil) { (status, msg, dict) in
            
            if status {
                
                if let dictData = dict?["data"] as? [String:Any] {
                    
                    if let channel_exist = dictData["channel_exist"] as? Bool {
                        
                        if channel_exist == true {
                            
                            print("channel is live --------------->>>>")
                            
                            self.showChannelDetails(dictData)
                        }
                    }
                }
            }
        }
    }
    
    func getAgoraToken() {
        
//        guard let user = User.getLoggedInUser() else {
//
//            return
//        }
        
//        guard let artistId = self.request?.artist_id, let channel = self.request?._id else {
//
//            return
//        }
        
        let customerId = CustomerDetails.custId
        let params = ["channel":self.request._id, "artist_id": Constants.CELEB_ID, "customer_id": customerId]
       // videoCallreRuestIdOnAcceptedCall
        //let web = WebService(showInternetProblem: true, isCloud: false, loaderView: nil)
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
        
        web.shouldAutoAddArtistId = false
        web.shouldPrintLog = true
        
        web.execute(type: .get, name: Constants.agoraTokenNew, params: params as [String : AnyObject]) { (status, msg, dict) in
            
            DispatchQueue.main.async {
                
                if status {
                    
                    self.view.isUserInteractionEnabled = true
                    
                    if let dictData = dict?["data"] as? [String:Any] {
                        
                        if let token = dictData["access_token"] as? String, let uid = dictData["customer_uid"] as? UInt {
                            
                            self.agoraToken = token
                            self.agoraUid = uid
                            self.loadAgoraKit()
                            
                            self.viewConnecting.showSuccess()
                            
//                            self.startLiveDurationTimer()
                            self.showScreenAfterLive()
                            
                            self.btnBack.isEnabled = false
                        }
                        else {
                            
                            self.btnBack.isEnabled = true
                            
                            self.showErrorAlert(msg: stringConstants.errSomethingWentWrong, completion: self.getAgoraToken)
                        }
                    }
                    else {
                        
                        self.btnBack.isEnabled = true
                        
                        self.showErrorAlert(msg: stringConstants.errSomethingWentWrong, completion: self.getAgoraToken)
                    }
                }
                else {
                    
                    self.btnBack.isEnabled = true
                    
                    self.showErrorAlert(msg: msg!, completion: self.getAgoraToken)
                }
            }
        }
    }
    
    func webJoinCall() {
        
        guard let videoCallId = self.request?._id else {

            return
        }
        
//        if let videoCallId = self.request?._id {
//            self.videoCallreRuestId = videoCallId
//            print("Video requestID: \(videoCallreRuestId ?? "")")
//        }
        
        var params = [String:Any]()
        
        params["video_id"] = videoCallId  //videoCallreRuestIdOnAcceptedCall //videoCallId
        
        params["join_by"] = "customer"
        
        params["product"] = Constants.product

    
        let api = Constants.videoCallJoin
        
       // let web = WebService(showInternetProblem: false, isCloud: false, loaderView: nil)
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)

        
        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: params as [String : AnyObject]) { [weak self] (status, msg, dict) in
            
            if status {
                
                guard let dictRes = dict else {
                    
                    self?.showErrorAlert(msg: stringConstants.errSomethingWentWrong, completion: nil)

                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {
                    
                    if let arrErrors = dictRes["error_messages"] as? [String] {
                        
                        self?.showErrorAlert(msg: arrErrors[0], completion: nil)
                    }
                    else {
                       
                        self?.showErrorAlert(msg: stringConstants.errSomethingWentWrong, completion: nil)
                    }
                    
                    return
                }

                self?.getAgoraToken()
            }
            else {
                
                print(msg ?? "Start Live Error.")
                print("Retrying Start Live")
                
                self?.showErrorAlert(msg: stringConstants.errSomethingWentWrong, completion: nil)
            }
        }
    }
    
    func webEndCall() {
        
       guard let videoCallId = self.request._id else {
    
        return
     }
        
        var params = [String:Any]()
        
        params["video_id"] = videoCallId//videoCallreRuestIdOnAcceptedCall
                
        params["product"] = Constants.product

        let api = Constants.videoCallEnd
        
       // let web = WebService(showInternetProblem: false, isCloud: false, loaderView: nil)
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)

        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: params as [String : AnyObject]) { [weak self] (status, msg, dict) in
            
            if status {
                
//                guard let dictRes = dict else {
//
//                    self?.showErrorAlert(msg: stringConstants.errSomethingWentWrong, completion: nil)
//
//                    return
//                }
//
//                if let error = dictRes["error"] as? Bool, error == true {
//
//                    if let arrErrors = dictRes["error_messages"] as? [String] {
//
//                        self?.showErrorAlert(msg: arrErrors[0], completion: nil)
//                    }
//                    else {
//
//                        self?.showErrorAlert(msg: stringConstants.errSomethingWentWrong, completion: nil)
//                    }
//
//                    return
//                }
//
            }
            else {
                
//                print(msg ?? "Start Live Error.")
//                print("Retrying Start Live")
//
//                self?.showErrorAlert(msg: stringConstants.errSomethingWentWrong, completion: nil)
            }
        }
    }
}
