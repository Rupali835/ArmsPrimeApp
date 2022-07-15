//
//  GiftDisplayView.swift
//  Live
//
//  Created by leo on 16/7/15.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import SDWebImage

class GiftDisplayView: XibBasedView {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var comboLabel: UILabel!
    @IBOutlet weak var textContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var giftBackgroundView: UIView!
    
    var currentCombo = 0 {
        didSet {
            comboLabel.text = "x\(currentCombo)"
        }
    }
    var initialGiftEvent: GiftEvent! {
        didSet {
            textLabel.text = initialGiftEvent.userName
            //            let imageUrl = URL(string: initialGiftEvent.giftImage)
            //            if let profileImage = URL(string: initialGiftEvent.userImage) {
            
            if let imageUrlString = initialGiftEvent.giftImage, let imageUrl = URL(string: imageUrlString) {
                //                imageView.sd_setImage(with: imageUrl, completed: nil)
                let imageURL = UIImage.gifImageWithURL(imageUrlString)
                if let image = imageURL {
                    imageView.image = image
                } else {
                    imageView.image =  UIImage(named: "icon-gift")
                }
            } else {
                imageView.image = #imageLiteral(resourceName: "icon-gift")
            }
            if let userImageUrl = initialGiftEvent.userImage, let profileImage = URL(string: userImageUrl) {
                profileImageView.sd_setImage(with: profileImage, completed: nil)
            } else {
                profileImageView.image = #imageLiteral(resourceName: "profileph")
            }
            //            imageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    var finalCombo = 0
    var timer: Timer?
    
    var lastEventTime: TimeInterval!
    var maximumStaySeconds: TimeInterval = 3
    
    var needsDismiss: ((_ view: GiftDisplayView) -> ())!
    //MARK:-
    override func load() {
        super.load()
        backgroundView.layer.cornerRadius = backgroundView.frame.height/2
        textContainer.layer.cornerRadius = textContainer.frame.height/2
        imageView.layer.cornerRadius = imageView.frame.height/2
        giftBackgroundView.layer.cornerRadius = giftBackgroundView.frame.height/2
        self.profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }

    func startAnimateCombo() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GiftDisplayView.tick(_:)), userInfo: nil, repeats: true)
        }
    }
    
    func prepareForReuse() {
        currentCombo = 0
        finalCombo = 0
    }
    
    
    @objc func tick(_ timer: Timer) {
        let now = Date().timeIntervalSince1970
        guard (now - lastEventTime) < maximumStaySeconds else {
            self.timer?.invalidate()
            self.timer = nil
            needsDismiss(self)
            return
        }
        guard finalCombo > currentCombo else {
            return
        }
        self.currentCombo += 1
        if finalCombo > 1 {
            self.currentCombo = self.finalCombo
            print("======\(finalCombo)")
        }
        

        UIView.animate(withDuration: 0.1, animations: {
            self.comboLabel.scale = 3
        }, completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                self.comboLabel.scale = 1
            }, completion: { finished in
            
            })
        })
        
    }
    
    
}
