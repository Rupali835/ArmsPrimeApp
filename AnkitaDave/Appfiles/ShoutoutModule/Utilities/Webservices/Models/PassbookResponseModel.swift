//
//  PassbookResponseModel.swift
//  AnveshiJain
//
//  Created by Apple on 09/10/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import Foundation

struct PassbookResponseModel: Codable {
    let data : PassbookData?
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
        data = try values.decodeIfPresent(PassbookData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
}


struct PassbookData : Codable {
    let list : [PassbookList]?
    let paginate_data : Paginate?
    let cache : Cache?
    
    enum CodingKeys: String, CodingKey {
        
        case list = "list"
        case paginate_data = "paginate_data"
        case cache = "cache"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([PassbookList].self, forKey: .list)
        paginate_data = try values.decodeIfPresent(Paginate.self, forKey: .paginate_data)
        cache = try values.decodeIfPresent(Cache.self, forKey: .cache)
    }
    
}

struct PassbookList : Codable {
    let _id : String?
    let entity : String?
    let entity_id : String?
    let platform : String?
    let platform_version : String?
    let xp : Int?
    let coins : Int?
    let total_coins : Int?
    let quantity : Int?
    let amount : Int?
    let coins_before_txn : Int?
    let coins_after_txn : Int?
    let txn_type : String?
    let status : String?
    let passbook_applied : Bool?
    let updated_at : String?
    let created_at : String?
    let package_price: Int?
    let artist : PassbookArtist?
    let meta_info : PassbookMetaInfo?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case entity = "entity"
        case entity_id = "entity_id"
        case platform = "platform"
        case platform_version = "platform_version"
        case xp = "xp"
        case coins = "coins"
        case total_coins = "total_coins"
        case quantity = "quantity"
        case amount = "amount"
        case coins_before_txn = "coins_before_txn"
        case coins_after_txn = "coins_after_txn"
        case txn_type = "txn_type"
        case status = "status"
        case passbook_applied = "passbook_applied"
        case updated_at = "updated_at"
        case created_at = "created_at"
        case artist = "artist"
        case meta_info = "meta_info"
        case package_price = "package_price"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        entity = try values.decodeIfPresent(String.self, forKey: .entity)
        entity_id = try values.decodeIfPresent(String.self, forKey: .entity_id)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        platform_version = try values.decodeIfPresent(String.self, forKey: .platform_version)
        xp = try values.decodeIfPresent(Int.self, forKey: .xp)
        coins = try values.decodeIfPresent(Int.self, forKey: .coins)
        total_coins = try values.decodeIfPresent(Int.self, forKey: .total_coins)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        coins_before_txn = try values.decodeIfPresent(Int.self, forKey: .coins_before_txn)
        coins_after_txn = try values.decodeIfPresent(Int.self, forKey: .coins_after_txn)
        txn_type = try values.decodeIfPresent(String.self, forKey: .txn_type)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        passbook_applied = try values.decodeIfPresent(Bool.self, forKey: .passbook_applied)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        artist = try values.decodeIfPresent(PassbookArtist.self, forKey: .artist)
        meta_info = try values.decodeIfPresent(PassbookMetaInfo.self, forKey: .meta_info)
        package_price = try values.decodeIfPresent(Int.self, forKey: .package_price)
    }
    
    static func initWithDictionary(data: Dictionary<String, Any>?) -> PassbookList? {
        guard let receivedData = data else { return nil }
        do
        {
            let passbookData = try JSONSerialization.data(withJSONObject: receivedData, options: .prettyPrinted)
            let passbook = try JSONDecoder().decode(PassbookList.self, from: passbookData)
            return passbook
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

struct PassbookArtist : Codable {
    let _id : String?
    let first_name : String?
    let last_name : String?
    let email : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }
    
    static func initWithDictionary(data: Dictionary<String, Any>?) -> PassbookArtist? {
        guard let receivedData = data else { return nil }
        do
        {
            let passbookData = try JSONSerialization.data(withJSONObject: receivedData, options: .prettyPrinted)
            let passbookArtist = try JSONDecoder().decode(PassbookArtist.self, from: passbookData)
            return passbookArtist
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

struct PassbookMetaInfo : Codable {
    let type : String?
    let name : String?
    let caption : String?
    let thumb : String?
    let video : String?
    let audio : String?
    let description : String?
    let transaction_price: String?
    let vendor: String?
    let vendor_txn_id: String?
    let currency_code: String?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case name = "name"
        case caption = "caption"
        case thumb = "thumb"
        case video = "video"
        case audio = "audio"
        case description = "description"
        case transaction_price = "transaction_price"
        case vendor = "vendor"
        case vendor_txn_id = "vendor_txn_id"
        case currency_code = "currency_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
        video = try values.decodeIfPresent(String.self, forKey: .video)
        audio = try values.decodeIfPresent(String.self, forKey: .audio)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        transaction_price = try values.decodeIfPresent(String.self, forKey: .transaction_price)
        vendor = try values.decodeIfPresent(String.self, forKey: .vendor)
        vendor_txn_id = try values.decodeIfPresent(String.self, forKey: .vendor_txn_id)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
    }
    
    static func initWithDictionary(data: Dictionary<String, Any>?) -> PassbookMetaInfo? {
        guard let receivedData = data else { return nil }
        do
        {
            let passbookData = try JSONSerialization.data(withJSONObject: receivedData, options: .prettyPrinted)
            let passbookInfo = try JSONDecoder().decode(PassbookMetaInfo.self, from: passbookData)
            return passbookInfo
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
