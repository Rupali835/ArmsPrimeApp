//
//  PurchaseTableViewCell.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 13/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

protocol PurchaseTableViewCellDelegate  {
    func didPressButton(_ purchase: Purchase)
}

class PurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var packageCoinsLabel: UILabel!
    @IBOutlet weak var transtionsIDLabel: UILabel!
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var celbNameLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var reportButton: UIButton!
    var currentPurchase : Purchase!
    var cellDelegate : PurchaseTableViewCellDelegate?
    
    
    @IBOutlet weak var orderNoLabel: UILabel!
    
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        purchaseView.layer.cornerRadius = 5
        purchaseView.clipsToBounds = true
        
        self.reportButton.layer.cornerRadius = reportButton.layer.frame.height / 2
        self.reportButton.clipsToBounds = true
        self.reportButton.layer.borderWidth = 1
        self.reportButton.layer.borderColor = UIColor.black.cgColor
        
        purchaseView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
        packageCoinsLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        orderNoLabel.font = UIFont(name: AppFont.regular.rawValue, size: 15.0)
         dateLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        transtionsIDLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        packagePriceLabel.font = UIFont(name: AppFont.regular.rawValue, size: 17.0)
        currencyCodeLabel.font = UIFont(name: AppFont.regular.rawValue, size: 17.0)
        orderStatusLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        celbNameLabel.font = UIFont(name: AppFont.light.rawValue, size: 13.0)
        
        packageCoinsLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
         orderNoLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        dateLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        transtionsIDLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        packagePriceLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
         currencyCodeLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        orderStatusLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        celbNameLabel.textColor = hexStringToUIColor(hex: MyColors.cellNameLabelTextColor)
    }
    
    @IBAction func reportbuttonPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(self.currentPurchase)
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
