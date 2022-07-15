//
//  imageScrollCollectionViewCell.swift
//  Poonam Pandey
//
//  Created by RazrTech2 on 09/01/19.
//  Copyright © 2019 Razrcorp. All rights reserved.
//

import UIKit

protocol photoDetailPurchaseDelegate : class{
    
    func didTapOpenPurchase(index : Int)
    
}

class imageScrollCollectionViewCell: UICollectionViewCell{

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var unlockPriceLabel: UILabel!
    @IBOutlet var playVideoImage : UIImageView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var blurView: UIView!
    weak var delegate: photoDetailPurchaseDelegate?
    var viewTag: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellImage.isUserInteractionEnabled = true
        self.scrollview.minimumZoomScale = 1
        self.scrollview.maximumZoomScale = 3
        self.scrollview.delegate = self
     
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
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        
        doubleTapGest.numberOfTapsRequired = 2
        
        scrollview.addGestureRecognizer(doubleTapGest)
    
//        self.viewTag.addSubview(scrollview)
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        
        if (scrollview.zoomScale > scrollview.minimumZoomScale)
        {
            scrollview.setZoomScale(scrollview.minimumZoomScale, animated: true)
        } else {
            scrollview.setZoomScale(scrollview.maximumZoomScale, animated: true)
        }
        
    }
    func setZoomScale()
    {
        let imageViewSize = cellImage.bounds.size
        let scrollViewSize = scrollview.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollview.minimumZoomScale = min(widthScale, heightScale)
        scrollview.zoomScale = 1.0
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        
        var zoomRect = CGRect.zero
        
        zoomRect.size.height = cellImage.frame.size.height / scale
        
        zoomRect.size.width  = cellImage.frame.size.width  / scale
        
        let newCenter = cellImage.convert(center, from: scrollview)
        
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cellImage.image = nil
        self.scrollview.minimumZoomScale = 1
        self.scrollview.contentOffset = CGPoint(x: 0, y: 0)
        scrollview.setZoomScale(scrollview.minimumZoomScale, animated: true)

    }
    
    @IBAction func didTapOpenHideContetnt(_ sender: UIButton) {
        
        delegate?.didTapOpenPurchase(index : sender.tag)
        
        
    }
    
    @objc func didTapBlurView (_ sender: UITapGestureRecognizer) {
        
        delegate?.didTapOpenPurchase(index : self.viewTag!)
        
    }
    
   
}

//MARK:- UIScrollViewDelegate
extension imageScrollCollectionViewCell: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.cellImage
    }
    
    //
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = cellImage.frame.size
        let scrollViewSize = scrollview.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollview.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
    }
}
