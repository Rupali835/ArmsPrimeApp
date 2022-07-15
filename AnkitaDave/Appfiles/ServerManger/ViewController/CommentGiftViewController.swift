//
//  CommentGiftViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 03/10/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import SDWebImage

protocol CommentGiftControllerDelegate {
    
    func sendGift(giftImage: String, giftId: String,giftCoin:Int)
}

class CommentGiftViewController: BaseViewController, PurchaseContentProtocol {
    
    @IBOutlet weak var containerVIew: UIView!
    @IBOutlet weak var giftCollectionView: UICollectionView!
    var delegate: CommentGiftControllerDelegate?
    @IBOutlet var priceView: UIView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet weak var priceViewHeight: NSLayoutConstraint!
    var giftsDataArray : [Gift]!
    var quantityArray : Array<Any>!
    var multiplierTableView : UITableView! = nil
    var currentIndexPath,PrevIndexPath : Int!
    var selectedGift : Gift!
    var giftPrice = 0
    //    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        pageControl = UIPageControl(frame: CGRect(x: 0,y: 10,width: UIScreen.main.bounds.width,height: 5))
        //        let pages:Int = Int (floor(collectionView.contentSize.width / collectionView.frame.size.width));
        //        self.pageControl.currentPage = pages
        //        self.pageControl.tintColor = UIColor.red
        //        self.pageControl.pageIndicatorTintColor = UIColor.white
        //        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        //        self.view.addSubview(pageControl)
        
        self.priceView.isHidden = true
        
        //        if let purchaseStickers = CustomerDetails.purchase_stickers, purchaseStickers == false {
        //
        //             self.priceView.isHidden = false
        //        } else {
        //             self.priceView.isHidden = true
        //             self.priceViewHeight.constant = 10
        //           }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.incomingNotification(_:)), name:  NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        
        //        if let stickersPrice = giftPrice as? Int{
        //            self.priceLabel.text = "Premium stickers - \(stickersPrice)"
        //        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 5, right: 15)
        layout.itemSize = CGSize(width: 120, height: 100)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        self.giftCollectionView.collectionViewLayout = layout
        self.giftCollectionView.showsHorizontalScrollIndicator = false
        self.giftCollectionView.dataSource = self
        self.giftCollectionView.delegate = self
        self.giftCollectionView.isPagingEnabled = true
        self.giftCollectionView.backgroundColor = BlackThemeColor.lightBlack
        self.giftCollectionView.register(UINib.init(nibName: "GiftsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"GiftCellID" )
        


        
    }
    
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //
    //        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    //    }
    
    @objc func incomingNotification(_ notification: Notification) {
        if let text = notification.userInfo?["text"] as? String {
            print(text)
            // do something with your text
            self.priceView.isHidden = true
            self.priceViewHeight.constant = 10
        }
        
        
    }
    
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        self.showToast(message: "stickersPurchaseSuccessful")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
    }
}

extension CommentGiftViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.giftsDataArray != nil) {
            return self.giftsDataArray.count
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : GiftsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCellID", for: indexPath) as! GiftsCollectionViewCell
        
        
        //         let gifURL : String = "https://d1bng4dn08r9r5.cloudfront.net/gifts/thumb-1570445708.png"//"https://dl.kraken.io/web/5f925f7147af4c608025dba22ec136cd/ic_loading_icon.gif"
        //         let imageURL = UIImage.gifImageWithURL(gifURL)
        //        cell.giftsImageView.image = imageURL
        //        let imageView3 = UIImageView(image: imageURL)
        //        imageView3.frame = CGRect(x: 0.0, y: 0.0, width:70, height: 70.0)
        //        cell.gifView.addSubview(imageView3)
        
        
        
        if (self.giftsDataArray != nil) {
            let giftDict: Gift = self.giftsDataArray[indexPath.item]
            
            //            cell.imageHeight.constant = 70
            //            cell.imagewidth.constant = 70
            
            let photoDict = giftDict.spendingPhoto
            let strImageUrl : URL? = URL(string: photoDict?.thumb ?? "")
                        cell.giftsImageView.sd_imageIndicator?.startAnimatingIndicator()
                        //cell.giftsImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.giftsImageView.sd_imageTransition = .fade
                        cell.giftsImageView.sd_setImage(with: strImageUrl)
            
//            let imageURL = UIImage.gifImageWithURL(photoDict?.thumb ?? "")
//            if let image = imageURL {
//                cell.giftsImageView.image = image
//            } else {
//                cell.giftsImageView.image =  UIImage(named: "emoji-icon")
//            }
            
            cell.giftsImageView.layer.cornerRadius = cell.giftsImageView.frame.size.height/2
            cell.armsCoinImage.isHidden = true
            
            if giftDict.type == "paid"{
                let coin = giftDict.coins
                cell.armsCoinImage.isHidden = false
                cell.armsCoinImageWidth.constant = 15
                cell.coins.text = coin?.roundedWithAbbreviations
            } else {
                cell.armsCoinImage.isHidden = true
                cell.coins.text = "Free"
                cell.armsCoinImageWidth.constant = 0
            }
        }
        cell.layer.borderColor = UIColor.clear.cgColor
        return cell
    }
    
}

extension CommentGiftViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (currentIndexPath != nil) {
            PrevIndexPath = currentIndexPath
            let prevCell : GiftsCollectionViewCell? = collectionView.cellForItem(at: NSIndexPath.init(item: PrevIndexPath, section: 0) as IndexPath) as? GiftsCollectionViewCell
            //            prevCell?.backgroundColor = UIColor.white
            //            prevCell?.giftContainer.backgroundColor = UIColor.white
        } else {
            PrevIndexPath = indexPath.item
        }
        
        currentIndexPath = indexPath.item
        let cell : GiftsCollectionViewCell? = collectionView.cellForItem(at: indexPath) as? GiftsCollectionViewCell
        //        cell?.giftContainer.backgroundColor = UIColor.lightGray
        
        if (self.multiplierTableView != nil) {
            self.multiplierTableView.isHidden = true
        }
        
        selectedGift = self.giftsDataArray[indexPath.item]
        
        let giftId =  selectedGift.id
        let image = selectedGift.spendingPhoto?.thumb
        let coins = selectedGift.coins
        //        let price = selectedGift.stickers_price
        delegate?.sendGift(giftImage: image!, giftId: giftId!,giftCoin:coins!)
        //    }
    }
    
}

extension CommentGiftViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = ( collectionView.bounds.height / 2) - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
