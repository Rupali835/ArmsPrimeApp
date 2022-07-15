//
//  WardrobeCollectionViewCell.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 20/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit

class WardrobeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var imgOutOfStock: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = BlackThemeColor.yellow.cgColor
        lblCoin.font =  UIFont(name: AppFont.light.rawValue, size: 13.0)
        lblProductName.font = UIFont(name: AppFont.light.rawValue, size: 13.0)
    }

    
    func configurCell(product: ProductList) {
        
        if let media = product.media, media.count > 0 {
            if let img = media[0].url,
                let url = URL(string: img) {
                imgProduct.sd_setImage(with: url, completed: nil)
            }
        }
       
        if let name = product.name {
            lblProductName.text = name
        }
        
        if let coins = product.coins {
            lblCoin.text = "\(coins)"
        }
        
        if let outofstock = product.outofstock {
            imgOutOfStock.isHidden = outofstock == "yes" ? false : true
        }
    }
}
