

import Foundation
import ObjectMapper

struct Banners : Mappable {
	var order : Int?
	var type : String?
	var name : String?
	var value : String?
	var photo : PhotoAsset?
    var video : VideoAsset?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		order <- map["order"]
		type <- map["type"]
		name <- map["name"]
		value <- map["value"]
		photo <- map["photo"]
	}

}
