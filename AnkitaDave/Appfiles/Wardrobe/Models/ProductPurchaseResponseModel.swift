//
//  ProductPurchaseResponseModel.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 23/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

struct ProductPurchaseResponseModel : Codable {
    let data : PurchaseData?
    let error_messages : [String]?
    let error : Bool?
    let status_code : Int?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(PurchaseData.self, forKey: .data)
        error_messages = try values.decodeIfPresent([String].self, forKey: .error_messages)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
}

struct PurchaseData : Codable {
    let purchase : PurchaseInfo?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        purchase = try values.decodeIfPresent(PurchaseInfo.self, forKey: .purchase)
    }
}

struct PurchaseInfo : Codable {
    let _id : String?
    let entity_id : String?
    let customer_id : String?
    let entity : String?
    let artist_id : String?
    let platform : String?
    let platform_version : String?
    let xp : Int?
    let coins : Int?
    let total_coins : Int?
    let silver_coins : Int?
    let gold_coins : Int?
    let diamond_coins : Int?
    let quantity : Int?
    let amount : Int?
    let coins_before_txn : Int?
    let coins_after_txn : Int?
    let txn_type : String?
    let status : String?
    let reference_id : String?
    let passbook_applied : Bool?
    let is_test : Bool?
    let cart_id : String?
    let remark : String?
    let updated_at : String?
    let created_at : String?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        entity_id = try values.decodeIfPresent(String.self, forKey: .entity_id)
        customer_id = try values.decodeIfPresent(String.self, forKey: .customer_id)
        entity = try values.decodeIfPresent(String.self, forKey: .entity)
        artist_id = try values.decodeIfPresent(String.self, forKey: .artist_id)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        platform_version = try values.decodeIfPresent(String.self, forKey: .platform_version)
        xp = try values.decodeIfPresent(Int.self, forKey: .xp)
        coins = try values.decodeIfPresent(Int.self, forKey: .coins)
        total_coins = try values.decodeIfPresent(Int.self, forKey: .total_coins)
        silver_coins = try values.decodeIfPresent(Int.self, forKey: .silver_coins)
        gold_coins = try values.decodeIfPresent(Int.self, forKey: .gold_coins)
        diamond_coins = try values.decodeIfPresent(Int.self, forKey: .diamond_coins)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        coins_before_txn = try values.decodeIfPresent(Int.self, forKey: .coins_before_txn)
        coins_after_txn = try values.decodeIfPresent(Int.self, forKey: .coins_after_txn)
        txn_type = try values.decodeIfPresent(String.self, forKey: .txn_type)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        reference_id = try values.decodeIfPresent(String.self, forKey: .reference_id)
        passbook_applied = try values.decodeIfPresent(Bool.self, forKey: .passbook_applied)
        is_test = try values.decodeIfPresent(Bool.self, forKey: .is_test)
        cart_id = try values.decodeIfPresent(String.self, forKey: .cart_id)
        remark = try values.decodeIfPresent(String.self, forKey: .remark)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }
}
