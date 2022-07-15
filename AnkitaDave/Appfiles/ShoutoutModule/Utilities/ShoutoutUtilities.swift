//
//  NavigationBarUtils.swift
//  VideoGreetings
//
//  Created by Apple on 04/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import MessageUI
import Branch

final class NavigationBarUtils {
    
    private init() { }
    
    static func setupNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.backgroundColor = UIColor.clear
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.isOpaque = false
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        return navigationController
    }
    
    static func setupTransparentNavigationBar(navigationController: UINavigationController?) {
        navigationController?.navigationBar.tintColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isOpaque = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    static func setupNavigationBar(navigationController: UINavigationController?) {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: ShoutoutFont.light.withSize(size: .custom(20.0)),  NSAttributedString.Key.foregroundColor: UIColor.white]
        let colors: [UIColor] = [hexStringToUIColor(hex: Colors.lightMaroon.rawValue), hexStringToUIColor(hex: Colors.black.rawValue)]
            navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
}

enum Storyboard: String {
    case main = "Main"
    case wardrobe = "Wardrobe"
    case videoGreetings = "VideoGreetings"
    case home = "Home"
    case videoCall = "VideoCall"
    
    
    func instantiateViewController<T: UIViewController>(viewController: T.Type) -> T {
        let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T {
            return viewController
        } else {
            fatalError("View Controller not found.")
        }
    }
}

class Alert {
    
    static func show(in viewController: UIViewController?, title: String? = "", message: String?, actionTitle: String? = "Okay", cancelTitle: String? = "Cancel", autoDismiss: Bool = false, comletionForAction: ((String)->())?) {
        let inViewController = viewController ?? UIViewController.topViewController()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var shouldDismiss: Bool = autoDismiss
        
        if let cancel = cancelTitle {
            let alertAction = UIAlertAction(title: cancel, style: .cancel) { (_) in
                comletionForAction?(cancel)
            }
            alertController.addAction(alertAction)
        }
        
        if let action = actionTitle {
            let alertAction = UIAlertAction(title: action, style: .default) { (_) in
                shouldDismiss = false
                comletionForAction?(action)
            }
            alertController.addAction(alertAction)
        }
        
        DispatchQueue.main.async {
            inViewController?.present(alertController, animated: true, completion: { () in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { () in
                    if shouldDismiss {
                        alertController.dismiss(animated: true, completion: { () in
                            comletionForAction?("autoDismiss")
                        })
                    }
                }
            })
        }
    }
}

class ShoutoutUtilities {
    fileprivate static let playerController = AVPlayerViewController()
    
    class func playVideoInAVPlayerController(videoUrl: String?, viewController: UIViewController? = nil, delegate: AVPlayerViewControllerDelegate? = nil) {
            let inViewController = viewController ?? UIViewController.topViewController()
            guard let urlString = videoUrl, let url = URL(string: urlString), let presentingVC = inViewController else { return }
            
            let avPlayer = AVPlayer(url: url)
            let avPlayerController = ShoutoutUtilities.playerController
            avPlayerController.player = avPlayer
            if let viewControllerAVDelegate = delegate {
                avPlayerController.delegate = viewControllerAVDelegate
            }
        
        //NotificationCenter.default.removeObserver(self)
        //NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayerController.player?.currentItem)
        
            presentingVC.present(avPlayerController, animated: true) {
                avPlayerController.player?.play()
            }
    }
    
    @objc fileprivate func playerDidFinishPlaying() {
        DispatchQueue.main.async {
            ShoutoutUtilities.playerController.dismiss(animated: true, completion: nil)
        }
    }
    
    class func shareWithActivityController(textToShare: String, inViewController: UIViewController) {
        let toBeShared = [textToShare]
        let activityViewController = UIActivityViewController(activityItems: toBeShared, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = inViewController.view
        
        // Exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        inViewController.present(activityViewController, animated: true, completion: nil)
    }
    
