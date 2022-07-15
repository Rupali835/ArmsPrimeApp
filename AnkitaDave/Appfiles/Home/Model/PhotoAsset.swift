//
//  PhotoAsset.swift
//  AnveshiJain
//
//  Created by Bhavesh Chaudhari on 25/06/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
import ObjectMapper

struct PhotoAsset : Mappable {
    var xsmall : String?
    var xsmall_width : Int?
    var xsmall_height : Int?
    var small : String?
    var small_width : Int?
    var small_height : Int?
    var thumb : String?
    var thumb_width : Int?
    var thumb_height : Int?
    var cover : String?
    var cover_width : Int?
    var cover_height : Int?
    var medium : String?
    var medium_width : Int?
    var medium_height : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        xsmall <- map["xsmall"]
        xsmall_width <- map["xsmall_width"]
        xsmall_height <- map["xsmall_height"]
        small <- map["small"]
        small_width <- map["small_width"]
        small_height <- map["small_height"]
        thumb <- map["thumb"]
        thumb_width <- map["thumb_width"]
        thumb_height <- map["thumb_height"]
        cover <- map["cover"]
        cover_width <- map["cover_width"]
        cover_height <- map["cover_height"]
        medium <- map["medium"]
        medium_width <- map["medium_width"]
        medium_height <- map["medium_height"]
    }

}
