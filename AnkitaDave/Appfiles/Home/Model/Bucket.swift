

import Foundation
import ObjectMapper

struct Bucket : Mappable {
	var _id : String?
	var code : String?
	var name : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		_id <- map["_id"]
		code <- map["code"]
		name <- map["name"]
	}

}
