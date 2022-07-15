//
//  AskTableViewCell.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 24/05/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

protocol AskTableViewCellDelegate: class {
    func didTapButton(_ sender: UIButton)
    func didLikeButton(_ sender: UIButton)
    func didShareButton(_ sender: UIButton)
    func didTapOpenOptions(_ sender: UIButton)
    func didTapOpenPurchase(_ sender : UIButton)
    func didTapVideoPlay(_ sender : UIButton)
}

class AskTableViewCell: UITableViewCell {

    @IBOutlet weak var unlockPriceLabel: UILabel!
    @IBOutlet weak var unlockView: UIView!
    var tapGesture : UITapGestureRecognizer!
    
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileDaysLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeTapButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var commentTapButton: UIButton!
    @IBOutlet weak var shareTapButton: UIButton!
    @IBOutlet weak var playVideoIcon: UIButton!
    @IBOutlet weak var profilewidthlayout: NSLayoutConstraint!
    @IBOutlet weak var unlockImageView: UIImageView!
    @IBOutlet weak var unlockdView: UIView!
    @IBOutlet weak var optionsTap: UIButton!
    
    
    weak var delegate: AskTableViewCellDelegate?
    var isVideo = false
    //MARK:-
    @IBAction func didTapOptionsButton(_ sender: UIButton) {
        delegate?.didTapOpenOptions(sender)
    }
    
    @IBAction func didTapVideoPlay(_ sender: UIButton) {
        delegate?.didTapVideoPlay(sender)
        
    }
    @IBAction func didTapOpenHideContetnt(_ sender: UIButton) {
        
        delegate?.didTapOpenPurchase(self.shareTapButton)
        
        
    }
    @objc func didTapBlurView (_ sender: UITapGestureRecognizer) {
        
        delegate?.didTapOpenPurchase(self.shareTapButton)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
        unlockdView.roundCorners(corners: [.topRight], radius: 30)
        unlockdView.roundCorners(corners: [.bottomRight], radius: 30)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                
                profilewidthlayout.constant = 0
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
                
                
            case 2208:
                print("iPhone 6+/6S+/7+/8+")
                
                
            case 2436:
                print("iPhone X")
                
                
            default:
                print("unknown")
            }
        }
        uiView.layer.cornerRadius = 5
        uiView.clipsToBounds = true
        
        self.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurView.addSubview(blurEffectView)
        self.blurView.bringSubviewToFront(unlockView)
        self.optionsButton.layer.cornerRadius = 4.0
        
        uiView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
        profileNameLabel.textColor = hexStringToUIColor(hex: MyColors.cellNameLabelTextColor)
        profileDaysLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        likeCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        commentCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        
        profileNameLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        profileDaysLabel.font = UIFont(name: AppFont.regular.rawValue, size: 13.0)
        likeCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        commentCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
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
