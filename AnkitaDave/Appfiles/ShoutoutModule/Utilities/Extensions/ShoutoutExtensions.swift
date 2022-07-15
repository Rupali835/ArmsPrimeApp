//
//  Extension+TableView+Cell.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func centerImageAndTitleVertically(space: CGFloat = 2.0, customImageSize: CGSize = CGSize(width: 32.0, height: 32.0)) {
        let spacing: CGFloat = space
        
        guard let titleSize = self.titleLabel?.frame.size, let _ = self.imageView?.frame.size else { return }
        
        let offset = (frame.size.height - customImageSize.height) / 2
        self.imageView?.contentMode = .scaleAspectFit
        self.titleLabel?.textAlignment = .center
        
        self.imageEdgeInsets = UIEdgeInsets(top: offset - titleSize.height - spacing, left: offset + 2.0, bottom: offset, right: offset)
        
        var titleInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        titleInsets.top = frame.height - customImageSize.height - titleSize.height - spacing
        // TO Do:
        //titleInsets.left = -(frame.size.width - titleSize.width + customImageSize.width) / 2 + 6.0
        titleInsets.left = (-(frame.size.width - customImageSize.width + titleSize.width) / 2) + 5.0 + (frame.size.width - titleSize.width) / 2.0
        //titleInsets.right = (frame.size.width - titleSize.width) / 4
        //titleInsets.bottom = 8.0 //titleEdgeInsets.bottom + spacing
        //self.titleEdgeInsets = titleInsets
        titleEdgeInsets.left = 0
        titleEdgeInsets.right = 0
    }
    
    func centerImageAndTitleAddingViews(space: CGFloat = 2.0, customImageSize: CGSize = CGSize(width: 32.0, height: 32.0), image: UIImage?, title: String?) {
        imageView?.image = nil
        let customImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: customImageSize.width, height: customImageSize.height))
        customImageView.isUserInteractionEnabled = false
        customImageView.image = image
        customImageView.contentMode = .scaleAspectFit
        
        let customTitleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: titleLabel?.frame.height ?? 25.0))
        customTitleLabel.isUserInteractionEnabled = false
        customTitleLabel.font = titleLabel?.font
        customTitleLabel.textColor = UIColor.black //titleLabel?.textColor
        customTitleLabel.text = title
        customTitleLabel.textAlignment = .center
        customTitleLabel.backgroundColor = UIColor.red
        
        let contentHeight: CGFloat = customImageSize.height + space + customTitleLabel.frame.height
        let verticalPadding: CGFloat = (frame.height - contentHeight) / 2.0
        let leftImagePadding: CGFloat = (frame.width - customImageSize.width) / 2.0
        
        customImageView.frame = CGRect(x: leftImagePadding, y: verticalPadding, width: customImageSize.width, height: customImageSize.height)
        customTitleLabel.frame = CGRect(x: 0.0, y: frame.height - verticalPadding - customTitleLabel.frame.height, width: frame.width, height: titleLabel?.frame.height ?? 25.0)
        
        addSubview(customImageView)
        addSubview(customTitleLabel)
    }
    
    func centerImageAndTitleVerticallyWithOriginalImageSize(space: CGFloat = 2.0) {
        let spacing: CGFloat = space
        
        guard let titleSize = self.titleLabel?.frame.size, let imageSize = self.imageView?.frame.size else { return }
        
        self.imageView?.contentMode = .scaleAspectFit
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0, right: -titleSize.width)
    }
}

extension UIViewController {
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

extension UIFont {
    var italic: UIFont {
        var symbolicTraits = fontDescriptor.symbolicTraits
        symbolicTraits.insert([.traitItalic])
        guard let fontDescriptorData = fontDescriptor.withSymbolicTraits(symbolicTraits) else { return self }
        return UIFont(descriptor: fontDescriptorData, size: pointSize)
    }
}
