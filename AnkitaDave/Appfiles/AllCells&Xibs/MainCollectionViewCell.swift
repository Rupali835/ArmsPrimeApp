//
//  MainCollectionViewCell.swift
//  KaranKundraConsumer
//
//  Created by Razrtech3 on 24/01/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit
import SDWebImage
import SQLite

protocol MainCollectionViewCellDelegate: class {
    
    func didTapButton(_ sender: UIButton)
    func didLikeButton(_ sender: UIButton)
    func didShareButton(_ sender: UIButton)
    func didTapOpenOptions(_ sender : UIButton)
    func didTapOpenPurchase(_ sender : UIButton)
    func didTapWebview(_ sender: UIButton)
}

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var webViewButton: UIButton!
    @IBOutlet weak var webViewLabel: UILabel!
    @IBOutlet weak var unlockPriceLabel: UILabel!
    @IBOutlet weak var profileImageView: ScaledHeightImageView!
    @IBOutlet weak var socialLogoImageView: UIImageView!
    @IBOutlet weak var unlockImageView: UIImageView!
    @IBOutlet weak var unlockdView: UIView!
    @IBOutlet weak var albumcount: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var likeTap: UIButton!
    @IBOutlet weak var commentTap: UIButton!
    @IBOutlet weak var shareTap: UIButton!
    @IBOutlet weak var optionsTap: UIButton!
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var viewWidthLayout:
    NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var feedImageHeightConstraint:
    NSLayoutConstraint!
    @IBOutlet weak var albumImageleftConstraint:
    NSLayoutConstraint!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var playVideoImage: UIImageView!
    @IBOutlet weak var optionsView: UIView!
    //    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: MainCollectionViewCellDelegate?
    var editButton = UIButton()
    var isVideo = false
    let fetcher = ImageSizeFetcher()
    var tapGesture : UITapGestureRecognizer!
    var list: List! {
        didSet {
            self.updateUI()
        }
    }
    @IBOutlet weak var blurView: UIView!
    let imageSize = CGSize(width: 300, height: 400)
     var dbPath : String?
    //MARK:-
    @IBAction func didTapOptionsButton(_ sender: UIButton) {
        delegate?.didTapOpenOptions(sender)
    }
    
    @IBAction func didTapOpenHideContetnt(_ sender: UIButton) {
        
        delegate?.didTapOpenPurchase(self.shareTap)
        
        
    }
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.webViewLabel.layer.cornerRadius = 5
        self.webViewLabel.clipsToBounds =  true
        self.webViewLabel.layer.masksToBounds = false
        
        unlockdView.roundCorners(corners: [.topRight], radius: 25)
        unlockdView.roundCorners(corners: [.bottomRight], radius: 25)
      
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        clipsToBounds = false
        
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapBlurView(_ :)))
        self.blurView.isUserInteractionEnabled = true
        self.blurView.addGestureRecognizer(tapGesture)
        
