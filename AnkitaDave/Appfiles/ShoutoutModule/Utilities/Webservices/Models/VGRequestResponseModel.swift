//
//  GreetingRequestModel.swift
//  VideoGreetings
//
//  Created by Apple on 24/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation

struct VGRequestResponseModel : Codable {
    let data : GreetingRequesData?
    let message : String?
    let error : Bool?
    let status_code : Int?
    let errorMessages: Array<String>?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case message = "message"
        case error = "error"
        case status_code = "status_code"
        case errorMessages = "error_messages"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(GreetingRequesData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        errorMessages = try values.decodeIfPresent(Array<String>.self, forKey: .errorMessages)
    }
}

struct GreetingRequesData : Codable {
    let passbook : VGPassbook?
    let shoutout : VGShoutout?
    
    enum CodingKeys: String, CodingKey {
        
        case passbook = "passbook"
        case shoutout = "shoutout"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        passbook = try values.decodeIfPresent(VGPassbook.self, forKey: .passbook)
        shoutout = try values.decodeIfPresent(VGShoutout.self, forKey: .shoutout)
    }
}

struct VGShoutout : Codable {
    let _id : String?
    let artist_id : String?
    let created_at : String?
    let customer_id : String?
    let from_name : String?
    let make_private : Bool?
    let message : String?
    let occassion_id : String?
    let operation_status : String?
    let passbook_id : String?
    let platform : String?
    let relationship : String?
    let schedule_at : String?
    //let shoutouthistorys : [Shoutouthistorys]?
    let status : String?
    let to_name : String?
    let updated_at : String?
    let v : String?
    var greetingData: GreetingList?
    //let videoCallURL
    let duration : String?
    let date : String?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case artist_id = "artist_id"
        case created_at = "created_at"
        case customer_id = "customer_id"
        case from_name = "from_name"
        case make_private = "make_private"
        case message = "message"
        case occassion_id = "occassion_id"
        case operation_status = "operation_status"
        case passbook_id = "passbook_id"
        case platform = "platform"
        case relationship = "relationship"
        case schedule_at = "schedule_at"
        //case shoutouthistorys = "shoutouthistorys"
        case status = "status"
        case to_name = "to_name"
        case updated_at = "updated_at"
        case v = "v"
//        case videoCallURL = "url"
        case duration = "duration"
        case date = "date"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        artist_id = try values.decodeIfPresent(String.self, forKey: .artist_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        customer_id = try values.decodeIfPresent(String.self, forKey: .customer_id)
        from_name = try values.decodeIfPresent(String.self, forKey: .from_name)
        make_private = try values.decodeIfPresent(Bool.self, forKey: .make_private)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        occassion_id = try values.decodeIfPresent(String.self, forKey: .occassion_id)
        operation_status = try values.decodeIfPresent(String.self, forKey: .operation_status)
        passbook_id = try values.decodeIfPresent(String.self, forKey: .passbook_id)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        relationship = try values.decodeIfPresent(String.self, forKey: .relationship)
        schedule_at = try values.decodeIfPresent(String.self, forKey: .schedule_at)
        //shoutouthistorys = try values.decodeIfPresent([Shoutouthistorys].self, forKey: .shoutouthistorys)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        to_name = try values.decodeIfPresent(String.self, forKey: .to_name)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)
        v = try values.decodeIfPresent(String.self, forKey: .v)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        
        
        
        // After submitting Greeting Request.
        // Set didSubmitRequest flag as true to handle Order Instruction visibility.
        greetingData = try? GreetingList(from: decoder, didSubmitRequest: true)
    }
    
}


