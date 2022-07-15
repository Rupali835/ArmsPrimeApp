//
//  PhotoDetailsCollectionViewCell.swift
//  Fazaa
//
//  Created by Razrcorp  on 07/06/18.
//  Copyright © 2018 Razrcorp . All rights reserved.
//

import UIKit

//protocol photoDetailPurchaseDelegate : class{
//
//    func didTapOpenPurchase(index : Int)
//
//}

class PhotoDetailsCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate {
    
   
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var unlockPriceLabel: UILabel!
    @IBOutlet var playVideoImage : UIImageView!

    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var blurView: UIView!
//    weak var delegate: photoDetailPurchaseDelegate?
    var viewTag: Int?
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellImage.isUserInteractionEnabled = true
      
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurView.addSubview(blurEffectView)
        self.blurView.bringSubviewToFront(unlockView)
        var tapGesture : UITapGestureRecognizer!

        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapBlurView(_ :)))
        self.blurView.isUserInteractionEnabled = true
        self.blurView.addGestureRecognizer(tapGesture)
//        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
//        cellImage.addGestureRecognizer(pinch)
      
    }
   
    override func prepareForReuse() {
        
    }
    
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let currentScale = self.cellImage.frame.size.width / self.cellImage.bounds.size.width
            let newScale = currentScale*sender.scale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.cellImage.transform = transform
            sender.scale = 1
        }
    }
    
    @IBAction func didTapOpenHideContetnt(_ sender: UIButton) {
        
//        delegate?.didTapOpenPurchase(index : sender.tag)
        
        
    }
    
  
    
    @objc func didTapBlurView (_ sender: UITapGestureRecognizer) {
        
//        delegate?.didTapOpenPurchase(index : self.viewTag!)
        
    }
}

