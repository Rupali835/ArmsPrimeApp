//
//  GreetingListModel.swift
//  VideoGreetings
//
//  Created by Apple on 24/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation

struct VGGreetingsResponseModel : Codable {
    let data : GreetingListData?
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
        data = try values.decodeIfPresent(GreetingListData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
    
}

struct GreetingListData : Codable {
    let list : [GreetingList]?
    let paginate : Paginate?
    
    enum CodingKeys: String, CodingKey {
        
        case list = "list"
        case paginate = "paginate"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([GreetingList].self, forKey: .list)
        paginate = try values.decodeIfPresent(Paginate.self, forKey: .paginate)
    }
    
}

struct GreetingList : Codable {
    let _id : String?
    let occassion : Occassion?
    let from_name : String?
    let to_name : String?
    let relationship : String?
    let schedule_at : String?
    let make_private : Bool?
    let message : String?
    let reason : String?
    let status : String?
    let created_at : String?
    let history: [ShoutoutHistory]?
    let passbook_id: String?
    let video: VGVideo?
    var order: GreetingOrderType?
    var didSubmitRequest: Bool = false
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case occassion = "occassion"
        case from_name = "from_name"
        case to_name = "to_name"
        case relationship = "relationship"
        case schedule_at = "schedule_at"
        case make_private = "make_private"
        case message = "message"
        case reason = "reason"
        case status = "status"
        case created_at = "created_at"
        case history = "history"
        case video = "video"
        case passbook_id = "passbook_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        occassion = try values.decodeIfPresent(Occassion.self, forKey: .occassion)
        from_name = try values.decodeIfPresent(String.self, forKey: .from_name)
        to_name = try values.decodeIfPresent(String.self, forKey: .to_name)
        relationship = try values.decodeIfPresent(String.self, forKey: .relationship)
        schedule_at = try values.decodeIfPresent(String.self, forKey: .schedule_at)
        make_private = try values.decodeIfPresent(Bool.self, forKey: .make_private)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        history = try values.decodeIfPresent([ShoutoutHistory].self, forKey: .history)
        passbook_id = try values.decodeIfPresent(String.self, forKey: .passbook_id)
        if let video = try? values.decodeIfPresent(VGVideo.self, forKey: .video) {
            self.video = video
        } else {
            video = nil
        }
        
        order = GreetingOrderType.getOrderFromStatusKey(status: status, greetingData: self)
    }
    
    init(from decoder: Decoder, didSubmitRequest: Bool) throws {
        try self.init(from: decoder)
        
        self.didSubmitRequest = didSubmitRequest
        order = GreetingOrderType.getOrderFromStatusKey(status: status, greetingData: self)
    }
}

struct ShoutoutHistory: Codable {
    let executed_at: String?
    let status: String?
    
     enum CodingKeys: String, CodingKey {
        case executed_at = "executed_at"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        executed_at = try values.decodeIfPresent(String.self, forKey: .executed_at)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Paginate : Codable {
    let current_page : Int?
    let first_page_url : String?
    let from : Int?
    let to : Int?
    let last_page : Int?
    let path : String?
    let per_page : Int?
    let total : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case current_page = "current_page"
        case first_page_url = "first_page_url"
        case from = "from"
        case to = "to"
        case last_page = "last_page"
        case path = "path"
        case per_page = "per_page"
        case total = "total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
        first_page_url = try values.decodeIfPresent(String.self, forKey: .first_page_url)
        from = try values.decodeIfPresent(Int.self, forKey: .from)
        to = try values.decodeIfPresent(Int.self, forKey: .to)
        last_page = try values.decodeIfPresent(Int.self, forKey: .last_page)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
    
}

struct Occassion : Codable {
    let _id : String?
    let name : String?
    let photo : VGPhotoModel?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case name = "name"
        case photo = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        photo = try values.decodeIfPresent(VGPhotoModel.self, forKey: .photo)
    }
    
}

struct VGVideo : Codable {
    let cover : String?
    let cover_height : Int?
    let cover_width : Int?
    let large : String?
    let large_height : Int?
    let large_width : Int?
    let medium : String?
    let medium_height : Int?
    let medium_width : Int?
    let player_type : String?
    let small : String?
    let small_height : Int?
    let small_width : Int?
    let thumb : String?
    let thumb_height : Int?
    let thumb_width : Int?
    let url : String?
    let xlarge : String?
    let xlarge_height : Int?
    let xlarge_width : Int?
    let xsmall : String?
    let xsmall_height : Int?
    let xsmall_width : Int?
    let url_naked: String?
    
    enum CodingKeys: String, CodingKey {
        
        case cover = "cover"
        case cover_height = "cover_height"
        case cover_width = "cover_width"
        case large = "large"
        case large_height = "large_height"
        case large_width = "large_width"
        case medium = "medium"
        case medium_height = "medium_height"
        case medium_width = "medium_width"
        case player_type = "player_type"
        case small = "small"
        case small_height = "small_height"
        case small_width = "small_width"
        case thumb = "thumb"
        case thumb_height = "thumb_height"
        case thumb_width = "thumb_width"
        case url = "url"
        case xlarge = "xlarge"
        case xlarge_height = "xlarge_height"
        case xlarge_width = "xlarge_width"
        case xsmall = "xsmall"
        case xsmall_height = "xsmall_height"
        case xsmall_width = "xsmall_width"
        case url_naked = "url_naked"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cover = try values.decodeIfPresent(String.self, forKey: .cover)
        cover_height = try values.decodeIfPresent(Int.self, forKey: .cover_height)
        cover_width = try values.decodeIfPresent(Int.self, forKey: .cover_width)
        large = try values.decodeIfPresent(String.self, forKey: .large)
        large_height = try values.decodeIfPresent(Int.self, forKey: .large_height)
        large_width = try values.decodeIfPresent(Int.self, forKey: .large_width)
        medium = try values.decodeIfPresent(String.self, forKey: .medium)
        medium_height = try values.decodeIfPresent(Int.self, forKey: .medium_height)
        medium_width = try values.decodeIfPresent(Int.self, forKey: .medium_width)
        player_type = try values.decodeIfPresent(String.self, forKey: .player_type)
        small = try values.decodeIfPresent(String.self, forKey: .small)
        small_height = try values.decodeIfPresent(Int.self, forKey: .small_height)
        small_width = try values.decodeIfPresent(Int.self, forKey: .small_width)
        thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
        thumb_height = try values.decodeIfPresent(Int.self, forKey: .thumb_height)
        thumb_width = try values.decodeIfPresent(Int.self, forKey: .thumb_width)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        xlarge = try values.decodeIfPresent(String.self, forKey: .xlarge)
        xlarge_height = try values.decodeIfPresent(Int.self, forKey: .xlarge_height)
        xlarge_width = try values.decodeIfPresent(Int.self, forKey: .xlarge_width)
        xsmall = try values.decodeIfPresent(String.self, forKey: .xsmall)
        xsmall_height = try values.decodeIfPresent(Int.self, forKey: .xsmall_height)
        xsmall_width = try values.decodeIfPresent(Int.self, forKey: .xsmall_width)
        url_naked = try values.decodeIfPresent(String.self, forKey: .url_naked)
    }
    
}




