//
//  PollButtonTableViewCell.swift
//  HarbhajanSingh
//
//  Created by webwerks on 12/09/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import UIKit
import Shimmer

class PollButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var selectedOptionImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var percentView: UIView!
    @IBOutlet weak var backView: UIView!
    var poll: PollDetail! {
        didSet {
            self.updateUI()
        }
    }

    @IBOutlet weak var widthOfPercentView: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpUI() {
        optionLabel.textColor = hexStringToUIColor(hex: MyColors.pollLabelColor)
        percentLabel.textColor = hexStringToUIColor(hex: MyColors.pollLabelColor)
        
        optionLabel.font = UIFont(name: AppFont.medium.rawValue, size: 13.0)
        percentLabel.font = UIFont(name: AppFont.medium.rawValue, size: 13.0)
        percentView.backgroundColor = BlackThemeColor.yellow
        percentView.alpha = 0.5
    }
    
    func updateUI() {
        optionLabel.text = poll.label
       
        if let percent = poll.votes_in_percentage {
            percentLabel.text = "\(Int(percent)) %"
        }
        if poll.isSelected {
            selectedOptionImageView.alpha = 1
        } else {
            selectedOptionImageView.alpha = 0
        }
        
        let widthF = (poll.votes_in_percentage! / 100)
        
        let optionWidth = UIScreen.main.bounds.size.width - 56
        let width = Double(optionWidth) * widthF
        self.widthOfPercentView.constant = CGFloat(width)
    }
}
