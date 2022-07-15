//
//  VideoTableViewCell.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 29/05/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

protocol VideoTableViewCellDelegate {
    func didTapButton(_ sender: UIButton)
    func didLikeButton(_ sender: UIButton)
    func didShareButton(_ sender: UIButton)
    func didTapOpenOptions(_ sender: UIButton)
    func didTapOpenPurchase(_ sender : UIButton)
    func didTapWebview(_ sender: UIButton)
//    func didTapVideoPlay(_ sender : UIButton)

}

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var durationBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var durationBackgroundView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var webViewLabel: UILabel!
    @IBOutlet weak var webViewButton: UIButton!
    @IBOutlet weak var unlockPriceLabel: UILabel!
    @IBOutlet weak var unlockView: UIView!
    var tapGesture : UITapGestureRecognizer!
    @IBOutlet weak var unlockImageView: UIImageView!
    @IBOutlet weak var unlockdView: UIView!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var likeTap: UIButton!
    @IBOutlet weak var commentTap: UIButton!
    @IBOutlet weak var shareTap: UIButton!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var profilewidthlayout: NSLayoutConstraint!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var optionsTap: UIButton!
    @IBOutlet weak var profilePicImageView: UIImageView!
   // @IBOutlet weak var playVideoImage: UIImageView!
    var editButton = UIButton()
    var isVideo = false
    var delegate: VideoTableViewCellDelegate?
    @IBOutlet weak var cellNameLabel: UILabel!
    
    @IBOutlet weak var premiumLabel: UILabel!
    
    //MARK:-
    @IBAction func didTapOptionsButton(_ sender: UIButton) {
        delegate?.didTapOpenOptions(sender)
    }
    @IBAction func didTapOpenHideContetnt(_ sender: UIButton) {
        delegate?.didTapOpenPurchase(self.shareTap)
   }
    
    @IBAction func webViewButton(_ sender: Any) {
        delegate?.didTapWebview(self.webViewButton)
    }
    
    @objc func didTapBlurView (_ sender: UITapGestureRecognizer) {
        delegate?.didTapOpenPurchase(self.shareTap)
    }
    
    @IBOutlet weak var ratedView: UIView!
    
    @IBOutlet weak var viewVideoCountLabel: UILabel!
    @IBOutlet weak var ratedAgeLabel: UILabel!
    
    @IBOutlet weak var viewVideoCountView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uiView.layer.cornerRadius = 10
        uiView.clipsToBounds = true
        premiumView.roundCorners(corners: [.bottomRight], radius: 30)
        self.profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2
        self.profilePicImageView.layer.masksToBounds = false
        self.profilePicImageView.clipsToBounds = true
        self.profilePicImageView.backgroundColor = UIColor.clear
        self.profilePicImageView.image = UIImage(named: "celebrityProfileDP")
   //        imageBackgroundView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
      
        self.webViewLabel.layer.cornerRadius = 5
        self.webViewLabel.clipsToBounds =  true
        self.webViewLabel.layer.masksToBounds = false
        unlockdView.roundCorners(corners: [.topLeft], radius: 30)
        unlockdView.roundCorners(corners: [.bottomLeft], radius: 30)
        
        self.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurView.addSubview(blurEffectView)
        self.blurView.bringSubviewToFront(unlockView)
        self.optionButton.layer.cornerRadius = 4.0
        
//        uiView.backgroundColor = hexStringToUIColor(hex: MyColors.primary)
//        uiView.layer.shadowColor = UIColor.white.cgColor
//        uiView.layer.cornerRadius = 8.0
//        uiView.layer.shadowOpacity = 0.5
//        uiView.layer.shadowRadius = 7.0
//        uiView.layer.shadowOffset = .zero
//        uiView.layer.shouldRasterize = true
//        uiView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
//        cellNameLabel.textColor = hexStringToUIColor(hex: MyColors.cellNameLabelTextColor)
//        daysLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
//        statusLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
//        webViewLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
//        likeCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
//        commentCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        
        cellNameLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        daysLabel.font = UIFont(name: AppFont.regular.rawValue, size: 13.0)
        likeCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        commentCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        statusLabel.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        webViewLabel.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        premiumLabel.font = UIFont(name: AppFont.regular.rawValue, size: 17.0)
        cellNameLabel.text = Constants.celebrityName
        ratedAgeLabel.font = UIFont(name: AppFont.regular.rawValue, size: 10.0)
        ratedView.roundCorners(corners: [.topRight,.bottomRight], radius: 10.0)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.webViewLabel.backgroundColor = UIColor.clear
        self.webViewLabel.text = ""
        self.durationBottomHeight.constant = -10
        self.webViewLabel.isHidden = true
        self.profileImageView.image = nil
        self.premiumView.isHidden = true
        self.statusLabel.text = ""
        
    }
    
    @IBAction func addCommentButtonTapped(_ sender: UIButton) {
        delegate?.didTapButton(sender)
    }
    @IBAction func addLikeButtonTapped(_ sender: UIButton) {
        
        delegate?.didLikeButton(sender)
        
    }
    @IBAction func addShareButtonTapped(_ sender: UIButton) {
        delegate?.didShareButton(sender)
    }
    
    @IBAction func likeTap(_ sender: UIButton) {
        
        self.addLikeButtonTapped(sender)
    }
    
    @IBAction func commentTap(_ sender: UIButton) {
        self.addCommentButtonTapped(sender)
    }
    @IBAction func shareTap(_ sender: UIButton) {
        self.addShareButtonTapped(sender)
    }
  
    
}
extension UIView {
    func dropShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
