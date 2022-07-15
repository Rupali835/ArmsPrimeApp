//
//  PodcastPlayerViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 10/09/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import YXWaveView
import MediaPlayer
import AVKit
import AVFoundation
import Pulsator
import AudioPlayerManager

class PodcastPlayerViewController: BaseViewController {
    
    
    @IBOutlet weak var poadcastCaption: UILabel!
    @IBOutlet weak var poadcastName: UILabel!
    @IBOutlet weak var podcastimage: UIImageView!
    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var playBackgroundView: UIView!
    @IBOutlet weak var playOorPauseButton: UIButton!
    
    var podcastPlayer : List!
    //  var podcastPlayer = [List]()
    var player: AVPlayer!
    var playPause:Bool = false
    var currentIndexPathRow = -1
    var audioList = [String]()
    var storeDetailsArray : [List] = [List]()
    var waterView: YXWaveView?
    var localPlayer: AVPlayerItem!
    var avPlayer:AVQueuePlayer?
    var pageIndex:Int = Int()
    var createLayerSwitch = true
    var playerLayer = AVPlayerLayer()
    var audioPlayer = AudioPlayerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
//        view.addGestureRecognizer(panGestureRecognizer)
//
//        UIApplication.shared.beginReceivingRemoteControlEvents()
//          AudioPlayerManager.shared.remoteControlReceivedWithEvent(event)

        self.play()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.isTranslucent = false
        }
        
        self.navigationItem.rightBarButtonItem = nil
