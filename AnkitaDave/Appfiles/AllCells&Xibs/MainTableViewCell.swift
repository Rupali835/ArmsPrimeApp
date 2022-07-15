//
//  MainTableViewCell.swift
//
//
//  Created by RazrTech2 on 21/02/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import SDWebImage
import SQLite

import CoreSpotlight
import MobileCoreServices
import SafariServices


protocol MainTableViewCellDelegate: class {
    func didTapButton(_ sender: UIButton)
    func didLikeButton(_ sender: UIButton)
    func didShareButton(_ sender: UIButton)
    func didTapOpenOptions(_ sender : UIButton)
    func didTapOpenPurchase(_ sender : UIButton)
    func didTapWebview(_ sender: UIButton)
}

extension VisualEffectView {
    func tint(_ color: UIColor, blurRadius: CGFloat) {
        self.colorTint = color
//        self.colorTintAlpha = 0.5
        self.blurRadius = blurRadius
    }
}

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var lockedContentImageView: UIImageView!
    @IBOutlet weak var cellNameLabel: UILabel!
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
    @IBOutlet weak var socialbackgroundView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var viewWidthLayout:
    NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var feedImageHeightConstraint:
    NSLayoutConstraint!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var playVideoImage: UIImageView!
    @IBOutlet weak var optionsView: UIView!
    //    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: MainTableViewCellDelegate?
    var editButton = UIButton()
    var isVideo = false
    let fetcher = ImageSizeFetcher()
    var tapGesture : UITapGestureRecognizer!
     var projects:[[String]] = []
    var list: List! {
        didSet {
            self.updateUI()
        }
    }
//    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)

    @IBOutlet weak var ageRatedLabel: UILabel!
    @IBOutlet weak var ratedView: UIView!
    @IBOutlet weak var videoLockedPadView: UIView!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var blurView: UIView!
    let imageSize = CGSize(width: 300, height: 400)
    @IBOutlet weak var videoViewCountView: UIView!
    @IBOutlet weak var viewVideoCountLabel: UILabel!
    let blurEffectView = VisualEffectView()
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        uiView.layer.cornerRadius = 20
        uiView.clipsToBounds = true

        profilePicImageView.borderWidth = 1
        profilePicImageView.borderColor = BlackThemeColor.yellow

        self.unlockView.isHidden = true
        
        socialbackgroundView.layer.cornerRadius = 5
        socialbackgroundView.clipsToBounds = true
        
        
        self.profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2
        self.profilePicImageView.layer.masksToBounds = false
        self.profilePicImageView.clipsToBounds = true
        self.profilePicImageView.backgroundColor = UIColor.clear
        self.profilePicImageView.image = UIImage(named: "celebrityProfileDP")
//        self.profileImageView.layer.cornerRadius = 15
//        self.profileImageView.clipsToBounds = true
        self.webViewLabel.layer.cornerRadius = 5
        self.webViewLabel.clipsToBounds =  true
        self.webViewLabel.layer.masksToBounds = false
        unlockdView.roundCorners(corners: [.topRight], radius: 25)
        unlockdView.roundCorners(corners: [.bottomRight], radius: 25)

        videoLockedPadView.roundCorners(corners: .topLeft, radius: 15)
        videoLockedPadView.roundCorners(corners: .bottomLeft, radius: 15)

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        clipsToBounds = false
        

//        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapBlurView(_ :)))
//                self.blurView.isUserInteractionEnabled = true
//                self.blurView.addGestureRecognizer(tapGesture)
//
//                self.socialLogoImageView.isHidden = true
//                optionsView.layer.cornerRadius = self.optionsView.frame.width/2;
//
//                playVideoImage.isHidden = true
//                self.clipsToBounds = true
//                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
//                let blurEffectView = UIVisualEffectView(effect: blurEffect)
//                blurEffectView.frame = blurView.bounds
//                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                self.blurView.addSubview(blurEffectView)
//                self.blurView.bringSubviewToFront(unlockView)
//                optionsView.layer.cornerRadius = 4.0
 
        cellNameLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        daysLabel.font = UIFont(name: AppFont.regular.rawValue, size: 13.0)
        likeCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        commentCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        statusLabel.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        webViewLabel.font = UIFont(name: AppFont.light.rawValue, size: 15.0)
        albumcount.font = UIFont(name: AppFont.bold.rawValue, size: 10.0)
        premiumLabel.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        cellNameLabel.text = Constants.celebrityName
        premiumView.roundCorners(corners: [.bottomRight], radius: 30)
        ageRatedLabel.font = UIFont(name: AppFont.regular.rawValue, size: 10.0)
