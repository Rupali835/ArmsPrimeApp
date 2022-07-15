//
//  VideoChatViewController.swift
//  Agora iOS Tutorial
//
//  Created by James Fang on 7/14/16.
//  Copyright © 2016 Agora.io. All rights reserved.
//

import UIKit
import AgoraRtcKit
import AgoraRtmKit

class VideoChatViewController: BaseViewController {
    
    @IBOutlet weak var localVideo: UIView!
    @IBOutlet weak var remoteVideo: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    var agoraKit: AgoraRtcEngineKit!
        
    var isRemoteVideoRender: Bool = true {
        didSet {
            remoteVideoMutedIndicator.isHidden = isRemoteVideoRender
            remoteVideo.isHidden = !isRemoteVideoRender
        }
    }
    
    var isLocalVideoRender: Bool = false {
        didSet {
            localVideoMutedIndicator.isHidden = isLocalVideoRender
        }
    }
    
    var isStartCalling: Bool = true {
        didSet {
            if isStartCalling {
                micButton.isSelected = false
            }
            micButton.isHidden = !isStartCalling
            cameraButton.isHidden = !isStartCalling
        }
    }
    
    let requestTimeout = 60
    var requestTimeoutCounter = 0
    
    var timerRTMRequestTimeout: Timer? = nil
    
    var channelName = "archanagautam"
    var token = ""
    var uid: UInt = 0
    var customLoader : CustomLoaderViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // This is our usual steps for joining
        // a channel and starting a call.
        
        setInitForCustomLoader()
        
        initializeAgoraEngine()
        
        agoraKit.delegate = self
        
        setupVideo()
        setupLocalVideo()
        
        getAgoraToken()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        leaveChannel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let identifier = segue.identifier else {
        
            return
        }        
    }
    
    func initializeAgoraEngine() {
        
        // init AgoraRtcEngineKit
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: artistConfig.agora_id!, delegate: self)
    }
    
    func startVideoCall() {
        
        
        joinChannel()
    }

    func setupVideo() {
        // In simple use cases, we only need to enable video capturing
        // and rendering once at the initialization step.
        // Note: audio recording and playing is enabled by default.
        
        agoraKit.enableVideo()
        
        // Set video configuration
        // Please go to this page for detailed explanation
        // https://docs.agora.io/cn/Voice/API%20Reference/java/classio_1_1agora_1_1rtc_1_1_rtc_engine.html#af5f4de754e2c1f493096641c5c5c1d8f
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative))
    }
    
    func setupLocalVideo() {
        // This is used to set a local preview.
        // The steps setting local and remote view are very similar.
        // But note that if the local user do not have a uid or do
        // not care what the uid is, he can set his uid as ZERO.
        // Our server will assign one and return the uid via the block
        // callback (joinSuccessBlock) after
        // joining the channel successfully.
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = localVideo
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel() {
        // Set audio route to speaker
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.
        
        print("token = \(token), channelName = \(channelName), uid = \(uid)")
       
//        let code = agoraKit.switchChannel(byToken: token, channelId: channelName) { [unowned self] (channel, uid, elapsed) -> Void in
//           // Did join channel "demoChannel1"
//           self.isLocalVideoRender = true
//           print("channel=\(channel), uid=\(uid), elapsed=\(elapsed)")
//        }
        
//        agoraKit.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid) { [unowned self] (channel, uid, elapsed) -> Void in
//            // Did join channel "demoChannel1"
//            self.isLocalVideoRender = true
//        }
        
        isStartCalling = true
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func leaveChannel() {
        // leave channel and end chat
                
        agoraKit?.leaveChannel(nil)
        
        isRemoteVideoRender = false
        isLocalVideoRender = false
        isStartCalling = false
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            leaveChannel()
            self.navigationController?.popViewController(animated: true)

        } else {
            joinChannel()
        }
    }
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        // mute local audio
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        agoraKit.switchCamera()
    }
}

// MARK: - Utility Methods
extension VideoChatViewController {
    
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
}

extension VideoChatViewController: AgoraRtcEngineDelegate {
    // first remote video frame
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        isRemoteVideoRender = true
        
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteVideo
        videoCanvas.renderMode = .fit
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        isRemoteVideoRender = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        isRemoteVideoRender = !muted
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
    }
}

// MARK: - Web Service Methods
extension VideoChatViewController {
    
     func getAgoraToken() {
            
            //        let randomInt = UInt.random(in: 0..<100000)
            
            //        let apiName = Constants.WEB_GET_AGORA_ACCESS_TOKEN + "?channel=\(channelName)" + "&artist_id=\(Constants.CELEB_ID)" + "&customer_id=\(randomInt)" + "&v=\(Constants.VERSION)" + "&platform=ios"
            
        let apiName = Constants.WEB_GET_AGORA_ACCESS_TOKEN + "?channel=\(artistConfig.channel_namespace!)" + "&artist_id=\(Constants.CELEB_ID)" + "&v=\(Constants.VERSION)" + "&platform=ios"
            
            if Reachability.isConnectedToNetwork() {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveStarted"), object: nil)
                
                //            self.showLoader()
                self.showCustomLoader()
                ServerManager.sharedInstance().getRequest(postData: nil, apiName: apiName, extraHeader: nil) { (result) in
                    
                    DispatchQueue.main.async {
                        //                    self.stopLoader()
                        self.removeCustomLoader()
                        switch result {
                        case .success(let data):
                            print("get agora token => : \(data)")
                            
                            if let dictData = data["data"].dictionaryObject {
                                
                                if let token = dictData["token"] as? String, let uid = dictData["uid"] as? UInt {
                     
                                    self.token = token
                                    self.uid = uid
                                    self.joinChannel()
                                }
                            }
                        case .failure(let error):
                            print(error)
                            
    //                        self.showToast(message: Constants.NO_Internet_MSG)
                        }
                    }
                }
            }
            else
            {
                self.showToast(message: Constants.NO_Internet_MSG)
            }
        }
}
