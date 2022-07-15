 import ObjectMapper
 import Foundation
 
 class LiveEventModel: Mappable {
    
    var id: String?
    var artist_id: String?
    var type: String?
    var coins: Int64?
    var schedule_at : String?
    var name: String?
    var status: String?
    var photo: PhotoModel?
    var casts : [EventCast]?
    var desc: String?
    var comment_box: Bool = false
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        id <- map["_id"]
        artist_id <- map["artist_id"]
        type <- map["type"]
        coins <- map["coins"]
        schedule_at <- map["schedule_at"]
        name <- map["name"]
        status <- map["status"]
        photo <- map["photo"]
        casts <- map["casts"]
        desc <- map["desc"]
        comment_box <- map["comment_box"]
    }
    
    static func object(_ object: [String:Any]) -> LiveEventModel? {
        
        return Mapper<LiveEventModel>().map(JSON: object)
    }
 }
 
 class EventCast: Mappable {
    
    var id : String?
    var first_name : String?
    var last_name : String?
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        id <- map["_id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
    }
 }
 
 class PhotoModel: Mappable {
    
    var small: String?
    var xsmall: String?
    var thumb: String?
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        small <- map["small"]
        xsmall <- map["xsmall"]
        thumb <- map["thumb"]
    }
    
 }
 class ChatMessageModel: Mappable {
    
    var message: String?
    var read: Bool?
    var message_by: String?
    var type: String?
    var reply: Bool?
    var name: String?
    var system: Bool?
    var picture: String?
    var date: String?
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        message <- map["message"]
        read <- map["read"]
        message_by <- map["message_by"]
        type <- map["type"]
        reply <- map["reply"]
        name <- map["name"]
        system <- map["system"]
        picture <- map["picture"]
        date <- map["date"]
    }
    
    static func object(_ arr: [[String: Any]]) -> [ChatMessageModel]? {
        
        return Mapper<ChatMessageModel>().mapArray(JSONArray: arr)
    }
    
    static func object(_ obj: [String: Any]) -> ChatMessageModel? {
        
        return Mapper<ChatMessageModel>().map(JSON: obj)
    }
 }
 
 class ChatRoomMessageModel: Mappable {
    
    var artist_id: String?
    var _id: Bool?
    var send_message: Bool?
    var customer_id: String?
    var platform: String?
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        artist_id <- map["artist_id"]
        _id <- map["_id"]
        send_message <- map["send_message"]
        customer_id <- map["customer_id"]
        platform <- map["platform"]
    }
    
    static func object(_ obj: [String: Any]) -> ChatRoomMessageModel? {
        
        return Mapper<ChatRoomMessageModel>().map(JSON: obj)
    }
 }
 
 public class PaginationStats : Mappable {
     
     var current_page: Int64?
     var last_page: Int64?
     var per_page: Int64?
     var total: Int64?
     var offsetFrom: Int64?
     var offsetTo: Int64?

     required public init?(map: Map) {
         
     }
     
     public func mapping(map: Map) {
         
         current_page <- map["current_page"]
         last_page <- map["last_page"]
         per_page <- map["per_page"]
         total <- map["total"]
         offsetFrom <- map["from"]
         offsetTo <- map["to"]
     }
     
     static func object(_ object: [String : Any]) -> PaginationStats? {
         
         return Mapper<PaginationStats>().map(JSON: object)
     }
 }

 // MARK: - DirectLine
 public class CommentSticker : Mappable {
     
     var _id: String?
     var name: String?
     var coins: Int64?
     var picture_found: Bool = false
     var photo: PhotoDetails?
     var type: String?
     var status: String?
     var available: Bool = false
     
     required public init?(map: Map) {
         
     }
     
     public func mapping(map: Map) {
         
         _id <- map["_id"]
         name <- map["name"]
         coins <- map["coins"]
         picture_found <- map["picture_found"]
         photo <- map["photo"]
         type <- map["type"]
         status <- map["status"]
         available <- map["available"]
     }
     
     static func object(_ object: [Any]) -> [CommentSticker]? {
         
         return Mapper<CommentSticker>().mapArray(JSONObject: object)
     }
 }

 public class PhotoDetails : Mappable {
     
     var cover : String?
     var cover_height : CGFloat?
     var cover_width : CGFloat?
     
     var large : String?
     var large_height : CGFloat?
     var large_width : CGFloat?
     
     var medium : String?
     var medium_height : CGFloat?
     var medium_width : CGFloat?
     
     var small : String?
     var small_height : CGFloat?
     var small_width : CGFloat?
     
     var thumb : String?
     var thumb_height : CGFloat?
     var thumb_width : CGFloat?
     
     var xlarge : String?
     var xlarge_height : CGFloat?
     var xlarge_width : CGFloat?
     
     var xsmall : String?
     var xsmall_height : CGFloat?
     var xsmall_width : CGFloat?
     
     required public init?(map: Map) {
         
     }
     
     public func mapping(map: Map) {
         
         cover <- map["cover"]
         cover_height <- map["cover_height"]
         cover_width <- map["cover_width"]
         
         large <- map["large"]
         large_height <- map["large_height"]
         large_width <- map["large_width"]
         
         medium <- map["medium"]
         medium_height <- map["medium_height"]
         medium_width <- map["medium_width"]
         
         small <- map["small"]
         small_height <- map["small_height"]
         small_width <- map["small_width"]
         
         thumb <- map["thumb"]
         thumb_height <- map["thumb_height"]
         thumb_width <- map["thumb_width"]
         
         xlarge <- map["xlarge"]
         xlarge_height <- map["xlarge_height"]
         xlarge_width <- map["xlarge_width"]
         
         xsmall <- map["xsmall"]
         xsmall_height <- map["xsmall_height"]
         xsmall_width <- map["xsmall_width"]
     }
 }

 // Agora
 public class AgoraCallRequest : Mappable {
    
    var id: String?
    var name: String?
    var photo: String?
    var request_type: String?
    var commercial_type: String?
    var live_id: String?
    var request_id: String?

    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        photo <- map["photo"]
        request_type <- map["request_type"]
        commercial_type <- map["commercial_type"]
        live_id <- map["live_id"]
        request_id <- map["request_id"]
    }
    
    static func object(_ object: Any?) -> AgoraCallRequest? {
        
        return Mapper<AgoraCallRequest>().map(JSONObject: object)
    }
 }


 // MARK: - Video Call
 public class VideoCallRequest : Mappable {
     
     var _id: String?
     var amount: String?
     var amount_discount: String?
     var amount_gst: String?
     var amount_original: String?
     var amount_total: String?
     var artist_id: String?
     var coins: Int64?
     var created_at: String?
     var customer_id: String?
     var date: String?
     var duration: Int?
     var language: String?
     var message: String?
     var passbook_id: String?
     var payment_mode: String?
     var reason: String?
     var scheduled_at: String?
     var scheduled_end_at: String?
     var status: String?
     var time: String?
     var type: String?
     var updated_at: String?
     var url: String?
     var usd_amount: String?
     var usd_amount_discount: String?
     var usd_amount_gst: String?
     var usd_amount_original: String?
     var usd_amount_total: String?
     var customer: User?
     var product: String?
     var rescheduled_by: String?
     
     required public init?(map: Map) {
         
         
     }
     
     public func mapping(map: Map) {
         
         _id <- map["_id"]
         amount <- map["amount"]
         amount_discount <- map["amount_discount"]
         amount_gst <- map["amount_gst"]
         amount_original <- map["amount_original"]
         amount_total <- map["amount_total"]
         artist_id <- map["artist_id"]
         coins <- map["coins"]
         created_at <- map["created_at"]
         customer_id <- map["customer_id"]
         date <- map["date"]
         duration <- map["duration"]
         language <- map["language"]
         message <- map["message"]
         passbook_id <- map["passbook_id"]
         payment_mode <- map["payment_mode"]
         reason <- map["reason"]
         scheduled_at <- map["scheduled_at"]
         scheduled_end_at <- map["scheduled_end_at"]
         status <- map["status"]
         time <- map["time"]
         type <- map["type"]
         updated_at <- map["updated_at"]
         url <- map["url"]
         usd_amount <- map["usd_amount"]
         usd_amount_discount <- map["usd_amount_discount"]
         usd_amount_gst <- map["usd_amount_gst"]
         usd_amount_original <- map["usd_amount_original"]
         usd_amount_total <- map["usd_amount_total"]
         customer <- map["customer"]
         product <- map["product"]
        rescheduled_by <- map["rescheduled_by"]
     }
     
     static func object(_ object: [[String:Any]]) -> [VideoCallRequest]? {
          
         return Mapper<VideoCallRequest>().mapArray(JSONObject: object)
     }
     
     static func object(_ object: [String:Any]) -> VideoCallRequest? {
          
         return Mapper<VideoCallRequest>().map(JSON: object)
     }
 }

 // Server Time
 public class ServerTime : Mappable {

     var ist:String?
     var istDate: Date?
     
     required public init?(map: Map) { }
     
     public func mapping(map: Map) {
         
         ist <- map["ist"]
         
         if let date = ist?.toDate(from: .yyyyMMddHHmmss) {
             
             istDate = date
         }
     }
     
     static func object(_ object: [String:Any]) -> ServerTime? {
          
         return Mapper<ServerTime>().map(JSON: object)
     }
 }
 
 
 
 

