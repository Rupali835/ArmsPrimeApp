//
//  GlobalFunctions.swift
//  Poonam Pandey
//
//  Created by Razrcorp  on 20/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

class GlobalFunctions: NSObject {
    
    //MARK: Analytics tracking
    static func screenViewedRecorder(screenName : String) {
        
        let screenNameVal = screenName + "_ios"
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: screenNameVal)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    //in login and register send event name success/ failure
    
    static func trackEvent (eventScreen : String, eventName : String, eventPostTitle : String, eventPostCaption : String , eventId : String) {
        
        var eventlabel : String = ""
        let screenNameVal = eventScreen + "_ios"

        if (eventPostTitle != "") {
            eventlabel = eventPostTitle
            
        } else if (eventPostCaption != "") {
            eventlabel = eventPostCaption
        } else if (eventId != "") {
            eventlabel = eventId
        }
        
        if (eventId != nil && eventId != "") {
            eventlabel = eventlabel + ": \(eventId)"
        }

        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.send(GAIDictionaryBuilder.createEvent(withCategory: screenNameVal, action: eventName, label: eventlabel, value: nil).build() as [NSObject : AnyObject])
        
        
    }
    
    
    static func checkContentLikeId( id : String) -> Bool{
        
        CustomerDetails.customerData = DatabaseManager.sharedInstance.getCustomerData()
        
        if (CustomerDetails.customerData != nil) {
            
            if ( CustomerDetails.customerData.like_content_ids != nil) {
                
                if (CustomerDetails.customerData.like_content_ids?.contains(id))!{
                    return true
                } else {
                    return false
                }
                
                
            }
        }
        return false
    }
    static func checkContentPurchaseId( id : String) -> Bool{
        CustomerDetails.customerData = DatabaseManager.sharedInstance.getCustomerData()
        
        if (CustomerDetails.customerData != nil) {
            
            if ( CustomerDetails.customerData.purchase_content_ids != nil) {
                
                if (CustomerDetails.customerData.purchase_content_ids?.contains(id))!{
                    return true
                } else {
                    return false
                }
                
                
            }
        }
        return false
        
        
    }
    
    static func isContentsPurchased( list : List) -> Bool{
        
        if (GlobalFunctions.checkContentPurchaseId(id: list._id!)) {
            return true
        } else {
            return false
        }
    }
    
    static func checkContentBlockId( id : String) -> Bool{
        CustomerDetails.customerData = DatabaseManager.sharedInstance.getCustomerData()
        
        if (CustomerDetails.customerData != nil) {
            
            if ( CustomerDetails.customerData.hide_content_ids != nil) {
                
                if (CustomerDetails.customerData.hide_content_ids?.contains(id))!{
                    return true
                } else {
                    return false
                }
                
                
            }
        }
        return false
        
        
    }
    static func checkContentsLock( dictionary : NSDictionary) -> Bool{
        
        let keyExists = dictionary["commercial_type"] != nil
        
        if (dictionary.object(forKey: "commercial_type")as? String == "free" || dictionary.object(forKey: "commercial_type")as? String == "partial_paid") {
            return true
        } else if ( dictionary.object(forKey: "commercial_type")as? String == "paid" && GlobalFunctions.checkContentPurchaseId(id: dictionary.value(forKey: "parentId") as! String)) {
            
            return true
        }
        return  !keyExists || false
        
    }
    static func checkContentsLockId( list : List) -> Bool{
        
        
        if (list.commercial_type == "free" || list.commercial_type == "partial_paid") {
            
            return true
        } else if ( list.commercial_type == "paid" && GlobalFunctions.checkContentPurchaseId(id: list._id!)) {
            
            return true
        }
        return false
        
    }
    static func isContentsPaid( list : List) -> Bool{
        
        if (GlobalFunctions.checkContentPurchaseId(id: list._id!)) {
            return false
        } else if (list.commercial_type == "paid") {
            return true
            
        } else {
            return false
        }
    }
    
