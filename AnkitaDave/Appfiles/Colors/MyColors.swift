//
//  MyColors.swift
//  Consumer App
//
//  Created by developer2 on 14/03/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import Foundation
import UIKit
//enum Colors:String {
//    case primary = "#3F4047"
//    case primaryDark = "#340000"
//    case secondary = "#04AF8E"
//    case casual = "#06FCCD"
//    //case accent = "#ef3d2c"
//    case blue = "#83ddf7"
//    case blueLight = "#5bc0de"
//    case blueDark = "#46b8da"
//    case green = "#59d25b"
//    case red = "#ef3d2c"
//    //    case purple = "#736eb2"
//    case white = "#191919"
//    case gray80pc = "#ff333333"
//    case shadowColor = "#CCCCCC"
//    case black = "#000000"
//    case lightMaroon = "#480009"
//    case lightPink = "#FF919C"
//    case textMaroon = "#DDB216"
//    case textGary = "#FFFFFF"
//    case textGaryFaint = "#3d3d3d"
//    case darkGray = "#2D2D2D"
//}

enum Colors:String {
    case primary = "#3F4047"
    case primaryDark = "#340000"
    case secondary = "#04AF8E"
    case casual = "#06FCCD"
    //case accent = "#ef3d2c"
    case blue = "#83ddf7"
    case blueLight = "#5bc0de"
    case blueDark = "#46b8da"
    case green = "#59d25b"
    case red = "#ef3d2c"
    //    case purple = "#736eb2"
    case white = "#ffffff"
    case gray80pc = "#ff333333"
    case shadowColor = "#CCCCCC"
    case black = "#000000"
    case lightMaroon = "#480009"
    case lightPink = "#FF919C"
    case textMaroon = "#590016"
    case textGary = "#909090"
    case textGaryFaint = "#3d3d3d"
    case darkGray = "#2D2D2D"

}

struct MyColors {
    static let navigationnBar : String = { return Colors.white.rawValue }()
    static let cardBackground : String = { return Colors.white.rawValue }()
    static let primaryDark : String = { return Colors.lightMaroon.rawValue }()
    static let primary : String = { return Colors.primary.rawValue }()
    static let secondary : String = { return Colors.secondary.rawValue }()
    static let casual : String = { return Colors.black.rawValue }()
    static let refreshControlTintColor: String = { return Colors.white.rawValue}()
    static let tabBarUnSelectedTextColor: String = { return Colors.lightPink.rawValue}()
    static let cellNameLabelTextColor: String = { return Colors.textMaroon.rawValue}()
    static let cellDateLabelTextColor: String = { return Colors.textGary.rawValue}()
    static let cellStatusLabelTextColor: String = { return Colors.textGaryFaint.rawValue}()
    static let pollLabelColor: String = { return Colors.black.rawValue}()
 //    static let appThemeColor: String = { return Colors.themColor.rawValue}()

}

//enum AppFont:String {
//    case regular = "Raleway-Regular"
//    case medium = "Raleway-Medium"
//    case bold = "Raleway-Bold"
//    case light = "Raleway-Light"
//}

enum AppFont:String {
    case regular = "Bebas-Regular"
    case medium = "OpenSans-Regular"
    case bold = "OpenSans-Bold"
    case light = "OpenSans-Semibold"
}

struct BlackThemeColor {

    static var darkBlack: UIColor  {
        if let color = UIColor(named: "AJDarkBlack") {
            return color
        } else {
            return UIColor.black
        }
    }

    static var lightBlack: UIColor  {
        if let color = UIColor(named: "AJLightBlack") {
            return color
        } else {
            return UIColor.lightGray
        }
    }

    static var dlSenderback: UIColor  {
        if let color = UIColor(named: "DLSenderBack") {
            return color
        } else {
            return   UIColor.lightGray
        }
    }

    static var lightGray: UIColor  {
           if let color = UIColor(named: "lightGray") {
               return color
           } else {
               return   UIColor.lightGray
           }
       }


    static var white: UIColor  {
           if let color = UIColor(named: "AJWhite") {
               return color
           } else {
               return UIColor.white
           }
       }

    static var yellow: UIColor  {
        if let color = UIColor(named: "AJYellow") {
            return color
        } else {
            return UIColor.yellow
        }
    }

    static var tabGray: UIColor  {
          if let color = UIColor(named: "tabGray") {
              return color
          } else {
              return UIColor.gray
          }
      }
    
    static var Indigo: UIColor  {
          if let color = UIColor(named: "Indigo") {
              return color
          } else {
              return UIColor.systemIndigo
          }
      }
    
    
}
