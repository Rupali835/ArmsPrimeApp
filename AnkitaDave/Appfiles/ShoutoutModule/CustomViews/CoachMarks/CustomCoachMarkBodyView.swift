// CustomCoachMarkBodyView.swift
//
//
//
//  Created by Pankaj Bawane on 13/08/19.
//  Copyright © Pankaj Bawane 2019. All rights reserved.
//

import UIKit
import Instructions

// Custom coach mark body (with the secret-like arrow)
class CustomCoachMarkBodyView : UIView, CoachMarkBodyView {
    // MARK: - Internal properties
    var nextControl: UIControl?

    var highlighted: Bool = false

    var hintLabel = UILabel()
    var titleLabel = UILabel()
    
    weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate? = nil
    
    // MARK: - Initialization
    override init (frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setupInnerViewHierarchy()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }

    // MARK: - Private methods
    fileprivate func setupInnerViewHierarchy() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white

        self.clipsToBounds = true
        self.layer.cornerRadius = 4

        self.hintLabel.backgroundColor = UIColor.clear
        self.hintLabel.textColor = UIColor.darkGray
        self.hintLabel.textAlignment = .center
        self.hintLabel.numberOfLines = 0
        hintLabel.font = ShoutoutFont.light.withSize(size: .medium)
        
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        titleLabel.textColor = hexStringToUIColor(hex: MyColors.cellNameLabelTextColor)//#colorLiteral(red: 0.8680543303, green: 0.08071563393, blue: 0.4117774963, alpha: 1)
        titleLabel.font = ShoutoutFont.regular.withSize(size: .large)

        self.hintLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false

        self.hintLabel.isUserInteractionEnabled = false

        self.addSubview(hintLabel)
        self.addSubview(titleLabel)

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[titleLabel]-(2)-[hintLabel]-(15)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["titleLabel": titleLabel, "hintLabel": hintLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[hintLabel]-(20)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                           metrics: nil, views: ["hintLabel": hintLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[titleLabel]-(10)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                           metrics: nil, views: ["titleLabel": titleLabel]))
        
    }
}
