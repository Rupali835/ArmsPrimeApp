//
//  MobileNumberVerifyModel.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 13/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

struct MobileNumberVerifyModel : Codable {
    let message : String?
    let error : Bool?
    let error_messages : [String]?
    let status_code : Int?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        error_messages = try values.decodeIfPresent([String].self, forKey: .error_messages)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
}