    class func copyResourceToTemporaryDirectory(resourceName: String, fileExtension: String, fromURL: URL) -> URL?
    {
        let tempDirectoryURL = URL(fileURLWithPath: FileManager.default.temporaryDirectory.absoluteString, isDirectory: true)
        let targetURL = tempDirectoryURL.appendingPathComponent("\(resourceName).\(fileExtension)")
        
        do {
            try FileManager.default.copyItem(at: fromURL, to: targetURL)
            return targetURL
        } catch let error {
            print("Unable to copy file: \(error)")
        }
        
        return nil
    }
    
    class func removeItemFromUserDirectory(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func callNumber(phoneNumber: String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            if (UIApplication.shared.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    class func sendEmail(receipients: [String], subject: String, inViewController: UIViewController?, delegate: MFMailComposeViewControllerDelegate?) {
        let viewController = inViewController ?? UIViewController.topViewController()
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            if let mailDelegate = delegate {
                mail.mailComposeDelegate = mailDelegate
            }
            
            mail.setSubject(subject)
            mail.setToRecipients(receipients)
            mail.setMessageBody("", isHTML: true)
            
            ShoutoutUtilities.toggleBarButtonTitleVisibility(show: true)
            
            viewController?.present(mail, animated: true) {
                ShoutoutUtilities.toggleBarButtonTitleVisibility(show: false)
            }
        } else if let email = receipients.first, let url = URL(string: email), UIApplication.shared.canOpenURL(url) {
            
            ShoutoutUtilities.toggleBarButtonTitleVisibility(show: true)
            
            UIApplication.shared.open(url, options: [:]) { _ in
                ShoutoutUtilities.toggleBarButtonTitleVisibility(show: false)
            }
        } else {
            // show failure alert
            print("Mail services are not available")
            Alert.show(in: viewController, title: "", message: "Mail services are not available", actionTitle: "Okay", cancelTitle: nil, comletionForAction: nil)
        }
    }
    
    class func shareReceivedGreeting(video: VGVideo?, inViewController: UIViewController?) {
        guard let videoUrl = video?.url else { return }
        
        let thumbnailUrl = video?.thumb ?? AppConstants.appThumbnail
        let buo = BranchUniversalObject.init()
        buo.title = "\(Constants.celebrityName) Offical App."
        buo.imageUrl = thumbnailUrl
        let message = "Hi! I received a greeting from \(Constants.celebrityName)! Check it out!"
        buo.contentDescription = message
        
        let videoTitle = "Shoutouts Video"
        
        let properties: BranchLinkProperties = BranchLinkProperties()
        properties.addControlParam(DeeplinkKeys.deeplink, withValue: DeeplinkKeys.shoutoutKey)
        properties.addControlParam(DeeplinkKeys.videoUrl, withValue: videoUrl)
        properties.addControlParam(DeeplinkKeys.thumbnailUrl, withValue: thumbnailUrl)
        properties.addControlParam(DeeplinkKeys.videoName, withValue: videoTitle)
        
        ShoutoutUtilities.toggleBarButtonTitleVisibility(show: true)
        
        buo.showShareSheet(with: properties, andShareText: nil, from: inViewController) { (_, _) in
            
            ShoutoutUtilities.toggleBarButtonTitleVisibility(show: false)
        }
    }
    
    class func shareOnTwitter(tweet: String, url: String, inViewController: UIViewController?) {
        
        let tweetText = tweet
        let tweetUrl = url

        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"

        if let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: escapedShareString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            Alert.show(in: inViewController, message: "Unable to share on Twitter", comletionForAction: nil)
        }
    }
    
    class func toggleBarButtonTitleVisibility(show: Bool) {
        if show {
           
             UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
        } else {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear], for: .normal)
        }
    }
}

struct DeeplinkKeys {
    static let deeplink = "deeplink"
    static let videoUrl = "video_url"
    static let thumbnailUrl = "thumbnail_url"
    static let videoName = "video_name"
    static let shoutoutKey = "greetings"
}
