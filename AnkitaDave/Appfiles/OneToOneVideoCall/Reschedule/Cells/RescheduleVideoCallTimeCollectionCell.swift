//
//  RescheduleVideoCallTimeCollectionCell.swift
//  Producer
//
//  Created by Parikshit on 14/12/20.
//  Copyright © 2020 developer2. All rights reserved.
//

import UIKit

class RescheduleVideoCallTimeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        
        lblTime.corner = lblTime.frame.size.height/2
        
        lblTime.borderWidth = 0.8
        lblTime.borderColor = utility.rgb(0, 0, 0, 0.25)
        
        lblTime.textColor = utility.rgb(0, 0, 0, 0.5)
    }
    
    func setDetails(slot: String, selected: String?) {
        
        lblTime.text = slot
        
        if slot == selected {
            
            lblTime.backgroundColor = appearences.newTheamColor
            lblTime.textColor = .white
        }
        else {
            
            lblTime.backgroundColor = .clear
            lblTime.textColor = utility.rgb(0, 0, 0, 0.5)
        }
    }
}
