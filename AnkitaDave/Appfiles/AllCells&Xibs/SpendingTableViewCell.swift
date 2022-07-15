//
//  SpendingTableViewCell.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 12/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

class SpendingTableViewCell: UITableViewCell {
    // beforeCoinsBalance  afterCoinsBalance  closingBalance celbNameLabel
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var celbNameLabel: UILabel!
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var beforeCoinsBalance: UILabel!
    @IBOutlet weak var afterCoinsBalance: UILabel!
    //@IBOutlet weak var closingBalance: UILabel!
    @IBOutlet weak var coinCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentNameLabel: UILabel!
//    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var spendingView: UIView!
    
    @IBOutlet weak var beforeTitleLabel: UILabel!
    
    @IBOutlet weak var afterTitleLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
       
        spendingView.layer.cornerRadius = 5
        spendingView.clipsToBounds = true
        
        spendingView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
        beforeTitleLabel.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        beforeCoinsBalance.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        afterTitleLabel.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        afterCoinsBalance.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
        dateLabel.font = UIFont(name: AppFont.light.rawValue, size: 11.0)
        transactionIdLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        nameLabel.font = UIFont(name: AppFont.regular.rawValue, size: 17.0)
        coinCountLabel.font = UIFont(name: AppFont.regular.rawValue, size: 17.0)
        statusLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        celbNameLabel.font = UIFont(name: AppFont.light.rawValue, size: 13.0)
        
        beforeTitleLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        afterTitleLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        beforeCoinsBalance.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        afterCoinsBalance.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        dateLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        transactionIdLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        nameLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        coinCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        celbNameLabel.textColor = hexStringToUIColor(hex: MyColors.cellNameLabelTextColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentNameLabel.text = ""
        self.videoImage.isHidden = true
    }
    
}
