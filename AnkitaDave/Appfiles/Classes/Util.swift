//
//  Util.swift
//  ZareenKhanConsumer
//
//  Created by Razr on 06/11/17.
//  Copyright © 2017 Razr. All rights reserved.
//

import UIKit
import Foundation

let imageCache = NSCache<NSString, AnyObject>()
class Util: NSObject
{
    
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}

class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
}

class RefreshManager: NSObject {

    static let shared = RefreshManager()
    private let defaults = UserDefaults.standard
    private let defaultsKey = "lastRefresh"
    private let calender = Calendar.current

    func loadDataIfNeeded(completion: (Bool) -> Void) {

        if isRefreshRequired() {
            // load the data
            defaults.set(Date(), forKey: defaultsKey)
            completion(true)
        } else {
            completion(false)
        }
    }

    private func isRefreshRequired() -> Bool {

        guard let lastRefreshDate = defaults.object(forKey: defaultsKey) as? Date else {
            return true
        }

        if let diff = calender.dateComponents([.hour], from: lastRefreshDate, to: Date()).hour, diff > 24 {
            return true
        } else {
            return false
        }
    }
}

//class ScaledHeightImageView: UIImageView {
//
//    // Track the width that the intrinsic size was computed for,
//    // to invalidate the intrinsic size when needed
//    private var layoutedWidth: CGFloat = 0
//
//    override var intrinsicContentSize: CGSize {
//        layoutedWidth = bounds.width
//        if let image = self.image {
//            let viewWidth = bounds.width
//            let ratio = viewWidth / image.size.width
//            return CGSize(width: viewWidth, height: image.size.height * ratio)
//        }
//        return super.intrinsicContentSize
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if layoutedWidth != bounds.width {
//            invalidateIntrinsicContentSize()
//        }
//    }
//}

extension UIImageView {
    
    public  func loadImageUsingCache(withUrl urlString : String, width: CGFloat, height: CGFloat) {
        
        if urlString == "" {
            return
        }
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            if width > 0
            {
                self.image =  resizeImage(image: cachedImage, newWidth: width, newHeight: height)  //cachedImage
                
            } else
            {
                self.image = cachedImage
            }
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    if width > 0
                    {
                        self.image =  self.resizeImage(image: image, newWidth: width, newHeight: height)  //cachedImage
                        
                    } else
                    {
                        self.image = image
                    }
                    imageCache.setObject(image, forKey: urlString as NSString)
                }
            }
            
        }).resume()
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        //for scalable heightbelow two lines
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //
        return newImage!
    }
  
    
}
extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
extension String {
    func captalizeFirstCharacter() -> String {
        if self.isEmpty
        {
            return ""
        } else
        {
            var result = self
            
            let substr1 = String(self[startIndex]).uppercased()
            result.replaceSubrange(...startIndex, with: substr1)
            
            return result
        }
        
    }
}
extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(Int(number))"
        }
    }
}
