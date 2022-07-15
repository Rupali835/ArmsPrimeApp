//
//  VideoGreetingCell.swift
//
//
//  Created by developer2 on 06/03/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class VideoGreetingCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.cornerRadius = 8.0
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 7.0
        containerView.layer.shadowOffset = .zero
        containerView.layer.shouldRasterize = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
