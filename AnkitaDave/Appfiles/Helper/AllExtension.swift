//
//  AllExtension.swift
//  AnveshiJain
//
//  Created by webwerks on 20/05/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import SideMenu

extension CAGradientLayer {
    
    enum Point {
        case topRight, topLeft
        case bottomRight, bottomLeft
        case custion(point: CGPoint)
        
        var point: CGPoint {
            switch self {
            case .topRight: return CGPoint(x: 1, y: 0)
            case .topLeft: return CGPoint(x: 0, y: 0)
            case .bottomRight: return CGPoint(x: 1, y: 1)
            case .bottomLeft: return CGPoint(x: 0, y: 1)
            case .custion(let point): return point
            }
        }
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.init()
        self.frame = frame
        self.colors = colors.map { $0.cgColor }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: Point, endPoint: Point) {
        self.init(frame: frame, colors: colors, startPoint: startPoint.point, endPoint: endPoint.point)
    }
    
    func createGradientImage() -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension UINavigationBar {
    func setGradientBackground(colors: [UIColor], startPoint: CAGradientLayer.Point = .topLeft, endPoint: CAGradientLayer.Point = .bottomLeft) {
//        var updatedFrame = bounds
//        updatedFrame.size.height += self.frame.origin.y
//        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, startPoint: startPoint, endPoint: endPoint)
//        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
        self.backgroundColor = BlackThemeColor.darkBlack
    }
}

extension UITabBar{
    func setGradientBackground(colors: [CGColor], startPoint: CAGradientLayer.Point = .topLeft, endPoint: CAGradientLayer.Point = .bottomLeft) {
        let layerGradient = CAGradientLayer()
        layerGradient.colors = colors
        layerGradient.startPoint = CGPoint(x: 0, y: 0)
        layerGradient.endPoint = CGPoint(x: 1, y: 1)
        layerGradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height+34)
        self.layer.addSublayer(layerGradient)
    }
    
    func setBarBackgroundImage() {
        let bgView: UIImageView = UIImageView(image: UIImage(named: "tabBG.jpg"))
        bgView.frame = self.frame//you might need to modify this frame to your tabbar frame
        self.addSubview(bgView)
    }
}
extension Date{
    
    static func getCurrentDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        return formatter.string(from: currentDateTime)
    }
}

extension UIViewController {
    func showAlert(title:String = "Alert", message:String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if #available(iOS 11.0, *) {
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(resultViewController, animated: true)
            }
        }
        vc.addAction(ok)
        vc.addAction(cancel)
        vc.preferredAction = ok
        self.present(vc, animated: true, completion: nil)
        
    }

    func showPhotoPreview(photo: String) {

        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(photo)
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)

        SKPhotoBrowserOptions.swapCloseAndDeleteButtons = true

        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images, initialPageIndex: 0)
        present(browser, animated: true, completion: {})
    }

    func gotoGamesController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameViewController = storyBoard.instantiateViewController(withIdentifier: "GamesViewController") as! GamesViewController
        gameViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
//    func showOnlyAlert(title:String = "Alert", message:String) {
//        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//        vc.addAction(ok)
//        self.present(vc, animated: true, completion: nil)
//    }
    func showOnlyAlert(title:String = "Alert", message:String, completion : (() -> ())? = nil) {
        
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action) in
            completion?()
        }
        
        vc.addAction(okAction)
        self.present(vc, animated: true, completion: nil)
    }
    func checkIsUserLoggedIn() -> Bool {
        if  UserDefaults.standard.object(forKey: "LoginSession") as? String == nil || UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionOut" || UserDefaults.standard.value(forKey: "LoginSession") as! String == "LoginSession"  {
            return false
        } else {
            return true
        }
    }
}


