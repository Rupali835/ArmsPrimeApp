//
//  Utility.swift
//  AnveshiJain
//
//  Created by developer2 on 31/03/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Toaster

var utility: Utility = {
    
    return Utility()
}()

class Utility: NSObject {

    func getIPAddress() -> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }
    
    func rgb(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat) -> UIColor {
        
        let color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        return color
    }
    
    func getDateDiff(start: Date, end: Date) -> Int {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: start, to: end)
        
        return difference.second!
    }
    
    func alert(title: String = stringConstants.appName, message: String?, delegate: UIViewController?, buttons: [String]? = [stringConstants.ok], cancel: String?, completion: ((String)->())?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if buttons != nil {
            
            for i in 0..<buttons!.count {
                
                let action = UIAlertAction(title: buttons![i], style: UIAlertAction.Style.default) { (action) in
                    
                    completion?(action.title!)
                }
                
                alert.addAction(action)
            }
        }
        
        if cancel != nil {
            
            let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel) { (action) in
                
                completion?(action.title!)
            }
            
            alert.addAction(cancelAction)
        }
        
        delegate?.present(alert, animated: true, completion: nil)
    }
    func getTimeString(seconds: Int) -> String {
           
           let duration = getHMS(seconds: seconds)
           
           if duration.hours > 0 {
               
               return utility.getString(duration.hours) + ":" + utility.getString(duration.minutes) + ":" + utility.getString(duration.seconds)
           }
           else {
               
               return utility.getString(duration.minutes) + ":" + utility.getString(duration.seconds)
           }
       }
    
    func setIQKeyboardManager(_ isEnabled: Bool, showToolbar: Bool = true) {
        
        IQKeyboardManager.shared.enable = isEnabled
        IQKeyboardManager.shared.enableAutoToolbar = showToolbar
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
    }
    func showToast(msg: String, delay:TimeInterval = 0, duration:TimeInterval = 2, bottom:CGFloat = 80) {
           
           ToastCenter.default.cancelAll()
           
           let toast = Toast(text: msg, delay: delay, duration: duration)
           
           toast.view.bottomOffsetPortrait = bottom
           
           toast.view.backgroundColor = utility.rgb(30, 30, 30, 1)
           
           toast.show()
       }
    func isValidEmail(emailStr:String) -> Bool {
           
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: emailStr)
       }
       func isValidPhone(strPhone:String, isIndia:Bool = false) -> Bool {
          
           var isNumber = false
           
           do {
               let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
               let matches = detector.matches(in: strPhone, options: [], range: NSRange(location: 0, length: strPhone.count))
               if let res = matches.first {
                   isNumber = res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == strPhone.count
               } else {
                   
                   isNumber = false
               }
           } catch {
               
               isNumber = false
           }
           
           if isIndia {
               
               if isNumber == true && strPhone.count == 10 {
                   
                   return true
               }
           }
           else {
               
               if isNumber == true && strPhone.count >= 8 && strPhone.count < 13 {
                   
                   return true
               }
           }
           
           return false
       }
    func sheet(delegate: UIViewController?, buttons: [String] = [stringConstants.ok], cancel: String = stringConstants.cancel, completion: ((String)->())?) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        for i in 0..<buttons.count {
            
            let action = UIAlertAction(title: buttons[i], style: UIAlertAction.Style.default) { (action) in
                
                completion?(action.title!)
            }
            
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
//    func showToast(msg: String, delay:TimeInterval = 0, duration:TimeInterval = 2, bottom:CGFloat = 80) {
//
//        ToastCenter.default.cancelAll()
//
//        let toast = Toast(text: msg, delay: delay, duration: duration)
//
//        toast.view.bottomOffsetPortrait = bottom
//
//        toast.view.backgroundColor = utility.rgb(30, 30, 30, 1)
//
//        toast.show()
//    }
    
    func setCornerRadius(view: UIView, radius: CGFloat) {
        
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
    
    func setBorder(view: UIView, color: UIColor, width: CGFloat) {
        
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
        view.layer.masksToBounds = true
    }
    
    func setShadow(view: UIView, offset: CGSize, opacity: Float, radius: CGFloat, color: UIColor) {
        
        view.layer.shadowOffset = offset
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = radius
        view.layer.shadowColor = color.cgColor
    }
    
    func addScaleAnimation(inView: UIView, scale: CGFloat, key: String, delegate: UIViewController?) {
        
        let anim = CABasicAnimation(keyPath: "transform")
        anim.setValue(key, forKey: "pathValue")
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.duration = 0.125
        anim.repeatCount = 1
        anim.autoreverses = true
        anim.isRemovedOnCompletion = true
        
        if let delegated = delegate as? CAAnimationDelegate {
            anim.delegate = delegated
        }
        
        anim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(scale, scale, 1.0))
        inView.layer.add(anim, forKey: key)
    }
    
    func getDateDiff(date: Date) -> (days: Int, hours: Int,minutes: Int, seconds: Int) {

           let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]

           let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: Date(), to: date)

           return (difference.day!, difference.hour!, difference.minute!, difference.second!)
       }
    
//    func getTimeString(seconds: Int) -> String {
//        
//        let duration = getHMS(seconds: seconds)
//        
//        if duration.hours > 0 {
//            
//            return utility.getString(duration.hours) + ":" + utility.getString(duration.minutes) + ":" + utility.getString(duration.seconds)
//        }
//        else {
//            
//            return utility.getString(duration.minutes) + ":" + utility.getString(duration.seconds)
//        }
//    }
    
    func showToast(msg: String, delay:TimeInterval = 0, duration:TimeInterval = 2) {
        
        ToastCenter.default.cancelAll()
        
        let toast = Toast(text: msg, delay: delay, duration: duration)
        
        toast.view.bottomOffsetPortrait = 150
        
        toast.show()
    }
    
    func getHMS(seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getTimeString(_ seconds: Int) -> String {
        
        let duration = getHMS(seconds: seconds)
        
        if duration.hours > 0 {
            
            return getString(duration.hours) + ":" + getString(duration.minutes) + ":" + getString(duration.seconds)
        }
        else {
            
            return getString(duration.minutes) + ":" + getString(duration.seconds)
        }
    }
    
    func getString(_ number: Int) -> String {
        
        return number < 10 ? "0\(number)" : "\(number)"
    }
    
    func getDurationString(_ seconds: Int) -> String {
        
        let duration = getHMS(seconds: seconds)
        
        let strHour = String(duration.hours) + " " + "\(duration.hours == 1 ? stringConstants.hour : stringConstants.hours)"
        
        let strMinute = String(duration.minutes) + " " + "\(duration.minutes == 1 ? stringConstants.minute : stringConstants.minutes)"
        
        let strSecond = String(duration.seconds) + " " + "\(duration.seconds == 1 ? stringConstants.second : stringConstants.seconds)"
        
        if duration.hours > 0 {
            
            if duration.seconds > 0 {
                
                return strHour + " " + strMinute + " " + strSecond
            }
            else {
                
                return strHour + " " + strMinute
            }
        }
        else if duration.minutes > 0 {
            
            if duration.seconds > 0 {
                
                return strMinute + " " + strSecond
            }
            else {
                
                return strMinute
            }
        }
        else {
                
            return strSecond
        }
    }
    
    func application() -> String {
        return Bundle.main.resourcePath!
    }
    
    func application(_ component: String?) -> String {
        var path = application()
        if (component != nil) { path = (path as NSString).appendingPathComponent(component!)    }
        return path
    }
}
