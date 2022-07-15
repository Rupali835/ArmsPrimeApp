//
//  VGApprovedTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class VGApprovedTableViewCell: UITableViewCell {

    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var approvedDescriptionLabel: UILabel!
    @IBOutlet weak var approvedTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timestampLabel.font = ShoutoutFont.regular.withSize(size: .smaller)
        approvedTitleLabel.font = ShoutoutFont.medium.withSize(size: .largeTitle)
        approvedDescriptionLabel.font = ShoutoutFont.regular.withSize(size: .small)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(greetingData: GreetingList?) {
        timestampLabel.text = greetingData?.created_at?.toDateString(fromFormat: .yyyyMMddHHmmss, toFormat: .ddMMMYYYYhhmm)
    }
    
}
