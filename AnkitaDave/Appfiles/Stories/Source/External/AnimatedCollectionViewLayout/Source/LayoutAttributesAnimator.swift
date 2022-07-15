//
//  LayoutAttributesAnimator.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit

public protocol LayoutAttributesAnimator {
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes)
}
