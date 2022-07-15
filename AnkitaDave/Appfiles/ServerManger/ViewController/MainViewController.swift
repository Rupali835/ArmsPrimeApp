//
//  MainViewController.swift
//  Karan Kundrra Official
//
//  Created by Razrtech3 on 02/05/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UITabBarController,UITabBarControllerDelegate {

   @IBOutlet weak var myTabBar: UITabBar?
    
     var previousVC : UIViewController?
     
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.delegate = self
        self.tabBarController?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
//        myTab
        tabBarItem.title = ""
         let colors: [CGColor] = [hexStringToUIColor(hex: Colors.lightMaroon.rawValue).cgColor, hexStringToUIColor(hex: Colors.black.rawValue).cgColor]
        myTabBar?.setGradientBackground(colors: colors)
//        let layerGradient = CAGradientLayer()
//        layerGradient.colors = [hexStringToUIColor(hex: Colors.lightMaroon.rawValue).cgColor, hexStringToUIColor(hex: Colors.primaryDark.rawValue).cgColor]
//        layerGradient.startPoint = CGPoint(x: 0, y: 0)
//        layerGradient.endPoint = CGPoint(x: 1, y: 1)
//        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//        self.myTabBar?.layer.addSublayer(layerGradient)
//        myTabBar?.setBarBackgroundImage()
        setTabBarItems()
//
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    func setTabBarItems() {
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "newsFeedUnclick")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "newsFeedClicked")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.title = "STAY CLOSE"
//        myTabBarItem1.selectedIndexVal = IndexPath.row
    
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -4, right: 0)
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "photoUnclick")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "photoClick")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.title = "SEE ME"
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -4, right: 0)
        
        
//        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
//        myTabBarItem3.image = UIImage(named: "Icon-App-40x40@1x")?.resizedImage(newWidth: 30).roundedImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
////        let barImage: UIImage = UIImage(named: "avatar_copy.png")!.resizedImage(newWidth: 40).roundedImage.withRenderingMode(.alwaysOriginal)
//        myTabBarItem3.selectedImage = UIImage(named: "Icon-App-40x40@1x")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
////        myTabBarItem3.layer.cornerRadius = 0.5 * myTabBarItem3.bounds.size.width
//        myTabBarItem3.title = "LIVE"
        
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage(named: "videoUnclick")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem3.selectedImage = UIImage(named: "videoClick")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem3.title = "KNOW ME"
        myTabBarItem3.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -4, right: 0)
        
        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: "menuUnclick")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.selectedImage = UIImage(named: "menuClick")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.title = "MENU"
        myTabBarItem4.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -4, right: 0)
        
        
        let selectedColor   = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        let unselectedColor = hexStringToUIColor(hex: MyColors.tabBarUnSelectedTextColor)//UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        UITabBar.appearance().unselectedItemTintColor = hexStringToUIColor(hex: MyColors.tabBarUnSelectedTextColor)
        UITabBar.appearance().tintColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: AppFont.light.rawValue, size: 9)!], for: .normal)
         UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: AppFont.light.rawValue, size: 9)!], for: .selected)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.myTabBar?.isHidden = false
        print("tab bar didSelect called")
        if let rootViewController = UIApplication.topViewController() {
          print("tab bar didSelect photo called")
            if (rootViewController.isKind(of: PhotosTableViewController.self) && previousVC != nil &&  (previousVC?.isKind(of: PhotosTableViewController.self))!) {
                let vc : PhotosTableViewController = rootViewController as! PhotosTableViewController
                if (vc.PhotoViewTable != nil && vc.isTableLoaded) {
                    let numberOfSections = vc.PhotoViewTable.numberOfSections
                    let numberOfRows = vc.PhotoViewTable.numberOfRows(inSection:numberOfSections-1)
             
                
                    if (numberOfRows > 0) {
                        vc.PhotoViewTable.scrollToRow(at:IndexPath.init(row: 0, section: 0) , at: .top, animated: true)
                    }
                }
            }
            else if (rootViewController.isKind(of: VideosViewController.self) &&  previousVC != nil && (previousVC?.isKind(of: VideosViewController.self))!) {
                print("tab bar didSelect video called")
                let vc : VideosViewController = rootViewController as! VideosViewController
                if (vc.videoTableView != nil && vc.isTableLoaded) {
                    let numberOfSections = vc.videoTableView.numberOfSections
                    let numberOfRows = vc.videoTableView.numberOfRows(inSection:numberOfSections-1)
                   
                    if (numberOfRows > 0) {
                    vc.videoTableView.scrollToRow(at:IndexPath.init(row: 0, section: 0) , at: .top, animated: true)
                    }
                    
                }
            } else if (rootViewController.isKind(of: SocialJunctionViewController.self) && previousVC != nil &&  (previousVC?.isKind(of: SocialJunctionViewController.self))!) {
                print("tab bar didSelect newsfeed called")
                let vc : SocialJunctionViewController = rootViewController as! SocialJunctionViewController
                if (vc.socialTableView != nil && vc.isTableLoaded) {
                    let numberOfSections = vc.socialTableView.numberOfSections
                    let numberOfRows = vc.socialTableView.numberOfRows(inSection:numberOfSections-1)
                    
                    if (numberOfRows > 0) {
                    vc.socialTableView.scrollToRow(at:IndexPath.init(row: 0, section: 0) , at: .top, animated: true)
                        
                    }
                }
            }
            previousVC =  rootViewController
        }
    }
    
//    func clickTabbarButtonEffect() {
//            let anim = CABasicAnimation(keyPath: "transform")
//        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        anim.duration = 0.125
//        anim.repeatCount = 1
//        anim.autoreverses = true
//        anim.isRemovedOnCompletion = true
//        anim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0))
//        self.likeButton.setImage(#imageLiteral(resourceName: "heart_filled"), for: .normal)
//        self.likeButton.layer.add(anim, forKey: nil)
//    }
//
   
class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.5
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
}



extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
extension UIImage{
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    func resizedImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

