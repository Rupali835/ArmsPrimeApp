//
//  GreetingOccasionListModel.swift
//  VideoGreetings
//
//  Created by Apple on 24/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation

struct VGOccasionsResponseModel : Codable {
    let data : OccasionData?
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
        data = try values.decodeIfPresent(OccasionData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
}

struct OccasionData : Codable {
    let list : [Occasion]?
    let cache : Cache?
    
    enum CodingKeys: String, CodingKey {
        
        case list = "list"
        case cache = "cache"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([Occasion].self, forKey: .list)
        cache = try values.decodeIfPresent(Cache.self, forKey: .cache)
    }
    
}

struct Cache : Codable {
    let hash_name : String?
    let hash_field : String?
    let cache_miss : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case hash_name = "hash_name"
        case hash_field = "hash_field"
        case cache_miss = "cache_miss"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hash_name = try values.decodeIfPresent(String.self, forKey: .hash_name)
        hash_field = try values.decodeIfPresent(String.self, forKey: .hash_field)
        cache_miss = try values.decodeIfPresent(Bool.self, forKey: .cache_miss)
    }
    
}

struct Occasion : Codable {
    let _id : String?
    let name : String?
    let type : String?
    let photo : VGPhotoModel?
    let is_other: Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case name = "name"
        case type = "type"
        case photo = "photo"
        case is_other = "is_other"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        photo = try values.decodeIfPresent(VGPhotoModel.self, forKey: .photo)
        is_other = try values.decodeIfPresent(Bool.self, forKey: .is_other)
    }
}

struct VGPhotoModel : Codable {
    let cover  : String?
    let cover_height : Int?
    let cover_width : Int?
    let large : String?
    let large_height : Int?
    let large_width : Int?
    let medium : String?
    let medium_height : Int?
    let medium_width : Int?
    let small : String?
    let small_height : Int?
    let small_width : Int?
    let thumb : String?
    let thumb_height : Int?
    let thumb_width : Int?
    let xlarge : String?
    let xlarge_height : Int?
    let xlarge_width : Int?
    let xsmall : String?
    let xsmall_height : Int?
    let xsmall_width : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case cover  = "cover "
        case cover_height = "cover_height"
        case cover_width = "cover_width"
        case large = "large"
        case large_height = "large_height"
        case large_width = "large_width"
        case medium = "medium"
        case medium_height = "medium_height"
        case medium_width = "medium_width"
        case small = "small"
        case small_height = "small_height"
        case small_width = "small_width"
        case thumb = "thumb"
        case thumb_height = "thumb_height"
        case thumb_width = "thumb_width"
        case xlarge = "xlarge"
        case xlarge_height = "xlarge_height"
        case xlarge_width = "xlarge_width"
        case xsmall = "xsmall"
        case xsmall_height = "xsmall_height"
        case xsmall_width = "xsmall_width"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cover  = try values.decodeIfPresent(String.self, forKey: .cover )
        cover_height = try values.decodeIfPresent(Int.self, forKey: .cover_height)
        cover_width = try values.decodeIfPresent(Int.self, forKey: .cover_width)
        large = try values.decodeIfPresent(String.self, forKey: .large)
        large_height = try values.decodeIfPresent(Int.self, forKey: .large_height)
        large_width = try values.decodeIfPresent(Int.self, forKey: .large_width)
        medium = try values.decodeIfPresent(String.self, forKey: .medium)
        medium_height = try values.decodeIfPresent(Int.self, forKey: .medium_height)
        medium_width = try values.decodeIfPresent(Int.self, forKey: .medium_width)
        small = try values.decodeIfPresent(String.self, forKey: .small)
        small_height = try values.decodeIfPresent(Int.self, forKey: .small_height)
        small_width = try values.decodeIfPresent(Int.self, forKey: .small_width)
        thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
        thumb_height = try values.decodeIfPresent(Int.self, forKey: .thumb_height)
        thumb_width = try values.decodeIfPresent(Int.self, forKey: .thumb_width)
        xlarge = try values.decodeIfPresent(String.self, forKey: .xlarge)
        xlarge_height = try values.decodeIfPresent(Int.self, forKey: .xlarge_height)
        xlarge_width = try values.decodeIfPresent(Int.self, forKey: .xlarge_width)
        xsmall = try values.decodeIfPresent(String.self, forKey: .xsmall)
        xsmall_height = try values.decodeIfPresent(Int.self, forKey: .xsmall_height)
        xsmall_width = try values.decodeIfPresent(Int.self, forKey: .xsmall_width)
    }
}



