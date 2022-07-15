//
//  WardrobeBannerHeaderView.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 20/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit
import SDWebImage

class WardrobeBannerHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var drawerArrow: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    override func awakeFromNib() {
        drawerArrow.layer.cornerRadius = 4
        drawerArrow.clipsToBounds = true
//        imgBanner.setImageColor(color: BlackThemeColor.yellow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func configure(urlStr: String, isVideo: Bool = false) {

//        if let url = URL(string: urlStr), urlStr != "" {
//            imgBanner.sd_setImage(with: url, completed: nil)
//        }
//
//        btnPlay.isHidden = !isVideo
    }
}
