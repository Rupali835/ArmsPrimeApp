//
//  WardrobeOrderTableViewCell.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 21/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit

class WardrobeOrderTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgProductView: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var btnStatus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        let colors = [hexStringToUIColor(hex: "F6AE7B"), hexStringToUIColor(hex: "E77C2D")]
        imgProductView.setGradientBackground(color: colors)
    }
    
    func configurCell(order: OrderList) {
        
        if let media = order.product?.media, media.count > 0 {
            if let img = media[0].url, let url = URL(string: img) {
                imgProduct.sd_setImage(with: url, completed: nil)
            }
        }
       
        if let name = order.product?.name {
            lblProductName.text = name
        }
        
        if let id = order._id {
            lblOrderID.text = id
        }
        
        if let date = order.created_at {
            lblOrderDate.text = date
        }
        
        if let coins = order.coins {
            lblCoin.text = "\(coins)"
        }
        
        if let status = order.delivery_info?.delivery_status {
            btnStatus.setTitle(status, for: .normal)
        }
    }
}
