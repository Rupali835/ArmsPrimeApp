//
//  LoadingOverlay.swift
//  Producer
//
//  Copyright © 2017 premani technologies. All rights reserved.
//

import Foundation
import UIKit
public class LoadingOverlay {
    
    var overlayView : UIView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
         UIApplication.shared.keyWindow?.addSubview(overlayView)
//        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.overlayView.removeFromSuperview()
        }
    }
}