//        self.navigationItem.title = "PODCAST"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
          self.setNavigationView(title: "PODCAST")
        let frame = CGRect(x: 0, y: 0, width: self.waveView.bounds.size.width, height: 0)
        waterView = YXWaveView(frame: frame, color:  hexStringToUIColor(hex:"#ED3834"))
        
        waveView.addSubview(waterView!)
        
        // real wave color
        waterView?.realWaveColor = hexStringToUIColor(hex: "#ED3834").withAlphaComponent(0.50)
        
        // mask wave color
        waterView?.maskWaveColor = hexStringToUIColor(hex: "#ED3834")
        
        // wave speed (default: 0.6)
        waterView?.waveSpeed = 1
        
        
        // wave height (default: 5)
        waterView?.waveHeight = 15
        
        // wave curvature (default: 1.5)
        waterView?.waveCurvature = 1
        
        waterView?.start()
        
        self.podcastimage.layer.cornerRadius = podcastimage.frame.size.width / 2
        self.podcastimage.layer.masksToBounds = false
        self.podcastimage.clipsToBounds = true
        self.podcastimage.layer.borderColor = UIColor.black.cgColor
        self.podcastimage.layer.borderWidth = 2
        
        self.playBackgroundView.layer.cornerRadius = playBackgroundView.frame.size.width / 2
        self.playBackgroundView.layer.masksToBounds = false
        self.playBackgroundView.clipsToBounds = true
        
        self.playOorPauseButton.layer.cornerRadius = playOorPauseButton.frame.size.width / 2
        self.playOorPauseButton.layer.masksToBounds = false
        self.playOorPauseButton.clipsToBounds = true
        
        
    }
    


    override func remoteControlReceived(with event: UIEvent?) {
        
        if let _event = event {
            switch _event.subtype {
            case UIEvent.EventSubtype.remoteControlPlay:
                self.audioPlayClicked()
            case UIEvent.EventSubtype.remoteControlPause:
                self.audioPauseClicked()
            case UIEvent.EventSubtype.remoteControlNextTrack:
                self.audioNextClicked()
            case UIEvent.EventSubtype.remoteControlPreviousTrack:
                self.audioPreviousClicked()
            case UIEvent.EventSubtype.remoteControlTogglePlayPause:
                self.audioPlayClicked()
            default:
                break
            }
        }
    }
    
    
    deinit {
        // Stop listening to the callbacks
        AudioPlayerManager.shared.removePlayStateChangeCallback(self)
        AudioPlayerManager.shared.removePlaybackTimeChangeCallback(self)
    }
    
 
    func play() {
        
        if self.storeDetailsArray.count > 0 && self.storeDetailsArray.count >= pageIndex {
          
            if  let currentList : List = self.storeDetailsArray[pageIndex] as? List {
                if (GlobalFunctions.isContentsPaidCoins(list: currentList)) && currentList.coins != 0 {
                    
                    self.showMessage(message: "please unlock to play next podcast")
                } else {
 
//                    let urls = storeDetailsArray[pageIndex].audio?.url
//                    let podurl = URL(string: urls!)
//                     AudioPlayerManager.shared.play(url: podurl)
                    
                    
                    if AudioPlayerManager.shared.isPlaying() {
                        let item = AudioPlayerManager.shared.currentTrack?.getPlayerItem()
                        if let url = (item?.asset as? AVURLAsset)?.url, let urls = storeDetailsArray[pageIndex].audio?.url, url == URL(string: urls) {
                            print(url)
                        } else {
                            if let urls = storeDetailsArray[pageIndex].audio?.url {
                                 self.playOorPauseButton.setImage(#imageLiteral(resourceName: "pause-icon"), for: .normal)
                                 waterView?.start()
                                let pod = URL(string: urls.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)
                                DispatchQueue.main.async {
                                    AudioPlayerManager.shared.play(url: pod)
                                    self.lockScreen()
                                }

                            }
                        }
                    } else if let urls = storeDetailsArray[pageIndex].audio?.url {
                        self.playOorPauseButton.setImage(#imageLiteral(resourceName: "pause-icon"), for: .normal)
                         waterView?.start()
                        let pod = URL(string: urls.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)
                         DispatchQueue.main.async {
                            AudioPlayerManager.shared.play(url: pod)
                            self.lockScreen()
                        }
                    }

                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:nil)
      
                    podcastimage.sd_setImage(with: URL(string: (storeDetailsArray[pageIndex].audio?.cover)!) , completed: nil)
                    
                    if let albumcaption = storeDetailsArray[pageIndex].caption{
                        self.poadcastCaption.text = "\(albumcaption) "
                    }
                    
                    if let albumname = storeDetailsArray[pageIndex].name{
                        self.poadcastName.text = "\(albumname) "
                    }
                }
            }
        }
    }
    
    
    override func viewWillDisappear( _ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.player = nil
    }
    
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        
        print("call")
        
        audioNextClicked()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lockScreen()
        
        
    }
    
    func lockScreen() {
        
        guard let file: List? = self.storeDetailsArray[pageIndex] else {
            AudioPlayerManager.shared.currentTrack?.nowPlayingInfo = [String:AnyObject]() as? [String : NSObject]
            return

        }
        let url = file?.audio?.cover
        let imageView = UIImageView()
        let imageUrl = URL(string: url!)

        imageView.sd_setImage(with: imageUrl) { (downloadedImage, error, cache, url) in
            let remoteArtwork = MPMediaItemArtwork(boundsSize: CGSize(width: 400, height: 400), requestHandler: { size in
                return self.resizeImage(with: downloadedImage, scaledTo: size)!
            })
            AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyArtwork] = remoteArtwork
            AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyTitle] = file?.name as NSObject?
            AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPMediaItemPropertyArtist] = file?.caption as NSObject?
            AudioPlayerManager.shared.currentTrack?.nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1.0 as? NSObject

        }
    }
 
    func resizeImage(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func audioPlayClicked() {
        
        if AudioPlayerManager.shared.isPlaying() {
            
            AudioPlayerManager.shared.pause()
            waterView?.stop()
            playOorPauseButton.setImage(#imageLiteral(resourceName: "playMusicButton"), for: .normal)
            
            
        } else {
            DispatchQueue.main.async {
                AudioPlayerManager.shared.play()
            }
            waterView?.start()
            playOorPauseButton.setImage(#imageLiteral(resourceName: "pause-icon"), for: .normal)
            
        }
    }
    
    func audioPauseClicked() {
        
         if AudioPlayerManager.shared.isPlaying() {
            
            AudioPlayerManager.shared.pause()
            waterView?.stop()
             playOorPauseButton.setImage(#imageLiteral(resourceName: "playMusicButton"), for: .normal)
            
        } else {
            DispatchQueue.main.async {
                AudioPlayerManager.shared.play()
            }
            waterView?.start()
            playOorPauseButton.setImage(#imageLiteral(resourceName: "pause-icon"), for: .normal)
            
        }
    }
    
    func audioNextClicked() {
        
        if pageIndex < (storeDetailsArray.count - 1) {
            pageIndex = pageIndex + 1
            play()
            lockScreen()
        }
        
    }
    
    func audioPreviousClicked() {
        
        if pageIndex > 0 {
            pageIndex = pageIndex - 1
            play()
            lockScreen()
        }
        
    }
    
//    @IBAction func tapCloseButton() {
////        self.tapCloseButtonActionHandler?()
//        self.dismiss(animated: true, completion: nil)
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.isTranslucent = false
            
        }
        
    }
    
    
    
    @IBAction func nextPlayAction(_ sender: Any) {
        
        if pageIndex < (storeDetailsArray.count - 1) {
            pageIndex = pageIndex + 1
            play()
            lockScreen()
        }
        
        
    }
    
    @IBAction func previusPlayAction(_ sender: Any) {
        
        if pageIndex > 0 {
            pageIndex = pageIndex - 1
            play()
            lockScreen()
        }
        
    }
    
    @IBAction func PlayOrPauseAction(_ sender: Any) {
        if AudioPlayerManager.shared.isPlaying() {
            
            AudioPlayerManager.shared.pause()
            waterView?.stop()
            playOorPauseButton.setImage(#imageLiteral(resourceName: "playMusicButton"), for: .normal)
        } else {
            DispatchQueue.main.async {
                AudioPlayerManager.shared.play()
            }
            waterView?.start()
            playOorPauseButton.setImage(#imageLiteral(resourceName: "pause-icon"), for: .normal)
            
        }
        
        
    }
    
    func showMessage(message : String) {
        DispatchQueue.main.async {
            let toastLabel = UILabel(frame: CGRect(x: 10, y: 320, width: self.view.frame.size.width - 20, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "systemFont", size: 3.0)
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
    
}

extension AVPlayer {
    
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
    
}

extension UIPanGestureRecognizer {
    
    enum GestureDirection {
        case Up
        case Down
        case Left
        case Right
    }
    
    /// Get current vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func verticalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).y > 0 ? .Down : .Up
    }
    
    /// Get current horizontal direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func horizontalDirection(target target: UIView) -> GestureDirection {
        return self.velocity(in: target).x > 0 ? .Right : .Left
    }
    
    /// Get a tuple for current horizontal/vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func versus(target target: UIView) -> (horizontal: GestureDirection, vertical: GestureDirection) {
        return (self.horizontalDirection(target: target), self.verticalDirection(target: target))
    }
    
}
