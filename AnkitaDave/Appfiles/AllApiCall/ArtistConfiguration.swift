//
//  ArtistConfiguration.swift
//  Karan Kundrra Official
//
//  Created by RazrTech2 on 24/04/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import Foundation
import SwiftyJSON

class ArtistConfiguration: NSObject {

    var _id : String?
    var artist_id : String?
    var ios_version_name : String?
    var ios_version_no : Int?
    var fmc_default_topic_id : String?
    var fmc_default_topic_id_test : String?
    var social_bucket_id : String?
    var fb_user_name : String?
    var fb_page_url : String?
    var fb_api_key : String?
    var fb_api_secret : String?
    var twitter_user_name : String?
    var twitter_page_url : String?
    var twitter_oauth_access_token : String?
    var twitter_oauth_access_token_secret : String?
    var twitter_consumer_key : String?
    var twitter_consumer_key_secret : String?
    var instagram_user_name : String?
    var instagram_page_url : String?
    var last_updated_buckets : String?
    var updated_at : String?
    var created_at : String?
    var key : String?
    var fcm_server_key : String?
    var domain : String?
    var session_timeout : Bool?
    var promotional_banners : Bool?
    var instagram_user_id : String?
    var socket_url : String?
    var fb_page_id : String?
    var fb_access_token : String?
    var instagram_password : String?
    var first_name : String?
    var last_name : String?
    var picture : String?
    var human_readable_created_date : String?
    var date_diff_for_human : String?
    var shoutout: ArtistShoutoutConfig?
    var static_url: StaticURLs?
    var directLine: ArtistDirectLine?
    var oneToOne: ArtistOneToOneConfig?
    var photo: String?
    var reported_tagsArray : ReportTagConfig?
    
    var privateVideoCall: privateVideoCallConfig?
    var privateVideoCallURL:privateVideoCallURLConfig?
    var privateVideoCallrateCard:PrivateVideoCallrateCardConfig?
    var privateVideoCallSuccessResponse:VideoCallBookingResponse?
    var artistLanguage:ArtistLanguageConfig?
    var MinimumTNCVersion: Double?
    var AcceptedTNCVersion: Double?

    var channel_namespace : String?
    var pubnub_publish_key : String?
    var pubnub_subcribe_key : String?
    var gift_channel_name : [Any]?
    var comment_channel_name : [Any]?
    var agora_id : String?
    var pn_auth_key : Bool?
    
    class func sharedInstance() -> ArtistConfiguration {
        struct Static {
            static let sharedInstance = ArtistConfiguration()
        }
        return Static.sharedInstance
    }
}

struct StaticURLs {
    
    var privacy_policy: String?
    var cancellation_refund_policy: String?
    var shoutouts: String?
    var terms_conditions: String?
    var faqs: String?
    var process_flow: String?
    var ott_community_guidelines_url: String?
    
    init(data: Dictionary<String, Any>?) {
        privacy_policy = data?["privacy_policy"] as? String
        cancellation_refund_policy = data?["cancellation_refund_policy"] as? String
        shoutouts = data?["shoutouts"] as? String
        terms_conditions = data?["terms_conditions"] as? String
        faqs = data?["faqs"] as? String
        process_flow = data?["process_flow"] as? String
        ott_community_guidelines_url = data?["ott_community_guidelines_url"] as? String
       // copy_right = data?[""]
    }
}

struct ArtistShoutoutConfig {
    var greetingQuota: Int?
    var greetingCoins: Int?
    var recordQuota: Int?
    var recordCoins: Int?
    var donateToCharity: Bool?
    var donateCharityName: String?
    var how_to_video: VGVideo?
    
    init(data: Dictionary<String, Any>?) {
        greetingQuota = data?["greeting_quota"] as? Int
        greetingCoins = data?["greeting_coins"] as? Int
        recordQuota = data?["record_quota"] as? Int
        recordCoins = data?["record_coins"] as? Int
        donateToCharity = data?["donate_to_charity"] as? Bool
        donateCharityName = data?["donate_charity_name"] as? String
        if let videoData = data?["how_to_video"] as? Dictionary<String, Any>, let data = try? JSONSerialization.data(withJSONObject: videoData, options: .prettyPrinted) {
            how_to_video = try? JSONDecoder().decode(VGVideo.self, from: data)
        }
    }
}

struct ArtistDirectLine {
    
    var message_length: Int64?
    var response_time: Int64?
    var coins: Int64?
    
    init(data: Dictionary<String, Any>?) {
        
        message_length = data?["message_length"] as? Int64
        response_time = data?["response_time"] as? Int64
        coins = data?["coins"] as? Int64
    }
}

struct ArtistOneToOneConfig {
    
    var coins: Int64? = 10
    var duration: Int64? = 30
    var visibility: String? = "true"
    
    init(data: Dictionary<String, Any>?) {
        
        coins = data?["coins"] as? Int64
        duration = data?["duration"] as? Int64
        visibility = data?["visibility"] as? String
    }
}

struct privateVideoCallConfig {
    
    var coins: Int64? = 10
    var duration: Int64? = 30
    var rateCradNew: Int64? = 30
    var privateVideoCallrateCard: PrivateVideoCallrateCardConfig?

    init(data: JSON) {
        
        coins = data["coins"].int64Value
        duration = data["time_interval"].int64Value
        rateCradNew = data["ratecard"].int64Value
        
        let arrayRateCards = data["ratecard"].arrayValue
       privateVideoCallrateCard = PrivateVideoCallrateCardConfig(data: arrayRateCards)
    }
      
}

struct privateVideoCallURLConfig {
    
    var videoURL: String? = " "

    init(data: Dictionary<String, Any>?) {
      
        videoURL = data?["url"] as? String
       
    }
      
}

struct PrivateVideoCallrateCardConfig {
    
    var coins = [Int64]()
    var durations = [Int64]()
     var defaultRatecard = [Int64]()
     //var isSelected: Bool = false
    init(data: [JSON]) {
        for json in data {
         let coin = json["coins"].int64Value
         let duration = json["duration"].int64Value
         let defaultratecard = json["default_ratecard"].int64Value
            
        coins.append(coin)
        durations.append(duration)
        defaultRatecard.append(defaultratecard)
        }
    }
}


public class VideoCallBookingResponse {
   
    var passbook_id: String?
    var request_id: String?
    var coin_after_transaction: Int64? = 10

    init(data: Dictionary<String, Any>?) {
        
        passbook_id = data?["passbook_id"] as? String
        request_id = data?["request_id"] as? String
        coin_after_transaction = data?["coin_after_transaction"] as? Int64
    }
}

struct ArtistLanguageConfig {
    var languages = [ArtistLanguage]()
    init(data: [JSON]) {
        for json in data{
            self.languages.append(ArtistLanguage(data: json))
        }
    }
}


struct ArtistLanguage {
    var isDefault: Bool = false
    var language: String = ""

    init(data: JSON) {
        self.isDefault = data["is_default"].boolValue
        self.language = data["name"].stringValue
    }
}

struct ReportTagConfig {
    var reported_tags = [ReportTag]()
    init(data: [JSON]) {
        for json in data{
            self.reported_tags.append(ReportTag(data: json))
        }
    }
}


struct ReportTag {
    var slug: String = ""
    var label: String = ""
    var description : String = ""
    var isSelectedRepoprt : Bool!

    init(data: JSON) {
        self.slug = data["slug"].stringValue
        self.label = data["label"].stringValue
        self.description = data["description"].stringValue
        self.isSelectedRepoprt = false
        
    }
}
