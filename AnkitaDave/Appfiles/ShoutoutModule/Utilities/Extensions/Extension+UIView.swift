//
//  Extension+UIView.swift
//  VideoGreetings
//
//  Created by Apple on 04/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return 0 }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var corner: CGFloat {
        
        get { return 0 }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var makeCirculaer: Bool {
        get { return false }
        
        set {
            if newValue == true {
                layer.cornerRadius = frame.width / 2.0
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return 0 }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { return nil }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get { return nil }
        
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return 0 }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOffest: CGSize {
        get { return CGSize.zero }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { return 0 }
        
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get { return false }
        
        set {
            layer.masksToBounds = newValue
        }
    }
    
    func addGradientOverlay(direction: GradientDirection, scale: CGFloat, colors: [UIColor] = [UIColor.clear,  UIColor.black]) {
        let gradient = CAGradientLayer()
        let gradientHeight = bounds.height * scale
        gradient.colors = colors.map { $0.cgColor }
        
        switch direction {
        case .topToBottom:
            gradient.frame = CGRect(x: 0.0, y: 0, width: bounds.width, height: gradientHeight)
            gradient.locations = [1.0, 0.0]
            
            
        case .bottomToTop:
            gradient.frame = CGRect(x: 0.0, y: bounds.height - gradientHeight, width: bounds.width, height: gradientHeight)
            gradient.locations = [0.0, 1.0]
        }
        
        layer.sublayers?.forEach({ (layer) in
            if let isGradient = layer as? CAGradientLayer {
                isGradient.removeFromSuperlayer()
            }
        })
        
        layer.insertSublayer(gradient, at: 0)
    }
}

enum GradientDirection {
    case topToBottom
    case bottomToTop
}
