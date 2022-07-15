//
//  VideoGreetingCollectionViewCell.swift
//  AnveshiJain
//
//  Created by Bhavesh Chaudhari on 05/07/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class VideoGreetingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = BlackThemeColor.yellow.cgColor
        
        // Initialization code
    }

    func configurVideo(_ media: Video) {

           guard let imageName = media.cover, let imageUrl = URL(string: imageName)  else {
               return
           }

           loadImages(with: imageUrl)
       }

    private func loadImages(with url: URL) {
        coverImage.sd_setImage(with: url, placeholderImage: UIImage(named: "wardrobe_placeholder"), options: .highPriority) {  (img, err, type, url) in

        }
    }

}
