//
//  APMStoryResponse.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

public class APMStoryResponse : Codable {
    public let data : APMStory?
    public let error_messages : [String]?
    public let error : Bool?
    public let status_code : Int?
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(APMStory.self, forKey: .data)
        error_messages = try values.decodeIfPresent([String].self, forKey: .error_messages)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
}
