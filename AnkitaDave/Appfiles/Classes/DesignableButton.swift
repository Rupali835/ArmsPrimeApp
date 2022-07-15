//
//  DesignableButton.swift
//  Live
//
//  Created by leo on 16/7/12.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

class DesignableButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var borderColor_: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor_.cgColor
        }
    }
    
    @IBInspectable var cornerRadius_: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius_
        }
    }
    
    @IBInspectable var borderWidth_: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth_
        }
    }
    
}
