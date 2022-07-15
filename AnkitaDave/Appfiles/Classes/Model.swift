//
//  Model.swift
//  Live
//
//  Created by leo on 16/7/13.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import Foundation
import ObjectMapper

public class Customer {
    public var _id : String?
    public var first_name : String?
    public var last_name : String?
    public var mobile_verified : Bool?
    public var email : String?
    public var identity : String?
    public var device_id : String?
    public var segment_id : Int?
    public var fcm_id : String?
    public var platform : String?
    public var coins : Int?
    public var badges : Array<Badges>?
    public var account_link : Account_link?
    public var status : String?
    public var updated_at : String?
    public var created_at : String?
    public var last_visited : String?
    public var picture : String?
    public var platforms : Array<String>?
    public var xp : Int?
    public var gender : String?
    public var mobile : String?
    public var countryCode : String?
    public var like_content_ids : [String]?
    public var purchase_content_ids : [String]?
    public var hide_content_ids : [String]?
    public var block_content_ids : [String]?
    public var purchaseStickers: Bool?
    public var purchaseLive_ids : [String]?
    public var directline_room_id : String?
    public var profile_completed : Bool?
    public var email_verified : Bool?
    public var mobile_code : String?
    public var dob : String?
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let customer_list = Customer.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Customer Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Customer]
    {
        var models:[Customer] = []
        for item in array
        {
            models.append(Customer(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let customer = Customer(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Customer Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        mobile_verified = dictionary["mobile_verified"] as? Bool
        email = dictionary["email"] as? String
        identity = dictionary["identity"] as? String
        device_id = dictionary["device_id"] as? String
        segment_id = dictionary["segment_id"] as? Int
        fcm_id = dictionary["fcm_id"] as? String
        platform = dictionary["platform"] as? String
        coins = dictionary["coins"] as? Int
        mobile_code = dictionary["mobile_code"] as? String
        dob = dictionary["dob"] as? String
//        if (dictionary["badges"] != nil) { badges = Badges.modelsFromDictionaryArray(array: dictionary["badges"] as! NSArray) }
        if (dictionary["badges"] != nil) { badges = Badges.modelsFromDictionaryArray(array: dictionary["badges"] as! NSArray) }
        if (dictionary["account_link"] != nil) { account_link = Account_link(dictionary: dictionary["account_link"] as! NSDictionary) }
        status = dictionary["status"] as? String
        updated_at = dictionary["updated_at"] as? String
        created_at = dictionary["created_at"] as? String
        last_visited = dictionary["last_visited"] as? String
        purchaseStickers = dictionary["purchase_stickers"] as? Bool
        picture = dictionary["picture"] as? String
        xp = dictionary["xp"] as? Int
        gender = dictionary["gender"] as? String
        mobile = dictionary["mobile"] as? String
        countryCode = dictionary["mobile_code"] as? String
        like_content_ids = dictionary["like_content_ids"] as? Array
        purchase_content_ids = dictionary["purchase_content_ids"] as? Array
        purchaseLive_ids = dictionary["like_content_ids"] as? Array
        directline_room_id = dictionary["directline_room_id"] as? String
        email_verified = dictionary["email_verified"] as? Bool
        profile_completed = dictionary["profile_completed"] as? Bool
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.mobile_verified, forKey: "mobile_verified")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.identity, forKey: "identity")
        dictionary.setValue(self.device_id, forKey: "device_id")
        dictionary.setValue(self.segment_id, forKey: "segment_id")
        dictionary.setValue(self.fcm_id, forKey: "fcm_id")
        dictionary.setValue(self.platform, forKey: "platform")
        dictionary.setValue(self.coins, forKey: "coins")
        dictionary.setValue(self.mobile_code, forKey: "mobile_code")
        dictionary.setValue(self.dob, forKey: "dob")
        dictionary.setValue(self.purchaseStickers, forKey: "purchase_stickers")
        dictionary.setValue(self.account_link?.dictionaryRepresentation(), forKey: "account_link")
        dictionary.setValue(self.directline_room_id, forKey: "directline_room_id")
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.last_visited, forKey: "last_visited")
        dictionary.setValue(self.picture, forKey: "picture")
        dictionary.setValue(self.xp, forKey: "xp")
        dictionary.setValue(self.email_verified, forKey: "email_verified")
        dictionary.setValue(self.profile_completed, forKey: "profile_completed")
        dictionary.setValue(self.countryCode, forKey: "mobile_code")

        return dictionary
    }
    
}
public class Badges {
    public var name : String?
    public var level : Int?
    public var icon : String?
    public var status : Bool?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let badges_list = Badges.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Badges Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Badges]
    {
        var models:[Badges] = []
        for item in array
        {
            models.append(Badges(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
    
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let badges = Badges(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Badges Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        name = dictionary["name"] as? String
        level = dictionary["level"] as? Int
        icon = dictionary["icon"] as? String
        status = dictionary["status"] as? Bool
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.level, forKey: "level")
        dictionary.setValue(self.icon, forKey: "icon")
        dictionary.setValue(self.status, forKey: "status")
        
        return dictionary
    }
    
}

public class Account_link {
    public var email : Int?
    public var google : Int?
    public var facebook : Int?
    public var twitter : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let account_link_list = Account_link.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Account_link Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Account_link]
    {
        var models:[Account_link] = []
        for item in array
        {
            models.append(Account_link(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let account_link = Account_link(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Account_link Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        email = dictionary["email"] as? Int
        google = dictionary["google"] as? Int
        facebook = dictionary["facebook"] as? Int
        twitter = dictionary["twitter"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.google, forKey: "google")
        dictionary.setValue(self.facebook, forKey: "facebook")
        dictionary.setValue(self.twitter, forKey: "twitter")
        
        return dictionary
    }
}


class LT_Meta_Info {
    var thumb: String?
    var caption: String?
    var type:String?
    var video:String?
    var name:String?
    var audio:String?
    var description:String?
    
    var vendor_txn_id:String?
    var currency_code: String?
    var transaction_price: Double?
    var vendor: String?
    
    init(dict: [String: Any]?) {
        thumb = dict?["thumb"] as? String
        caption = dict?["caption"] as? String
        type = dict?["type"] as? String
        video = dict?["video"] as? String
        name = dict?["name"] as? String
        audio = dict?["audio"] as? String
        description = dict?["description"] as? String
        
        vendor_txn_id = dict?["vendor_txn_id"] as? String
        currency_code = dict?["currency_code"] as? String
        transaction_price = dict?["transaction_price"] as? Double
        vendor = dict?["vendor"] as? String
    }
}

class LedgerTransaction {
    var _id: String?
    var coins_after_txn: Int?
    var coins_before_txn: Int?
    var total_coins: Int?
    
    var xp: Int?
    var amount: Int?
    var coins:Int?
    var status: String?
    var platform_version: String?
    var txn_type: String?
    var updated_at: String?
    var created_at: String?
    
    var package_price: Int?
    var platform: String?
    var quantity: Int?
    var entity_id: String?
    var entity: String?
    var passbook_applied:Bool?
    var metaInfo: LT_Meta_Info?
    var artist: Artist?
    
    init(dict: [String: Any]) {
        _id = dict["_id"] as? String
        coins_after_txn = dict["coins_after_txn"] as? Int
        coins_before_txn = dict["coins_before_txn"] as? Int
        total_coins = dict["total_coins"] as? Int
        
        xp = dict["xp"] as? Int
        amount = dict["amount"] as? Int
        coins = dict["coins"] as? Int
        status = dict["status"] as? String
        platform_version = dict["platform_version"] as? String
        txn_type = dict["txn_type"] as? String
        updated_at = dict["updated_at"] as? String
        created_at = dict["created_at"] as? String
        
        quantity = dict["quantity"] as? Int
        package_price = dict["package_price"] as? Int
        platform = dict["platform"] as? String
        entity_id = dict["entity_id"] as? String
        entity = dict["entity"] as? String
        passbook_applied = dict["passbook_applied"] as? Bool
        
        metaInfo = LT_Meta_Info(dict: dict["meta_info"] as? [String: Any])
        artist = Artist(dict: dict["artist"] as? [String: Any])
    }
}


public class List {
    var _id : String?
    var artist_id : String?
    var level : Int?
    var code : String?
    var name : String?
    var caption : String?
    var ordering : Int?
    var content_types : Array<String>?
    var visiblity : Array<String>?
    var status : String?
    var photo : Photo?
    var blur_photo  : Blur_photo?
    var slug : String?
    var type : String?
    var stats : Stats?
    var updated_at : String?
    var created_at : String?
    var bucket_id : String?
    var is_album : String?
    var date_diff_for_human : String?
    var feeling_activity : String?
    var published_at : String?
    var commercial_type : String?
    var coins : Int?
    var video : Video?
    var audio:Audio?
    var source : String?
    var webview_label : String?
    var webview_url : String?
    var commentbox_enable : String?
    var Duration:String?
    var partial_play_duration:String?
    var age_restriction: Int?
    var age_restriction_label: String?
    var is_expired: String?
    var total_votes: Int?
    var pollStat: [PollDetail]?
    var expired_at: String?
    var value: String?
    var list: [List]?
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let list_list = List.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of List Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [List]
    {
        var models:[List] = []
        for item in array
        {
            models.append(List(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let list = List(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: List Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        artist_id = dictionary["artist_id"] as? String
        bucket_id = dictionary["bucket_id"] as? String
        is_album =  dictionary["is_album"] as? String
        date_diff_for_human = dictionary["date_diff_for_human"] as? String
        feeling_activity = dictionary["feeling_activity"] as? String
        published_at = dictionary["published_at"] as? String
        commercial_type = dictionary["commercial_type"] as? String
        webview_label = dictionary["webview_label"] as? String
        webview_url = dictionary["webview_url"] as? String
        level = dictionary["level"] as? Int
        partial_play_duration = dictionary["partial_play_duration"] as? String
        Duration = dictionary["duration"] as? String
        code = dictionary["code"] as? String
        commentbox_enable = dictionary["is_commentbox_enable"] as? String
        name = dictionary["name"] as? String
        caption = dictionary["caption"] as? String
        ordering = dictionary["ordering"] as? Int
        status = dictionary["status"] as? String
        if let value = dictionary["value"] as? String {
            self.value = value
        }
        if let bucket = dictionary["bucket"] as? [String: Any] {
            if let code = bucket["code"] as? String, let name = bucket["name"] as? String {
                self.code = code
              //  self.name = name
            }
        }
        if (dictionary["contents"] != nil) {
            list = List.modelsFromDictionaryArray(array: dictionary["contents"] as! NSArray)
        }
        if (dictionary["banners"] != nil) {
            list = List.modelsFromDictionaryArray(array: dictionary["banners"] as! NSArray)
        }
        if (dictionary["blur_photo"] != nil) { blur_photo = Blur_photo(dict: (dictionary["blur_photo"] as? [String : Any]))}
        
        if (dictionary["photo"] != nil) { photo = Photo(dict: (dictionary["photo"] as? [String : Any])) }
        if (dictionary["video"] != nil) { video = Video(dictionary: (dictionary["video"] as! NSDictionary)) }
        if (dictionary["audio"] != nil) { audio = Audio(dictionary: (dictionary["audio"] as! NSDictionary)) }
        slug = dictionary["slug"] as? String
        type = dictionary["type"] as? String
        if (dictionary["stats"] != nil) { stats = Stats(dictionary: dictionary["stats"] as! NSDictionary) }
        updated_at = dictionary["updated_at"] as? String
        created_at = dictionary["created_at"] as? String
        if let coinsString = dictionary["coins"] as? String {
            coins = Int(coinsString)
        } else if let coinsInt = dictionary["coins"] as? Int {
            coins = coinsInt
        } else {
            coins = 0
        }

        source = dictionary["source"] as? String
        age_restriction = dictionary["age_restriction"] as? Int
        age_restriction_label = dictionary["age_restriction_label"] as? String
        is_expired  = dictionary["is_expired"] as? String
        total_votes = dictionary["total_votes"] as? Int
        if (dictionary["pollstats"] != nil) { pollStat = PollDetail.modelsFromDictionaryArray(array: dictionary["pollstats"] as! [[String: Any]]) }
        expired_at = dictionary["expired_at"] as? String
    }
    
}
public class PollDetail {
    public var id : String?
    public var votes : Int?
    public var label : String?
    public var url : String?
    public var votes_in_percentage: Double?
    public var isSelected:Bool = false
    /*  {
     "id" : "5d78c41d63389034517b45e2",
     "votes" : 0,
     "label" : "Yes",
     "votes_in_percentage" : 0
     }*/
    
    
    public class func modelsFromDictionaryArray(array:[[String: Any]]) -> [PollDetail]
    {
        var models:[PollDetail] = []
        for item in array
        {
            models.append(PollDetail(dictionary: item)!)
        }
        return models
    }
    
    init?(dictionary: [String:Any]) {
        
        id = dictionary["id"] as? String
        votes = dictionary["votes"] as? Int
        label = dictionary["label"] as? String
        votes_in_percentage = dictionary["votes_in_percentage"] as? Double
    }
}

public class Audio {
    public var cover : String?
    public var embed_code : String?
    public var content_types : String?
    public var url : String?
    
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let video_list = Video.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Video Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Audio]
    {
        var models:[Audio] = []
        for item in array
        {
            models.append(Audio(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let video = Video(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Video Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        cover = dictionary["cover"] as? String
        content_types = dictionary["content_types"] as? String
        url = dictionary["url"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.cover, forKey: "cover")
        dictionary.setValue(self.content_types, forKey: "content_types")
        dictionary.setValue(self.url, forKey: "url")
        
        return dictionary
    }
    
}

public class Video {
    public var cover : String?
    public var embed_code : String?
    public var player_type : String?
    public var url : String?
    var coverHeight: Int?
    var coverWidth: Int?
    var thumbHeight: Int?
    var thumbWidth: Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let video_list = Video.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Video Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Video]
    {
        var models:[Video] = []
        for item in array
        {
            models.append(Video(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let video = Video(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Video Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        cover = dictionary["cover"] as? String
        embed_code = dictionary["embed_code"] as? String
        player_type = dictionary["player_type"] as? String
        url = dictionary["url"] as? String
        coverHeight = dictionary["cover_height"] as? Int
        coverWidth = dictionary["cover_width"] as? Int
        thumbHeight = dictionary["thumb_height"] as? Int
        thumbWidth = dictionary["thumb_width"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.cover, forKey: "cover")
        dictionary.setValue(self.embed_code, forKey: "embed_code")
        dictionary.setValue(self.player_type, forKey: "player_type")
        dictionary.setValue(self.url, forKey: "url")
        
        return dictionary
    }
    
}
public class Stats {
    public var likes : Int?
    public var comments : Int?
    public var shares : Int?
    public var childrens : Int?
    public var replies : Int?
    public var views : Int?
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let stats_list = Stats.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Stats Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Stats]
    {
        var models:[Stats] = []
        for item in array
        {
            models.append(Stats(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let stats = Stats(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Stats Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        likes = dictionary["likes"] as? Int
        comments = dictionary["comments"] as? Int
        shares = dictionary["shares"] as? Int
        childrens = dictionary["childrens"] as? Int
        replies = dictionary["replies"] as? Int
        views = dictionary["views"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.likes, forKey: "likes")
        dictionary.setValue(self.comments, forKey: "comments")
        dictionary.setValue(self.shares, forKey: "shares")
        dictionary.setValue(self.childrens, forKey: "childrens")
        
        return dictionary
    }
    
}

class Room {
    
    var key: String
    var title: String
    
    
    init(dict: [String: AnyObject]) {
        title = dict["title"] as! String
        key = dict["key"] as! String
    }
    
    func toDict() -> [String: AnyObject] {
        return [
            "title": title as AnyObject,
            "key": key as AnyObject
        ]
    }
}




class Rewards {
    var reward_title: String?
    var _id: String?
    var updated_at: String?
    var reward_type: String?
    var coins: Int?
    var created_at: String?
    var description: String?
    var title: String?
    var customer_id: String?
    var artist_id: String?
    var artist: Artist?
    
    init(dict: [String: Any]) {
        reward_title = dict["reward_title"] as? String
        coins = dict["coins"] as? Int
        reward_type = dict["reward_type"] as? String
        created_at = dict["created_at"] as? String
        description = dict["description"] as? String
        _id = dict["_id"] as? String
        title = dict["title"] as? String
        customer_id = dict["customer_id"] as? String
        artist_id = dict["artist_id"] as? String
        artist = Artist(dict: dict["artist"] as? [String: Any])
        //            dict["artist"] as? Artist
        
    }
}

class Purchase {
    
    var package_id: String?
    var updated_at: String?
    var created_at: String?
    var package_price: Int?
    var platform: String?
    var package_coins: Int?
    var vendor: String?
    var currency_code: String?
    var package_sku: String?
    var customer_id: String?
    var order_status: String?
    var artist_id: String?
    var _id: String?
    var package_xp: Int?
    var coins_after_purchase: Int?
    var transaction_price: Double?
    var artist: Artist?
    
    init(dict: [String: Any]) {
        package_id = dict["package_id"] as? String
        package_price = dict["package_price"] as? Int
        updated_at = dict["updated_at"] as? String
        created_at = dict["created_at"] as? String
        package_coins = dict["package_coins"] as? Int
        platform = dict["platform"] as? String
        coins_after_purchase = dict["coins_after_txn"] as? Int
        vendor = dict["vendor"] as? String
        currency_code = dict["currency_code"] as? String
        customer_id = dict["customer_id"] as? String
        package_sku = dict["package_sku"] as? String
        order_status = dict["order_status"] as? String
        artist_id = dict["artist_id"] as? String
        _id = dict["_id"] as? String
        package_xp = dict["package_xp"] as? Int
        transaction_price = dict["transaction_price"] as? Double
        artist = Artist(dict: dict["artist"] as? [String: Any])
        
    }
}



class Spending {
    
    var id: String?
    var coins: Int?
    var created_at: String?
    var entity_id: String?
    var gift: Gift?
    var type: String?
    var coins_before_purchase: Int?
    var updated_at: String?
    var coins_after_purchase: Int?
    var artist: Artist?
    var coin_of_one: Int?
    var spending_type: String?
    var total_quantity: Int?
    var entity: String?
    var artist_id: String?
    var customer_id: String?
    var content:Content?
    
    init(dict: [String: Any]) {
        id = dict["_id"] as? String
        coins = dict["coins"] as? Int
        created_at = dict["created_at"] as? String
        entity_id = dict["entity_id"] as? String
        coins_before_purchase = dict["coins_before_purchase"] as? Int
        updated_at = dict["updated_at"] as? String
        coins_after_purchase = dict["coins_after_txn"] as? Int
        artist = Artist(dict: dict["artist"] as? [String: Any])
        if let speningContent = dict["content"] as? [String : Any] {
            spending_type = speningContent["type"] as? String
        }
        //        content = dict["content"] as? Content
        coin_of_one = dict["coin_of_one"] as? Int
        total_quantity = dict["total_quantity"] as? Int
        entity = dict["entity"] as? String
        artist_id = dict["artist_id"] as? String
        customer_id = dict["customer_id"] as? String
        gift = Gift.init(dict: dict["gift"] as? [String : Any])
        content = Content.init(dict: dict["content"] as? [String : Any])
    }
}

class Gift: Codable {
    var xp : String?
    var type : String?
    var status: String?
    var name: String?
    var id: String?
    var free_limit: Int?
    var coins: Int?
    var spendingPhoto: SpendingOnPhoto?
    var photo : Photo?
    var live_type : String?

    init() {

    }
    
    init(dict: [String: Any]?) {
        status = dict?["status"] as? String
        name = dict?["name"] as? String
        id = dict?["_id"] as? String
        free_limit = dict?["free_limit"] as? Int
        coins = dict?["coins"] as? Int
        xp = dict?["xp"] as? String
        type =  dict?["type"] as? String
        spendingPhoto = SpendingOnPhoto.init(dict: dict?["photo"] as? [String : Any])
        photo = Photo.init(dict: dict?["photo"] as? [String : Any])
        
    }
}

class  SpendingOnPhoto: Codable {
    var thumb: String?
    init(dict: [String: Any]?) {
        thumb = dict?["thumb"] as? String
    }
}
class Content {
    var photo: Photo?
    var video:videos?
    var audio:Audios?
    var slug:String?
    init(dict: [String: Any]?) {
        photo = Photo.init(dict: dict?["photo"] as? [String : Any])
        video = videos.init(dict: dict?["video"] as? [String : Any])
        audio = Audios.init(dict: dict?["audio"] as? [String : Any])
        slug = dict?["slug"] as? String
        
    }
}
class Audios {
    var cover: String?
    init(dict: [String: Any]?) {
        cover = dict?["cover"] as? String
    }
}

class videos {
    var cover: String?
    init(dict: [String: Any]?) {
        cover = dict?["cover"] as? String
    }
}

class Blur_photo: Codable { //rupali

    var portrait : String?
    var landscape : String?
    
    init(dict: [String: Any]?) {
        
        portrait = dict?["portrait"] as? String
        landscape = dict?["landscape"] as? String
    }
}

class Photo: Codable {
    var cover: String?
    var thumb: String?
    var coverHeight: Int?
    var coverWidth: Int?
    var thumbHeight: Int?
    var thumbWidth: Int?
    init(dict: [String: Any]?) {
        cover = dict?["cover"] as? String
        thumb = dict?["thumb"] as? String
        coverHeight = dict?["cover_height"] as? Int
        coverWidth = dict?["cover_width"] as? Int
        thumbHeight = dict?["thumb_height"] as? Int
        thumbWidth = dict?["thumb_width"] as? Int
    }
}

class Artist {
    var first_name: String?
    var last_name: String?
    var id: String?
    var cover: Cover?
    init(dict: [String: Any]?) {
        first_name = dict?["first_name"] as? String
        last_name = dict?["last_name"] as? String
        id = dict?["_id"] as? String
        cover = Cover(dict: dict?["cover"] as? [String: Any])
        //            dict?["cover"] as? Cover
    }
}

//class thumb {
//    var thumb: String?
//    var thumbHeight: Int?
//    var thumbWidth: Int?
//    init(dict: [String: Any]?) {
//        thumb = dict?["thumb"] as? String
//        thumbHeight = dict?["thumb_height"] as? Int
//        thumbWidth = dict?["thumb_width"] as? Int
//    }
//}

class Cover {
    var thumb: String?
    
    init(dict: [String: Any]?) {
        thumb = dict?["thumb"] as? String
        
    }
}

struct LiveComment {
    
    var text: String?
    var imageUrl: String?
    var senderFirstName: String?
    var userUid: String?
    var userTimeStamp: String?
    
    init(dict: [String: Any]) {
        text = dict["userComment"] as? String
        imageUrl = dict["userProfilePic"] as? String
        senderFirstName = dict["userName"] as? String
        userUid = dict["userUid"] as? String
        userTimeStamp = dict["userTimeStamp"] as? String
    }
}


class User {
    
    var id = Int(arc4random())
    
    static let currentUser = User()
}

class Comments  : NSObject {
    
    var comment: String?
    var _id: String?
    var contentId: String?
    var entityId: String?
    var user: Users?
    var date_diff_for_human: String?
    var stats : Stats?
    var commented_by : String?
    var types : String?
    var created_at : Date?
    init(dict: [String: Any]) {
        _id = dict["_id"] as? String
        comment = dict["comment"] as? String
        types = dict["type"] as? String
        entityId = dict["entity_id"] as? String
        date_diff_for_human = dict["date_diff_for_human"] as? String
        contentId = dict["contentId"] as? String
        if  let dateStr =  dict["created_at"] as? String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.calendar = Calendar.current
            let date = dateFormatter.date(from: dateStr)
            created_at = date
        }
        user = Users(dict:dict["user"]  as? Dictionary)
        if let statDIct =  dict["stats"] as? NSDictionary{
            stats = Stats(dictionary: statDIct)
        }
    }
}
class Reply  : NSObject {
    
    var comment: String?
    var _id: String?
    var parentId: String?
    var entityId: String?
    var user: Users?
    var created_at : Date?
    var replied_by : String?
    var types : String?
    var date_diff_for_human: String?
    init(dict: [String: Any]) {
        _id = dict["_id"] as? String
        comment = dict["comment"] as? String
        entityId = dict["entity_id"] as? String
        date_diff_for_human = dict["date_diff_for_human"] as? String
        parentId = dict["parent_id"] as? String
        types = dict["type"] as? String
        user = Users(dict:dict["user"]  as? Dictionary)
        if  let dateStr =  dict["created_at"] as? String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.calendar = Calendar.current
            let date = dateFormatter.date(from: dateStr)
            created_at = date
        }
    }
}

class Users : NSObject {
    var id : String?
    var first_name : String?
    var last_name : String?
    var picture : String?
    var badgeIcon : String?
    var badgeName : String?
    var identity : String?
    var email : String?
    
    init(dict: [String: Any]?) {
        
        id  = dict?["_id"] as? String
        first_name  = dict?["first_name"] as? String
        last_name = dict?["last_name"] as? String
        picture = dict?["picture"] as? String
        identity = dict?["identity"] as? String
    }
}


class GiftEvent: NSObject {
    
    var giftImage: String?
    var comboType: Int?
    var giftCost: String?
    var userName: String?
    var userImage: String?
    var userUid: String?
    var userTimeStamp: String?
    
    init(dict: [String: Any]) {
        giftImage = dict["giftUrl"] as? String
        userUid = dict["userUid"] as? String
        comboType = Int(dict["giftComboCount"] as? String ?? "0")
        giftCost = dict["giftCost"] as? String
        userName = dict["userName"] as? String
        userImage = dict["userProfilePic"] as? String
        userTimeStamp = dict["userTimeStamp"] as? String
    }
    
    func shouldComboWith(_ event: GiftEvent) -> Bool {
        return userName == event.userName && giftImage == event.giftImage
    }
    
}

class Package: Codable {
    var id: String
    var name: String
    var coins: Int
    var price: Int
    var xp: Int
    var sku: String
    var status: String
    var updated_at: String
    var created_at: String
    
    init(dictionary: [String: Any]) {
        id = dictionary["_id"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        coins = dictionary["coins"] as? Int ?? 0
        price = dictionary["price"] as? Int ?? 0
        xp = dictionary["xp"] as? Int ?? 0
        sku = dictionary["sku"] as? String ?? ""
        status = dictionary["status"] as? String ?? ""
        updated_at = dictionary["updated_at"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
    }
}

class Greetings {
    var id: String
    var message: String
    var video: Video?
    var customer: Users?


    init(dictionary: [String: Any]) {
        id = dictionary["_id"] as? String ?? ""
        message = dictionary["message"] as? String ?? ""
        if let videoDict = dictionary["video"] as? NSDictionary, let video = Video(dictionary: videoDict) {
            self.video = video
        }
        if let userDict = dictionary["customer"] as? [String:Any] {
            let user = Users(dict: userDict)
            self.customer = user
        }
    }
}

