//
//  MediaTableViewCell.swift
//  Multiplex
//
//  Created by Sameer Virani on 19/05/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var mediaCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
        btnSeeAll.titleLabel?.font = UIFont(name: AppFont.light.rawValue, size: 17.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
