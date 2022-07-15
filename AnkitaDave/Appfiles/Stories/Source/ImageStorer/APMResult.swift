//
//  APMResult.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation

public enum APMResult<V, E> {
    case success(V)
    case failure(E)
}
