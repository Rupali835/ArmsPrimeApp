//
//  VideoCallDashboardView.swift
//  Multiplex
//
//  Created by Parikshit on 24/10/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

class VideoCallDashboardView: UIView {

    @IBOutlet weak var imgViewCut: UIImageView!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewMiddle: UIView!
    @IBOutlet weak var viewRight: UIView!
    
    override func awakeFromNib() {
        
        setLayoutAndDesign()
    }
    
    func setLayoutAndDesign() {
        
        imgViewCut?.imgTintColor = appearences.newIndigoColor
        viewLeft?.backgroundColor = appearences.newIndigoColor
        viewMiddle?.backgroundColor = appearences.newIndigoColor
        viewRight?.backgroundColor = appearences.newIndigoColor
    }
}


