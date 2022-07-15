//
//  APMCommon.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation
import UIKit

/******** UITableViewCell&UICollectionViewCell<Extension> ********/
protocol CellConfigurer: class {
    static var nib: UINib {get}
    static var reuseIdentifier: String {get}
}

extension CellConfigurer {
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: CellConfigurer {}
extension UITableViewCell: CellConfigurer {}

/*************************** UINIB<Extension> ************************************************/
extension UINib {
    class func nib(with name: String) -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
}
