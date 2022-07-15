//
//  DeactivateAccountModel.swift
//  HarsimranKaur
//
//  Created by Apple on 23/10/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import Foundation

struct DeactivateAccountModel: Codable {
    //let data: Any?
    let message: String?
    let error: Bool?
    
    enum CodingKeys: String, CodingKey {
        //case data = "data"
        case message = "message"
        case error = "error"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //data = try values.decodeIfPresent(Any.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
    }
}
