//
//  CustomBranchHandler.swift
//  HotShot
//
//  Created by webwerks on 13/08/19.
//  Copyright © 2019 com.armsprime.hotshot. All rights reserved.
//

import Foundation
import Branch

class CustomBranchHandler {
    // test key key_test_dfGxEFEYpGbR1GRqZKZsXidavraJnnNk
    // test domain bak6n.test-app.link
    
    static var shared = CustomBranchHandler()
    var paramData : [String: AnyObject]?
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var isCustomBranchLaunchApp = false
    var isOpenDeeplinkdata = false
    var referralCustomerID: String = ""
    //MARK:-
    private init() {}
    func configureBranchIO(application: UIApplication,launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Branch.getInstance().initSession(launchOptions: launchOptions) { params , error in
                    // Option 1: read deep link data
                    if let branchLaunch = launchOptions?[UIApplication.LaunchOptionsKey.sourceApplication] as? String {
                        if branchLaunch.count != 0 {
                            if let data = params as? [String: AnyObject] {
                                print("actuall param of BranchIo \(data)")
                                if let isClickedBranch = data["+clicked_branch_link"] as? Bool{
                                    if isClickedBranch && !self.isCustomBranchLaunchApp{
                                          self.isCustomBranchLaunchApp = true
                                        self.isOpenDeeplinkdata = true
                                        self.paramData = data
        //                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "branchNotif"), object: nil)
                                        let alert = UIAlertController.init(title: "Launch by Branch", message: "flag =>\(CustomBranchHandler.shared.isCustomBranchLaunchApp) param \(CustomBranchHandler.shared.paramData)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction.init(title: "ok", style: .cancel, handler: nil))
        //                                self.appDel.window?.rootViewController?.present(alert, animated: true, completion: nil)
        //                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
        //                                    self.handleBranchIODeepLink(param: data)
        //                                }
                                        // Handle Shoutout Video.
        //                                if let deeplinkValue = data[DeeplinkKeys.deeplink] as? String, deeplinkValue == DeeplinkKeys.shoutoutKey {
                                            self.handleBranchIODeepLink(param: data)
        //                                }
                                    } else if isClickedBranch {
                                        self.handleBranchIODeepLink(param: data)
                                    }
                                }
                            }
                        }
                    } else {
                        if let data = params as? [String: AnyObject] {
                            print("actuall param of BranchIo1 \(data)")
                            if let isClickedBranch = data["+clicked_branch_link"] as? Bool{
                                if isClickedBranch {
                                    self.handleBranchIODeepLink(param: data)
                                }
                            }
                        }
                    }
                }
    }
    
    func handleBranchIODeepLink(param : [String: AnyObject]) {
            guard let deeplink = param["deeplink"] as? String else { return }
            let contentId = (param["content_id"] as? String) ?? ""
            if deeplink.lowercased() == "content" {
                
                /**
                 Call Your video content deeplink view controller
                 **/
                if contentId != "" {
                    openVideoDetailViewControler(contentId: contentId)
                }
            } else if deeplink.lowercased() == "artist" {
                /**
                 Call Your models content deeplink view controller
                 **/
                if contentId != "" {
                    openModelDetailViewControler(contentId: contentId)
                }
            } else if deeplink.lowercased() == "referral" {
                if contentId != "" {
                   referralCustomerID = contentId
                }
            } else if deeplink.lowercased() == DeeplinkKeys.shoutoutKey {
                let videoUrl = param[DeeplinkKeys.videoUrl] as? String
                ShoutoutUtilities.playVideoInAVPlayerController(videoUrl: videoUrl)
            } else {
                   if contentId != "" {
                       openBucketVC(contentID: contentId, bucketCode: deeplink)
                    }
        }
    }
    
    //MARK:- Referral Link
//    func shareReferralBranchLink(customerId: String , vc: UIViewController) {
//
//        let buo = BranchUniversalObject.init()
//        buo.title = "HotShots Digital Entertainment!"
//
//
//        let lp: BranchLinkProperties = BranchLinkProperties()
//        lp.addControlParam("deeplink", withValue: "referral")
//        lp.addControlParam("content_id", withValue: customerId)
////        lp.channel = "WhatsApp"
//
////        buo.getShortUrl(with: lp) { (url, error) in
////            print(url ?? "")
////        }
//        buo.showShareSheet(with: lp, andShareText: message, from: vc) { (activityType, completed) in
//            print("branch==> \(activityType ?? "")")
//        }
//    }
    
    func shareReferralBranchLink(customerId: String,completion: @escaping (String?) -> Void) {

        let buo = BranchUniversalObject.init()
        buo.title = "\(Constants.celebrityAppName)"
        buo.imageUrl = AppConstants.appThumbnail
        let message = "Check out Ankita Dave official app. Sign up using this link to claim your free coins."
        buo.contentDescription = message

        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.addControlParam("deeplink", withValue: "referral")
        lp.addControlParam("content_id", withValue: customerId)
                buo.getShortUrl(with: lp) { (url, error) in
                    print(url ?? "")
                    completion(url)
                }
    }
    
    func shareContentBranchLink(content: List,bucketCode: String, inViewController: UIViewController?) {
        
        let buo = BranchUniversalObject.init()
        var thumbnailUrl = AppConstants.appThumbnail
        
        var artistConfig = ArtistConfiguration.sharedInstance()
        let artistPic = artistConfig.picture
      
        //"https://d1bng4dn08r9r5.cloudfront.net/artistprofile/thumb-1598727322.jpg"
        
           if let type = content.type {
            if type == "video" {
                thumbnailUrl = content.video?.cover ?? AppConstants.appThumbnail
            } else {
                if content.photo != nil {
                    
                    if content.coins! > 0
                    {
                        thumbnailUrl = artistPic!
                    }else{
                        thumbnailUrl = content.photo?.thumb ?? artistPic as! String
                    }
                
                }
                else{

                    if content.blur_photo?.portrait != nil
                    {
                        thumbnailUrl = artistPic!
                    }
                    else if content.blur_photo?.landscape != nil
                    {
                        thumbnailUrl = artistPic!
                    }
                }

               
            }
        }
        buo.title = "\(Constants.celebrityAppName)"
        let message = content.name ?? ""
        
        buo.contentDescription = message
        buo.imageUrl = thumbnailUrl
        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.addControlParam("deeplink", withValue: bucketCode)
        lp.addControlParam("content_id", withValue: content._id ?? "")
       
        ShoutoutUtilities.toggleBarButtonTitleVisibility(show: true)
        
        buo.showShareSheet(with: lp, andShareText: nil, from: inViewController) { (_, _) in
            
            ShoutoutUtilities.toggleBarButtonTitleVisibility(show: false)
        }
    }
}


//MARK:- Methods of respective class content
extension CustomBranchHandler {
    
