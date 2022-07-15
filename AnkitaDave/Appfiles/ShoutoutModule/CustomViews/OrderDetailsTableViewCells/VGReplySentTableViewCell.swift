//
//  RVGReplySentTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 06/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class VGReplySentTableViewCell: UITableViewCell {

    @IBOutlet weak var replySentTitle: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var thumbnailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        replySentTitle.font = ShoutoutFont.medium.withSize(size: .largeTitle)
        replyLabel.font = ShoutoutFont.regular.withSize(size: .small)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(greetingData: GreetingList?) {
        
    }
    
}
