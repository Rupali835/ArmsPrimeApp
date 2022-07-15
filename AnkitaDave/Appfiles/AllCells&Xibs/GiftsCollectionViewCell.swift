//
//  GiftsCollectionViewCell.swift
//  Karan Kundrra Official
//
//  Created by Razr Corp on 17/05/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit

class GiftsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var giftContainer: UIView!
    @IBOutlet weak var imagewidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var armsCoinImage: UIImageView!
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var giftsImageView: UIImageView!
    
    @IBOutlet weak var armsCoinImageWidth: NSLayoutConstraint!

    override func awakeFromNib() {
        self.layer.borderWidth = 1
    }
}
