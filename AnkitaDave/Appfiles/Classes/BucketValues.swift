//
//  BucketValues.swift
//  ZareenKhanConsumer
//
//  Created by Razr on 06/11/17.
//  Copyright © 2017 Razr. All rights reserved.
//

import Foundation

class BucketValues : NSObject
{
    static var bucketTitleArr = [String]()
    static var CodeArr = [String]()
    static var bucketIdArray = [String]()
    static var bucketContentArr = NSMutableArray()
    static var titleImageArray = [String]()
    //MARK:-
    override init() {
        super.init()
    }
    
    init(bucketTittleArr: [String: Any]) {
    }
    
//     init(bucketTittleArr: NSMutableArray) {
//        self.bucketTitleArr = bucketTitleArr
//    }
}
