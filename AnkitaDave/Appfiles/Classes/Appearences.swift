//
//  Appearences.swift
//  Producer
//
//  Created by developer2 on 19/08/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import UIKit

var appearences: Appearences = {
    
    return Appearences()
}()

class Appearences: NSObject {

    let borderColor: UIColor = .lightGray
    let placeholderColor = utility.rgb(170, 170, 170, 1)
    let cornerRadius: CGFloat = 4.0
    let redColor = utility.rgb(237, 38, 26, 1)
    let partialPaidColor = UIColor.orange.withAlphaComponent(0.7)
    let paidColor = UIColor.white.withAlphaComponent(0.7)
    let navTitleColor: UIColor = .black
    //let newTheamColor = #colorLiteral(red: 0.1960784314, green: 0, blue: 0.3215686275, alpha: 1)
    let newTheamColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    let yellowColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    let newIndigoColor = #colorLiteral(red: 0.3921568627, green: 0.3137254902, blue: 0.9882352941, alpha: 1)
    
}
