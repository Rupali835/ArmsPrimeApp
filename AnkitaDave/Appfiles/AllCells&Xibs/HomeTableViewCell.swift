//
//  HomeTableViewCell.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 18/04/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    

    @IBOutlet weak var homeSectionName: UILabel!
     @IBOutlet weak var uiView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        uiView.addDashedBorder()
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension UIView {
    
    func addDashedBorder() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]
        let path = CGMutablePath()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
              
                path.addLines(between: [CGPoint(x: 0, y: 0),
                                        CGPoint(x: self.frame.size.width, y: 0)])
                shapeLayer.path = path
                layer.addSublayer(shapeLayer)
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
             
                path.addLines(between: [CGPoint(x: 0, y: 0),
                                        CGPoint(x: self.frame.size.width+50, y: 0)])
                shapeLayer.path = path
                layer.addSublayer(shapeLayer)
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                
            
                path.addLines(between: [CGPoint(x: 0, y: 0),
                                        CGPoint(x: self.frame.size.width+90, y: 0)])
                shapeLayer.path = path
                layer.addSublayer(shapeLayer)
                
            case 2436:
                print("iPhone X")
                
                path.addLines(between: [CGPoint(x: 0, y: 0),
                                        CGPoint(x: self.frame.size.width+50, y: 0)])
                shapeLayer.path = path
                layer.addSublayer(shapeLayer)
                
            default:
                print("unknown")
            }
        }
        
        
        
        
    }
    
}