    func openVideoDetailViewControler(contentId:String) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let destViewController : AlbumVideoDetailsViewController = storyboard.instantiateViewController(withIdentifier:
//            "AlbumVideoDetailsViewController") as! AlbumVideoDetailsViewController
//        destViewController.contentId = contentId
//        destViewController.isComingFromDeepLinking = true
//        if let presentedVC = appDel.window?.rootViewController?.presentedViewController {
//            presentedVC.present(destViewController, animated: true, completion: nil)
//        } else {
//            appDel.window?.rootViewController?.present(destViewController, animated: true, completion: nil)
//        }
        
        //         self.window?.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
        //         self.window?.rootViewController?.present(destViewController, animated: true, completion: nil)
    }
    
    func openModelDetailViewControler(contentId:String) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myVC = storyboard.instantiateViewController(withIdentifier: "ModelNameViewController") as! ModelNameViewController
//        let navController = UINavigationController(rootViewController: myVC)
//        myVC.ArtistId = contentId
//        myVC.isComingFromDeepLinking = true
//
//        if let presentedVC = appDel.window?.rootViewController?.presentedViewController {
//            presentedVC.present(navController, animated: true, completion: nil)
//        } else {
//            appDel.window?.rootViewController?.present(navController, animated: true, completion: nil)
//        }
        
    }
    
    func openBucketVC(contentID: String , bucketCode: String)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let currentNav: UINavigationController =  UIApplication.shared.delegate?.window??.rootViewController as!  UINavigationController
        
        let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
        
        let bucket : BucketContentDetailsViewController = storyboard.instantiateViewController(withIdentifier: "BucketContentDetailsViewController") as! BucketContentDetailsViewController
        bucket.contedID = contentID
        bucket.bucketcodeStr = bucketCode
        
        currentNav.viewControllers = [vc]
        currentNav.pushViewController(bucket, animated: false)
    }
}
