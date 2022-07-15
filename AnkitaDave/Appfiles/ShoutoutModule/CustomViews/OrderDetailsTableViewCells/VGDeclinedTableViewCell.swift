//
//  VGDeclinedTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class VGDeclinedTableViewCell: UITableViewCell {

    @IBOutlet weak var declineTitleLabel: UILabel!
    @IBOutlet weak var declineReasonLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var orderAgainButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timestampLabel.font = ShoutoutFont.regular.withSize(size: .smaller)
        declineTitleLabel.font = ShoutoutFont.medium.withSize(size: .largeTitle)
        declineReasonLabel.font = ShoutoutFont.regular.withSize(size: .small)
        orderAgainButton.titleLabel?.font = ShoutoutFont.medium.withSize(size: .medium)
        orderAgainButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(greetingData: GreetingList?) {
        if let history = greetingData?.history {
            for historyItem in history {
                if historyItem.status == OrderStatusKeys.denied {
                    timestampLabel.text = historyItem.executed_at?.toDateString(fromFormat: .yyyyMMddHHmmss, toFormat: .ddMMMYYYYhhmm)
                }
            }
        }
        declineTitleLabel.text = "REQUEST DECLINED"
        declineReasonLabel.text = greetingData?.reason
    }
    
    @IBAction func didTapOrderAgain(_ sender: UIButton) {
    }
}
