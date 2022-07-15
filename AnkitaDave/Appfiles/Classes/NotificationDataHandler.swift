//
//  NotificationDataHandler.swift
//  Karan Kundra
//
//  Created by RazrTech2 on 06/04/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import Foundation
import SwiftyJSON


enum PushNotificationPayload {

    case socialLife(title: String?, body: String?, action: String?, contentId: String?)
    case photosView(title: String?, body: String?, action: String?, contentId: String?)
    case videosView(title: String?, body: String?, action: String?, contentId: String?)
    case travelView(title: String?, body: String?, action: String?, contentId: String?)
    case favouriteView(title: String?, body: String?, action: String?, contentId: String?)
    case askKaran(title: String?, body: String?, action: String?, contentId: String?)
    case liveStarted(action: String?, userId: String?)
    
    
    case NewFeed // NEW_FEED
    case FeedMarkedFavUnfav // FEED_MARKED_FAVUNFAV
    case ConversationsChanged(action: String?, contentId: String?) // CONVERSATIONS_CHANGED
    
    case GroupAvatarChanged(action: String?, contentId: String?) // GROUP_AVATAR_CHANGED
    
    case UserProfileChanged(action: String?, userId: String?) // USER_PROFILE_CHANGED
    
    case UserAvatarChanged(action: String?, userId: String?) // USER_AVATAR_CHANGED
    
    
    case UserStatusChanged(action: String?, userId: String?, status: String?) // USER_STATUS_CHANGED
    
    case NewFeedMediaThumbnail(action: String?, contentId: String?, mediaId: String?) // NEW_FEED_MEDIA_THUMBNAIL
    
}

class NotificationDataHandler {
    
    static let sharedInstance = NotificationDataHandler()
    var isDataNotification = false
    
    //MARK:-
    func processBusinessNotificationPayload(payload: [AnyHashable: Any]) {
        if let pushNotificationPayload = parseBusinessNotificationPayload(payload: payload) {
            switch pushNotificationPayload {
            default:
                print(payload)
            }
        }
    }
    
    
    func processDataNotificationPayload(payload: [AnyHashable: Any]) {
        if let pushNotificationPayload = parseDataNotificationPayload(payload: payload) {
            switch pushNotificationPayload {
            default:
                print(payload)
            }
        }
    }
    

    
    func parseBusinessNotificationPayload(payload: [AnyHashable: Any]) -> PushNotificationPayload? {
        
        let json =  JSON(payload)
        let type = json["deeplink"].string

        print("JSON Dict \(json.dictionaryValue)")
        let action = json["action"].string
        
        let title = json["aps"]["alert"]["title"].string
        
        let body = json["aps"]["alert"]["body"].string
        
        if type == "social-life" {
            
            if let feedId = json["feedId"].string, let commentId = json["commentId"].string {
                return PushNotificationPayload.socialLife(title: title, body: body, action: action, contentId: feedId)
                
            }
            
        }
        
        if type == "photos" {
            
            
            
            //            let icon = json["icon"].string
            if let conversationId = json["conversationId"].string,
                let messageId = json["messageId"].string {
                return PushNotificationPayload.photosView(title: title, body: body, action: action, contentId: conversationId)
                
            }
            
            
        }
        
        if type == "videos" {
            
            if let conversationId = json["conversationId"].string {
                return PushNotificationPayload.videosView(title: title, body: body, action: action, contentId: conversationId)
            }
        }
        
        if type == "travel" {
            
            if let conversationId = json["conversationId"].string {
                
                return PushNotificationPayload.travelView(title: title, body: body, action: action, contentId: conversationId)
            }
            
            
        }
        
        if type == "favourite" {
            
            if let conversationId = json["conversationId"].string {
                
                
                return PushNotificationPayload.favouriteView(title: title, body: body, action: action, contentId: conversationId)
            }
        }
        
        if type == "ask" {
            
            if let conversationId = json["conversationId"].string {
                
                return PushNotificationPayload.askKaran(title: title, body: body, action: action, contentId: conversationId)
            }
            
        }
        
        
        if type == "round-video" {
            
            if let conversationId = json["conversationId"].string {
                return PushNotificationPayload.GroupAvatarChanged(action: action, contentId: conversationId)
            }
            
        }
        
        if type == "top-10" {
            
            if let conversationId = json["conversationId"].string {
                return PushNotificationPayload.GroupAvatarChanged(action: action, contentId: conversationId)
            }
            
        }
        
        if type == "hmf" {
            
            if let conversationId = json["conversationId"].string {
                return PushNotificationPayload.GroupAvatarChanged(action: action, contentId: conversationId)
            }
            
        }
        
        if type == "monster" {
            
            if let conversationId = json["conversationId"].string {
                return PushNotificationPayload.GroupAvatarChanged(action: action, contentId: conversationId)
            }
            
        }

        if type == "live" {
            
            if let conversationId = json["conversationId"].string {
                return PushNotificationPayload.GroupAvatarChanged(action: action, contentId: conversationId)
            }
            
        }
        
        return nil
        
    }
    
    func parseDataNotificationPayload(payload: [AnyHashable: Any]) -> PushNotificationPayload? {
        
        let json =  JSON(payload)
        
        
        
        let type = json["deeplink"].string
        
        print("JSON Dict \(json.dictionaryValue)")
        
        let action = json["action"].string
        
        let title = json["aps"]["alert"]["title"].string
        
        let body = json["aps"]["alert"]["body"].string
        
        if type == "social-life" {
            
            if let feedId = json["feedId"].string, let commentId = json["commentId"].string {
                
                return PushNotificationPayload.socialLife(title: title, body: body, action: action, contentId: feedId)
                
            }
            
        }
        
        if type == "photos" {
            
            
            
            //            let icon = json["icon"].string
            if let conversationId = json["conversationId"].string,
                let messageId = json["messageId"].string {
                return PushNotificationPayload.photosView(title: title, body: body, action: action, contentId: conversationId)
                
            }
            
            
        }
        
        if type == "videos" {
//            updateFeedBadgeCount()
            return PushNotificationPayload.NewFeed
        }
        
        if type == "travel" {
            return PushNotificationPayload.FeedMarkedFavUnfav
            
        }
        
        if type == "favourite" {
            return PushNotificationPayload.ConversationsChanged(action: action, contentId: nil)
        }
        
        if type == "ask" {
            
            if let conversationId = json["conversationId"].string {
                
                
                return PushNotificationPayload.GroupAvatarChanged(action: action, contentId: conversationId)
            }
        }
        
        if type == "round-video" {
            
            if let userId = json["userId"].string {
                
                return PushNotificationPayload.UserProfileChanged(action: action, userId: userId)
            }
            
        }
        
        if type == "top-10" {
            
            if let userId = json["userId"].string {
                
                return PushNotificationPayload.UserAvatarChanged(action: action, userId: userId)
            }
            
        }
        
        if type == "hmf" {
            
            if let userId = json["userId"].string, let status = json["status"].string {
                return PushNotificationPayload.UserStatusChanged(action: action, userId: userId, status: status)
                
            }
            
        }
        
        if type == "monster" {
            if let feedId = json["feedId"].string, let mediaId = json["mediaId"].string {
                return PushNotificationPayload.NewFeedMediaThumbnail(action: action, contentId: feedId, mediaId: mediaId)
                
            }
        }
        
        if type == "live" {
            
            
            
            if let feedId = json["feedId"].string, let mediaId = json["mediaId"].string {
                return PushNotificationPayload.NewFeedMediaThumbnail(action: action, contentId: feedId, mediaId: mediaId)
                
            }
        }
        
        return nil
        
    }
    
    
}
