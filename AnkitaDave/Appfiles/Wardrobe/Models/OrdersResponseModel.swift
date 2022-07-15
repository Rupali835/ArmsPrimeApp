//
//  OrdersResponseModel.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 23/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

struct OrdersResponseModel : Codable {
    let data : OrderData?
    let error_messages : [String]?
    let error : Bool?
    let status_code : Int?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(OrderData.self, forKey: .data)
        error_messages = try values.decodeIfPresent([String].self, forKey: .error_messages)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
}

struct OrderData : Codable {
    let lists : [OrderList]?
    let cache : Cache?
    let paginate_data : Paginate?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lists = try values.decodeIfPresent([OrderList].self, forKey: .lists)
        cache = try values.decodeIfPresent(Cache.self, forKey: .cache)
        paginate_data = try values.decodeIfPresent(Paginate.self, forKey: .paginate_data)
    }
}

struct OrderList : Codable {
    let _id : String?
    let entity_id : String?
    let coins : Int?
    let coins_before_txn : Int?
    let coins_after_txn : Int?
    let delivery_info : DeliveryInfo?
    let created_at : String?
    let product : ProductList?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        entity_id = try values.decodeIfPresent(String.self, forKey: .entity_id)
        coins = try values.decodeIfPresent(Int.self, forKey: .coins)
        coins_before_txn = try values.decodeIfPresent(Int.self, forKey: .coins_before_txn)
        coins_after_txn = try values.decodeIfPresent(Int.self, forKey: .coins_after_txn)
        delivery_info = try values.decodeIfPresent(DeliveryInfo.self, forKey: .delivery_info)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        product = try values.decodeIfPresent(ProductList.self, forKey: .product)
    }
}

struct DeliveryInfo : Codable {
    let delivery_name : String?
    let delivery_address : String?
    let delivery_pincode : String?
    let delivery_mobile : String?
    let delivery_email : String?
    let delivery_place : String?
    let delivery_status : String?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        delivery_name = try values.decodeIfPresent(String.self, forKey: .delivery_name)
        delivery_address = try values.decodeIfPresent(String.self, forKey: .delivery_address)
        delivery_pincode = try values.decodeIfPresent(String.self, forKey: .delivery_pincode)
        delivery_mobile = try values.decodeIfPresent(String.self, forKey: .delivery_mobile)
        delivery_email = try values.decodeIfPresent(String.self, forKey: .delivery_email)
        delivery_place = try values.decodeIfPresent(String.self, forKey: .delivery_place)
        delivery_status = try values.decodeIfPresent(String.self, forKey: .delivery_status)
    }
}
