//
//  VideoAsset.swift
//  AnveshiJain
//
//  Created by Bhavesh Chaudhari on 25/06/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
import ObjectMapper

struct VideoAsset : Mappable {
    var player_type : String?
    var url : String?
    var thumb : String?
    var thumb_width : Int?
    var thumb_height : Int?
    var cover : String?
    var cover_width : Int?
    var cover_height : Int?
    var medium : String?
    var medium_width : Int?
    var medium_height : Int?
    var large : String?
    var large_width : Int?
    var large_height : Int?
    var xsmall : String?
    var xsmall_width : Int?
    var xsmall_height : Int?
    var xlarge : String?
    var xlarge_width : Int?
    var xlarge_height : Int?
    var small : String?
    var small_width : Int?
    var small_height : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        player_type <- map["player_type"]
        url <- map["url"]
        thumb <- map["thumb"]
        thumb_width <- map["thumb_width"]
        thumb_height <- map["thumb_height"]
        cover <- map["cover"]
        cover_width <- map["cover_width"]
        cover_height <- map["cover_height"]
        medium <- map["medium"]
        medium_width <- map["medium_width"]
        medium_height <- map["medium_height"]
        large <- map["large"]
        large_width <- map["large_width"]
        large_height <- map["large_height"]
        xsmall <- map["xsmall"]
        xsmall_width <- map["xsmall_width"]
        xsmall_height <- map["xsmall_height"]
        xlarge <- map["xlarge"]
        xlarge_width <- map["xlarge_width"]
        xlarge_height <- map["xlarge_height"]
        small <- map["small"]
        small_width <- map["small_width"]
        small_height <- map["small_height"]
    }

}
