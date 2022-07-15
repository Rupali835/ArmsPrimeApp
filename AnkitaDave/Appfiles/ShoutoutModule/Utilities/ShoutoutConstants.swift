//
//  ShoutoutConstants.swift
//  VideoGreetings
//
//  Created by Apple on 24/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation
import UIKit

// Constants.
struct ShoutoutConstants {
    static let relationships: [String] = ["Self", "Mother", "Father", "Daughter", "Sister", "Husband", "Grandmother", "Grandfather", "Aunt", "Brother", "Wife", "Boyfriend", "Uncle", "Niece", "Nephew", "Cousin", "Coworker", "Friend", "Girlfriend", "Son"]
    
    static let charLimitForMessageInVGRequest: Int = 250
    static let charLimitForMobileNumber: Int = 10
    static let charLimitForOtherOccasion: Int = 20
    static let shoutoutBucketCode: String = "shoutout"
    static let recommendeDaysPriorToMakeShoutoutRequest: Int = 6 // Considering inclusion of 7th day.
}

// Validation error text.
struct ValidationError {
    static let occasion = "Please select occasion"
    static let date = "Please select date"
    static let greetingsTo = "Please enter name of the receiver"
    static let relation = "Please select the relationship between you and the receiver"
    static let greetingMessage = "Please enter your message"
    static let tAndCMessage = "Please accept terms and conditions"
    static let greetingsFrom = "Please enter name of the person sending this greeting"
    static let invalidMobileNumber = "Mobile number should contain 10 digits"
    static let message = "Please write your message properly, concise that might be helpful to your favourite celebrity."
    static let enterMobileNumber = "Please enter mobile number"

}

struct AlertMessages {
    static let shoutoutPhotoGalleryAccessError = "Please grant permission to access Photo Gallery in iPhone's Settings to save downloaded greeting."
    static let shoutoutVideoSaveError = "Something went wrong. Could not save video."
    static let shoutoutVideoDownloadError = "Something went wrong. Could not download video."
    static let shoutoutVideoSavedToGallery = "Video saved in Gallery."
    static let internetConnectionError = "Internet connection is not available. Please, try again."
}

// Custom Fonts.
fileprivate struct FontName {
    static let regular = AppFont.regular.rawValue
    static let bold = AppFont.bold.rawValue
    static let light = AppFont.light.rawValue
    static let medium = AppFont.medium.rawValue
    static let italic = "OpenSans-Italic"
}

enum FontSize {
    case smaller
    case small
    case medium
    case large
    case largeTitle
    case custom(_ size: CGFloat)
    
    func getSize() -> CGFloat {
        switch self {
        case .smaller:
            return 11
        case .small:
            return 15
        case .medium:
            return 17
        case .large:
            return 19
        case .largeTitle:
            return 22
        case .custom(let size):
            return size
        }
    }
}

enum ShoutoutFont {
    case bold
    case regular
    case light
    case medium
    case italic
    
    func withSize(size: FontSize) -> UIFont {
        
        switch self {
        case .bold:
            return UIFont(name: FontName.bold, size: size.getSize()) ?? UIFont.systemFont(ofSize: size.getSize(), weight: .bold)
        case .light:
            return UIFont(name: FontName.light, size: size.getSize()) ?? UIFont.systemFont(ofSize: size.getSize(), weight: .light)
        case .medium:
            return UIFont(name: FontName.medium, size: size.getSize()) ?? UIFont.systemFont(ofSize: size.getSize(), weight: .medium)
        case .regular:
            return UIFont(name: FontName.regular, size: size.getSize()) ?? UIFont.systemFont(ofSize: size.getSize(), weight: .regular)
        case .italic:
            return UIFont(name: FontName.italic, size: size.getSize()) ?? UIFont.systemFont(ofSize: size.getSize(), weight: .regular)
        }
    }
}
