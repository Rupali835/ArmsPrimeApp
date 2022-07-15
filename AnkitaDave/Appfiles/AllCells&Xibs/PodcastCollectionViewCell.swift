//
//  PodcastCollectionViewCell.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 07/09/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit

protocol PodcastCollectionViewCellDelegate {
     func didTapOpenPurchase(_ sender : UIButton)
}

class PodcastCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var podcastBackgroundView: UIView!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var albumCoverImage: UIImageView!
    @IBOutlet weak var totalEpisode: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var unlockPriceLabel: UILabel!
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var unlockImageView: UIImageView!
    @IBOutlet weak var unlockdView: UIView!
    
     var delegate: PodcastCollectionViewCellDelegate?
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.podcastBackgroundView.layer.borderWidth = 1
        self.podcastBackgroundView.layer.borderColor = hexStringToUIColor(hex: MyColors.casual).cgColor
        self.podcastBackgroundView.clipsToBounds = true
      
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumCoverImage.image = nil
        self.albumName.text = ""
        self.totalEpisode.text = ""
       
    }
    
    @IBAction func didTapOpenHideContetnt(_ sender: UIButton) {
        
        delegate?.didTapOpenPurchase(self.unlockButton)
        
        
    }
}