//        uiView.layer.cornerRadius = 5
//        uiView.clipsToBounds = true
        self.socialLogoImageView.isHidden = true
        optionsView.layer.cornerRadius = self.optionsView.frame.width/2;
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        let screenWidth = UIScreen.main.bounds.size.width
        viewWidthLayout.constant = screenWidth - (2 * 1)
        playVideoImage.isHidden = true
        self.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurView.addSubview(blurEffectView)
        self.blurView.bringSubviewToFront(unlockView)
        optionsView.layer.cornerRadius = 4.0
        //        self.likeButton.setImage(UIImage(named: "heart (1)"), for: .normal)
    }

    
    func updateUI() {
        
        if let isCaption = list.date_diff_for_human
        {
            self.daysLabel.isHidden = false
            self.daysLabel.text = isCaption.captalizeFirstCharacter()
        }
        
        self.albumcount.text = ""
        if list.is_album == "true" {
            
            self.socialLogoImageView.image = UIImage(named:"albumicon")
            self.socialLogoImageView.isHidden = false
            self.socialLogoImageView.backgroundColor = UIColor.clear
            
            if let albumcount = list.stats?.childrens {
                self.albumcount.text = albumcount.roundedWithAbbreviations
            }
        }
        
        if list.commentbox_enable == "true" && list.commentbox_enable != nil && list.commentbox_enable != "" {
            self.commentTap.isUserInteractionEnabled = true
            self.commentTap.backgroundColor = UIColor.clear
        } else {
            self.commentButton.isUserInteractionEnabled = false
            self.commentTap.isUserInteractionEnabled = false
            self.commentTap.backgroundColor = BlackThemeColor.white
        }
        
        self.webViewLabel.text = ""
        
        if let listLabel = list.webview_label, listLabel != "" {
            self.webViewLabel.isHidden = false
            self.webViewLabel.text = listLabel
            self.webViewButton.isUserInteractionEnabled = true
            self.webViewLabel.backgroundColor = UIColor.white
        } else {
            self.webViewButton.isUserInteractionEnabled = false
            self.webViewLabel.backgroundColor = UIColor.clear
        }
        
        self.statusLabel.text = ""
        if list.name != "" && list.name != nil
        {
            self.statusLabel.isHidden = false
            self.statusLabel.text = list.name?.captalizeFirstCharacter()
        } else if list.caption != "" && list.caption != nil {
            self.statusLabel.isHidden = false
            self.statusLabel.text = list.name?.captalizeFirstCharacter()
        }
        
        if let likes = list.stats?.likes{
            self.likeCountLabel.text = likes.roundedWithAbbreviations  //formatPoints(num: Double(likes))//String(likes)
        }
        if let comments = list.stats?.comments{
            
            self.commentCountLabel.text = comments.roundedWithAbbreviations //formatPoints(num: Double(comments))//String(comments)
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
                profileImageView.sd_setImage(with: imageUrl.absoluteURL, placeholderImage: nil, options: .refreshCached) { (image : UIImage?, err : Error? ,SDImageCacheTypeMemory , url : URL?) in
                    self.setNeedsLayout()
                }
            } else {
                self.imageViewHeightConstraint.constant = 0
                self.playVideoImage.isHidden = true
                profileImageView?.image = nil
                self.layoutIfNeeded()
                self.layoutSubviews()
            }
            
        } else if list.type == "video"{
            
            profileImageView.isHidden = false
            if let thumbHeight = list.video?.thumbHeight, let thumbWidth = list.video?.thumbWidth {
                self.setImageHeight(currentHeight: CGFloat(thumbHeight), currentWidth: CGFloat(thumbWidth))
                  self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                if let imageUrl = list.video?.cover {
                    self.playVideoImage.isHidden = false
                    profileImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                }
            } else if let coverUrl = list.video?.cover, let imageUrl = URL(string: coverUrl) {
                //                self.getImageSize(urlString: coverUrl, list: list)
                self.imageViewHeightConstraint.constant = 400
                self.getImageHeight(imageUrl: imageUrl, list: list)
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
               
                profileImageView.sd_imageTransition = .fade
                self.profileImageView.sd_setImage(with: imageUrl.absoluteURL, placeholderImage: nil, options: .refreshCached) { (image : UIImage?, err : Error? ,SDImageCacheTypeMemory , url : URL?) in
                    if (err == nil) {
                        self.playVideoImage.isHidden = false
                        self.setNeedsLayout()
                    }
                }
            } else {
                self.imageViewHeightConstraint.constant = 250
                profileImageView.image = #imageLiteral(resourceName: "defaultVideoThumb")
            }
        } else {
            self.imageViewHeightConstraint.constant = 0
            profileImageView?.image = nil
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
        
//        if list.type == "photo" {
//            self.playVideoImage.isHidden = true
//            if let imageURL = list.photo?.cover, imageURL != "" {
//                self.profileImageView.sd_setShowActivityIndicatorView(true)
//                let url = URL(string: imageURL)
//                //                print("Image Height and Width == \(GetImageSize(url: url!))")
//                self.profileImageView.sd_setShowActivityIndicatorView(true)
//                self.profileImageView.sd_setIndicatorStyle(.gray)
//                self.profileImageView.sd_imageTransition = .fade
//                profileImageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { (downloadedImage, error, cache, url) in
//                    if let image = downloadedImage {
//                        DispatchQueue.main.async {
//                            self.profileImageView.image = image
//                                                        self.invalidateIntrinsicContentSize()
//                                                        self.setNeedsLayout()
//                                                        self.layoutIfNeeded()
//                                                        self.profileImageView.setNeedsDisplay()
//
//                        }
//                                                DispatchQueue.global(qos: .userInitiated).async {
//                                                    let modifiedImage = image
//                                                        .resizedImageWithinRect(rectSize: self.imageSize)
//                                                    SDWebImageManager.shared().saveImage(toCache: modifiedImage, for: url)
//
//                                                    DispatchQueue.main.async {
//                                                        self.profileImageView.image = modifiedImage
//                                                        self.profileImageView.setNeedsDisplay()
//                                                    }
//                                                }
//                                                self.layoutIfNeeded()
//                                                self.layoutSubviews()
//                    } else {
//                        self.profileImageView?.image = nil
//                                                self.layoutIfNeeded()
//                                                self.layoutSubviews()
//                    }
//                })
//
//            } else {
//                profileImageView?.image = nil
//                self.layoutIfNeeded()
//                self.layoutSubviews()
//            }
//        } else if list.type == "video"{
//            if let imageURL = list.video?.cover, imageURL != "" {
//                let url = URL(string: imageURL)
//                print("Image Height and Width == \(GetImageSize(url: url!))")
//                self.profileImageView.sd_setShowActivityIndicatorView(true)
//                self.profileImageView.sd_setIndicatorStyle(.gray)
//                self.profileImageView.sd_imageTransition = .fade
//                profileImageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { (downloadedImage, error, cache, url) in
//                    if let image = downloadedImage {
//                        self.playVideoImage.isHidden = false
//                        DispatchQueue.main.async {
//                            self.profileImageView.image = image
//                            self.invalidateIntrinsicContentSize()
//                            self.setNeedsLayout()
//                            self.layoutIfNeeded()
//                                self.profileImageView.setNeedsDisplay()
//                        }
//                                                DispatchQueue.global(qos: .userInitiated).async {
//                                                    let modifiedImage = image
//                                                        .resizedImageWithinRect(rectSize: self.imageSize)
//                                                    SDWebImageManager.shared().saveImage(toCache: modifiedImage, for: url)
//                                                    DispatchQueue.main.async {
//                                                        self.profileImageView.image = modifiedImage
//                                                        self.profileImageView.setNeedsDisplay()
//                                                    }
//                                                }
//                                                self.layoutIfNeeded()
//                                                self.layoutSubviews()
//                    } else {
//                        self.profileImageView?.image = nil
//                                                self.layoutIfNeeded()
//                                                self.layoutSubviews()
//                    }
//                })
//            }
//        } else {
//            self.playVideoImage.isHidden = true
//            profileImageView?.image = nil
//                        self.layoutIfNeeded()
//                        self.layoutSubviews()
//        }
        
    
    
    @IBAction func webViewButtonAction(_ sender: Any) {
        
        delegate?.didTapWebview(self.webViewButton)
    }
    
    @objc func didTapBlurView (_ sender: UITapGestureRecognizer) {
        
        delegate?.didTapOpenPurchase(self.shareTap)
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        if self.window != nil { return }
//        self.profileImageView.sd_cancelCurrentImageLoad()
        self.profileImageView.image = nil
        self.profileImageView.isHidden = true
        self.webViewLabel.text = ""
        self.webViewLabel.isHidden = true
        self.webViewLabel.backgroundColor = UIColor.clear
        self.statusLabel.text = ""
        self.statusLabel.text = nil
        self.albumcount.text = ""
        self.playVideoImage.isHidden = true
        self.socialLogoImageView.isHidden = true
        self.likeButton.imageView?.image = nil
        self.profileImageView.image = nil
//        self.likeButton.setImage(UIImage(named: "heart_empty"), for: .normal)
        self.statusLabel.isHidden = true
        self.daysLabel.isHidden = true
        self.blurView.isHidden = true
       
    }
    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        //        let height = layoutAttributes.frame.height
        
    }
    
    public func GetImageSize(url:URL) -> (width: CGFloat, height: CGFloat) {
        var imageWidth:CGFloat = 0
        var imageHeight:CGFloat = 0
        
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                imageWidth = imageProperties[kCGImagePropertyPixelWidth] as! CGFloat
                imageHeight = imageProperties[kCGImagePropertyPixelHeight] as! CGFloat
            }
        }
        
        return (width: imageWidth, height: imageHeight)
    }
    
    
}

