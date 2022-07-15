//
//  CommentTableViewCell.swift
//  Karan Kundra
//
//  Created by Razrtech3 on 03/04/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var hourseLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var profileStatusLabel: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var profileStatusBottom: NSLayoutConstraint!
    @IBOutlet weak var profileNametop: NSLayoutConstraint!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var verifyArtistTickImage: UIImageView!
    @IBOutlet weak var replyTextLabel: UILabel!
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
   
//        self.profilePicImage.layer.borderWidth = 1
//        self.profilePicImage.layer.borderColor = UIColor.black.cgColor
        self.profilePicImage.layer.cornerRadius = profilePicImage.frame.size.width / 2
        self.profilePicImage.layer.masksToBounds = false
        self.profilePicImage.clipsToBounds = true
//        self.profilePicImage.backgroundColor = UIColor.clear
        
        uiView.layer.cornerRadius = 10
//          uiView.layer.masksToBounds = true
//        uiView.backgroundColor = BlackThemeColor.lightBlack
        profileNameLabel.textColor = BlackThemeColor.white
        hourseLabel.textColor = BlackThemeColor.white
        profileStatusLabel.textColor = BlackThemeColor.white
        replyCount.textColor = BlackThemeColor.white
        replyTextLabel.textColor = BlackThemeColor.white
    
        profileNameLabel.font =  UIFont(name: AppFont.regular.rawValue, size: 14.0)
//        hourseLabel.font = UIFont(name: AppFont.light.rawValue, size: 7)
//        replyTextLabel.font = UIFont(name: AppFont.medium.rawValue, size: 11.0)
//        replyCount.font = UIFont(name: AppFont.light.rawValue, size: 7)
        profileStatusLabel.font = UIFont(name: AppFont.medium.rawValue, size: 13.0)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileStatusLabel.text = ""
//        self.profileStatusLabel.isHidden = true
       
    }


    
}

