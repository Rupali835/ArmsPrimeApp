//
//  PHVideoCallBookingDurationCollectionCell.swift
//  Multiplex
//
//  Created by Parikshit on 27/10/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

class PHVideoCallBookingDurationCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDuration: UILabel!
    
    override func awakeFromNib() {
        
        lblDuration.corner = lblDuration.frame.size.height/2
        
        lblDuration.borderWidth = 0.8
        lblDuration.borderColor = utility.rgb(0, 0, 0, 0.25)
        
        lblDuration.textColor = utility.rgb(0, 0, 0, 0.5)
    }
    
    func setDetails(duration: Int64, isCoinSelected: Bool) {
        
        if duration > 0 {
            
            lblDuration.text = "\(duration) mins"
        }
        else {
            
            lblDuration.text = "-- mins"
        }
        
        if isCoinSelected {
            
            lblDuration.backgroundColor = appearences.newTheamColor
            lblDuration.textColor = .white
        }
        else {
            
            lblDuration.backgroundColor = .clear
            lblDuration.textColor = utility.rgb(0, 0, 0, 0.5)
        }
    }
}
