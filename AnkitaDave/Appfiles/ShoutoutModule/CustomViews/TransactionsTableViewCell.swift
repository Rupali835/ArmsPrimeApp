//
//  TransactionsTableViewCell.swift
//  AnveshiJain
//
//  Created by Apple on 04/10/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var paidForLabel: UILabel!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var transationTypeLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var coinsBeforeTransactionLabel: UILabel!
    @IBOutlet weak var transactionIDLabel: CopyableLabel!
    @IBOutlet weak var coinsAfterTransactionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        [ contentTitleLabel, transationTypeLabel].forEach { (label) in
            label?.font = ShoutoutFont.regular.withSize(size: .small)
        }
        
        contentTitleLabel.adjustsFontSizeToFitWidth = true
        
        [timestampLabel, contentTitleLabel, coinsBeforeTransactionLabel, transactionIDLabel, coinsAfterTransactionLabel].forEach { (label) in
            label?.font = ShoutoutFont.light.withSize(size: .small)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: PassbookList, isExpanded: Bool) {
        coinsLabel.text = "\(data.total_coins ?? 0)"
        timestampLabel.text = data.updated_at ?? ""
        if let paidFor = data.meta_info?.description, paidFor != "" {
            paidForLabel.text = data.meta_info?.description
        } else {
            paidForLabel.text = "NA"
        }
        
        contentTitleLabel.text = "(\(data.entity?.localizedCapitalized ?? "NA"))"
        transationTypeLabel.text = data.txn_type?.localizedCapitalized
        coinsBeforeTransactionLabel.text = "Before Txn Coins Balance: " + "\(data.coins_before_txn ?? 0)"
        coinsAfterTransactionLabel.text = "After Txn Coins Balance: " + "\(data.coins_after_txn ?? 0)"
        transactionIDLabel.text = "Txn ID: " + (data._id ?? "")
        
        if let transactionType = PassbookFilterTypes.status(for: data.txn_type) {
            switch transactionType {
            case .added:
                transationTypeLabel.textColor = #colorLiteral(red: 0.1278283894, green: 0.5185144544, blue: 0.1342647076, alpha: 1)
                coinsLabel.textColor = #colorLiteral(red: 0.1278283894, green: 0.5185144544, blue: 0.1342647076, alpha: 1)
            case .received:
                transationTypeLabel.textColor = #colorLiteral(red: 0.1278283894, green: 0.5185144544, blue: 0.1342647076, alpha: 1)
                coinsLabel.textColor = #colorLiteral(red: 0.1278283894, green: 0.5185144544, blue: 0.1342647076, alpha: 1)
            case .paid:
                transationTypeLabel.textColor = #colorLiteral(red: 0.9109638929, green: 0.05280861259, blue: 0, alpha: 1)
                coinsLabel.textColor = #colorLiteral(red: 0.9109638929, green: 0.05280861259, blue: 0, alpha: 1)
            default: break
            }
        }
        setupArrow(type: data.txn_type, isExpanded: isExpanded)
    }
    
    func setupArrow(type: String?, isExpanded: Bool) {
        arrowImageView.tintColor = .white
        if type == PassbookFilterTypes.paid.rawValue {
            if isExpanded {
                arrowImageView.image = #imageLiteral(resourceName: "VG_arrow-up")
                //bottomStackView.isHidden = false
            } else {
                arrowImageView.image = #imageLiteral(resourceName: "VG_arrow-down")
                //bottomStackView.isHidden = true
            }
        } else {
            arrowImageView.image = #imageLiteral(resourceName: "dropdown")
            //bottomStackView.isHidden = true
        }
    }
}
