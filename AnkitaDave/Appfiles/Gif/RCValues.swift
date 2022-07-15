//
//  RCValues.swift
//  RemoteConfigTutorial
//
//  Created by Razrtech3 on 01/08/18.
//  Copyright © 2018 Razrtech3. All rights reserved.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

class RCValues {
    
    static let sharedInstance = RCValues()
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    enum ValueKey: String {
        case bigLabelColor
        case flyingColors
        case array_suggestions
        case navBarBackground
        case navTintColor
        case eventTitleColor
        case detailInfoColor
        case subscribeBannerText
        case eventTitleText
        case subscribeVCText
        case subscribeVCButton
        case eventDisplay
        case experimentGroup
        case isServerUnderMaintenanceIOS
        case isWebEnabled
        case serverMessageIOS
        case planetImageScaleFactor
        case bannerImageview
        case rechargeTitleText
        case rechargeAmount
        case web_label
        case web_url
        case messageWardrobeDeliveryNoteIos
        case showMobileVerifyPopupIos
        case isMobileVerificationMandatoryIos
        case showBuyCoinsLiveBtniOS
        case verifyMobileMandetoryIos
        case verifyMobileOptionalIos
        case DLPhotoShow
        case isPreventvideorecordingIos
    }
    
    
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    //MARK:-
    func loadDefaultValues() {
        
        let appDefaults: [String: Any?] = [
            ValueKey.bigLabelColor.rawValue: "#FFFFFF66",
            ValueKey.rechargeTitleText.rawValue: "Your wallet balance is getting low. Please recharge your wallet.",
            ValueKey.flyingColors.rawValue: "#FFFFFF~#FFFFFF~#FFFFFF",
            ValueKey.navBarBackground.rawValue: "#535E66",
            ValueKey.navTintColor.rawValue: "#FBB03B",
            ValueKey.eventTitleColor.rawValue: "#FFFFFF",
            ValueKey.detailInfoColor.rawValue: "#CCCCCC",
            ValueKey.subscribeBannerText.rawValue: "Like Planet Tour?",
            ValueKey.eventTitleText.rawValue: "",
            ValueKey.subscribeVCText.rawValue: "Want more astronomy facts? Sign up for our newsletter!",
            ValueKey.subscribeVCButton.rawValue: "Subscribe",
            ValueKey.eventDisplay.rawValue: false,
            ValueKey.serverMessageIOS.rawValue:"Server is temporarily unavailable or under maintenance. Request you to please try again after sometime.",
            ValueKey.isServerUnderMaintenanceIOS.rawValue:false,
            ValueKey.isWebEnabled.rawValue: false,
            ValueKey.web_label.rawValue:"",
            ValueKey.web_url.rawValue:"",
            ValueKey.experimentGroup.rawValue: "default",
            ValueKey.rechargeAmount.rawValue: 100,
            ValueKey.bannerImageview.rawValue: "https://www.google.co.in/imgres?imgurl=https://www.gettyimages.ie/gi-resources/images/Homepage/Hero/UK/CMS_Creative_164657191_Kingfisher.jpg&imgrefurl=https://www.gettyimages.ie/&h=550&w=1140&tbnid=fiJ-HZc0KFC-WM:&q=image&tbnh=96&tbnw=200&usg=AFrqEzdWc9tvtP3Veswk92nOEagKDltAKQ&vet=12ahUKEwjDkPy3gdHcAhUXX30KHUAFBLgQ_B0wG3oECAcQCQ..i&docid=2ESR_bi_dYOFhM&itg=1&sa=X&ved=2ahUKEwjDkPy3gdHcAhUXX30KHUAFBLgQ_B0wG3oECAcQCQ",
            ValueKey.messageWardrobeDeliveryNoteIos.rawValue: "Item collection from Mumbai or can be couriered on Freight.\n\nDomestic - We deliver items in 3 to 4 days\n\nInternational - We deliver item in 15 working days\n\nDelivery at Home - Timing 7pm-9pm-Mon-Sat\n\nOffice - Timings 10am-5pm Mon-Sat",
            ValueKey.showMobileVerifyPopupIos.rawValue: false,
            ValueKey.isMobileVerificationMandatoryIos.rawValue: false,
            ValueKey.showBuyCoinsLiveBtniOS.rawValue: true,
            ValueKey.verifyMobileOptionalIos.rawValue: false,
            ValueKey.verifyMobileMandetoryIos.rawValue: false,
            ValueKey.DLPhotoShow.rawValue: false,
            ValueKey.isPreventvideorecordingIos.rawValue: false
        ]
        
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }

    func comment(forKey key: ValueKey) -> Array<String> {

        var commentArray =  [String]()
        if let commentAsHexString = RemoteConfig.remoteConfig()[key.rawValue].stringValue as? String{

            let commenArray = commentAsHexString.components(separatedBy: "~")
            commentArray = [String]()
            for comments in commenArray{
                commentArray.append(comments)
            }
        }

        return commentArray
    }

