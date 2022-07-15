//
//  Fonts.swift
//  Producer
//
//  Created by developer2 on 19/08/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import Foundation
import UIKit

var fonts: Fonts = {
    
    return Fonts()
}()

class Fonts: NSObject {
    
    func regular(size: CGFloat) -> UIFont {
        
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    func bold(size: CGFloat) -> UIFont {
                
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    func light(size: CGFloat) -> UIFont {
        
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }
    
    func medium(size: CGFloat) -> UIFont {
        
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    func semibold(size: CGFloat) -> UIFont {
        
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
}

