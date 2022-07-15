//
//  CommentTextCollectionViewCell.swift
//  SaraKhan
//
//  Created by Rohit Mac Book on 16/12/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import UIKit

class CommentTextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.commentView.layer.cornerRadius = commentView.layer.frame.height / 2
            self.commentView.clipsToBounds = true
            self.commentView.borderWidth = 1
            self.commentView.borderColor = .white
       
    }
    

}