    static func isContentsPaidCoins( list : List) -> Bool{
        
        if (GlobalFunctions.checkContentPurchaseId(id: list._id!)) {
            return false
        }
        let coins =  list.coins as? Int
        if (coins! > 0) {
                return true
            } else {
                return false
                
            }
        
    }
       
       
//        else if (list.coins == "coins") {
//            return true
//
//        } else {
//            return false
//        }
//    }
    
    
    static func isContentsPaidWithDict( dict : Dictionary<String, Any>) -> Bool{
        
        if (GlobalFunctions.checkContentPurchaseId(id: dict["parentId"] as! String)) {
            return false
        } else if (dict["commercial_type"] as! String == "paid") {
            return true
            
        } else {
            return false
        }
        
    }
    
    
    static func isContentPiadWithDictCoins(dict : Dictionary<String, Any>) -> Bool{

        if let coins =  dict["coins"] as? String{
            if (Int(coins)! > 0) {
                return true
            } else {
                return false

            }
        }
        return false

    }
    
    static func isContentsPaidWithDictForAlbum( dict : Dictionary<String, Any>) -> Bool{
        
        if (GlobalFunctions.checkContentPurchaseId(id: dict["parentId"] as! String)) {
            return false
            
        } else if (dict["commercial_type"] as! String == "paid" || dict["commercial_type"] as! String == "partial_paid") {
            
            if let coins =  dict["coins"] as? String{
                if (Int(coins)! > 0) {
                    return true
                } else {
                    return false
                    
                }
            }
            return false
            
        } else {
            return false
        }
    }
    
    static func isContentsPaidForAlbum(list : List ) -> Bool{
        
        if (GlobalFunctions.checkContentPurchaseId(id: list._id!)) {
            return false
            
        } else if (list.commercial_type == "paid" || list.commercial_type == "partial_paid") {
            
            if let coins =  list.coins as? Int{
                if (coins > 0) {
                    return true
                } else {
                    return false
                    
                }
            }
            return false
            
        } else {
            return false
        }
    }
    
    static func checkAlbumLockId( list : List) -> Bool{
        
        
        if (list.commercial_type == "free" || list.commercial_type == "partial_paid") {
            return true
        } else if ( list.commercial_type == "paid" && GlobalFunctions.checkContentPurchaseId(id: list._id!)) {
            
            return true
        }
        return false
        
    }
    static func checkPartialPaidContentList( list : List) -> Bool{
        
        if ( list.commercial_type == "partial_paid" && !GlobalFunctions.checkContentPurchaseId(id: list._id!)) {
            
            return true
        }
        return false
        
    }
    
    static func checkPartialPaidContent( dictionary : NSDictionary) -> Bool{
        
        let keyExists = dictionary["commercial_type"] != nil
        
        if ( dictionary.object(forKey: "commercial_type")as? String == "partial_paid" || !GlobalFunctions.checkContentPurchaseId(id: dictionary.value(forKey: "parentId") as! String)) {
            
            return true
        }
        return  !keyExists || false
        
    }
    
    static func saveLikesIdIntoDatabase(content_id : String) {
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        database.insertIntoContentLikesTable(likeId: content_id)
    }
    
