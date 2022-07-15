//
//  Constants.swift
//  Kate Sharma
//
//  Created by Razr on 06/11/17.
//  Copyright © 2017 Razr. All rights reserved.
//

import  UIKit
import Foundation

class Constants: NSObject {

    //App URls Or APIs
    //Razr : 5a91386b9353ad33ab15b0d2
    //Karan : 5a3373be9353ad4b0b0c2242
    //zareen : 59858df7af21a2d01f54bde2
    //scarlet : 5a9d91aab75a1a17711af702
    //poonam : 598aa3d2af21a2355d686de2
    //Anup : 5b08015e95b3397c6b57c1e2
    //SS : 598aa482af21a2373a3960b2
    //SL : 5c5a9186534e05708664d2c2
  //  SakshiChopraa : 5c8ba8a76338907815184ec2
    // SherlynChopra : 5c9a21aa633890355a377d33
    //anveshiJain : 5cda8e156338905d962b9472
    //Viral Bhayani : 5d2e0fe66338904aeb54f1f2
//    static var App_BASE_URL:String =  "http://services.razrstudio.com/api/1.0/" // prepod
//    static var App_BASE_URL:String =  "http://haste.razrstudio.com/api/1.0/" //dev
//
//    static var App_BASE_URL:String = "https://apistg.apmedia.app/api/1.0/" //stagging
    static var App_BASE_URL: String = "https://api.aprime.in/api/1.0/" //live
    static var selectedImage: UIImage! //5deb74e0633890620e45f9a2

    static var CELEB_ID: String = "5f46168f63389041ac48c3e2" //ankita dave


 //   static var CELEB_ID:String = "5deb74e0633890620e45f9a2" // Archana
//
  //  static var cloud_base_url: String = "https://apistg.apmedia.app/api/1.0/" //stagging
    
     static var cloud_base_url: String = "https://d1wm9ta1tktrp6.cloudfront.net/api/1.0/" //live

//     live
    static var artistId_platform: String = "artist_id=\(CELEB_ID)&platform=ios"
    static var appBundleID: String = "com.ankitadaveofficial"
    static var androidPackageID: String = "com.ankitadaveofficial"
    static var celebrityName: String = "Ankita Dave"
    static var celebrityAppName: String = "\(celebrityName) Official App -"
    static var appLink: String = "https://ankitadaveofficial.page.link"
    static var CustomerId_URL: String = "https://system.apmedia.app/api/1.0/" //get bucket(epu)
    static var CustomerBucket: String = "customers/bucket/"
    static var VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static var environment = "production"
    static var PHOTOGALARY: String = "content/detailv1/"
    static var API_KEY: String = "eynpaQcc7nihvcYuZOuU0TeP7tlNC6o5"
    static var ARTIST_DATA: String = "customers/artistconfig?"
    static var REGISTER: String = "customers/register"
    static var HOME_SCREEN_DATA: String = "buckets/lists?"
    static var GET_PROFILE_DATA: String = "customers/profile"
    static var UPDATE_PROFILE: String = "customers/updateprofilev2"
    static var UPDATE_PROFILE_PIC: String = "customers/updateprofilepicture"
    static var LEVEL_1_BUCKET_CONTENTS: String = "contents/listsv1?"
    static var PLATFORM_TYPE = "ios"
    static var COMMENT_GIFTS: String = "gifts/lists?"

    static var videoCallRequest = "videocall/request"
    static var getVideoCallList = "videocall/list"
    static var videoCallUpdate = "videocall/update"
    static let updateVideoCall = "videocall/update"
    static var getVideoCallGetSlots = "videocall/getslots"
    static var product = "apm"
    static let videoCallJoin = "videocall/join"
    static let videoCallEnd = "videocall/end"
    static let videoCallFeedback = "support/customer/feedback/videocall"
    static let agoraChannelExist = "https://api.agora.io/dev/v1/channel/user/"
    static let agoraTokenNew = "accounts/agora/dynamickey"
    static var artist_leaderboards:String =  "artists/leaderboards/\(CELEB_ID)?platform=ios"
    static var COMMENT: String = "comments/lists?"
    static var COMMENT_SAVE: String = "customers/savecomment"
    static var COMMENT_REPLY:String = "customers/replyoncomment"
    static var COMMENT_GET_REPLY: String = "commentreplies/lists?"
    static var COMMENT_REPLY_SAVE:String = "customers/replyoncomment"
    static var CUSTOMER_PURCHASE:String = "customers/passbook/purchasecontent"// "customers/purchasecontent"// (new end point)
    static var FORGET_PASSWORD = "customers/forgetpassword"
    static var CHANGE_PASSWORD = "customers/changepassword"
    static var STICKERS_PURCHASE:String = "customers/passbook/puchasestickers"//"customers/passbook/puchasestickers"// (new end point)
    static var LIKE_SAVE:String = "customers/like"
    static var FANS_VIDEO:String = "celebyte/artist/public/greetings/\(CELEB_ID)"
    static var BLOCK_SAVE:String = "customers/blockcontents"
    static var META_ID:String = "customers/metaidsv3?"
    static var LIKE_GET:String = "customers/content/likes"
    static var ASK_ARTIST:String = "customers/asktoartist"
    static var last_updated_buckets:String = "last_updated_buckets"
    static var SPENDING: String = "customers/spendings"
    static var PURCHASE:String = "customers/purchases"
    static var REWARDS:String = "customers/rewards"
    static var HELP_SUPPORT:String = "captures"
    static var NO_Internet_Connection_MSG : String = "Internet Connection not Available!"
    static var GIFTS: String = "gifts/lists?"
    static var DEVICE_ID = UIDevice.current.identifierForVendor?.uuidString
    static var TOKEN: String = UserDefaults.standard.string(forKey: "token") ?? ""
    static var PURCHASE_PACKAGE = "customers/purchasepackage"
    static var SEND_GIFT = "customers/passbook/sendgift"//"customers/passbook/sendgift" //
    static var Update_Device_Info = "customers/updatedeviceinfo"
    static var Get_User_Info = "customers/profile"
    static var getCoins = "customers/getcoinsxp"
    static var Fcm_Topic_Id = "ankitadave"
    static var getPackages = "packages/lists?"
    static var generateTempOrder = "customers/generatetemporder"
    static var getOrderStatus = "customers/passbook/captureiosorder/v2" //"customers/passbook/captureiosorder"
    static var NO_Internet_MSG : String = "No Internet Connection"
    static var visiblity: String = "&visiblity=customer"
   
