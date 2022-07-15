//
//  APMStoryPreviewModel.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

class APMStoryPreviewModel: NSObject {
    
    //MARK:- iVars
    var story: APMStory?
    
    //MARK:- Init method
    init(_ story: APMStory) {
        self.story = story
    }
    
    //MARK:- Functions
    func numberOfItemsInSection(_ section: Int) -> Int {
        if let _ = story {
            return 1
        }
        return 0
    }
    func cellForItemAtIndexPath(_ indexPath: IndexPath) -> APMStory? {
        guard let _ = story else { return nil }
        return story
    }
}