//        ratedView.roundCorners(corners: [.topRight,.bottomRight], radius: 10.0)
        projects.append([(Constants.celebrityName )])
        projects.append([(cellNameLabel.text ?? "")])
        
        index(item: 0)
    }
    
    func updateUI() {
        
        if let isCaption = list.date_diff_for_human
        {
            self.daysLabel.isHidden = false
            self.daysLabel.text = isCaption.captalizeFirstCharacter()
            projects.append([(self.daysLabel.text ?? "")])
            index(item: 0)
        }
        
        self.albumcount.text = ""
        if list.is_album == "true" {
            projects.append([(list.is_album ?? "")])
            index(item: 0)
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
//        if list.age_restriction != nil {
//            if let age = list.age_restriction {
//                if age > 0 {
//                    self.ratedView.isHidden = false
//                    self.ageRatedLabel.text = "Rated \(age)+"
//                    projects.append([("Rated \(age)+")])
//                    index(item: 0)
//                }
//            }
//        } else {
//            self.ratedView.isHidden = true
//        }
        
        if list.age_restriction_label != nil {
            if let agelabel = list.age_restriction_label {
                self.ratedView.isHidden = false
                self.ageRatedLabel.text = "\(agelabel)"
                projects.append([("Rated \(agelabel)")])
                index(item: 0)
            }
        }else {
            self.ratedView.isHidden = true
        }
        self.webViewLabel.text = ""
        
        if let listLabel = list.webview_label, listLabel != "" {
            self.webViewLabel.isHidden = false
            self.webViewLabel.text = listLabel
            self.webViewButton.isUserInteractionEnabled = true
            self.webViewLabel.backgroundColor = hexStringToUIColor(hex: MyColors.cardBackground)
            projects.append([(listLabel)])
            index(item: 0)
        } else {
            self.webViewButton.isUserInteractionEnabled = false
            self.webViewLabel.backgroundColor = UIColor.clear
        }
        
        self.statusLabel.text = ""
        if list.name != "" && list.name != nil
        {
            self.statusLabel.isHidden = false
            self.statusLabel.text = list.name
            projects.append([(list.name ?? "")])
            index(item: 0)
        } else {
            self.statusLabel.isHidden = false
            self.statusLabel.text = list.name
            projects.append([(list.name ?? "")])
             index(item: 0)
        }
        if list.caption != "" && list.caption != nil
        {
            self.statusLabel.isHidden = false
            self.statusLabel.text = list.caption
            projects.append([(self.statusLabel.text ?? "")])
            index(item: 0)
        }
        
        if let likes = list.stats?.likes{
            self.likeCountLabel.text = likes.roundedWithAbbreviations  //formatPoints(num: Double(likes))//String(likes)
            projects.append([String(likes)])
            index(item: 0)
        }
        if let comments = list.stats?.comments{
            
            self.commentCountLabel.text = comments.roundedWithAbbreviations //formatPoints(num: Double(comments))//String(comments)
            projects.append([String(comments)])
            index(item: 0)
        }
        
        if list.type == "photo" {
            projects.append([(list.type ?? "")])
            index(item: 0)
            profileImageView.isHidden = false
            playVideoImage.isHidden = true
            
            if let thumbHeight = list.photo?.thumbHeight, let thumbWidth = list.photo?.thumbWidth {
                self.unlockView.isHidden = true  //free photo
                self.setImageHeight(currentHeight: CGFloat(thumbHeight), currentWidth: CGFloat(thumbWidth))
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                if let imageUrl = list.photo?.cover {
                    profileImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                }
            }
            else if let coverUrl = list.photo?.cover, let imageUrl = URL(string: coverUrl) {
                self.unlockView.isHidden = true  //free photo
              //  self.imageViewHeightConstraint.constant = 400
                self.getImageHeight(imageUrl: imageUrl, list: list)
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                profileImageView.sd_imageTransition = .fade
                profileImageView.sd_setImage(with: imageUrl.absoluteURL, placeholderImage: nil, options: .refreshCached) { (image : UIImage?, err : Error? ,SDImageCacheTypeMemory , url : URL?) in
                    self.setNeedsLayout()
                }
            }
            else if let blurphoto = list.blur_photo, let coin = list.coins //rupali
            {
                self.imageViewHeightConstraint.constant = 400
                
//                guard let l_img = list.blur_photo?.landscape else {
//                    return
//                }
//
//                guard let p_img = list.blur_photo?.portrait else {
//                    return
//                }
//
//                if p_img != "" && p_img != nil
//                {
//                    profileImageView.sd_setImage(with: URL(string: p_img), completed: nil)
//                    self.unlockView.isHidden = false
//                }
//                else if l_img != "" && l_img != nil
//                {
//                    profileImageView.sd_setImage(with: URL(string: l_img), completed: nil)
//                    self.unlockView.isHidden = false
//                }
                
                
                if let p_imageUrl = list.blur_photo?.portrait
                {
                    if p_imageUrl != "" && p_imageUrl != nil
                    {
                        profileImageView.sd_setImage(with: URL(string: p_imageUrl), completed: nil)
                        self.unlockView.isHidden = false
                    }else
                    {
                        if let l_imgurl = list.blur_photo?.landscape
                        {
                            if l_imgurl != "" && l_imgurl != nil
                            {
                                profileImageView.sd_setImage(with: URL(string: l_imgurl), completed: nil)
                                self.unlockView.isHidden = false
                            }
                        }
                    }
                    
                }
                else if let l_imgurl = list.blur_photo?.landscape {
                    
                    if l_imgurl != "" && l_imgurl != nil
                    {
                        profileImageView.sd_setImage(with: URL(string: l_imgurl), completed: nil)
                        self.unlockView.isHidden = false
                    }
                    

                }
                
            }
            
            else {
                self.imageViewHeightConstraint.constant = 0
                self.playVideoImage.isHidden = true
                profileImageView?.image = nil
                self.layoutIfNeeded()
                self.layoutSubviews()
            }
            durationView.isHidden = true
            durationLabel.isHidden = true
            self.videoViewCountView.isHidden = true
        } else if list.type == "video"{
            projects.append([(list.type ?? "")])
             index(item: 0)
            profileImageView.isHidden = false
            if let thumbHeight = list.video?.thumbHeight, let thumbWidth = list.video?.thumbWidth {
                self.setImageHeight(currentHeight: CGFloat(thumbHeight), currentWidth: CGFloat(thumbWidth))
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                if let imageUrl = list.video?.cover {
                    self.playVideoImage.isHidden = false
                    profileImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                    projects.append([(imageUrl )])
                    index(item: 0)
                }
            } else if let coverUrl = list.video?.cover, let imageUrl = URL(string: coverUrl) {
                //                self.getImageSize(urlString: coverUrl, list: list)
                projects.append([(coverUrl)])
                index(item: 0)
                self.imageViewHeightConstraint.constant = 400
                self.getImageHeight(imageUrl: imageUrl, list: list)
                self.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImageView.sd_imageTransition = .fade
                profileImageView.sd_imageTransition = .fade
                profileImageView.sd_setImage(with: imageUrl.absoluteURL, placeholderImage: nil, options: .refreshCached) { (image : UIImage?, err : Error? ,SDImageCacheTypeMemory , url : URL?) in
                    if (err == nil) {
                        self.playVideoImage.isHidden = false
                        self.setNeedsLayout()
                    }
                }

            } else {
                self.imageViewHeightConstraint.constant = 250
                profileImageView.image = UIImage(named: "image placeholder")
            }
            
            if  list.Duration != nil && list.Duration != "" {
                durationView.isHidden = false
                durationLabel.isHidden = false
                durationLabel.text = list.Duration
                projects.append([(list.Duration ?? "")])
                index(item: 0)
                
            } else {
                durationView.isHidden = true
                durationLabel.isHidden = true
                
            }
            
            if let view = list.stats?.views{
                self.videoViewCountView.isHidden = false
                self.viewVideoCountLabel.text = view.roundedWithAbbreviations
            } else {
                self.videoViewCountView.isHidden = true
            }
            
        } else {
            self.imageViewHeightConstraint.constant = 0
            profileImageView?.image = nil
            durationView.isHidden = true
            durationLabel.isHidden = true
            self.videoViewCountView.isHidden = true
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

    @IBAction func didTapOptionsButton(_ sender: UIButton) {
        UserDefaults.standard.setValue(list._id, forKey: "entityId")
        UserDefaults.standard.synchronize()
        delegate?.didTapOpenOptions(sender)
    }
    
    @IBAction func didTapOpenHideContetnt(_ sender: UIButton) {
        
        delegate?.didTapOpenPurchase(self.shareTap)
         
    }
    
    
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
    
    func index(item:Int) {

      let project = projects[item]
      let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
      attrSet.title = project[0]
      //attrSet.contentDescription = project[1]
        attrSet.contentDescription = project[0]

      let item = CSSearchableItem(
          uniqueIdentifier: "\(item)",
          domainIdentifier: "kho.arthur",
          attributeSet: attrSet )

      CSSearchableIndex.default().indexSearchableItems( [item] )
      { error in

        if let error = error
        { print("Indexing error: \(error.localizedDescription)")
        }
        else
        { print("Search item successfully indexed.")
        }
      }

    }


    func deindex(item:Int) {

      CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"])
      { error in

        if let error = error
        { print("Deindexing error: \(error.localizedDescription)")
        }
        else
        { print("Search item successfully removed.")
        }
      }

    }
     
    
}
