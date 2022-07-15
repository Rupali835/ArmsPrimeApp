//
//  SlideBarTableViewCell.swift
//  KaranKundraConsumer
//
//  Created by Razrtech3 on 28/02/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit

class SlideBarTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconNameLabel: UILabel!
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconNameLabel.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
