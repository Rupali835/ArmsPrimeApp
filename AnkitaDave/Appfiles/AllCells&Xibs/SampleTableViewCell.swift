//
//  SampleTableViewCell.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 18/05/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit

class SampleTableViewCell: UITableViewCell {

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

    @IBOutlet weak var imageHeight: NSLayoutConstraint!

    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var playVideoImage: UIImageView!
    var editButton = UIButton()
    var isVideo = false
    
 //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        if self.window != nil { return }
        self.profileImageView.sd_cancelCurrentImageLoad()
        self.profileImageView.image = nil
        self.statusLabel.text = ""
    }
    
//    func setImage(withUrlString urlString: String, completion: @escaping () -> Void) {
//        // Need to store the URL because cells will be reused. The check is in adjustBannerHeightToFitImage.
//       
//        
//        // Flush first. Or placeholder if you have.
//        profileImageView.image = nil
//        
//        guard let url = URL(string: urlString) else { return }
//        profileImageView.contentMode = .scaleAspectFit
//        
//        // Loads the image asynchronously
//        profileImageView.sd_setImage(with: url.absoluteURL, placeholderImage: #imageLiteral(resourceName: "whiteView34") , options: .cacheMemoryOnly) { (image : UIImage?, err : Error? ,SDImageCacheTypeMemory , url : URL?) in
//            self.profileImageView.contentMode = .scaleAspectFit
//            let imageSIze =  self.profileImageView.intrinsicContentSize
//            self.imageHeight.constant = imageSIze.height
//          
//            completion()
//            self.setNeedsLayout()
//        }
//    }
//    
//    class ScaledHeightImageView: UIImageView {
//        
//        override var intrinsicContentSize: CGSize {
//            
//            if let myImage = self.image {
//                let myImageWidth = myImage.size.width
//                let myImageHeight = myImage.size.height
//                let myViewWidth = self.frame.size.width
//                
//                let ratio = myViewWidth/myImageWidth
//                let scaledHeight = myImageHeight * ratio
//                
//                return CGSize(width: myViewWidth, height: scaledHeight)
//            }
//            
//            return CGSize(width: -1.0, height: -1.0)
//        }
//        
//    }
//
    
    
//    internal var aspectConstraint : NSLayoutConstraint? {
//        didSet {
//            if oldValue != nil {
//                profileImageView.removeConstraint(oldValue!)
//            }
//            if aspectConstraint != nil {
//                profileImageView.addConstraint(aspectConstraint!)
//            }
//        }
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        aspectConstraint = nil
//    }
//    
//    func setCustomImage(image : UIImage) {
//        
//        let aspect = image.size.width / image.size.height
//        
//        let constraint = NSLayoutConstraint(item: profileImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: profileImageView, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
//        constraint.priority = UILayoutPriority(rawValue: 999)
//        
//        aspectConstraint = constraint
//        
//        profileImageView.image = image
//    }

 
    
}
