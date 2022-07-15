//
//  MediaCollectionViewCell.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 26/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgMedia: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurCell(media: Media) {
        
        if let type = media.type {
            if type == "photo" {
                if let img = media.url,
                    let url = URL(string: img) {
                    imgMedia.sd_setImage(with: url, completed: nil)
                }
            } else {
                if let img = media.cover,
                    let url = URL(string: img) {
                    imgMedia.sd_setImage(with: url, completed: nil)
                }
            }
            
            btnPlay.isHidden = type == "photo"
        }
    }

}