extension UIView {
    func addunderlinedWithColor(color: UIColor){
           let border = CALayer()
           let width = CGFloat(1.0)
           border.borderColor = color.cgColor
           border.frame = CGRect(x: 3, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
           border.borderWidth = width
           self.layer.addSublayer(border)
           self.layer.masksToBounds = true
       }
       var viewMasksToBounds: Bool {
           get { return false }
           
           set {
               layer.masksToBounds = newValue
           }
       }
       
       var glowEffect: Bool {
           
           get { return false }
           
           set {
               
               if newValue {
                   
                   self.shadowColor = UIColor.white
                   self.shadowOffest = CGSize.init(width: 0, height: 0)
                   self.shadowRadius = 8.0
                   self.shadowOpacity = 0.7
                   self.viewMasksToBounds = false
               }
           }
       }
    func setGradientBackground() {
//          let gradientLayer = CAGradientLayer(frame: self.bounds, colors: [hexStringToUIColor(hex:Colors.lightMaroon.rawValue),  hexStringToUIColor(hex:Colors.black.rawValue)], startPoint: CAGradientLayer.Point.topLeft, endPoint: CAGradientLayer.Point.bottomLeft)
//         self.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundColor = BlackThemeColor.darkBlack
    }
    
    func setGradientBackground(color: [UIColor]) {
//        let gradientLayer = CAGradientLayer(frame: self.bounds, colors: color, startPoint: CAGradientLayer.Point.topLeft, endPoint: CAGradientLayer.Point.bottomLeft)
//        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradient() {
        self.backgroundColor = .clear
        print("Sublayers \(layer.sublayers?.count)")
        if let sublayers = layer.sublayers {
            sublayers.forEach { (layer) in
                if let gradientLayer = layer as? CAGradientLayer {
                    gradientLayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func addunderlined() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 3, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension Notification.Name {
    static let didReceiveScreenName = Notification.Name("didReceiveScreenName")
}

extension UIViewController : SideMenuNavigationControllerDelegate  {

    func addSideMeuBarButton() {
        let HamburgerMenu = UIButton()
        HamburgerMenu.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        if let image = UIImage(named: "hamburge") {
            HamburgerMenu.setImage(image, for: .normal)
            let barButton = UIBarButtonItem()
            barButton.customView = HamburgerMenu
//            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItems = [barButton]
            HamburgerMenu.addTarget(self, action:#selector(openSidemenu), for: .touchUpInside)
        }
    }

    @objc func openSidemenu() {
        let sidemenuController = Storyboard.main.instantiateViewController(viewController: MenuViewController.self)
        let menu = SideMenuNavigationController(rootViewController: sidemenuController)
        menu.leftSide = true
        menu.sideMenuDelegate = self
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = view.bounds.width * 0.8
        present(menu, animated: true, completion: nil)
    }

    func setNavigationView(title: String) {
            
            self.navigationItem.title = title
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: AppFont.light.rawValue, size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.white]
    //        let colors: [UIColor] = [hexStringToUIColor(hex: Colors.textMaroon.rawValue), hexStringToUIColor(hex: Colors.black.rawValue)]
            
            if self.view.tag != -100 {
             
                self.view.setGradientBackground()
            }
                    
            if self.navigationController != nil {
              self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: Colors.darkGray.rawValue)
            }
        }
        
        func setupNavigationBar() {
            navigationItem.backBarButtonItem?.title = ""
            navigationController?.navigationBar.barStyle = .black
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: AppFont.light.rawValue, size: 20) ?? UIFont.systemFont(ofSize: 20.0, weight: .light),  NSAttributedString.Key.foregroundColor: UIColor.white]
    //        let colors: [UIColor] = [hexStringToUIColor(hex: Colors.lightMaroon.rawValue), hexStringToUIColor(hex: Colors.black.rawValue)]
            
            if self.view.tag != -100 {
             
                self.view.setGradientBackground()
            }
            
            if self.navigationController != nil {
              self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: Colors.darkGray.rawValue)
            }
        }
    }


extension UITextField {
    func underlined() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 3, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func changePlaceholderColor(color: UIColor) {
        
        if let placeholder = self.placeholder {
            
            self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                            attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    func setAttributedPlaceholder(text: String, attributes: [NSAttributedString.Key : Any]) {
        
        let attStr = NSAttributedString(string: text, attributes: attributes)
        self.attributedPlaceholder = attStr
    }
}

extension UITextView {
    func underlined() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 3, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIImagePickerController {

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .black
        self.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
    self.navigationBar.topItem?.rightBarButtonItem?.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: AppFont.bold.rawValue, size: 17)!,
                NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .normal)
        
        
    }
}
