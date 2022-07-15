//
//  APMStory.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

public class APMStory : Codable {
    public let internalIdentifier : String = "APMStory"
    public let snaps : [APMSnap]?
    
    var lastPlayedSnapIndex = 0
    var isCompletelyVisible = false
    var isCancelledAbruptly = false
    
    enum CodingKeys : String, CodingKey {
        case snaps = "list"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        snaps = try values.decodeIfPresent([APMSnap].self, forKey: .snaps)
    }
    
    func copy() throws -> APMStory {
        let data = try JSONEncoder().encode(self)
        let copy = try JSONDecoder().decode(APMStory.self, from: data)
        return copy
    }
}

extension APMStory : Equatable {
    public static func == (lhs: APMStory, rhs: APMStory) -> Bool {
        return lhs.internalIdentifier == rhs.internalIdentifier
    }
}
