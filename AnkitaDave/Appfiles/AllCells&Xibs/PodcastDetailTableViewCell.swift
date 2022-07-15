//
//  PodcastDetailTableViewCell.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 08/09/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit

protocol PodcastDetailTableViewCellDelegate: class {
    
    func didTapButton(_ sender: UIButton)
    func didLikeButton(_ sender: UIButton)
    func didShareButton(_ sender: UIButton)
   
}

class PodcastDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var podcastBackgroundView: UIView!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var playAnimationImage: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var daysAgo: UILabel!
    @IBOutlet weak var podcastCaption: UILabel!
    @IBOutlet weak var podcastTitleName: UILabel!
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var lockImage: UIImageView!
    weak var delegate: PodcastDetailTableViewCellDelegate?
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
       
//        self.podcastBackgroundView.layer.borderWidth = 1
//        self.podcastBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
//        self.podcastBackgroundView.clipsToBounds = true
        
    }

  
 
    @IBAction func shareButtonAction(_ sender: Any) {
         delegate?.didShareButton(self.shareButton)
    }
    
    @IBAction func likeButtonAction(_ sender: Any) {
         delegate?.didLikeButton(self.likeButton)
    }
    
    @IBAction func commentButtonAction(_ sender: Any) {
         delegate?.didTapButton(self.commentButton)
    }
}
