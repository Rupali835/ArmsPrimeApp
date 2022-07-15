//
//  Enums.swift
//  Producer
//
//  Created by developer2 on 17/09/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import Foundation

enum Notifications: String {
    
    case uploadStepChanged = "uploadStepChanged"
    case startedAlbumUploading = "startedAlbumUploading"
    case finishedAlbumUploading = "finishedAlbumUploading"
    case mediaCreated = "mediaCreated"
    case seeMyFeeds = "seeMyFeeds"
    case updateMedia = "updateMedia"
    case stickersLoaded = "stickersLoaded"
    case bucketsLoaded = "bucketsLoaded"
    case shoutoutFilterApplied = "shoutoutFilterApplied"
    case shoutoutCompleted = "shoutoutCompleted"
    case shoutoutRejected = "shoutoutRejected"
    case introductoryVideoCreated = "introductoryVideoCreated"
    case liveEventCreated = "liveEventCreated"
    case phoneNumberVerifed = "phoneVerifed"
    case videoCallUpdated = "videoCallUpdated"
    case gotoVideoCallDetails = "gotoVideoCallDetails"
    
    // MARK: - VC 2
    case videoCallBookingDone = "videoCallBookingDone"
    case videoMessageBookingDone = "videoMessageBookingDone"
    case videoMessagebookingShowRecharge = "videoMessagebookingShowRecharge"
    case videoCallbookingShowRecharge = "videoCallbookingShowRecharge"
    case balanceUpdated = "balanceUpdated"
    
    func add<T: Any>(viewController: T, selector: Selector) {
        
        NotificationCenter.default.addObserver(viewController, selector: selector, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func post(object: Any?) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: object)
    }
}
enum RegularExpression: String {
    
    case phone = ".*[^0-9].*"
    case email = ".*[^A-Za-z0-9.@_].*"
    case name = ".*[^A-Za-z0-9_-@#].*"
}
enum VerifyOTPActivityType: String{
    case login = "login"
    case verify = "verify"
}
enum VerifyOTPType: String {
    
    case phone = "mobile"
    case email = "email"
    case both = "both"
}

enum LoginType: String{
    case apple = "apple"
    case facebook = "facebook"
    case gmail = "google"
    case email = "email"
    case phone = "mobile"
}
enum LoginEventStatus {
    case success
    case failure(message: String)
}
enum FileType: String, CaseIterable {
    
    case photo = "photo"
    case video = "video"
    //case audio = "audio"
    case album = "album"
    
    func getFilepath() -> String {
        
        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        var fileName = ""
        
        if self == .photo {
            
            fileName = "\(timeStamp).png"
        }
        else if self == .video {
            
            fileName = "\(timeStamp).mp4"
        }
        else {
            
            fileName = "\(timeStamp).aac"
        }
        
        let arrPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentDir = arrPaths[0]
        
        let filePath = documentDir + "/" + fileName

        return filePath
    }
}

enum UploadMediaSteps: Int {
    case first = 1
    case second,third,fourth
}

enum MediaPaidTypes: String, CaseIterable {
    
    case free = "Free"
    case partial = "Partial Paid"
    case paid = "Paid"
    
    func value() -> String {
        
        if self == .free {
            
            return "free"
        }
        else if self == .partial {
         
            return "partial_paid"
        }
        else {
            
            return "paid"
        }
    }
}

enum LiveEventPaidTypes: String, CaseIterable {
    
    case all = "All"
    case free = "Free"
    case paid = "Paid"
    
    func value() -> String {
        
        if self == .free {
            
            return "free"
        }
        else {
            
            return "paid"
        }
    }
}

enum FansTypes: String, CaseIterable {
    
    case topFan = "Top Fan"
    case dieHard = "Die Hard Fan"
    case loyal = "Loyal Fan"
    case superFan = "Super Fan"
    case all = "All"
}

enum AgeRatings: String, CaseIterable {
    
    case seven = "7"
    case ten = "10"
    case thirteen = "13"
    case eighteen = "18"
}

enum Platforms: String, CaseIterable {
    
    case iOS = "iOS"
    case android = "Android"
    case web = "Web"
}

enum AWSBucket: String {
    
    case images = "apmediarawimages"
    case videos = "apmediarawvideos"
    case audios = "apmediarawaudios"
}

enum MediaContentMIMEType : String {
   
    case jpg = "image/jpeg"
    case png = "image/png"
    case mov = "video/quicktime"
    case mp4 = "video/mp4"
    case aac = "audio/aac"
}

enum ArrangeTypes : String, CaseIterable {
    
    case none = "None"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

enum SortTypes: String, CaseIterable {
    
    case none = "None"
    case last7Days = "Last 7 days"
    case last30Days = "Last 30 days"
    case custom = "Custom Dates"
    
    func value() -> String {
        
        if self == .last7Days {
            
            return "last_7days"
        }
        
        if self == .last30Days {
            
            return "last_30days"
        }
        
        return ""
    }
}

enum CelebyteDurationTypes: String, CaseIterable {
    
    case lifeTime = "Life Time"
    case today = "Today"
    case yesterday = "Yesterday"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    
    func value() -> String {
        
        if self == .thisWeek {
            
            return "this_week"
        }
        
        if self == .thisMonth {
            
            return "this_month"
        }
        
        if self == .today {
            
            return "today"
        }
        
        if self == .yesterday {
            
            return "yesterday"
        }
        
        if self == .lifeTime {
            
            return "till_date"
        }
        
        return ""
    }
}

enum CelebyteRequestStatusTypes: String, CaseIterable {
    
    case completed = "Completed"
    case rejected = "Rejected"
    
    var value : String {
        
        if self == .completed {
            
            return "completed"
        }
        
        if self == .rejected {
            
            return "rejected"
        }
        
        return ""
    }
}

enum CelebytesSortTypes: String, CaseIterable {
    
    case newest = "Latest First"
    case oldest = "Latest Last"
    case expiring = "Expiring First"
    
    var value: String? {
        
        if self == .newest {
            
            return "latest_first"
        }
        
        else if self == .oldest {
            
            return "latest_last"
        }
        
        else {
            
            //expiring
            return "expiring_first"
        }
    }
}

enum ContentCommentType: String {
    
    case sticker = "stickers"
    case text = "text"
}

enum shoutoutHomeCells: CaseIterable {
  
    case totalEarnings
    case missedEarnings
    case potentialEarnings
    
    var earningsInfoTitle: String {
        
        switch self {
        case .totalEarnings:
            return "Total earning so far"
            
        case .missedEarnings:
            return "Total earning you missed"
            
        case .potentialEarnings:
            return "Total Potential earning"
        }
    }
    
    var totalBytesTitle: String {
        
        switch self {
        case .totalEarnings:
            return "Total complete celebytes:"
        
        case .missedEarnings:
            return "Total incomplete celebytes:"
            
        case .potentialEarnings:
            return "Total Pending celebytes"
        }
    }
    
    var image: UIImage? {
        
        switch self {
        case .totalEarnings:
            return UIImage(named:"shoutout_total_eraning")
            
        case .missedEarnings:
            return UIImage(named:"shoutout_missed_opportunity")
        
        case .potentialEarnings:
            return UIImage(named:"shoutout_potententil_earning")
        }
    }
}

enum Gender: String, CaseIterable {
   
    case male = "Male"
    case female = "Female"
    
    var value: String {
        
        if self == .male {
            
            return "male"
        }
        else {
            
            return "female"
        }
    }
}
enum AgoraCallRequestType: String {
    
    case oneToone = "oneonone"
    case multi = "multi"
}
