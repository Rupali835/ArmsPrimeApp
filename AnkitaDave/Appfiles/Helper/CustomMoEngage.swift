//
//  CustomMoEngage.swift
//  AnveshiJain
//
//  Created by webwerks on 24/05/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import Foundation
import MoEngage
class CustomMoEngage {
    static var shared = CustomMoEngage()
    static var Celebye = false
        static var DirectLine = false


    //WPHSR49856UJGDA23A1BU1SJ
    private init() {
    }
    
    func configureMoEngage(appId: String,application: UIApplication,launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        MoEngage.setAppGroupID("group.com.ankitadaveofficial.MoEngage")
        
        #if DEBUG
         MoEngage.debug(LOG_ALL)
        MoEngage.sharedInstance().initializeDev(withApiKey: appId, in: application, withLaunchOptions: launchOptions, openDeeplinkUrlAutomatically: true)
        #else
        MoEngage.sharedInstance().initializeProd(withApiKey: appId, in: application, withLaunchOptions: launchOptions, openDeeplinkUrlAutomatically: true)
        #endif
        

       self.sendAppStatusToMoEngage()

    }
    
    // MARK:- Send app status to MoEngage
    
    func getAppVersion () -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    func saveAppVersionToDefaults () {
        UserDefaults.standard.set(self.getAppVersion(), forKey: "app version")
        UserDefaults.standard.synchronize()
    }
    
    func sendAppStatusToMoEngage () {
        if ((UserDefaults.standard.value(forKey:"app version") == nil)) {
            MoEngage.sharedInstance().appStatus(INSTALL)
            self.saveAppVersionToDefaults()
            return
        }
        
        if (self.getAppVersion() != (UserDefaults.standard.value(forKey:"app version") as! String)) {
            MoEngage.sharedInstance().appStatus(UPDATE)
            self.saveAppVersionToDefaults()
        }
    }
    
    //MARK:- Set USER INFO
    
    func setMoUserInfo(customer: Customer) { //not in use
        MoEngage.sharedInstance().setUserUniqueID(customer._id != nil ? customer._id:"")
        MoEngage.sharedInstance().setUserName(customer.first_name != nil ? customer.first_name:"")
        MoEngage.sharedInstance().setUserLastName(customer.last_name != nil ? customer.last_name:"")
        MoEngage.sharedInstance().setUserFirstName(customer.first_name != nil ? customer.first_name:"")
        MoEngage.sharedInstance().setUserEmailID(customer.email != nil ? customer.email:"")
        MoEngage.sharedInstance().setUserMobileNo(customer.mobile != nil ? customer.mobile:"")
        if customer.gender == "Male" {
           MoEngage.sharedInstance().setUserGender(MALE)
        } else {
            MoEngage.sharedInstance().setUserGender(FEMALE)
        }
        
        MoEngage.sharedInstance().setUserAttribute(customer.picture, forKey: "avatar")
        MoEngage.sharedInstance().setUserAttribute(Constants.DEVICE_ID, forKey: "device_id")
        MoEngage.sharedInstance().setUserAttribute(Constants.cloud_base_url, forKey: "get_base_url")
        MoEngage.sharedInstance().setUserAttribute(Constants.App_BASE_URL, forKey: "post_base_url")
        MoEngage.sharedInstance().setUserAttribute("test", forKey: "user_badge_icon")
        MoEngage.sharedInstance().setUserAttribute("test", forKey: "user_badge_level")
        MoEngage.sharedInstance().setUserAttribute("test", forKey: "user_badge_name")
        MoEngage.sharedInstance().setUserAttribute("test", forKey: "user_badge_status")
        MoEngage.sharedInstance().setUserAttribute(customer.last_visited, forKey: "user_last_visited")
        MoEngage.sharedInstance().setUserAttribute(customer.identity, forKey: "user_login_type")
        MoEngage.sharedInstance().setUserAttribute(customer.status, forKey: "user_status")
        MoEngage.sharedInstance().setUserAttribute(customer.coins ?? 0, forKey: "wallet_balance")
        MoEngage.sharedInstance().setUserAttribute("ios", forKey: "app_platform")
        
        let userdict :[String : String?] = [
            "UniqueId":customer._id != nil ? customer._id:"",
            "UserName":customer.first_name != nil ? customer.first_name:"",
            "firstName":customer.first_name != nil ? customer.first_name:"",
            "lastName":customer.last_name != nil ? customer.last_name:"",
            "email":customer.email != nil ? customer.email:"",
            "mobile":customer.mobile != nil ? customer.mobile:"",
            "gender": customer.gender,
            "avatar":customer.picture,
            "device_id":Constants.DEVICE_ID,
            "get_base_url":Constants.cloud_base_url,
            "post_base_url":Constants.App_BASE_URL,
            "user_badge_icon":"",
            "user_badge_level":"",
            "user_badge_name":"",
            "user_badge_status":"",
            "user_last_visited":customer.last_visited,
            "user_login_type":customer.identity,
            "user_status":customer.status,
            "wallet_balance":"\(customer.coins ?? 0) ?? 0"
        ]
        print("moenageg user data => \(userdict)")
    }
    
