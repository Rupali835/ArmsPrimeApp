//
//  Macros.swift
//  Producer
//
//  Created by developer2 on 19/08/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import Foundation
import UIKit

var macros: Macros = {
    
    return Macros()
}()

class Macros: NSObject {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    let appDel = UIApplication.shared.delegate as? AppDelegate
    
    var safeArea : (top:CGFloat, bottom: CGFloat) {
        
        get {
            
            if #available(iOS 11.0, *) {
                
                let window = UIApplication.shared.keyWindow
                
                var topInset:CGFloat = 0
                var bottomInset:CGFloat = 0

                if let topPadding = window?.safeAreaInsets.top {
                    
                    topInset = topPadding
                }
                
                if let bottomPadding = window?.safeAreaInsets.bottom {
                    
                    bottomInset = bottomPadding
                }
                                
                return (topInset, bottomInset)
            }
            else {
                
                return (0, 0)
            }
        }
    }
}


