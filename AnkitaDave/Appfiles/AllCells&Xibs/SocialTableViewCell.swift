//
//  SocialTableViewCell.swift
//  Karan Kundra
//
//  Created by Razrtech3 on 02/04/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit
import SDWebImage
import SQLite

protocol SocialTableViewCellDelegate {
    func didTapButton(_ sender: UIButton)
    func didLikeButton(_ sender: UIButton)
    func didShareButton(_ sender: UIButton)
    func didTapOpenOptions(_ sender : UIButton)
    func didTapWebview(_ sender: UIButton)
}

class SocialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var webViewLabel: UILabel!
    @IBOutlet weak var webviewButton: UIButton!
    @IBOutlet weak var profileImageView: ScaledHeightImageView!
    @IBOutlet weak var karanPicImageView: UIImageView!
    @IBOutlet weak var karanNameLabel: UILabel!
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
    @IBOutlet weak var textView: UITextView!
    //    @IBOutlet weak var emitterView: WaveEmitterView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var playVideoImage: UIImageView!
    
    @IBOutlet weak var ratedView: UIView!
    //    let instgram = URL(string: "https://scontent-bom1-2.cdninstagram.com/vp/4a7a78d030aec59507714027e133ffcb/5D5CBD70/t51.2885-19/s150x150/60400877_596022580905652_2351629654101590016_n.jpg?_nc_ht=scontent-bom1-2.cdninstagram.com")
     let instgram = URL(string: "https://scontent-bom1-2.cdninstagram.com/vp/ec6caa2e150ce9b2b18eea5da02365a9/5DAAE4EA/t51.2885-19/s150x150/64570104_357786718215330_871200237291569152_n.jpg?_nc_ht=scontent-bom1-2.cdninstagram.com")
    /*
https://scontent-bom1-2.cdninstagram.com/vp/ec6caa2e150ce9b2b18eea5da02365a9/5DAAE4EA/t51.2885-19/s150x150/64570104_357786718215330_871200237291569152_n.jpg?_nc_ht=scontent-bom1-2.cdninstagram.com
     */
    let facebook = URL(string: "https://scontent-bom1-2.xx.fbcdn.net/v/t1.0-9/49896558_1103016273208772_5337032649565274112_n.jpg?_nc_cat=101&_nc_ht=scontent-bom1-2.xx&oh=a2cb23d7e8f8d739dbd5e595938fa496&oe=5D6195C7")
    let twitter = URL(string: "https://pbs.twimg.com/profile_images/922857717898780672/PB0TEAG0_400x400.jpg")
    
    var editButton = UIButton()
    var isVideo = false
    let imageSize = CGSize(width: 300, height: 400)
    var list: List! {
        didSet {
            self.updateUI()
        }
    }
    
    let fetcher = ImageSizeFetcher()
    
    var delegate: SocialTableViewCellDelegate?
    
    @IBOutlet weak var ratedAgeLabel: UILabel!
    @IBOutlet weak var videoViewCountLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var viewVideoCountView: UIView!
    @IBOutlet weak var durationView: UIView!
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //         self.helpSupportTextView.isEditable = false
//        self.helpSupportTextView.dataDetectorTypes = .all
      
        self.profileImageView.layer.cornerRadius = 15
        self.profileImageView.clipsToBounds = true
        
//        self.webViewLabel.layer.cornerRadius = 5
//        self.webViewLabel.layer.borderWidth  = 1
//        self.webViewLabel.layer.borderColor = UIColor.lightGray.cgColor
//        self.webViewLabel.clipsToBounds =  true
//        self.webViewLabel.layer.masksToBounds = false
        
        self.karanPicImageView.layer.cornerRadius = karanPicImageView.frame.size.width / 2
        self.karanPicImageView.layer.masksToBounds = false
        self.karanPicImageView.clipsToBounds = true
        self.karanPicImageView.backgroundColor = UIColor.clear
        
        uiView.layer.cornerRadius = 10
        uiView.clipsToBounds = true
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.likeTap.isHidden = false
        self.likeButton.isHidden = false
        self.likeCountLabel.isHidden = false
        self.commentTap.isHidden = false
        self.commentButton.isHidden = false
        self.commentCountLabel.isHidden = false
        self.playVideoImage.isHidden = true
