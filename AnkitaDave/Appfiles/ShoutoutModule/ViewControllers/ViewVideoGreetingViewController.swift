//
//  ViewVideoGreetingViewController.swift
//  VideoGreetings
//
//  Created by Apple on 06/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit
import AVKit
import PhotosUI

class ViewVideoGreetingViewController: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    var greetingData: GreetingList?
    
    // MARK: - IBOutlets.
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var helpTitleLabel: UILabel!
    @IBOutlet weak var downloadTitleLabel: UILabel!
    
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        [shareButton, downloadButton, feedbackButton, helpButton].forEach { (button) in
            button?.centerImageAndTitleVerticallyWithOriginalImageSize()
        }
    }
    
    // MARK: - IBActions.
    @IBAction func didTapPlay(_ sender: UIButton) {
        ShoutoutUtilities.playVideoInAVPlayerController(videoUrl: greetingData?.video?.url, viewController: self, delegate: self)
    }
    
    @IBAction func didTapShare(_ sender: UIButton) {
        ShoutoutUtilities.shareWithActivityController(textToShare: "", inViewController: self)
    }
    
    @IBAction func didTapDownload(_ sender: UIButton) {
        sender.isEnabled = false
        didDownloadVideo()
       
    }
    
    @IBAction func didTapFeedback(_ sender: UIButton) {
        ShoutoutConfig.InAppNavigation.toHelpAndSupport(inViewController: self, transactionId: greetingData?.passbook_id ?? "")
    }
    
    @IBAction func didTapHelp(_ sender: UIButton) {
        ShoutoutConfig.InAppNavigation.toHelpAndSupport(inViewController: self, transactionId: greetingData?.passbook_id ?? "")
    }
}

// MARK: - Custom Methods.
extension ViewVideoGreetingViewController {
    fileprivate func setupView() {
        
        title = "My Greetings"
        
        [shareButton, downloadButton, feedbackButton, helpButton].forEach { (button) in
            button?.titleLabel?.adjustsFontSizeToFitWidth = true
            button?.titleLabel?.font = ShoutoutFont.regular.withSize(size: .smaller)
            button?.centerImageAndTitleVerticallyWithOriginalImageSize()
        }
        
        [helpTitleLabel, downloadTitleLabel].forEach { (label) in
            label?.adjustsFontSizeToFitWidth = true
            label?.font = ShoutoutFont.regular.withSize(size: .small)
        }
        
        if let thumbnail = greetingData?.video?.cover, let url = URL(string: thumbnail) {
            videoThumbnail.sd_setImage(with: url, completed: nil)
        }
    }
}

// MARK: - WebService Methods.
extension ViewVideoGreetingViewController {
    fileprivate func didDownloadVideo() {
        guard let videoURL = greetingData?.video?.url_naked, let videoIdAsName = greetingData?._id else { return }
        
        WebService.shared.downloadFile(url: videoURL, parameters: nil, downloadProgress: { (_) in
        }) { (tempURL, error) in
            self.downloadButton.isEnabled = true
            if let fileURL = tempURL {
                if let videoURL = ShoutoutUtilities.copyResourceToTemporaryDirectory(resourceName: videoIdAsName, fileExtension: "mov", fromURL: fileURL) {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                    }) { completed, error in
                        if completed {
                            Alert.show(in: self, title: "", message: AlertMessages.shoutoutVideoSavedToGallery, cancelTitle: nil, comletionForAction: nil)
                        } else {
                            print(error?.localizedDescription as Any)
                            Alert.show(in: self, title: "", message: AlertMessages.shoutoutVideoSaveError, cancelTitle: nil, comletionForAction: nil)
                        }
                        
                        // Clean up.
                        ShoutoutUtilities.removeItemFromUserDirectory(url: videoURL)
                        ShoutoutUtilities.removeItemFromUserDirectory(url: fileURL)
                        
                    }
                } else {
                    Alert.show(in: self, title: "", message: AlertMessages.shoutoutVideoSaveError, cancelTitle: nil, comletionForAction: nil)
                    
                    // Clean up.
                    ShoutoutUtilities.removeItemFromUserDirectory(url: fileURL)
                }
            } else {
                var errorMessage = AlertMessages.shoutoutVideoDownloadError
                print(error?.localizedDescription as Any)
                if let internetError = error as? WebServiceError, internetError == .internetError {
                    errorMessage = AlertMessages.internetConnectionError
                }
                Alert.show(in: self, title: "", message: errorMessage, cancelTitle: nil, comletionForAction: nil)
            }
        }
    }
}

// MARK: - AVPlayerViewController Delegate.
extension ViewVideoGreetingViewController: AVPlayerViewControllerDelegate { }