  //  static var pubNubPublishKEY: String = "pub-c-c99f42b8-c720-4a1c-9d18-30a677d28cd9"//"pub-c-afd17fa2-ad65-4fe0-a7a0-292831bb4a85"
 //   static var pubNubSubscribeKEY: String = "sub-c-c1958dde-e713-11ea-9d1c-16efd2dbfec5"//"sub-c-64b12f96-7640-11e9-912a-e2e853b4b660"
    //MARK:- Alert messages

    static var CUSTOMER_PASSBOOK : String = "customers/passbook"

    static var moEnagegAppID: String = "GBUWBG2AXB4JV4GQH4I0TRJF"
    static var emailIDAcceptedCharacter: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_!.@-"
    static var dontAllowSpaceCharacter: String = " "
    static var appStoreLink: String = "http://www.armsprime.com/"

//    static let AgoraAppId: String = "34a153aa097248479ae6fa9e2183b94c" // For HotShot
//    static let AgoraAppId: String = "b6012ab300ca484587d6b4e3ae80f6ed" // Archana

 //   static let AgoraAppId: String = "f76cadd413b34bae8c96af9bc24cdc99"

    static let WEB_GET_AGORA_ACCESS_TOKEN = "accounts/agora/accesstoken"
    static let WEB_GET_AGORA_ACCESS_TOKEN_NEW = "accounts/agora/dynamickey"
    static let sendCallRequest = "lives/video/request"

    static let WEB_CHECK_AGORA_CHANNEL = "https://api.agora.io/dev/v1/channel/user/"
    //b6012ab300ca484587d6b4e3ae80f6ed
    static let AgoraUsername: String = "e1e3ed02fb154209aff47d396403cb02"
    static let AgoraPassword: String = "b4bc599c845a40c4a7d76ac4e90b03e9"
    //archanagautam
 //   static let AgoraChannelName = "ankitadave"
//    static let AgoraChannelName = "archanagautam"
    static let AgoraChannleClosed = """
A big thank you to all of my fans!! Love spending time with you, always.
    I had an amazing time; we must do this again!....and again…

    Absolutely love you guys, you make me “Me”!!

    Keep the suggestions flowing. Ta, till next time!!!
"""

    static let officialWebSitelink = "http://www.armsprime.com?"//"http://www.armsprime.com?"
    static let pollSubmitApi = "polls/submitresult"
    static let WEB_UPCOMING_LIVE_EVENTS = "lives/upcoming?"
    static var PURCHASED_EVENT = "PURCHASED_EVENT"
    // functions
    static func setPurchasedEventId(_ id : String?) {

        if id == nil {

            UserDefaults.standard.removeObject(forKey: PURCHASED_EVENT)
        }
        else {

            UserDefaults.standard.set(id, forKey: PURCHASED_EVENT)
        }

        UserDefaults.standard.synchronize()
    }

    static func deletePurchasedEventId() {

        UserDefaults.standard.removeObject(forKey: PURCHASED_EVENT)
        UserDefaults.standard.synchronize()
    }
    static let databaseName = "/ConsumerDatabase.sqlite"
    static var LIVE_EVENT_PURCHASE = "customers/passbook/purchaselive"
    static var WEB_FEEDBACK_LIVE = "support/customer/feedback/live"
    static var LIVE_FEEDBACK = "LIVE_FEEDBACK"
    static let updateViewCountAPI = "customers/content/view"
    static var SEND_STICKER_COMMENT:String = "passbook/sendsticker/comment" // (new)
    static var SEND_STICKER_REPLY:String = "passbook/sendsticker/replyoncomment" // (new)
    static var appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static var general_feedback = "support/customer/feedback/general"
    static var deactivate_Account = "customers/deactivate"

    //Direct Line
    static let createRoom = "directline/createroom"
    static let roomChatHistory = "directline/messagehistory/"
    static let sendChatMessage = "directline/sendmessage"

    //Wardrobe
    static let productsList = "products/lists"
    static let ordersList = "products/store/orders"
    static let productPurchase = "products/store/purchase"
    static let bucketContent = "contents/listsv1"

    //MobileNumberVerification
    // Login
    static var LOGIN: String = "customers/sociallogin"
    static var requestloginOTP = "customers/requestotp"
    static var verifyOTP = "customers/login/verifyotp"
    static let mobileVerifyOTP = "customers/verifyotp"
    static let home = "homepage"
    //Report content
    static var reportContent = "support/customer/report/content"
     
    // TnC
    
    static var acceptTnC = "customer/acceptanceactivity"

}

struct AppConstants {
    static let helpSupportPhoneNumber: String = "+919321901661"
    static let helpSupportEmail: String = "info@armsprime.com"
    static let numberOfBucketItemsInTab: Int = 5
    static let storeKitMasterSharedKey: String = "6a50086eb4234ebbb753417c7957f2ff"
    static let appThumbnail: String = "https://d3m1vhnnekwbrq.cloudfront.net/artistprofile/small-1598428812.jpg"

   
}


