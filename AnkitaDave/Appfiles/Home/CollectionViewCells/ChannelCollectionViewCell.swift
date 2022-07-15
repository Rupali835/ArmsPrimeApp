//
//  ChannelCollectionViewCell.swift
//  Multiplex
//
//  Created by Sameer Virani on 19/05/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

protocol ChannelDelegate: class {
    func didTapButton(_ sender: UIButton)
    func didLikeButton(_ sender: UIButton)
    func didShareButton(_ sender: UIButton)
    func didTapOpenOptions(_ sender : UIButton)
    func didTapOpenPurchase(_ sender : UIButton)
    func didTapWebview(_ sender: UIButton)
}

class ChannelCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    weak var delegate: ChannelDelegate?
    var tapGesture : UITapGestureRecognizer!
    var list: List! {
           didSet {
               self.updateUI()
           }
       }


    override func prepareForReuse() {
        self.blurView.isHidden = true
        self.unlockView.isHidden = true
    }

    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.layer.cornerRadius = 4
//        self.layer.borderColor = BlackThemeColor.yellow.cgColor
//        self.layer.borderWidth = 1
//
//        let blurEffectView = VisualEffectView()
//        blurEffectView.frame = blurView.bounds
//        blurEffectView.blurRadius = 5
//        blurEffectView.colorTint = .black
//        blurEffectView.scale = 1
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.blurView.insertSubview(blurEffectView, at: 0)
////        self.blurView.bringSubviewToFront(unlockView)
////        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapBlurView(_ :)))
////        self.blurView.isUserInteractionEnabled = true
////        self.blurView.addGestureRecognizer(tapGesture)
//    }
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            self.layer.cornerRadius = 4
            self.layer.borderColor = BlackThemeColor.yellow.cgColor
            self.layer.borderWidth = 1

          //  let blurEffectView = VisualEffectView()
    //        blurEffectView.frame = blurView.bounds
    //        blurEffectView.blurRadius = 5
    //        blurEffectView.colorTint = .black
    //        blurEffectView.scale = 1
    //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //        self.blurView.insertSubview(blurEffectView, at: 0)
    //        self.blurView.bringSubviewToFront(unlockView)
    //        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapBlurView(_ :)))
    //        self.blurView.isUserInteractionEnabled = true
    //        self.blurView.addGestureRecognizer(tapGesture)
            
            self.blurView.isUserInteractionEnabled = true
          //  optionsView.layer.cornerRadius = self.optionsView.frame.width/2;
            //        self.contentView.translatesAutoresizingMaskIntoConstraints = true
            //        let screenWidth = UIScreen.main.bounds.size.width
            //        viewWidthLayout.constant = screenWidth - (2 * 1)
                  //  playVideoImage.isHidden = true
                    self.clipsToBounds = true
                    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
                    let blurEffectView = UIVisualEffectView(effect: blurEffect)
                    blurEffectView.frame = blurView.bounds
                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                  self.blurView.insertSubview(blurEffectView, at: 0)
//                  self.blurView.addSubview(blurEffectView)

                  //  self.blurView.addSubview(blurEffectView)
                   // self.blurView.bringSubviewToFront(unlockView)
                   // optionsView.layer.cornerRadius = 4.0
        }

    
    func configurBlurPhoto(_ media: Blur_photo) {  //rupali
        self.blurView.isHidden = true
        self.unlockView.isHidden = false
              if let portraitImg = media.portrait
              {
                if portraitImg != ""
                {
                    loadImages(with: URL(string: portraitImg)!)
                }else if let landImg = media.landscape
                {
                    if landImg != ""
                    {
                        loadImages(with: URL(string: landImg)!)
                    }
                }
                 
              }
              else if let landImg = media.landscape
              {
                if landImg != ""
                {
                    loadImages(with: URL(string: landImg)!)
                }
              }

          }

    func configurPhoto(_ media: Photo) {
        self.blurView.isHidden = true
        self.unlockView.isHidden = true

        guard let imageName = media.thumb, let imageUrl = URL(string: imageName)  else {
            return
        }

        loadImages(with: imageUrl)
    }

    func updateUI() {

    }

    func configurVideo(_ media: Video) {

        guard let imageName = media.cover, let imageUrl = URL(string: imageName)  else {
            return
        }

        loadImages(with: imageUrl)
    }


    private func loadImages(with url: URL) {
        imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "wardrobe_placeholder"), options: .highPriority) {  (img, err, type, url) in

        }
    }

//    @objc func didTapBlurView (_ sender: UITapGestureRecognizer) {
//
//           delegate?.didTapOpenPurchase(self.shareTap)
//
//       }

}
