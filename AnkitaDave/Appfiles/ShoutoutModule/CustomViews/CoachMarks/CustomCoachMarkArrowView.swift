// CustomCoachMarkArrowView.swift
//
//
//
//  Created by Pankaj Bawane on 13/08/19.
//  Copyright © Pankaj Bawane 2019. All rights reserved.
//

import UIKit
import Instructions

// Custom coach mark body (with the secret-like arrow)
class CustomCoachMarkArrowView : UIView, CoachMarkArrowView {
    // MARK: - Internal properties
    var topPlateImage = UIImage(named: "coach-mark-top-plate")
    var bottomPlateImage = UIImage(named: "coach-mark-bottom-plate")
    var plate = UIImageView()

    var isHighlighted: Bool = false

    // MARK: - Private properties
    fileprivate var column = UIView()

    // MARK: - Initialization
    init?(orientation: CoachMarkArrowOrientation) {
        super.init(frame: CGRect.zero)

        if orientation == .top {
            self.plate.image = topPlateImage
        } else {
            self.plate.image = bottomPlateImage
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        self.column.translatesAutoresizingMaskIntoConstraints = false
        self.plate.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(plate)
        self.addSubview(column)

        plate.backgroundColor = UIColor.clear
        column.backgroundColor = UIColor.white

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[plate]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["plate" : plate]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[column(==3)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["column" : column]))

        self.addConstraint(NSLayoutConstraint(item: column, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))

        if orientation == .top {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[plate(==5)][column(==10)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["plate" : plate, "column" : column]))
        } else {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[column(==10)][plate(==5)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["plate" : plate, "column" : column]))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
}
