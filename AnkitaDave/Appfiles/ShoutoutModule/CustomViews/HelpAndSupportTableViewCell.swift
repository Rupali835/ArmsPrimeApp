//
//  HelpAndSupportTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 06/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class HelpAndSupportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