    static func sendBLockContentToServer(content : String) {
        
        let params = ["content_id" : content] as [String : Any]
        ServerManager.sharedInstance().postRequest(postData: params , apiName:Constants.BLOCK_SAVE, extraHeader: nil) { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure( let error):
                print(error)
            }
        }
    }
    
    //MARK:- Poll
    static func isPollAlreadySelected( list : List) -> Bool{
        let stringArr = DatabaseManager.sharedInstance.getIfUserSelectForPollContent(userId: CustomerDetails.customerData._id ?? "", contentId: list._id ?? "")
        print("Selected content Id \(stringArr)")
        if stringArr.count > 0 {
            for str in stringArr {
                if str == list._id! {
                    return true
                }
            }
        } else {
            return false
        }
        return false
    }
  static  func showBucketArrayContent(arr:[List]) {
        for list in arr {
            print("show list of code[\(list.code!)] caption [\(list.caption!)]")
        }
    }
    
    static func returnSelectedIndexBucketList(arr:[List],atIndex:Int) -> List?{
        if arr.count > atIndex {
            print("selected bucketCode @@@@@ \(arr[atIndex].code) caption \(arr[atIndex].caption)")
            return arr[atIndex]
        }
        return nil
    }
    
    static func sortedTabMenuArrayIndex(code: String) -> Int? {
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        var bucketsArray = database.getBucketListing()
        
        if bucketsArray.count  == 0 {
            return nil
        }
        bucketsArray = bucketsArray.sorted(by: { $0.ordering! < $1.ordering! })
        
        var tabMenuArray = [List]()
        for list in bucketsArray {
            if tabMenuArray.count < 3 {
                tabMenuArray.append(list)
            } else { break }
        }
        tabMenuArray = tabMenuArray.sorted(by: { $0.ordering! < $1.ordering! })
        
        var index = -1
        if tabMenuArray.count > 0 {
            for i in 0 ..< tabMenuArray.count {
                if let codeOfbucket = tabMenuArray[i].code {
                    if codeOfbucket == code {
                        index = i
                        return index
                    }
                }
            }
        }
        
        return nil
    }
    
    static func returnBucketListFormBucketCode(code: String, isForStory: Bool = false) -> List? {
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        var bucketsArray = [List]()
        bucketsArray = database.getBucketListing(isForStory: isForStory)
        
        if bucketsArray.count > 0 {
            for list in bucketsArray {
                if list.code == code {
                    return list
                }
            }
        }
        return nil
    }
    
    static func findIndexOfBucketCode(code: String) -> Int? {
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        if (FileManager.default.fileExists(atPath: writePath)) {
            var index = -1
            var bucketsArray = [List]()
            bucketsArray = database.getBucketListing()
            
            if bucketsArray.count > 0 {
                for i in 0 ..< bucketsArray.count {
                    if let codeOfbucket = bucketsArray[i].code {
                        if codeOfbucket == code {
                            index = i
                            return index
                        }
                    }
                }
            }
            
        } else {
            
            return nil
        }
        return nil
    }
    
    static func checkPasswordIsInCorrectFormat(pwd: String) -> Bool {
        let alphanumeric = CharacterSet.alphanumerics
        let alphaNumFlag = pwd.rangeOfCharacter(from: alphanumeric)
        let alphaFlag = pwd.rangeOfCharacter(from: CharacterSet.letters)
        
        let alpha = "abcdefghijklmnopqrstuvwxyz"
        let cs = NSCharacterSet(charactersIn:alpha).inverted
        let numberFlag = pwd.rangeOfCharacter(from: cs as CharacterSet)
        
        let specialCharacter = "!@#$%^&*()_+{}|:<>?;.,/~-='"
        let cs2 = NSCharacterSet(charactersIn:specialCharacter)
        let specialCharFlag = pwd.rangeOfCharacter(from: cs2 as CharacterSet)
        
        if pwd == "" {
            return false
        } else if pwd.count < 8 {
            return false
        } else if alphaNumFlag == nil{
            return false
        } else if alphaNumFlag != nil && alphaFlag == nil{
            return false
        } else if alphaFlag != nil && alphaFlag != nil && numberFlag == nil {
            return false
        } else if alphaFlag != nil && alphaFlag != nil && numberFlag != nil && specialCharFlag == nil{
            return false
        }
        
        
        return true
    }
    
    //MARK:- Paid live
    static func checkContentPurchaseLiveId( id : String) -> Bool{
        
        CustomerDetails.customerData = DatabaseManager.sharedInstance.getCustomerData()
        
        if (CustomerDetails.customerData != nil) {
            
            if ( CustomerDetails.customerData.purchaseLive_ids != nil) {
                
                if (CustomerDetails.customerData.purchaseLive_ids?.contains(id))!{
                    return true
                } else {
                    return false
                }
                
                
            }
        }
        return false
    }
    static func savePurchaseLiveIdIntoDatabase(content_id : String) {
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        database.insertIntoContentPurchaseLiveIdsTable(purchaseId: content_id)
    }
}
