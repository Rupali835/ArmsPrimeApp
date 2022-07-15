//
//  OrderPlacedView.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 23/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit

protocol OrderPlacedViewDelegate: class {
    func orderPlaced()
}

class OrderPlacedView: UIView {
    
    @IBOutlet weak var vwTransparentView: UIView!
    @IBOutlet weak var vwGradiantView: UIView!

    weak var delegate: OrderPlacedViewDelegate?
  
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instanceFromNib() -> OrderPlacedView {

        let orderPlacedView = UINib(nibName: "OrderPlacedView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OrderPlacedView
        orderPlacedView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        return orderPlacedView
    }
    
    override func draw(_ rect: CGRect) {
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(removeView))
        tapGuesture.delegate = self
        self.addGestureRecognizer(tapGuesture)
        
        let colors = [hexStringToUIColor(hex: "20F599"), hexStringToUIColor(hex: "10BBA9")]
        vwGradiantView.setGradientBackground(color: colors)
    }
    
    @IBAction func didTapOkThanks(_ sender: UIButton) {
        removeView()
    }
    
    @objc func removeView() {
        self.delegate?.orderPlaced()
        self.removeFromSuperview()
    }
}

extension OrderPlacedView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view == vwTransparentView ? true : false
    }
}
