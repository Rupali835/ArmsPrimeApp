//
//  PHTablePlaceholder.swift
//  Producer
//
//  Created by developer2 on 31/10/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import UIKit

class PHTablePlaceholder: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    func setDetails(title:String, detail:String) {
        
        lblTitle.text = title
        lblDetail.text = detail
        
        viewContainer.backgroundColor = .clear
        self.backgroundColor = .clear
        
//        self.activityLoader.tintColor = appearences.redColor
        self.activityLoader.isHidden = true
        
        if title.count == 0 && detail.count == 0 {
            
            self.activityLoader.isHidden = false
            self.activityLoader.startAnimating()
        }
    }
}
