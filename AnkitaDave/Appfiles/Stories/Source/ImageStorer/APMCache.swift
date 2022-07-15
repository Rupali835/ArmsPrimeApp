//
//  ImageCache.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

fileprivate let ONE_HUNDRED_MEGABYTES = 1024 * 1024 * 100

class APMCache: NSCache<AnyObject, AnyObject> {
    static let shared = APMCache()
    private override init() {
        super.init()
        self.setMaximumLimit()
    }
}

extension APMCache {
    func setMaximumLimit(size: Int = ONE_HUNDRED_MEGABYTES) {
        totalCostLimit = size
    }
}