//        self.profileImageView.image = nil
        self.likeButton.imageView?.image = nil
        
        self.statusLabel.text = ""
        self.optionsButton.layer.cornerRadius = 4.0
        
        uiView.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
        karanNameLabel.textColor = hexStringToUIColor(hex: MyColors.cellNameLabelTextColor)
        daysLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        statusLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        webViewLabel.textColor = hexStringToUIColor(hex: MyColors.cellStatusLabelTextColor)
        likeCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        commentCountLabel.textColor = hexStringToUIColor(hex: MyColors.cellDateLabelTextColor)
        
        karanNameLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        daysLabel.font = UIFont(name: AppFont.regular.rawValue, size: 13.0)
        likeCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        commentCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        statusLabel.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        webViewLabel.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        karanNameLabel.text = Constants.celebrityName
        ratedAgeLabel.font = UIFont(name: AppFont.regular.rawValue, size: 10.0)
        ratedView.roundCorners(corners: [.topRight,.bottomRight], radius: 10.0)
    }
    
    @IBAction func didTapOptions(_ sender: UIButton) {
        delegate?.didTapOpenOptions(sender)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.image = nil
        self.profileImageView.isHidden = true
        self.statusLabel.text = ""
        self.shareButton.isHidden = false
        self.likeTap.isHidden = false
        self.likeButton.isHidden = false
        self.likeCountLabel.isHidden = false
        self.commentTap.isHidden = false
        self.commentButton.isHidden = false
        self.commentCountLabel.isHidden = false
    }
    
    
    func updateUI() {
        print("update UI \(list.type)")
//        self.karanPicImageView.sd_imageIndicator?.startAnimatingIndicator()
//        self.karanPicImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        self.karanPicImageView.sd_imageTransition = .fade

        if list.source == "twitter" {
            self.karanPicImageView.sd_setImage(with: twitter , completed: nil)
            self.likeTap.isHidden = true
            self.likeButton.isHidden = true
            self.likeCountLabel.isHidden = true
            self.shareButton.isHidden = true
            self.commentTap.isHidden = true
            self.commentButton.isHidden = true
            self.commentCountLabel.isHidden = true
        } else if list.source  == "facebook" {
//            self.karanPicImageView.sd_setImage(with: facebook, completed: nil)
//            self.karanPicImageView.sd_setImage(with: facebook, placeholderImage: UIImage(named: "celebrityProfileDP"), options: .refreshCached, progress: nil, completed: nil)
             self.karanPicImageView.image = UIImage(named: "celebrityProfileDP")
        } else if list.source  == "instagram" {
//            self.karanPicImageView.sd_setImage(with: instgram, completed: nil)
//            self.karanPicImageView.sd_setImage(with: instgram, placeholderImage: UIImage(named: "celebrityProfileDP"), options: .refreshCached, progress: nil, completed: nil)
            self.karanPicImageView.image = UIImage(named: "celebrityProfileDP")
        } else if list.source == "custom" {
            self.karanPicImageView.image = UIImage(named: "celebrityProfileDP")
        }
        
        if list.type == "photo" {
            profileImageView.isHidden = false
            playVideoImage.isHidden = true
            if let thumbHeight = list.photo?.thumbHeight, let thumbWidth = list.photo?.thumbWidth {
                
                self.setImageHeight(currentHeight: CGFloat(thumbHeight), currentWidth: CGFloat(thumbWidth))
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                if let imageUrl = list.photo?.cover {
                    profileImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                }
            } else if let coverUrl = list.photo?.cover, let imageUrl = URL(string: coverUrl) {
                
                self.imageViewHeightConstraint.constant = 400
                self.getImageHeight(imageUrl: imageUrl, list: list)
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                profileImageView.sd_imageTransition = .fade
               profileImageView.sd_setImage(with: imageUrl, completed: nil)
            } else {
                self.webViewLabel.isHidden = true
                self.webviewButton.isHidden = true
                self.imageViewHeightConstraint.constant = 0
                self.playVideoImage.isHidden = true
                profileImageView?.image = nil
                self.layoutIfNeeded()
                self.layoutSubviews()
            }
            self.durationView.isHidden =  true
            self.viewVideoCountView.isHidden = true
        } else if list.type == "video"{
            
            profileImageView.isHidden = false
            if let thumbHeight = list.video?.thumbHeight, let thumbWidth = list.video?.thumbWidth {
                self.setImageHeight(currentHeight: CGFloat(thumbHeight), currentWidth: CGFloat(thumbWidth))
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                print("video url \(list.video?.cover)")
                if let imageUrl = list.video?.cover {
                    
                    self.playVideoImage.isHidden = false
                    profileImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                }
            } else if let coverUrl = list.video?.cover, let imageUrl = URL(string: coverUrl) {
                //                self.getImageSize(urlString: coverUrl, list: list)
                print("video url2 \(list.video?.cover)")
                self.imageViewHeightConstraint.constant = 400
                self.getImageHeight(imageUrl: imageUrl, list: list)
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
//                self.profileImageView.sd_setImage(with: imageUrl.absoluteURL, placeholderImage: nil, options: .fromCacheOnly) { (image : UIImage?, err : Error? ,SDImageCacheTypeMemory , url : URL?) in
//                    if (err == nil) {
//                        self.playVideoImage.isHidden = false
//                        self.setNeedsLayout()
//                    }
//                }
                self.playVideoImage.isHidden = false
//                 self.profileImageView.sd_setImage(with: imageUrl, completed: nil)
                self.profileImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage.init(named: "image placeholder"), options: .refreshCached, progress: nil, completed: nil)
                
            } else {
                self.webViewLabel.isHidden = true
                self.webviewButton.isHidden = true
                self.imageViewHeightConstraint.constant = 250
                profileImageView.image = UIImage.init(named: "image placeholder")
            }
            
            if  list.Duration != nil && list.Duration != "" {
                self.durationView.isHidden = false
                self.durationLabel.text = list.Duration
            } else {
                self.durationView.isHidden =  true
            }
            
            if let view = list.stats?.views{
                self.viewVideoCountView.isHidden = false
                self.videoViewCountLabel.text = view.roundedWithAbbreviations
            } else {
                self.viewVideoCountView.isHidden = true
            }
        } else {
            self.webViewLabel.isHidden = true
            self.webviewButton.isHidden = true
            self.imageViewHeightConstraint.constant = 0
            profileImageView?.image = nil
            self.durationView.isHidden =  true
            self.viewVideoCountView.isHidden = true
            self.layoutIfNeeded()
            self.layoutSubviews()
        }

    }
    
    func setImageHeight(currentHeight: CGFloat, currentWidth: CGFloat) {
        let ratio = 370/currentWidth
        let newheight = currentHeight * ratio
        self.imageViewHeightConstraint.constant = newheight
        self.layoutIfNeeded()
    }
    
    var dbPath : String?
    func getImageHeight(imageUrl: URL, list: List) {
        fetcher.sizeFor(atURL: imageUrl) { (error, result) -> (Void) in
            if let height = result?.size.height, let width = result?.size.width {
                
                DispatchQueue.main.async {
                    
                    
                    var db : Connection!
                    
                    func  initDatabase( path : String) {
                        self.dbPath = path
                        do {
                            db = try Connection(path)
                            list.photo?.thumbHeight = Int(height)
                            list.photo?.thumbWidth = Int(width)
                            
                        }catch{

                        }


                    }
                  
                    //                    self.photoImageView.frame.size = (result?.size)!
                    let ratio = 370/width
                    let newheight = height * ratio
                    self.imageViewHeightConstraint.constant = newheight
                    self.layoutIfNeeded()
                    self.layoutIfNeeded()
                }
                
            }
        }
    }
    
    @IBAction func unclockContentButtonTapped(_ sender: Any) {
        
        
        
    }
    
    @IBAction func webviewButton(_ sender: UIButton) {
        
        delegate?.didTapWebview(self.webviewButton)
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
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

