//
//  ProducerGreetingCell.swift
//
//
//  Created by developer2 on 07/03/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class ProducerGreetingCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.cornerRadius = 8.0
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 7.0
        containerView.layer.shadowOffset = .zero
        containerView.layer.shouldRasterize = true
 
        btnReject.layer.cornerRadius = 5.0
        btnReject.layer.shadowRadius = 5.0
        btnReject.layer.shadowColor = UIColor.black.cgColor
        btnReject.layer.shadowOpacity = 0.5
        btnReject.layer.shadowOffset = .zero
        btnReject.layer.shouldRasterize = true
        btnReject.setTitleColor(.white, for: .normal)
       
        btnAccept.layer.cornerRadius = 5.0
        btnAccept.layer.shadowRadius = 5.0
        btnAccept.layer.shadowColor = UIColor.black.cgColor
        btnAccept.layer.shadowOpacity = 0.5
        btnAccept.layer.shadowOffset = .zero
        btnAccept.layer.shouldRasterize = true
        btnAccept.layer.cornerRadius = 8.0
        btnAccept.setTitleColor(.white, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
