//
//  VGRequestDetailsTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class VGRequestDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var occasionImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var occasionLabel: UILabel!
    @IBOutlet weak var orderInstructionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        [orderInstructionLabel, orderIDLabel, dateLabel, toLabel, relationLabel, greetingLabel, fromLabel, occasionLabel].forEach { (label) in
            label?.font = ShoutoutFont.light.withSize(size: .small)
            label?.textColor = .white//UIColor.black
        }
        calendarImage.tintColor = .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(greetingData: GreetingList?) {
        orderInstructionLabel.isHidden = !(greetingData?.didSubmitRequest ?? false)
        orderIDLabel.text = "Order ID - " + (greetingData?.passbook_id ?? "")
        occasionLabel.text = "Occasion - " + (greetingData?.occassion?.name ?? "")
        toLabel.text = "To - " + (greetingData?.to_name ?? "")
        fromLabel.text = "From - " + (greetingData?.from_name ?? "")
        relationLabel.text = "Relation - " + (greetingData?.relationship ?? "")
        greetingLabel.text = #"Message - "\#(greetingData?.message ?? "")""#
        dateLabel.text = greetingData?.schedule_at?.toDateString(fromFormat: .yyyyMMddHHmmss, toFormat: .ddMMMMyyyy)
        
        if let iconURL = greetingData?.occassion?.photo?.thumb {
            occasionImage.sd_setImage(with: URL(string: iconURL), completed: nil)
            occasionImage.backgroundColor = nil
        } else {
            occasionImage.backgroundColor = .lightGray
        }
    }
}
