//
//  ProductsResponseModel.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 23/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

struct ProductsResponseModel : Codable {
    let data : ProductData?
    let error_messages : [String]?
    let error : Bool?
    let status_code : Int?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ProductData.self, forKey: .data)
        error_messages = try values.decodeIfPresent([String].self, forKey: .error_messages)
        error = try values.decodeIfPresent(Bool.self, forKey: .error)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
}

struct ProductData : Codable {
    let lists : [ProductList]?
    let cache : Cache?
    let paginate_data : Paginate?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lists = try values.decodeIfPresent([ProductList].self, forKey: .lists)
        cache = try values.decodeIfPresent(Cache.self, forKey: .cache)
        paginate_data = try values.decodeIfPresent(Paginate.self, forKey: .paginate_data)
    }
}

struct ProductList : Codable {
    let _id : String?
    let artist_id : String?
    let type : String?
    let name : String?
    let slug : String?
    let description : String?
    let media : [Media]?
    var outofstock : String?
    let coins : Int?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        artist_id = try values.decodeIfPresent(String.self, forKey: .artist_id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        media = try values.decodeIfPresent([Media].self, forKey: .media)
        outofstock = try values.decodeIfPresent(String.self, forKey: .outofstock)
        coins = try values.decodeIfPresent(Int.self, forKey: .coins)
    }
}

struct Media : Codable {
    let type : String?
    let cover : String?
    let url : String?
    let order : String?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        cover = try values.decodeIfPresent(String.self, forKey: .cover)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        order = try values.decodeIfPresent(String.self, forKey: .order)
    }
}
