//
//  BannerCollectionViewCell.swift
//  Multiplex
//
//  Created by Sameer Virani on 19/05/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurCell(_ media: Photo) {
        
        if let img = media.thumb,
            let url = URL(string: img) {
            
//            imgView.contentMode = .center
            
            imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "splashLogoSmall"), options: .highPriority) { [weak self] (img, err, type, url) in

            }
        } else {
            imgView.image = UIImage(named: "splashLogoSmall")
        }
        
//        imgView.backgroundColor = appearences.placeholderBackColor
    }
}