    func fetchCloudValues() {
        
        let fetchDuration: TimeInterval = 0
        activateDebugMode()
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { [weak self] status, error in
            
            if let error = error {
                print ("Uh-oh. Got an error fetching remote values \(error)")
                return
            }
            
            RemoteConfig.remoteConfig().activate { (error) in
                print(error ?? "Firebase RemoteConfig Eroor")
            }
            
            let eventTitleText = RemoteConfig.remoteConfig()
                .configValue(forKey: "eventTitleText")
                .stringValue ?? "undefined"
            let eventTitleColor = RemoteConfig.remoteConfig()
                .configValue(forKey: "eventTitleColor")
                .stringValue ?? "undefined"
            let bannerImageview = RemoteConfig.remoteConfig()
                .configValue(forKey: "bannerImageview")
                .stringValue ?? "undefined"
            let eventDisplay = RemoteConfig.remoteConfig()
                .configValue(forKey: "eventDisplay")
                .stringValue ?? "undefined"
            let flyingColors = RemoteConfig.remoteConfig()
                .configValue(forKey: "flyingColors")
                .stringValue ?? "undefined"
            let rechargeTitleText = RemoteConfig.remoteConfig()
                .configValue(forKey: "rechargeTitleText")
                .stringValue ?? "undefined"
            let rechargeAmount = RemoteConfig.remoteConfig()
                .configValue(forKey: "rechargeAmount")
                .stringValue ?? "undefined"
            let serverMessageIOS = RemoteConfig.remoteConfig()
                .configValue(forKey: "serverMessageIOS")
                .stringValue ?? "undefined"
            let isServerUnderMaintenanceIOS = RemoteConfig.remoteConfig()
                .configValue(forKey: "isServerUnderMaintenanceIOS")
                .stringValue ?? "undefined"
            let isWebEnabled = RemoteConfig.remoteConfig().configValue(forKey: "isWebEnabled").stringValue ?? "undefined"
            let web_label = RemoteConfig.remoteConfig()
                .configValue(forKey: "web_label")
                .stringValue ?? "undefined"
            let web_url = RemoteConfig.remoteConfig()
                .configValue(forKey: "web_url")
                .stringValue ?? "undefined"
            let messageWardrobeDeliveryNoteIos = RemoteConfig.remoteConfig()
                .configValue(forKey: "messageWardrobeDeliveryNoteIos")
                .stringValue ?? "undefined"
            let showMobileVerifyPopupIos = RemoteConfig.remoteConfig()
                .configValue(forKey: "showMobileVerifyPopupIos").boolValue
            let isMobileVerificationMandatoryIos = RemoteConfig.remoteConfig()
                .configValue(forKey: "isMobileVerificationMandatoryIos").boolValue
            let verifyMobileOptionalIos = RemoteConfig.remoteConfig()
            .configValue(forKey: "verifyMobileOptionalIos").boolValue
            let verifyMobileMandetoryIos = RemoteConfig.remoteConfig()
            .configValue(forKey: "verifyMobileMandetoryIos").boolValue
            let DLPhotoShow = RemoteConfig.remoteConfig()
            .configValue(forKey: "DLPhotoShow").boolValue
            
            let isPreventvideorecordingIos = RemoteConfig.remoteConfig()
            .configValue(forKey: "isPreventvideorecordingIos").boolValue
            
            print("Firebase serverMessageIOS is \(serverMessageIOS)")
            print("Firebase isServerUnderMaintenanceIOS is \(isServerUnderMaintenanceIOS)")
            print("Firebase web_label is \(web_label)")
            print("Firebase web_url is \(web_url)")
            print("Firebase isWebEnabled is \(isWebEnabled)")
            print("Firebase eventTitleText is \(eventTitleText)")
            print("Firebase eventTitleColor is \(eventTitleColor)")
            print("Firebase bannerImageview is \(bannerImageview)")
            print("Firebase eventDisplay is \(eventDisplay)")
            print("Firebase flyingColors is \(flyingColors)")
            print("Firebase rechargeTitleText is \(rechargeTitleText)")
            print("Firebase rechargeAmount is \(rechargeAmount)")
            print("Firebase messageWardrobeDeliveryNoteIos is \(messageWardrobeDeliveryNoteIos)")
            print("Firebase showMobileVerifyPopupIos is \(showMobileVerifyPopupIos)")
            print("Firebase isMobileVerificationMandatoryIos is \(isMobileVerificationMandatoryIos)")
            print("Firebase isPreventvideorecordingIos is \(isPreventvideorecordingIos)")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
            
            self?.fetchComplete = true
            self?.loadingDoneCallback?()
        }
    }
    
    func bool(forKey key: ValueKey) -> Bool {
        return RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
    
    func string(forKey key: ValueKey) -> String {
        return RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
    func double(forKey key: ValueKey) -> Double {
        if let numberValue = RemoteConfig.remoteConfig()[key.rawValue].numberValue {
            return numberValue.doubleValue
        } else {
            return 0.0
        }
    }
    
    func color(forKey key: ValueKey) -> UIColor {
        let colorAsHexString = RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "#FFFFFF"
        let convertedColor = hexStringToUIColor(hex: colorAsHexString)
        return convertedColor
    }
    
    func colors(forKey key: ValueKey) -> Array<UIColor> {
        
        var colorArray =  [ hexStringToUIColor(hex: "#FBB03B"),  hexStringToUIColor(hex: "#FBB03B") ,hexStringToUIColor(hex: "#FBB03B") ]
        if let colorAsHexString = RemoteConfig.remoteConfig()[key.rawValue].stringValue as? String{
            
            let strcolorArray = colorAsHexString.components(separatedBy: "~")
            colorArray = [UIColor]()
            for color in strcolorArray{
                colorArray.append(hexStringToUIColor(hex: color))
            }
        }
        //        let convertedColor = hexStringToUIColor(hex: colorAsHexString)
        return colorArray
    }
    
    func activateDebugMode() {
        let debugSettings = RemoteConfigSettings()
        RemoteConfig.remoteConfig().configSettings = debugSettings
    }
}
