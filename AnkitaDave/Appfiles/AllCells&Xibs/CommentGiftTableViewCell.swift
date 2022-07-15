//
//  CommentGiftTableViewCell.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 03/10/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit

class CommentGiftTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var sendGiftImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var hourseLabel: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var replylabel: UILabel!
    @IBOutlet weak var verifyArtistTickImage: UIImageView!
    @IBOutlet weak var imageLeftConstraint: NSLayoutConstraint!
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profilePicImage.layer.cornerRadius = profilePicImage.frame.size.width / 2
        self.profilePicImage.layer.masksToBounds = false
        self.profilePicImage.clipsToBounds = true
        
        profileNameLabel.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        profileNameLabel.textColor = BlackThemeColor.white
        hourseLabel.font = UIFont(name: AppFont.regular.rawValue, size: 11.0)
        replylabel.font = UIFont(name: AppFont.regular.rawValue, size: 11.0)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
    }
  
    
}
