//
//  SocialPhotosViewController.swift
//  Poonam Pandey
//
//  Created by Razrcorp  on 18/07/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

class SocialPhotosViewController: PannableViewController, UIScrollViewDelegate {
   
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var socialImage: UIImageView!
    var liveButton = UIButton()
    var backButton : UIButton!
    var contedID: String = ""
     var pageIndex = 0
//    var selectedPost : List!
    var storeDetailsArray : [List] = [List]()
    //MARK:-
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let dictData = self.storeDetailsArray[pageIndex] as? List{
            
            let contentId : String = dictData._id!
            if GlobalFunctions.checkContentLikeId(id: contentId) {
                
                self.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
            }
        }
        
        self.likeButton.isHidden = false
        self.commentCount.isHidden = false
        self.likeCount.isHidden = false
        self.commentButton.isHidden = false
//        self.shareButton.isHidden = false
        
        if storeDetailsArray[pageIndex].source == "twitter" {
            
            self.likeButton.isHidden = true
            self.commentCount.isHidden = true
            self.likeCount.isHidden = true
            self.commentButton.isHidden = true
//            self.shareButton.isHidden = true
            
        }
        
        socialImage.isUserInteractionEnabled = true
        
        scrollView.delegate = self
        
        self.scrollView.minimumZoomScale = 1
        
        self.scrollView.maximumZoomScale = 6
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        self.navigationController?.navigationBar.barTintColor = UIColor.black
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        
        doubleTapGest.numberOfTapsRequired = 2
        
        scrollView.addGestureRecognizer(doubleTapGest)
        
        setProfileImageOnBarButton()
        
        self.view.addSubview(scrollView)
        
        self.tabBarController?.tabBar.isHidden = true

//        let colors: [UIColor] = [UIColor.black,UIColor.black]
//        self.navigationController!.navigationBar.setGradientBackground(colors: colors)
        if  let coverPhoto = storeDetailsArray[pageIndex].photo?.cover {
            socialImage.sd_setImage(with: URL(string: coverPhoto) , completed: nil)
            
        }
      
        if  let commentcount = storeDetailsArray[pageIndex].stats?.comments {
             self.commentCount.text = "\(commentcount)"
            
        }
        
