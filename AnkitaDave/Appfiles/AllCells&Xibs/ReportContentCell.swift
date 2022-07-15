//
//  ReportContentCell.swift
//  Flora Saini
//
//  Created by Rupali on 16/05/21.
//  Copyright © 2021 armsprime. All rights reserved.
//

import UIKit

class ReportContentCell: UITableViewCell {

    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var lblreporteNm: UILabel!
    @IBOutlet weak var btnReportInfo: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnReportInfo_onClick(_ sender: Any) {
        
    }
}
