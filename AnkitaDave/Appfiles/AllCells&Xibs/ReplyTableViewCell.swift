//
//  ReplyTableViewCell.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 15/05/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileStatusLabel: UILabel!
    @IBOutlet weak var hourseLabel: UILabel!
    @IBOutlet weak var verifyArtistTickImage: UIImageView!
    @IBOutlet weak var uiView: UIView!
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        uiView.layer.cornerRadius = 10
       
        self.profilePicImage.layer.cornerRadius = profilePicImage.frame.size.width / 2
        self.profilePicImage.layer.masksToBounds = false
        self.profilePicImage.clipsToBounds = true
        self.profilePicImage.backgroundColor = UIColor.clear
        
//        uiView.backgroundColor = BlackThemeColor.lightBlack
//        profileNameLabel.textColor = BlackThemeColor.white
//        hourseLabel.textColor = BlackThemeColor.white
//        profileStatusLabel.textColor = BlackThemeColor.white
//
        profileNameLabel.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
//        hourseLabel.font = UIFont(name: AppFont.medium.rawValue, size: 7.0)
//        profileStatusLabel.font = UIFont(name: AppFont.medium.rawValue, size: 7)
    }

   
    
}
