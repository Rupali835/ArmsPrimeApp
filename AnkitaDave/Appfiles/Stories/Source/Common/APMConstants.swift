//
//  APMConstants.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit

public struct APMScreen {
    /**UIScreen.main.bounds.width*/
    static let width = UIScreen.main.bounds.width
    /**UIScreen.main.bounds.height*/
    static let height = UIScreen.main.bounds.height
}

//Referring the Instagram Theme colors
//https://www.designpieces.com/palette/instagram-new-logo-2016-color-palette/
public struct APMTheme {
    //Instagram Red Orange
    static let redOrange = UIColor.rgb(from: 0xe95950)
}

enum UserDefaultKey: String {
    case inAppPackages
    case recentSticker
}