struct VGPassbook : Codable {
    let _id : String?
    let amount : Int?
    let artist_id : String?
    let coins : Int?
    let coins_after_txn : Int?
    let coins_before_txn : Int?
    let created_at : String?
    let customer_id : String?
    let entity : String?
    let entity_id : String?
    let passbook_applied : Bool?
    let platform : String?
    let platform_version : String?
    let quantity : Int?
    let reference_id : String?
    let status : String?
    let total_coins : Int?
    let txn_meta_info : Txn_meta_info?
    let txn_type : String?
    let updated_at : String?
    let xp : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case amount = "amount"
        case artist_id = "artist_id"
        case coins = "coins"
        case coins_after_txn = "coins_after_txn"
        case coins_before_txn = "coins_before_txn"
        case created_at = "created_at"
        case customer_id = "customer_id"
        case entity = "entity"
        case entity_id = "entity_id"
        case passbook_applied = "passbook_applied"
        case platform = "platform"
        case platform_version = "platform_version"
        case quantity = "quantity"
        case reference_id = "reference_id"
        case status = "status"
        case total_coins = "total_coins"
        case txn_meta_info = "txn_meta_info"
        case txn_type = "txn_type"
        case updated_at = "updated_at"
        case xp = "xp"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        artist_id = try values.decodeIfPresent(String.self, forKey: .artist_id)
        coins = try values.decodeIfPresent(Int.self, forKey: .coins)
        coins_after_txn = try values.decodeIfPresent(Int.self, forKey: .coins_after_txn)
        coins_before_txn = try values.decodeIfPresent(Int.self, forKey: .coins_before_txn)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        customer_id = try values.decodeIfPresent(String.self, forKey: .customer_id)
        entity = try values.decodeIfPresent(String.self, forKey: .entity)
        entity_id = try values.decodeIfPresent(String.self, forKey: .entity_id)
        passbook_applied = try values.decodeIfPresent(Bool.self, forKey: .passbook_applied)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        platform_version = try values.decodeIfPresent(String.self, forKey: .platform_version)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        reference_id = try values.decodeIfPresent(String.self, forKey: .reference_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        total_coins = try values.decodeIfPresent(Int.self, forKey: .total_coins)
        txn_meta_info = try values.decodeIfPresent(Txn_meta_info.self, forKey: .txn_meta_info)
        txn_type = try values.decodeIfPresent(String.self, forKey: .txn_type)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        xp = try values.decodeIfPresent(Int.self, forKey: .xp)
    }
}

struct Txn_meta_info : Codable {
    let _id : String?
    let artist_id : String?
    let created_at : String?
    let customer_id : String?
    let from_name : String?
    let make_private : Bool?
    let message : String?
    let occassion_id : String?
    let operation_status : String?
    let platform : String?
    let relationship : String?
    let schedule_at : String?
    //let shoutouthistorys : [Shoutouthistorys]?
    let status : String?
    let to_name : String?
    let updated_at : String?
    let v : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case artist_id = "artist_id"
        case created_at = "created_at"
        case customer_id = "customer_id"
        case from_name = "from_name"
        case make_private = "make_private"
        case message = "message"
        case occassion_id = "occassion_id"
        case operation_status = "operation_status"
        case platform = "platform"
        case relationship = "relationship"
        case schedule_at = "schedule_at"
        //case shoutouthistorys = "shoutouthistorys"
        case status = "status"
        case to_name = "to_name"
        case updated_at = "updated_at"
        case v = "v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        artist_id = try values.decodeIfPresent(String.self, forKey: .artist_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        customer_id = try values.decodeIfPresent(String.self, forKey: .customer_id)
        from_name = try values.decodeIfPresent(String.self, forKey: .from_name)
        make_private = try values.decodeIfPresent(Bool.self, forKey: .make_private)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        occassion_id = try values.decodeIfPresent(String.self, forKey: .occassion_id)
        operation_status = try values.decodeIfPresent(String.self, forKey: .operation_status)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        relationship = try values.decodeIfPresent(String.self, forKey: .relationship)
        schedule_at = try values.decodeIfPresent(String.self, forKey: .schedule_at)
        //shoutouthistorys = try values.decodeIfPresent([Shoutouthistorys].self, forKey: .shoutouthistorys)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        to_name = try values.decodeIfPresent(String.self, forKey: .to_name)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        v = try values.decodeIfPresent(String.self, forKey: .v)
    }
    
}

/*
struct Shoutouthistorys : Codable {
    let _id : String?
    let created_at : String?
    let executed_at : String?
    let executed_by : String?
    let interval : Int?
    let operation_status : String?
    let status : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case created_at = "created_at"
        case executed_at = "executed_at"
        case executed_by = "executed_by"
        case interval = "interval"
        case operation_status = "operation_status"
        case status = "status"
        case updated_at = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        executed_at = try values.decodeIfPresent(String.self, forKey: .executed_at)
        executed_by = try values.decodeIfPresent(String.self, forKey: .executed_by)
        interval = try values.decodeIfPresent(Int.self, forKey: .interval)
        operation_status = try values.decodeIfPresent(String.self, forKey: .operation_status)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}
 */
