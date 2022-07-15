//
//  CustomerDetails.swift
//  ZareenKhanConsumer
//
//  Created by Razr on 10/11/17.
//  Copyright © 2017 Razr. All rights reserved.
//

import UIKit
import Foundation


class CustomerDetails
{
    static var customerData: Customer!
    
    static var custId: String!
    static var account_link: NSMutableDictionary!
    //account_link will have values like given below
    /* email = 1;
     facebook = 0;
     google = 0;
     twitter = 0; */
    static var badges: Any!
    static var coins: Int!
    static var email: String!
    static var firstName: String!
    static var lastName: String!
    static var mobile_verified: Bool = false
    static var email_verified: Bool = false
    static var token: String!
    static var picture: String!
    static var gender: String!
    static var mobile_code: String!
    static var dob: String!
    static var mobileNumber: String!
    static var selectedIndex:Bool = false
    static var baseViewToPushIs: String!
    static var arrBadges: NSMutableArray!
    static var commentChannelName: String?
    static var giftChannelName: String?
    static var purchase_stickers : Bool?
    static var profile_completed : Bool?
    static var identity: String?
    static var lastVisited:String?
    static var badgesArray:[Badges]?
    static var status: String?
    static var directline_room_id : String?
}

