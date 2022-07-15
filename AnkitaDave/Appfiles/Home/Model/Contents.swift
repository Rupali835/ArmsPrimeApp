

import Foundation
import ObjectMapper

struct Contents : Mappable {
	var _id : String?
	var type : String?
	var name : String?
	var slug : String?
	var caption : String?
	var coins : Int?
	var video : VideoAsset?
    var photo : PhotoAsset?
	var stats : Stats?
	var order : Int?
	var content_id : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		_id <- map["_id"]
		type <- map["type"]
		name <- map["name"]
		slug <- map["slug"]
		caption <- map["caption"]
		coins <- map["coins"]
		video <- map["video"]
        photo <- map["photo"]
		stats <- map["stats"]
		order <- map["order"]
		content_id <- map["content_id"]
	}

}