    func setMoUserInfoUsingCustomerDetails() {
        MoEngage.sharedInstance().setUserUniqueID(CustomerDetails.custId != nil ? CustomerDetails.custId:"")
        MoEngage.sharedInstance().setUserName(CustomerDetails.firstName != nil ? CustomerDetails.firstName:"")
        MoEngage.sharedInstance().setUserLastName(CustomerDetails.lastName != nil ? CustomerDetails.lastName:"")
        MoEngage.sharedInstance().setUserFirstName(CustomerDetails.firstName != nil ? CustomerDetails.firstName:"")
        MoEngage.sharedInstance().setUserEmailID(CustomerDetails.email != nil ? CustomerDetails.email:"")
        MoEngage.sharedInstance().setUserMobileNo(CustomerDetails.mobileNumber != nil ? CustomerDetails.mobileNumber:"")
        if CustomerDetails.gender == "Male" {
            MoEngage.sharedInstance().setUserGender(MALE)
        } else {
            MoEngage.sharedInstance().setUserGender(FEMALE)
        }
        
        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.picture, forKey: "avatar")
        MoEngage.sharedInstance().setUserAttribute(Constants.DEVICE_ID, forKey: "device_id")
        MoEngage.sharedInstance().setUserAttribute(Constants.cloud_base_url, forKey: "get_base_url")
        MoEngage.sharedInstance().setUserAttribute(Constants.App_BASE_URL, forKey: "post_base_url")
        MoEngage.sharedInstance().setUserAttribute("", forKey: "user_badge_icon")
        MoEngage.sharedInstance().setUserAttribute("", forKey: "user_badge_level")
        MoEngage.sharedInstance().setUserAttribute("", forKey: "user_badge_name")
        MoEngage.sharedInstance().setUserAttribute("", forKey: "user_badge_status")
        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.lastVisited, forKey: "user_last_visited")
        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.identity, forKey: "user_login_type")
        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.status, forKey: "user_status")
        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.coins ?? 0, forKey: "wallet_balance")
         MoEngage.sharedInstance().setUserAttribute("ios", forKey: "app_platform")
        let userdict :[String : String?] = [
            "UniqueId":CustomerDetails.custId != nil ? CustomerDetails.custId:"",
            "UserName":CustomerDetails.firstName != nil ? CustomerDetails.firstName:"",
            "firstName":CustomerDetails.firstName != nil ? CustomerDetails.firstName:"",
            "lastName":CustomerDetails.lastName != nil ? CustomerDetails.lastName:"",
            "email":CustomerDetails.email != nil ? CustomerDetails.email:"",
            "mobile":CustomerDetails.mobileNumber != nil ? CustomerDetails.mobileNumber:"",
            "gender": CustomerDetails.gender,
            "avatar":CustomerDetails.picture,
            "device_id":Constants.DEVICE_ID,
            "get_base_url":Constants.cloud_base_url,
            "post_base_url":Constants.App_BASE_URL,
            "user_badge_icon":"",
            "user_badge_level":"",
            "user_badge_name":"",
            "user_badge_status":"",
            "user_last_visited":CustomerDetails.lastVisited,
            "user_login_type":CustomerDetails.identity,
            "user_status":CustomerDetails.status,
            "wallet_balance":"\(CustomerDetails.coins ?? 0)"
        ]
        print("MoEngage user data => \(userdict)")
    }
    func setMoReLogginUserAttributes(re_loggedin: Bool) {
        //re_loggedin
        MoEngage.sharedInstance().setUserAttribute(re_loggedin, forKey: "re_loggedin")
    }
    
    func resetMoUserInfo() {
        MoEngage.sharedInstance().resetUser()
    }

    func updateUserInfo(customer: Customer) {
        print("update user info \(customer)")
        
        MoEngage.sharedInstance().setAlias(customer._id != nil ? customer._id:"")
        MoEngage.sharedInstance().setUserName(customer.first_name != nil ? customer.first_name:"")
        MoEngage.sharedInstance().setUserLastName(customer.last_name != nil ? customer.last_name:"")
        MoEngage.sharedInstance().setUserFirstName(customer.first_name != nil ? customer.first_name:"")
        MoEngage.sharedInstance().setUserEmailID(customer.email != nil ? customer.email:"")
        MoEngage.sharedInstance().setUserMobileNo(customer.mobile != nil ? customer.mobile:"")
        MoEngage.sharedInstance().setUserAttribute(customer.picture != nil ? customer.picture: "", forKey: "avatar")
        if customer.gender == "Male" {
            MoEngage.sharedInstance().setUserGender(MALE)
        } else {
            MoEngage.sharedInstance().setUserGender(FEMALE)
        }
        MoEngage.sharedInstance().setUserAttribute(customer.coins ?? 0, forKey: "wallet_balance")
        MoEngage.sharedInstance().setUserAttribute("ios", forKey: "app_platform")
    }
    func updateMoEngageCustomerBucketAttribute(customerbucket:String) {
        MoEngage.sharedInstance().setUserAttribute(customerbucket , forKey: "customer_bucket")
    }
    func updateMoEngageCoinAttribute() {
        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.coins ?? 0, forKey: "wallet_balance")
    }
    //MARK:- EVENT call
    /*
     @JvmStatic
     fun actionFacebookSignUp(status: String, reason: String) {
     val builder = PayloadBuilder()
     builder.putAttrString("status", status)
     .putAttrString("reason", reason)
     .putAttrDate("updated_at", Date())
     MoEHelper.getInstance(mContext).trackEvent("FacebookSignUp", builder.build())
     }
     
     @JvmStatic
     fun actionGoogleSignUp(status: String, reason: String) {
     val builder = PayloadBuilder()
     builder.putAttrString("status", status)
     .putAttrString("reason", reason)
     .putAttrDate("updated_at", Date())
     MoEHelper.getInstance(mContext).trackEvent("GoogleSignUp", builder.build())
     }
     
     @JvmStatic
     fun actionFacebookLogIn(status: String, reason: String) {
     val builder = PayloadBuilder()
     builder.putAttrString("status", status)
     .putAttrString("reason", reason)
     .putAttrDate("updated_at", Date())
     MoEHelper.getInstance(mContext).trackEvent("FacebookLogIn", builder.build())
     }
     
     @JvmStatic
     fun actionGoogleLogIn(status: String, reason: String) {
     val builder = PayloadBuilder()
     builder.putAttrString("status", status)
     .putAttrString("reason", reason)
     .putAttrDate("updated_at", Date())
     MoEHelper.getInstance(mContext).trackEvent("GoogleLogIn", builder.build())
     }
     
     @JvmStatic
     fun actionEmailSignUp(status: String, reason: String) {
     val builder = PayloadBuilder()
     builder.putAttrString("status", status)
     .putAttrString("reason", reason)
     .putAttrDate("updated_at", Date())
     MoEHelper.getInstance(mContext).trackEvent("EmailSignUp", builder.build())
     }
     
     @JvmStatic
     fun actionEmailLogIn(status: String, reason: String) {
     val builder = PayloadBuilder()
     builder.putAttrString("status", status)
     .putAttrString("reason", reason)
     .putAttrDate("updated_at", Date())
     MoEHelper.getInstance(mContext).trackEvent("EmailLogIn", builder.build())
     }
     
     @JvmStatic
     fun actionUpdateProfile(status: String, reason: String) {
     val builder = PayloadBuilder()
     builder.putAttrString("status", status)
     .putAttrString("reason", reason)
     .putAttrDate("updated_at", Date())
     MoEHelper.getInstance(mContext).trackEvent("UpdateProfile", builder.build())
     }
     */
    func sendEvent(eventType: MoEventType,action: String, status: String, reason: String,extraParamDict: NSMutableDictionary?) {
        /**
         action : Update Profile
         status : Success
         reason : empty
         updated_at : time stamp
         **/
        var  payloadDict = NSMutableDictionary()
        if extraParamDict != nil {
            payloadDict =  extraParamDict ?? payloadDict
        }
        payloadDict.setObject(action, forKey: "action_name" as NSCopying)
        payloadDict.setObject(status, forKey: "status" as NSCopying)
        payloadDict.setObject(reason, forKey: "reason" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
        print("\(#function) eventName =>[\(eventType.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(eventType.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    func sendEventUserLogin(source: String,action: String, status: String, reason: String,extraParamDict: NSMutableDictionary?) {
        /**
         action : Update Profile
         status : Success
         reason : empty
         updated_at : time stamp
         **/
        var  payloadDict = NSMutableDictionary()
        if extraParamDict != nil {
            payloadDict =  extraParamDict ?? payloadDict
        }
        
        payloadDict.setObject(source, forKey: "source" as NSCopying)
        payloadDict.setObject(action, forKey: "action_name" as NSCopying)
        payloadDict.setObject(status, forKey: "status" as NSCopying)
        payloadDict.setObject(reason, forKey: "reason" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
        print("\(#function) eventName =>[\(MoEventType.userlogin.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(MoEventType.userlogin.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    func sendEventForLike(contentId: String,status: String, reason: String,extraParamDict: NSMutableDictionary?) {
        /**
         action : Update Profile
         status : Success
         reason : empty
         updated_at : time stamp
         **/
        var  payloadDict = NSMutableDictionary()
        if extraParamDict != nil {
            payloadDict =  extraParamDict ?? payloadDict
        }
        payloadDict.setObject(contentId, forKey: "content_id" as NSCopying)
        payloadDict.setObject(status, forKey: "status" as NSCopying)
        payloadDict.setObject(reason, forKey: "reason" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
        print("\(#function) eventName =>[\(MoEventType.like.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(MoEventType.like.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    
    func sendEventUIComponent(componentName: String , extraParamDict: NSMutableDictionary?) {
        /*
         UiComponent : component name OR action info
         action : Clicked
         updated_at : time stamp
         */
        var  payloadDict = NSMutableDictionary()
        if extraParamDict != nil {
            payloadDict =  extraParamDict ?? payloadDict
        }
       
        payloadDict.setObject(componentName, forKey: "UiComponent" as NSCopying)
        payloadDict.setObject("Clicked", forKey: "action_name" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
         print("\(#function) eventName =>[\(MoEventType.clickUI.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(MoEventType.clickUI.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    
    func sendEventForLockedContent(id : String) {
        /*
         content_id : content ID
         updated_at : time stamp
         */
        
        let  payloadDict = NSMutableDictionary()
        payloadDict.setObject(id, forKey: "content_id" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
        print("\(#function) eventName =>[\(MoEventType.clickLockContent.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(MoEventType.clickLockContent.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    
    func sendEventDialog(_ title: String ,_ selectedButtonTitle: String ,_ extraParamDict: NSMutableDictionary?) {
        /*
         dialog_title : either title or message either retrieved or hard-coded
         button_pressed : button text either retrieved or hard-coded
         updated_at : time stamp
         */
        var  payloadDict = NSMutableDictionary()
        if extraParamDict != nil {
            payloadDict =  extraParamDict ?? payloadDict
        }
        
        payloadDict.setObject(title, forKey: "dialog_title" as NSCopying)
        payloadDict.setObject(selectedButtonTitle, forKey: "button_pressed" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
        print("\(#function) eventName =>[\(MoEventType.dialog.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(MoEventType.dialog.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    func sendEventForContentPurchaseLive(contentName:String,contentId:String,coins:Int,status:String,reason:String) {
        
        /*
         @JvmStatic
         fun actionEventPurchase(purchaseResponse: PurchaseResponse?, eventId: String, contentName: String, coins: String, status: String, reason: String) {
         val builder = PayloadBuilder()
         if (purchaseResponse != null) {
         if (purchaseResponse!!.data != null) {
         if (purchaseResponse!!.data.purchase != null) {
         if (purchaseResponse!!.status_code === 200) {
         builder.putAttrInt("quantity", 1)
         .putAttrString("content_purchase_product_id", if (purchaseResponse.data.purchase._id != null) purchaseResponse.data.purchase._id else "productID null")
         .putAttrString("event_id", eventId)
         .putAttrDate("purchase_date", Date())
         .putAttrLong("price", price(purchaseResponse.data.purchase.coins))
         .putAttrString("currency", "rupees")
         .putAttrString("event_name", contentName)
         //   .putAttrString("commercial_type", commercialType)
         .putAttrString("coins", coins)
         .putAttrString("status", status)
         .putAttrString("reason", reason)
         } else {
         */
        
        let  payloadDict = NSMutableDictionary()
        payloadDict.setObject(1, forKey: "quantity" as NSCopying)
        payloadDict.setObject(contentId, forKey: "content_purchase_product_id" as NSCopying)
        payloadDict.setObject(contentId, forKey: "event_id" as NSCopying)
        payloadDict.setObject("rupees", forKey: "currency" as NSCopying)
        payloadDict.setObject(contentName, forKey: "event_name" as NSCopying)
        payloadDict.setObject(coins, forKey: "coins" as NSCopying)
        payloadDict.setObject(coins, forKey: "price" as NSCopying)
        payloadDict.setObject(status, forKey: "status" as NSCopying)
        payloadDict.setObject(reason, forKey: "reason" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "purchase_date" as NSCopying)
        print("\(#function) eventName =>[\(MoEventType.eventPurchase.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(MoEventType.eventPurchase.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    //MARK:- New Login and SignUp event
    func sendEventSignUpLogin(eventType: MoEventType,status: String, reason: String,extraParamDict: NSMutableDictionary?) {
        /**
         status : Success
         reason : empty
         updated_at : time stamp
         **/
        var  payloadDict = NSMutableDictionary()
        if extraParamDict != nil {
            payloadDict =  extraParamDict ?? payloadDict
        }
        payloadDict.setObject(status, forKey: "status" as NSCopying)
        payloadDict.setObject(reason, forKey: "reason" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
        print("\(#function) eventName =>[\(eventType.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(eventType.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    

    func sendEventViewVide(id:String,coins:Int,bucketCode:String,bucketName:String,videoName:String,type:String,percent:Int) {
        let  payloadDict = NSMutableDictionary()
      
        payloadDict.setObject(id, forKey: "content_id" as NSCopying)
        payloadDict.setObject(coins, forKey: "coins" as NSCopying)
        payloadDict.setObject(bucketCode, forKey: "bucket_code" as NSCopying)
        payloadDict.setObject(bucketName, forKey: "bucket_name" as NSCopying)
        payloadDict.setObject(videoName, forKey: "video_name" as NSCopying)
        payloadDict.setObject(type, forKey: "commercial_type" as NSCopying)
        payloadDict.setObject(percent, forKey: "percent_watched" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
        
        print("\(#function) eventName =>[\(MoEventType.viewVideo.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(MoEventType.viewVideo.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    
    func sendEventForContentPurchase(list:List?,bucketCode:String,bucketName:String,status:String,reason:String,contentId:String,coins:Int) {
       
         /*
         3. Content Purchase
         
         Content Name
         
         Content Price
         
         Content Type- Image, Video, Album
         
         Commercial Type - Paid, Partial Paid
         
         builder.putAttrInt("quantity", 1)
         .putAttrString("content_purchase_product_id", "purchaseResponseObject null")
         .putAttrDate("purchase_date", Date())
         .putAttrString("price", "purchaseResponseObject null")
         .putAttrString("currency", "rupees")
         .putAttrString("content_name", contentName)
         .putAttrString("bucket_code", bucketCode)
         .putAttrString("coins", coins)
         .putAttrString("status", status)
         .putAttrString("reason", reason)
         
 
         */
        
        let  payloadDict = NSMutableDictionary()
        payloadDict.setObject(1, forKey: "quantity" as NSCopying)
        payloadDict.setObject(contentId, forKey: "content_purchase_product_id" as NSCopying)
        payloadDict.setObject(bucketCode, forKey: "bucket_code" as NSCopying)
        payloadDict.setObject(bucketName, forKey: "bucket_name" as NSCopying)
        payloadDict.setObject("rupees", forKey: "currency" as NSCopying)
        payloadDict.setObject(list?.caption ?? "", forKey: "content_name" as NSCopying)
        payloadDict.setObject(coins, forKey: "coins" as NSCopying)
        payloadDict.setObject(list?.commercial_type ?? "", forKey: "commercial_type" as NSCopying)
        if let isAlbum = list?.is_album {
            if isAlbum == "true"{
                payloadDict.setObject("Album", forKey: "contentType" as NSCopying)
            } else {
                payloadDict.setObject(list?.type ?? "", forKey: "contentType" as NSCopying)
            }
        } else {
            payloadDict.setObject(list?.type ?? "", forKey: "contentType" as NSCopying)
        }
        
        payloadDict.setObject(status, forKey: "status" as NSCopying)
        payloadDict.setObject(reason, forKey: "reason" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "purchase_date" as NSCopying)
        print("\(#function) eventName =>[\(MoEventType.purchaseContent.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(MoEventType.purchaseContent.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    
    func sendEventWardrobePurchase(coins: Int, status: String, reason: String) {
        let payloadDict = NSMutableDictionary()
        payloadDict.setObject(coins, forKey: "coins" as NSCopying)
        payloadDict.setObject(status, forKey: "status" as NSCopying)
        payloadDict.setObject(reason, forKey: "reason" as NSCopying)
        payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
        print("\(#function) eventName =>[\(MoEventType.wardrobePurchase.rawValue)] dict => \(payloadDict)")
        MoEngage.sharedInstance().trackEvent(MoEventType.wardrobePurchase.rawValue, andPayload: payloadDict)
        MoEngage.sharedInstance().syncNow()
    }
    
    func sendEventCelebytePurchase(coins: Int, status: String, reason: String) {
               let  payloadDict = NSMutableDictionary()
               payloadDict.setObject(coins, forKey: "coins" as NSCopying)
               payloadDict.setObject(status, forKey: "status" as NSCopying)
               payloadDict.setObject(reason, forKey: "reason" as NSCopying)
               payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
               MoEngage.sharedInstance().trackEvent(MoEventType.celebytePurchase.rawValue, andPayload: payloadDict)
               MoEngage.sharedInstance().syncNow()
           }

           func sendEventDirectLinePurchase(coins: Int, status: String, reason: String) {
               let  payloadDict = NSMutableDictionary()
               payloadDict.setObject(coins, forKey: "coins" as NSCopying)
               payloadDict.setObject(status, forKey: "status" as NSCopying)
               payloadDict.setObject(reason, forKey: "reason" as NSCopying)
               payloadDict.setObject(Date.getCurrentDate(), forKey: "updated_at" as NSCopying)
               MoEngage.sharedInstance().trackEvent(MoEventType.directLinePurchase.rawValue, andPayload: payloadDict)
               MoEngage.sharedInstance().syncNow()
           }

    
}

//MARK:- MoEnagage Event type
enum MoEventType: String {
    case userlogin = "UserLogin"
    case updateUserAtrribute = "Update User attributes"
    case setUserAtrribute = "Set User attributes"
    case logOut  = "Log out"
    case clickLockContent = "Clicked_Locked_Content"
    case purchaseContent = "ContentPurchase"
    case purchaseCoinPackage = "CoinPackagePurchase"
    case callAPI_CoinPurchase  = "CoinPurchaseApiCalled"
    case like = "Like"
    case comment = "Comment"
    case share = "Share"
    case clickUI  = "Ui_Clicked"
    case dialog  = "Dialog"
    case enterfragment = "Enter_Fragment" //need to discuss
    case acitvityName = "Activity_Entered" //need to discuss
    case clickSendGift = "SendGiftClicked"
    case apiName  = "api_name Called"
    case helpNSupport = "help_n_support"
    case walletPassbook = "Wallet_passbook"
    case screenName = "iOS_ScreenName"
    case updateprofile = "UpdateProfile"
    case viewVideo = "Viewed_Video"
    case signUp = "Signup"
    case login = "Login"
    case eventPurchase = "EventPurchase"
    case wardrobePurchase = "WardrobePurchase"
    case celebytePurchase = "ShoutoutPurchase"
        case directLinePurchase = "DirectLine"
}

