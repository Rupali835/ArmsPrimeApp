//
//  APMSnap.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

public enum MimeType : String {
    case photo
    case video
    case unknown
}

public class APMSnap : Codable {
    public let _id : String?
    public let type : String?
    public let is_story : Bool?
    public let promotion_type : String?
    public let promotion_value : String?
    public let webview_label : String?
    public let video : APMVideo?
    public let photo : APMPhoto?
    
    public var kind : MimeType {
        switch type {
        case MimeType.photo.rawValue:
            return MimeType.photo
        case MimeType.video.rawValue:
            return MimeType.video
        default:
            return MimeType.unknown
        }
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        is_story = try values.decodeIfPresent(Bool.self, forKey: .is_story)
        promotion_type = try values.decodeIfPresent(String.self, forKey: .promotion_type)
        promotion_value = try values.decodeIfPresent(String.self, forKey: .promotion_value)
        webview_label = try values.decodeIfPresent(String.self, forKey: .webview_label)
        video = try values.decodeIfPresent(APMVideo.self, forKey: .video)
        photo = try values.decodeIfPresent(APMPhoto.self, forKey: .photo)
    }
}

public class APMPhoto : Codable {
    public let url : String?
    
    enum CodingKeys : String, CodingKey {
        case url = "cover"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
}

public class APMVideo : Codable {
    public let url : String?

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
}

//public class APMDownload : Codable {
//    public let video : APMVideoURL?
//
//    required public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        video = try values.decodeIfPresent(APMVideoURL.self, forKey: .video)
//    }
//}
//
//public class APMVideoURL : Codable {
//    public let url : String?
//
//    required public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        url = try values.decodeIfPresent(String.self, forKey: .url)
//    }
//}
