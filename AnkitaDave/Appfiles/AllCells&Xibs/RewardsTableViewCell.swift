//
//  RewardsTableViewCell.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 13/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

class RewardsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createdatLabel: UILabel!
    @IBOutlet weak var rewardImageView: UIImageView!
    @IBOutlet weak var rewardView: UIView!
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rewardView.layer.cornerRadius = 5
        rewardView.clipsToBounds = true
         rewardView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
        descriptionLabel.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        createdatLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
       
        
        createdatLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        descriptionLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
