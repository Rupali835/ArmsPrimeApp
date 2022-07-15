//
//  VGPendingTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class VGPendingTableViewCell: UITableViewCell {

    @IBOutlet weak var pendingTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var pendingTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timestampLabel.font = ShoutoutFont.regular.withSize(size: .smaller)
        pendingTitleLabel.font = ShoutoutFont.medium.withSize(size: .largeTitle)
        pendingTextLabel.font = ShoutoutFont.regular.withSize(size: .small)
        
        pendingTextLabel.text = "Your request has been submitted and sent for moderation! You will receive the confirmation of your video on the registered email in next 7-8 working days. Please stay tuned!"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(greetingData: GreetingList?) {
        if let history = greetingData?.history {
            for historyItem in history {
                if historyItem.status == OrderStatusKeys.pending || historyItem.status == OrderStatusKeys.processing || historyItem.status == OrderStatusKeys.submitted {
                    timestampLabel.text = historyItem.executed_at?.toDateString(fromFormat: .yyyyMMddHHmmss, toFormat: .ddMMMYYYYhhmm)
                }
            }
        }
    }
    
}
