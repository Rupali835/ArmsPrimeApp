//
//  VGGreetingUsageStats.swift
//  VideoGreetings
//
//  Created by Apple on 30/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation

struct VGGreetingUsageStatsModel: Codable {
    let data : GreetingStatsData?
    let message : String?
    let error : Bool?
    let status_code : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case message = "message"
        case error = "error"
        case status_code = "status_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(GreetingStatsData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
    
}

struct GreetingStatsData : Codable {
    let shoutout : GreetingStats?
    let cache : Cache?
    
    enum CodingKeys: String, CodingKey {
        
        case shoutout = "shoutout"
        case cache = "cache"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shoutout = try values.decodeIfPresent(GreetingStats.self, forKey: .shoutout)
        cache = try values.decodeIfPresent(Cache.self, forKey: .cache)
    }
    
}

struct GreetingStats : Codable {
    let quota_total : Int?
    let quota_used : Int?
    let quota_remaining : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case quota_total = "quota_total"
        case quota_used = "quota_used"
        case quota_remaining = "quota_remaining"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quota_total = try values.decodeIfPresent(Int.self, forKey: .quota_total)
        quota_used = try values.decodeIfPresent(Int.self, forKey: .quota_used)
        quota_remaining = try values.decodeIfPresent(Int.self, forKey: .quota_remaining)
    }
    
}


