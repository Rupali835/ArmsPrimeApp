//
//  PHVideoCallBookingDateCollectionCell.swift
//  Multiplex
//
//  Created by Parikshit on 27/10/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

class PHVideoCallBookingDateCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        
      //  viewContainer.makeCirculer = true
        viewContainer.makeCirculaer = true
        viewContainer.borderWidth = 0.8
        viewContainer.borderColor = utility.rgb(0, 0, 0, 0.25)
        
        viewContainer.backgroundColor = .clear
        
        lblDate.textColor = utility.rgb(0, 0, 0, 1)
        
        lblDay.textColor = utility.rgb(0, 0, 0, 0.5)
    }
    
    func setDetails(currentDate: Date, offset: Int, selectedDate: Date) {
                
        if let date = currentDate.dateByAdding(day: offset) {
            
            let weekday = Calendar.current.component(.weekday, from: date)
            
            let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
            
            let weekdayName = days[weekday-1]
            
            lblDay.text = weekdayName.uppercased()
            
            let day = Calendar.current.component(.day, from: date)
            lblDate.text = "\(day)"
            
            if date.compare(selectedDate) == .orderedSame {
                
                viewContainer.backgroundColor = appearences.newTheamColor
                
                lblDate.textColor = .white
            }
            else {
                
                viewContainer.backgroundColor = .clear
                lblDate.textColor = utility.rgb(0, 0, 0, 0.5)
            }
        }
        else {
            
            lblDay.text = "-"
            lblDate.text = "-"
        }
    }
}
