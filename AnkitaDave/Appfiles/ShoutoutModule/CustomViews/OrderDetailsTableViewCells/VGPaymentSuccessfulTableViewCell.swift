//
//  VGPaymentSuccessfulTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class VGPaymentSuccessfulTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var termsAndCondStackView: UIStackView!
    @IBOutlet weak var paymentSuccessLabel: UILabel!
    @IBOutlet weak var termsAndCondButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timestampLabel.font = ShoutoutFont.regular.withSize(size: .smaller)
        paymentSuccessLabel.font = ShoutoutFont.medium.withSize(size: .largeTitle)
        termsAndCondStackView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(greetingData: GreetingList?) {
        timestampLabel.text = greetingData?.created_at?.toDateString(fromFormat: .yyyyMMddHHmmss, toFormat: .ddMMMYYYYhhmm)
    }
    
    @IBAction func didTapCheckbox(_ sender: UIButton) {
    }
    
    @IBAction func didTapTermsAndCond(_ sender: UIButton) {
    }
    
    @IBAction func didTapSendGreeting(_ sender: UIButton) {
    }
}
