//
//  HeaderVideoPlayerViewController.swift
//  AnveshiJain
//
//  Created by Bhavesh Chaudhari on 30/06/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import Pulley
import AVKit
import NVActivityIndicatorView

enum BannerState {
    case photo(imageUrl: URL)
    case video(videoUrl: URL)
}

enum PlayerState{
    case fromWadrable
    case fromCelebyte
    case fromOnetoOne
}

class HeaderVideoPlayerViewController: BaseViewController {

    //MARK:- outlet declaration
    @IBOutlet var bannerImage: UIImageView!
    @IBOutlet var playerOuterView: UIView!
    @IBOutlet var soundButton: UIButton!
    @IBOutlet var noVideoFound: UILabel!

    //MARK:- variable declaration
    var viewState: BannerState?
    private var player: AVPlayer?
    var playerSate: PlayerState?
    var drawerState: DrawerState = .close
    private var playerLayer: AVPlayerLayer?
    var isPlayerHiden: Bool = false {
        didSet {
            playerOuterView.isHidden = isPlayerHiden
            noVideoFound.isHidden = !isPlayerHiden
        }
    }

    var playerLooper: NSObject?
//    var queuePlayer: AVQueuePlayer?



    //MARK:- ViewController Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startPreventingRecording()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.reinitilizePlayer()
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        if self.drawerState == .open {
            return
        }

        if self.player != nil {
            self.player?.play()
            return
        }

        if let state = self.viewState {
            self.setupView(with: state)
        } else {
            switch playerSate {
            case .fromCelebyte:
                    layOutViewForcelebyte()
            case .fromWadrable:
                    layoutViewForWardrobe()
            case .fromOnetoOne:
                    layoutViewForPrivateVideo()
            case .none:
                print("")
            }
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        self.player?.pause()
        NotificationCenter.default.removeObserver(self)
    }

    deinit {

    }

}

//MARK:- custom methods
extension HeaderVideoPlayerViewController {

      private func setupView(with state: BannerState) {
          switch state {
          case .photo(let imageUrl):
              setupBanner(imageUrl: imageUrl)
          case .video(let videoUrl):
              setupPayer(with: videoUrl)
          }
      }

      private func setupBanner(imageUrl: URL) {
          bannerImage.sd_setImage(with: imageUrl, completed: nil)
      }

      private func setupPayer(with videoUrl: URL) {
//          self.player = AVPlayer(url: videoUrl)
//                 if playerLayer != nil {
//                     playerLayer?.removeFromSuperlayer()
//                     playerLayer = nil
//                 }
//                 playerLayer = AVPlayerLayer(player: player)
//                 playerLayer?.videoGravity = .resizeAspectFill
//                 playerLayer?.frame = self.playerOuterView.bounds
//                 guard let playerLayer = self.playerLayer else {
//                     return
//                 }
//                 self.playerOuterView.layer.addSublayer(playerLayer)
//                 player?.play()


        let playerItem = AVPlayerItem(url: videoUrl)
        self.player = AVQueuePlayer(items: [playerItem])
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLooper = AVPlayerLooper(player: self.player! as! AVQueuePlayer, templateItem: playerItem)
        guard let playerLayer = self.playerLayer else {
                return
        }
        playerLayer.videoGravity = .resizeAspectFill
        self.playerOuterView.layer.addSublayer(playerLayer)
        self.playerLayer?.frame = self.playerOuterView.bounds
        self.player?.play()
      }
    
    func startPreventingRecording() {
           NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: UIScreen.main, queue: OperationQueue.main) { (notification) in
               let isCaptured =  UIScreen.main.isCaptured
               if isCaptured {
                   self.player?.pause()
               }else{
                   self.player?.play()
               }
           }
       }
    
    private func reinitilizePlayer() {
             if self.player?.isPlaying ?? true {
                 player?.seek(to: CMTime.zero)
                 player?.play()
             }
         }

    func changeSoundStatus(with state: DrawerState) {
        self.drawerState = state
        if state == .close {
            self.player?.play()
        } else {
            self.player?.pause()
        }
    }

    private func playVideoOnPlayer(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

    private func layOutViewForcelebyte() {
        if let appdelgate = UIApplication.shared.delegate as? AppDelegate {
             self.showLoader()
             appdelgate.artistData(completion: { [unowned self] status in
                 self.stopLoader()
                 if let videoUrlPath = ShoutoutConfig.howItWorksVideoURL, let url = URL(string:videoUrlPath) {
                     let state =  BannerState.video(videoUrl: url)
                      self.setupView(with: state)
                 } else {
                    self.isPlayerHiden = true
                }
             })
         }
    }

    private func layoutViewForPrivateVideo() {
        if let appdelgate = UIApplication.shared.delegate as? AppDelegate {
            self.showLoader()
            appdelgate.artistData(completion: { status in
                self.stopLoader()
                if let videoUrlPath = ArtistConfiguration.sharedInstance().privateVideoCallURL?.videoURL, let url = URL(string:videoUrlPath) {
                    let state =  BannerState.video(videoUrl: url)
                     self.setupView(with: state)
                } else {
                    self.isPlayerHiden = true
                }
            })
        }
    }

    private func layoutViewForWardrobe() {
        self.showLoader()
        didFetchBanner {
            self.stopLoader()
            if let state = self.viewState {
                self.setupView(with: state)
            } else {
                self.isPlayerHiden = true
            }
        }
    }
}

//MARK:- action methods
extension HeaderVideoPlayerViewController {

    @IBAction func soundClick(sender: UIButton) {

        guard let soundValue = self.player?.isMuted else {
            return
        }

        let muteImage: UIImage = (soundValue ? UIImage(named: "UnMute")! : UIImage(named: "Sound"))!
        sender.setImage(muteImage, for: .normal)
        self.player?.isMuted.toggle()
    }

    @IBAction func playerClick(sender: UIButton) {
          if case let .video(url) = viewState {
            playVideoOnPlayer(url: url)
          }
      }

}

extension HeaderVideoPlayerViewController {
    fileprivate func didFetchBanner(then handler: @escaping (() -> Void)) {

            if let bucket = GlobalFunctions.returnBucketListFormBucketCode(code: "wardrobe"),
                let bucketID = bucket._id {

                let paramters = ["bucket_id": bucketID]

                WebServiceHelper.shared.callGetMethod(endPoint: Constants.bucketContent, parameters: paramters, responseType: BucketContentResponseModel.self, showLoader: false, baseURL: Constants.cloud_base_url) { [weak self] (response, error) in

                    if let banner = response?.data?.list, banner.count > 0 {

                        switch banner[0].type {
                        case "photo":
                            if let photoPath = banner[0].photo?.cover, let url = URL(string: photoPath) {
    //                            self?.imgURL = url
                                self?.viewState = BannerState.photo(imageUrl: url)
                            }
                        case "video":
                            if let videoPath = banner[0].video?.url, let url = URL(string: videoPath) {
                                self?.viewState = BannerState.video(videoUrl: url)
                            }
                        default:
                            break
                        }

                    } else {
    //                    self?.imgURL = ""
                    }
                    self?.stopLoader()
                    handler()
                }
            }
        }
}


