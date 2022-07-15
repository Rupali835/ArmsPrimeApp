//
//  BannerTableViewCell.swift
//  Multiplex
//
//  Created by Sameer Virani on 19/05/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    var bannerCount = 0
    var bannerTimer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateBannerCount(count: Int) {
        bannerCount = count
        if bannerTimer == nil {
            bannerTimer =  Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
        }
    }

    @objc func scrollAutomatically(_ timer1: Timer) {

        if let coll  = bannerCollectionView {
            for cell in coll.visibleCells {

                guard  let indexPath = coll.indexPath(for: cell) else {
                    return
                }


                if indexPath.row < bannerCount - 1 {
                  let nextIndexPath = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                    coll.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                } else {
                    let nextIndexPath = IndexPath.init(row: 0, section: indexPath.section)
                    coll.scrollToItem(at: nextIndexPath, at: .right, animated: false)
                }
            }
        }
    }
}
