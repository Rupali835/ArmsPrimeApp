//
//  RechargeWalletTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 06/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class RechargeWalletTableViewCell: UITableViewCell {

    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(greetingData: GreetingList?) {
        
    }

}
