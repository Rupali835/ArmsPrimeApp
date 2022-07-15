//
//  LiveCommentTableViewCell.swift
//  Karan Kundra
//
//  Created by RazrTech2 on 19/03/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit

class LiveCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var CommenterName: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commenterProfileImage: UIImageView!
    
    var comment: LiveComment! {
        didSet {
            updateUI()
        }
    }
    let placeHolderImage = UIImage(named: "profileph")
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        commenterProfileImage.frame  = CGRect(x: commenterProfileImage.frame.origin.x, y: commenterProfileImage.frame.origin.y, width: 40, height: 40)
        commenterProfileImage.layer.borderWidth = 3
        commenterProfileImage.layer.borderColor = UIColor.red.cgColor
        commenterProfileImage.layer.masksToBounds = false
        commenterProfileImage.layer.cornerRadius = commenterProfileImage.frame.height / 2
        commenterProfileImage.clipsToBounds = true
        commenterProfileImage.backgroundColor = UIColor.clear
        
        self.commentView.layer.cornerRadius = commentView.layer.frame.height / 2
        self.commentView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
//       let imageUrl = URL(string: comment.imageUrl)
//            commenterProfileImage.sd_setImage(with: imageUrl, completed: nil)
        let imageUrl = URL(string: comment.imageUrl ?? "")
            commenterProfileImage.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, completed: nil)
        
        CommenterName.text = comment.senderFirstName
        commentLabel.text = comment.text
    }
}
