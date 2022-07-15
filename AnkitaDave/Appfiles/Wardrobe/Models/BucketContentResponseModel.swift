//
//  BucketContentResponseModel.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 24/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

struct BucketContentResponseModel : Codable {
    let data : BucketContentData?
    let error_messages : [String]?
    let error : Bool?
    let status_code : Int?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(BucketContentData.self, forKey: .data)
        error_messages = try values.decodeIfPresent([String].self, forKey: .error_messages)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
}

struct BucketContentData : Codable {
    let list : [BucketList]?
    let cache : Cache?
    let paginate_data : Paginate?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([BucketList].self, forKey: .list)
        cache = try values.decodeIfPresent(Cache.self, forKey: .cache)
        paginate_data = try values.decodeIfPresent(Paginate.self, forKey: .paginate_data)
    }
}

struct BucketList : Codable {
    let _id : String?
    let type : String?
    let video : VideoInfo?
    let photo : PhotoInfo?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        video = try values.decodeIfPresent(VideoInfo.self, forKey: .video)
        photo = try values.decodeIfPresent(PhotoInfo.self, forKey: .photo)
    }
}

struct VideoInfo : Codable {
    let url : String?
    let playerType : String?
    let cover : String?
    let coverHeight : Int?
    let coverWidth : Int?
    let thumb : String?
    let thumbHeight : Int?
    let thumbWidth : Int?
    
    enum CodingKeys: String, CodingKey {
        case url
        case playerType = "player_type"
        case cover
        case coverHeight = "cover_height"
        case coverWidth = "cover_width"
        case thumb
        case thumbHeight = "thumb_height"
        case thumbWidth = "thumb_width"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        playerType = try values.decodeIfPresent(String.self, forKey: .playerType)
        cover = try values.decodeIfPresent(String.self, forKey: .cover)
        coverHeight = try values.decodeIfPresent(Int.self, forKey: .coverHeight)
        coverWidth = try values.decodeIfPresent(Int.self, forKey: .coverWidth)
        thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
        thumbHeight = try values.decodeIfPresent(Int.self, forKey: .thumbHeight)
        thumbWidth = try values.decodeIfPresent(Int.self, forKey: .thumbWidth)
    }
}

struct PhotoInfo : Codable {
    let cover : String?
    var coverHeight : Int?
    var coverWidth : Int?
    let thumb : String?
    let thumbHeight : Int?
    let thumbWidth : Int?

    enum CodingKeys: String, CodingKey {
        case cover
        case coverHeight = "cover_height"
        case coverWidth = "cover_width"
        case thumb
        case thumbHeight = "thumb_height"
        case thumbWidth = "thumb_width"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cover = try values.decodeIfPresent(String.self, forKey: .cover)
        coverHeight = try values.decodeIfPresent(Int.self, forKey: .coverHeight)
        coverWidth = try values.decodeIfPresent(Int.self, forKey: .coverWidth)
        thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
        thumbHeight = try values.decodeIfPresent(Int.self, forKey: .thumbHeight)
        thumbWidth = try values.decodeIfPresent(Int.self, forKey: .thumbWidth)
    }
}
