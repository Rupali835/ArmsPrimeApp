//
//  ProductCell.swift
//  Karan Kundrra Official
//
//  Created by RazrTech2 on 11/05/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit
import StoreKit

enum ProductCellViewState {
    case fromLiveView
    case fromPurchaseView
}

class ProductCell: UITableViewCell {

    @IBOutlet weak var coinCountLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var coinBackgroundView: UIView!
    
    @IBOutlet weak var priceView: UIView!
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    var productPrice = ""
    
    var buyButtonHandler: ((_ product: SKProduct) -> ())?

    var viewState: ProductCellViewState? {
        didSet {
            if let state = viewState, state == .fromLiveView {
//                PriceLabel.textColor = .darkGray
//                coinCountLabel.textColor = .darkGray
//                priceView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .darkGray)
            } else {
//                PriceLabel.textColor = .white
//                coinCountLabel.textColor = .white
//                priceView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .white)
            }
        }
    }
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            self.localizePrice(product: product)
            coinCountLabel?.text = product.localizedTitle
            if InAppPurchaseHelper.canMakePayments() {
                ProductCell.priceFormatter.locale = product.priceLocale
                PriceLabel.text = ProductCell.priceFormatter.string(from: product.price)!
//                accessoryType = .none
//                accessoryView = newBuyButton()
                coinImageView?.image = UIImage(named: "armsCoin")
            } else {
                textLabel?.text = "Not available"
            }
        }
    }
    //MARK:-
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
        detailTextLabel?.text = ""
        accessoryView = nil
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        coinBackgroundView.clipsToBounds = true
//        coinBackgroundView.layer.cornerRadius = 20
//
//        if #available(iOS 11.0, *) {
//            coinBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//            coinBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMaxYCorner]
//
//        } else {
//            // Fallback on earlier versions
//        }
        

//        PriceLabel.textColor = .white
        productView.layer.cornerRadius = 4
        productView.clipsToBounds = true
//        self.productView.layer.borderWidth = 1
//        self.productView.layer.borderColor = hexStringToUIColor(hex: MyColors.casual).cgColor
//        self.productView.layer.masksToBounds = false
        
        self.PriceLabel.layer.cornerRadius = PriceLabel.layer.frame.height / 2
        self.PriceLabel.clipsToBounds = true

        priceView.layer.cornerRadius = 4
        priceView.clipsToBounds = true
        
        productView.addunderlined()
        PriceLabel.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
        coinCountLabel.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
    }
    
    func newBuyButton() -> UIButton {
        let button = UIButton(type: .system)
        var buttonFrame = button.frame
        buttonFrame.size = CGSize(width: 150, height: button.frame.height)
        button.frame = buttonFrame
        
//        button.layer.borderWidth = 1.0
//        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5
        button.setTitleColor(tintColor, for: UIControl.State())
        button.setTitle(self.productPrice, for: UIControl.State())
        button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        return button
    }
    
    @objc func buyButtonTapped(_ sender: AnyObject) {
        buyButtonHandler?(product!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func localizePrice(product: SKProduct) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        let cost = formatter.string(from: product.price)!
        print(cost)
        print("===============")
    }

}
