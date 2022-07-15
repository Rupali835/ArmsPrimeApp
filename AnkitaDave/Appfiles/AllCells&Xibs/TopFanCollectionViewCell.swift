//
//  TopFanCollectionViewCell.swift
//  KaranKundraConsumer
//
//  Created by Razrtech3 on 27/01/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit

class TopFanCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var logoiconImageView: UIImageView!
    @IBOutlet weak var numbercount: UILabel!
    @IBOutlet weak var superfanlogoImageView: UIImageView!
    @IBOutlet weak var superfanLabel: UILabel!
    
    @IBOutlet weak var viewWidthLayout: NSLayoutConstraint!
//MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        //let height = UIScreen.main.bounds.size.height
        viewWidthLayout.constant = screenWidth ///- (2 * 12)
        
        
        
        self.profileImageView.layer.borderWidth = 2
        self.profileImageView.layer.borderColor = UIColor.red.cgColor
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.clipsToBounds = true
//        self.profileImageView.backgroundColor = UIColor.clear
        
        
        
        self.logoiconImageView.layer.borderWidth = 1
        self.logoiconImageView.layer.borderColor = UIColor.clear.cgColor
        self.logoiconImageView.layer.cornerRadius = logoiconImageView.frame.size.width / 2
        self.logoiconImageView.layer.masksToBounds = false
        self.logoiconImageView.clipsToBounds = true
        self.logoiconImageView.backgroundColor = UIColor.clear
        self.logoiconImageView.image = UIImage(named: "usrPicDummy.png")
        
        
        
        
    }

}
