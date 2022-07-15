
import Foundation
import ObjectMapper

struct HomePageDetails : Mappable {
	var _id : String?
	var page_name : String?
	var artist_id : String?
	var type : String?
	var name : String?
	var bucket_id : String?
	var ordering : Int?
	var platforms : [String]?
	var description : String?
	var status : String?
	var slug : String?
	var updated_at : String?
	var created_at : String?
	var banners : [Banners]?
    var content : [List]?
	var bucket : Bucket?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		_id <- map["_id"]
		page_name <- map["page_name"]
		artist_id <- map["artist_id"]
		type <- map["type"]
		name <- map["name"]
		bucket_id <- map["bucket_id"]
		ordering <- map["ordering"]
		platforms <- map["platforms"]
		description <- map["description"]
		status <- map["status"]
		slug <- map["slug"]
		updated_at <- map["updated_at"]
		created_at <- map["created_at"]
		banners <- map["banners"]
		bucket <- map["bucket"]
        content <- map["contents"]

	}

    static func object(_ object: [Any]) -> [HomePageDetails]? {

           return Mapper<HomePageDetails>().mapArray(JSONObject: object)
       }

       static func object(_ object: Any?) -> HomePageDetails? {

           return Mapper<HomePageDetails>().map(JSONObject: object)
       }

}
