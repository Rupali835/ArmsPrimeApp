//
//  LiveScreenViewController.swift
//  KaranKundraConsumer
//
//  Created by RazrTech2 on 20/02/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_SwiftyJSON
import IQKeyboardManagerSwift




class LiveScreenViewController: BaseViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var backButton: UIButton!
    var movieView: UIView!
    var isLogin = false
    var isLiveEnded = true
    var isColseButtonPressed = false
    var myTimer: Timer?
    //    fileprivate var player = Player()
    
    let progressHUD = ProgressHUD(text: "Connecting")
    var newPlayer = PLPlayer()
    
//    let manager = SocketManager(socketURL: URL(string: "http://35.201.147.163:7000")!, config: [.log(true), .compress])
//    lazy var socket = manager.defaultSocket
    
    var overlayController: LiveOverlayViewController!
    
    // MARK: object lifecycle
    //    deinit {
    //        self.player.stop()
    //        self.player.muted = true
    //        self.player.willMove(toParentViewController: self)
    //        self.player.view.removeFromSuperview()
    //        self.player.removeFromParentViewController()
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        //        self.player.playerDelegate = self
        //        self.player.playbackDelegate = self
        previewView.backgroundColor = UIColor.black
        //        self.player.view.frame = previewView.bounds
        //        self.previewView.addSubview(progressHUD)
        backButton.layer.cornerRadius = backButton.frame.size.height/2

        prepareForVideoPlay()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        IQKeyboardManager.shared.isEnableAutoToolbar = false
        //        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        UIApplication.shared.isIdleTimerDisabled = true
        
        //        socket.connect()
        //        if socket.status == .connected {
        //            print("Socket connected")
        //        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        UIApplication.shared.isIdleTimerDisabled = false
        
        //        IQKeyboardManager.shared().isEnableAutoToolbar = true
        //        IQKeyboardManager.sharedManager().enable = true
        //        socket.disconnect()
        //        self.player.stop()
        //        self.player.playerDelegate = nil
        //        self.player.playbackDelegate = nil
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func prepareForVideoPlay() {
        
        let option = PLPlayerOption.default()
        option.setOptionValue(15, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        option.setOptionValue(2000, forKey: PLPlayerOptionKeyMaxL1BufferDuration)
        option.setOptionValue(1000, forKey: PLPlayerOptionKeyMaxL2BufferDuration)
        option.setOptionValue(false, forKey: PLPlayerOptionKeyVideoToolbox)
        let videoUrl: URL = URL(string: "http://d2fy11zd7yuyoz.cloudfront.net/\(self.artistConfig.key ?? "ankitadave ")/myStream/playlist.m3u8")!
        //        rtmp://stream.razrmedia.com:1935/" + artist_key + "/myStream"
        self.newPlayer = PLPlayer(url: videoUrl, option: option)!
        self.newPlayer.delegate = self
        self.newPlayer.playerView?.addSubview(progressHUD)

        previewView.addSubview(self.newPlayer.playerView!)
        
        if UserDefaults.standard.bool(forKey: "liveStatus") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.playVideo()
            })
        }
    }
    
    
    func playVideo() {
        self.newPlayer.play()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "overlay" {
            overlayController = segue.destination as! LiveOverlayViewController
//            overlayController.delegate = self
//            overlayController.socket = socket
        }
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        print("bufferd time did changed")
    }
    
    func isLiveStarted() {
        self.prepareForVideoPlay()
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        newPlayer.stop()
        self.isColseButtonPressed = true
        self.navigationController?.popViewController(animated: true)
        
    }
}

//MARK:- PLPlayerDelegate
extension LiveScreenViewController: PLPlayerDelegate {
    
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        switch state {
        case .stateAutoReconnecting:
            print("Auto Reconnecting ==>")
        case .statusCaching:
            print("Caching ==>")
        case .statusCompleted:
            print("Completed ==>")
        case .statusError:
            print("Error ==>")
        case .statusPaused:
            print("Paused ==>")
        case .statusPlaying:
            self.progressHUD.removeFromSuperview()
            print("Playing ==>")
        case .statusPreparing:
            print("Preparing ==>")
        case .statusReady:
            print("Ready ==>")
        case .statusStopped:
            print("Stopped ==>")
            if !self.isColseButtonPressed {
                endLive()
            }
        case .statusUnknow:
            print("Unknown ==>")
        
        case .statusOpen:
            print("Unknown ==>")
        }
    }
    
    func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        print("Errrooooorrrr == \(error)")
//        endLive()
    }
    
    func endLive() {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Alert", message : "Live has Ended", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alert) in
                self.newPlayer.stop()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liveEnded"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }))
            
            if let presented = self.presentedViewController {
                presented.removeFromParent()
            }
            
            if self.presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            }
            
        })
    }
    
    func playerWillEndBackgroundTask(_ player: PLPlayer) {
        print("Player will end background task")
    }
}

