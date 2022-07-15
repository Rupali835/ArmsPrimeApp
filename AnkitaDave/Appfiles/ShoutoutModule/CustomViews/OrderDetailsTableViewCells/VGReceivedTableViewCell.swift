//
//  VGReceivedTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit
import AVKit
import Photos
import NVActivityIndicatorView

class VGReceivedTableViewCell: UITableViewCell {

    var greetingData: GreetingList?
    var appActivityIndicator = NVActivityIndicatorView(frame: CGRect.zero, type: .ballTrianglePath, color: #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), padding: 0.0)
    
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var greetingHereTitleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var downloadLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timestampLabel.font = ShoutoutFont.regular.withSize(size: .smaller)
        greetingHereTitleLabel.font = ShoutoutFont.medium.withSize(size: .largeTitle)
        shareLabel.font = ShoutoutFont.regular.withSize(size: .small)
        downloadLabel.font = ShoutoutFont.regular.withSize(size: .small)
        
        thumbnailImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapVideoThumbnail))
        tapGesture.numberOfTapsRequired = 1
        thumbnailImageView.addGestureRecognizer(tapGesture)
        
        setupActivityIndicator()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapShare(_ sender: UIButton) {
        if let video = greetingData?.video {
            
            ShoutoutUtilities.shareReceivedGreeting(video: video, inViewController: nil)
        } else {
            Alert.show(in: nil, message: "Unable to share greeting. Please, try again later.", comletionForAction: nil)
        }
    }
    
    @IBAction func didTapDownload(_ sender: UIButton) {
        
        // Photo Gallery access.
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            didDownloadVideo(downloadButton: sender)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [unowned self] (status) in
                switch status {
                case .authorized:
                    self.didDownloadVideo(downloadButton: sender)
                default:
                    Alert.show(in: nil, title: "", message: AlertMessages.shoutoutPhotoGalleryAccessError, cancelTitle: nil, comletionForAction: nil)
                }
            }
        default:
            Alert.show(in: nil, title: "", message: AlertMessages.shoutoutPhotoGalleryAccessError, cancelTitle: nil, comletionForAction: nil)
        }
    }
    
    @objc fileprivate func didTapVideoThumbnail(_ sender: UIGestureRecognizer) {
        ShoutoutUtilities.playVideoInAVPlayerController(videoUrl: greetingData?.video?.url, delegate: self)
    }
    
    func configureCell(greetingData: GreetingList?) {
        self.greetingData = greetingData
        if let history = greetingData?.history {
            for historyItem in history {
                if historyItem.status == OrderStatusKeys.completed {
                    timestampLabel.text = historyItem.executed_at?.toDateString(fromFormat: .yyyyMMddHHmmss, toFormat: .ddMMMYYYYhhmm)
                }
            }
        }
        
        if let _ = greetingData?.video {
            playImageView.isHidden = false
            if let thumbnail = greetingData?.video?.cover, let url = URL(string: thumbnail) {
                thumbnailImageView.sd_setImage(with: url, completed: nil)
            } else {
                thumbnailImageView.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    fileprivate func setupActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if let viewController = UIViewController.topViewController() {
                strongSelf.appActivityIndicator.frame.size = CGSize(width: 40.0, height: 40.0)
                strongSelf.appActivityIndicator.center = viewController.view.center
                viewController.view.addSubview(strongSelf.appActivityIndicator)
            }
        }
    }
    
}

// MARK: - WebService Methods.
extension VGReceivedTableViewCell {
    fileprivate func didDownloadVideo(downloadButton: UIButton) {
        guard let videoURL = greetingData?.video?.url_naked, let videoIdAsName = greetingData?._id else { return }
        
        DispatchQueue.main.async { [weak self] in
            downloadButton.isEnabled = false
            self?.appActivityIndicator.startAnimating()
        }
        
        WebService.shared.downloadFile(url: videoURL, parameters: nil, showLoader: false, downloadProgress: { (_) in
        }) { (tempURL, error) in
            
            if let fileURL = tempURL {
                if let videoURL = ShoutoutUtilities.copyResourceToTemporaryDirectory(resourceName: videoIdAsName, fileExtension: "mov", fromURL: fileURL) {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                    }) { completed, error in
                        if completed {
                            Alert.show(in: nil, title: "", message: AlertMessages.shoutoutVideoSavedToGallery, cancelTitle: nil, comletionForAction: nil)
                        } else {
                            print(error?.localizedDescription as Any)
                            Alert.show(in: nil, title: "", message: AlertMessages.shoutoutVideoSaveError, cancelTitle: nil, comletionForAction: nil)
                        }
                        
                        // Clean up.
                        ShoutoutUtilities.removeItemFromUserDirectory(url: videoURL)
                        ShoutoutUtilities.removeItemFromUserDirectory(url: fileURL)
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.appActivityIndicator.stopAnimating()
                        }
                        
                    }
                } else {
                    Alert.show(in: nil, title: "", message: AlertMessages.shoutoutVideoSaveError, cancelTitle: nil, comletionForAction: nil)
                    
                    // Clean up.
                    ShoutoutUtilities.removeItemFromUserDirectory(url: fileURL)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.appActivityIndicator.stopAnimating()
                    }
                }
            } else {
                var errorMessage = AlertMessages.shoutoutVideoDownloadError
                print(error?.localizedDescription as Any)
                if let internetError = error as? WebServiceError, internetError == .internetError {
                    errorMessage = AlertMessages.internetConnectionError
                }
                Alert.show(in: nil, title: "", message: errorMessage, cancelTitle: nil, comletionForAction: nil)
                
                DispatchQueue.main.async { [weak self] in
                    self?.appActivityIndicator.stopAnimating()
                }
            }
            
            DispatchQueue.main.async {
                downloadButton.isEnabled = true
                //self?.appActivityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - AVPlayerViewController Delegate.
extension VGReceivedTableViewCell: AVPlayerViewControllerDelegate {
}
