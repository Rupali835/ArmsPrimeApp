//
//  TopFanTableViewCell.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 21/09/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit

class TopFanTableViewCell: UITableViewCell {
    @IBOutlet weak var topFanBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var logoiconImageView: UIImageView!
    @IBOutlet weak var numbercount: UILabel!
    @IBOutlet weak var superfanlogoImageView: UIImageView!
    @IBOutlet weak var superfanLabel: UILabel!
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topFanBackgroundView.layer.borderWidth = 1
        self.topFanBackgroundView.layer.cornerRadius = 10
        self.topFanBackgroundView.clipsToBounds = true
        
        self.profileImageView.layer.borderWidth = 2
        self.profileImageView.layer.borderColor = hexStringToUIColor(hex: MyColors.casual).cgColor
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.clipsToBounds = true
      
        self.logoiconImageView.layer.borderWidth = 1
        self.logoiconImageView.layer.borderColor = UIColor.clear.cgColor
        self.logoiconImageView.layer.cornerRadius = logoiconImageView.frame.size.width / 2
        self.logoiconImageView.layer.masksToBounds = false
        self.logoiconImageView.clipsToBounds = true
        self.logoiconImageView.backgroundColor = UIColor.clear
        self.logoiconImageView.image = UIImage(named: "profileph")
        
        
//        topFanBackgroundView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
        numbercount.textColor = BlackThemeColor.white
        namelbl.textColor = BlackThemeColor.white
        superfanLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
       
        
        numbercount.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        namelbl.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        superfanLabel.font = UIFont(name: AppFont.bold.rawValue, size: 8.0)
     
    }
}