        if  let likecount = storeDetailsArray[pageIndex].stats?.likes {
            self.likeCount.text = likecount.roundedWithAbbreviations//"\(likecount)"
            
        }
       
//        addCustomBackButton()
    }
    func addCustomBackButton() {
        backButton   = UIButton(type: UIButton.ButtonType.system) as UIButton
        //        backButton.backgroundColor = UIColor.red
        
        let image = UIImage(named: "backbutton") as UIImage?
        backButton.frame = CGRect(x: 10, y: self.view.frame.origin.y - 55, width: 20, height: 22)
        //        button.layer.cornerRadius = button.frame.height/2
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.white
        backButton.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        //        self.view.addSubview(backButton)
        
        let backButtonContainer   = UIButton(type: UIButton.ButtonType.system) as UIButton
        backButtonContainer.frame = CGRect(x: 20, y: self.view.frame.origin.y - 20, width: 40, height: 40)
        backButtonContainer.tintColor = UIColor.white
        backButtonContainer.titleLabel?.text = ""
        backButtonContainer.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        self.navigationController?.navigationBar.barTintColor = UIColor.black
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.isTranslucent = false
         self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        //        self.view.backgroundColor = hexStringToUIColor(hex: MyColors.primary)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.navigationBar.isHidden = false
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
         self.navigationController?.navigationBar.isHidden = false
    }
    @objc func backButtonPressed(sender: UIButton!) {
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func shareButtonCustomAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share", style: .default) { action in
            let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,Constants.appStoreLink], applicationActivities: nil)
            viewController.popoverPresentationController?.sourceView = self.view
            
            self.present(viewController, animated: true, completion: nil)
            
        })
        /*
        alert.addAction(UIAlertAction(title: "Save Photo", style: .default) { action in
            
            if (self.storeDetailsArray.count > Int(self.pageIndex)) {
                if let currentPhotoDetails = self.storeDetailsArray[self.pageIndex] as? List{
                    
                    let  imagestring = currentPhotoDetails.photo?.cover
                    let url = URL(string:imagestring!)
                    var image = UIImage()
                    if let data = try? Data(contentsOf: url!) {
                        image = UIImage(data: data)!
                    }
                    
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                    let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                self.showToast(message: Constants.NO_Internet_MSG)
            }
        })
        */
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    func setProfileImageOnBarButton() {
        liveButton.frame = CGRect(x: 0, y: 0, width: 32, height: 30)
        liveButton.addTarget(self, action:#selector(self.openLiveScreen), for: .touchUpInside)
        let color = UIColor(patternImage: UIImage(named: "threedots-1")!)
        liveButton.backgroundColor = color
        //        self.liveButton.layer.cornerRadius = liveButton.frame.size.width / 2
        self.liveButton.clipsToBounds = true
        
        let barButton = UIBarButtonItem()
        barButton.customView = liveButton
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    @objc func openLiveScreen() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share", style: .default) { action in
            let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,Constants.appStoreLink], applicationActivities: nil)
            viewController.popoverPresentationController?.sourceView = self.view
            
            self.present(viewController, animated: true, completion: nil)
            
            })
        /*
        alert.addAction(UIAlertAction(title: "Save Photo", style: .default) { action in
            
            if (self.storeDetailsArray.count > Int(self.pageIndex)) {
                if let currentPhotoDetails = self.storeDetailsArray[self.pageIndex] as? List{
                
                let  imagestring = currentPhotoDetails.photo?.cover
                let url = URL(string:imagestring!)
                var image = UIImage()
                if let data = try? Data(contentsOf: url!) {
                    image = UIImage(data: data)!
                }
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
                let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
        })
        */
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    }
    
  
    func showToast(message : String) {
        DispatchQueue.main.async {
            
            let toastLabel = UILabel(frame: CGRect(x: 10, y: self.view.frame.size.height-120, width: self.view.frame.size.width - 20, height: 35))
            //        let toastLabel = UILabel(frame: CGRect(x: 10, y: 350, width: self.view.frame.size.width - 20, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Montserrat-Light", size: 11.0)
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
    
    @IBAction func likeButtonAction(_ sender: Any) {
        if !self.checkIsUserLoggedIn() {
           self.loginPopPo()
            return
        }
        if let dictData = self.storeDetailsArray[pageIndex] as? List{
            
            let contentId : String = dictData._id!
            
            if GlobalFunctions.checkContentLikeId(id: contentId) {
                
                return
            }
            
            let dict = ["content_id": contentId, "like": "true"] as [String: Any]
            
            let anim = CABasicAnimation(keyPath: "transform")
            anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            anim.duration = 0.125
            anim.repeatCount = 1
            anim.autoreverses = true
            anim.isRemovedOnCompletion = true
            anim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0))
//            self.likeButton.image =  UIImage(named: "wow_color_white")
            self.likeButton.setImage(UIImage(named: "newLike"), for: .normal)
            self.likeButton.layer.add(anim, forKey: nil)
            
            let likeCount = Int(self.likeCount.text!)
            if  let likecount = storeDetailsArray[pageIndex].stats?.likes {
                self.likeCount.text = (likecount + 1).roundedWithAbbreviations//"\(likecount)"
                
            }
           
//            self.likeCount.text = "\(likeCount!+1)"
            
            ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.LIKE_SAVE, extraHeader: nil) { (result) in
                switch result {
                case .success(let data):
                    GlobalFunctions.saveLikesIdIntoDatabase(content_id: contentId)
                    print(data)
                    CustomMoEngage.shared.sendEventForLike(contentId: contentId, status: "Success", reason: "", extraParamDict: nil)
                case .failure(let error):
                    CustomMoEngage.shared.sendEventForLike(contentId: contentId, status: "Failed", reason:  error.localizedDescription, extraParamDict: nil)
                    print(error)
                }
            }
        }
        
    }
    
    @IBAction func commentButtonAction(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let CommentTableViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        if let dict =  self.storeDetailsArray[pageIndex] as? List{
            let postId = dict._id
            CommentTableViewController.postId = postId!
            CommentTableViewController.isFromSocialPhoto = true
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = .fade//CATransitionType.push
//            transition.subtype =  CATransitionSubtype.fromRight
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(CommentTableViewController, animated: false)
        }
    }
    func loginPopPo() {
              let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPopPopViewController") as! LoginPopPopViewController
                  self.addChild(popOverVC)
                  popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                  popOverVC.textLabel.text = "Hey there! log in right now to connect with me"
                  popOverVC.coinsView.isHidden = true
                  self.view.addSubview(popOverVC.view)
                  popOverVC.didMove(toParent: self)
          }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let viewController = UIActivityViewController(activityItems:[Constants.celebrityAppName,Constants.appStoreLink], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view
        
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        
        if scrollView.zoomScale == 1 {
            
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)

        } else {
            
            scrollView.setZoomScale(1, animated: true)
            
        }
        
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        
        var zoomRect = CGRect.zero
        
        zoomRect.size.height = socialImage.frame.size.height / scale
        
        zoomRect.size.width  = socialImage.frame.size.width  / scale
        
        let newCenter = socialImage.convert(center, from: scrollView)
        
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return socialImage
        
    }
}



