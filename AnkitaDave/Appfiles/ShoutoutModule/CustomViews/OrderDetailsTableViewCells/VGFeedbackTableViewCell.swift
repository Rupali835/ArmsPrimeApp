//
//  VGFeedbackTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class VGFeedbackTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thanksLabel.font = ShoutoutFont.regular.withSize(size: .medium)
        replyLabel.font = ShoutoutFont.regular.withSize(size: .small)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
