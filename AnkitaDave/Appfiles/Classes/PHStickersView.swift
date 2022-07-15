//
//  PHStickersView.swift
//  Producer
//
//  Created by developer2 on 16/11/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import UIKit

class PHStickerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgViewPic: UIImageView!
    @IBOutlet weak var cnstImgViewPicHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstImgViewPicWidth: NSLayoutConstraint!
    @IBOutlet weak var lblPrice: UILabel!
}

protocol PHStickersViewDelegate {
    
    func didSelectSticker(stickerView: PHStickersView, sticker: CommentSticker)
    func didCloseSticker()
}

class PHStickersView: UIView {

    @IBOutlet weak var cvStickers: UICollectionView!
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var cnstPageIndicatorBottom: NSLayoutConstraint!
    @IBOutlet weak var viewClose: UIView!
    
    var delegate: PHStickersViewDelegate? = nil
    
    var arrStickers = [CommentSticker]()
    
    var web: WebService? = nil
    var apiCallStatus = (isCalling:false, page:1, isLoadMore:false, isFirstCall: true)
    
    var isFirstPageOnly = false
    
    var cellHeight: CGFloat = 0
    var cellWidth: CGFloat = 0
    
    override func awakeFromNib() {
        
        self.cvStickers.isHidden = false
        self.pageIndicator.isHidden = true
        self.activity.isHidden = true
        self.btnRetry.isHidden = true
//        self.cvStickers.backgroundColor = .white
        self.pageIndicator.isUserInteractionEnabled = false
//        self.backgroundColor = blackthem
        self.viewClose?.isHidden = true
//        self.pageIndicator.tintColor = appearences.placeholderColor
//        self.pageIndicator.currentPageIndicatorTintColor = appearences.redColor
        
        if PHStickerLoader.shared.arrStickers.count == 0 {
            
            PHStickerLoader.shared.loadStickers()
        }

        
        self.setLayoutAndDesigns()
        self.backgroundColor = BlackThemeColor.darkBlack
    }
    
    // MARK: - IBActions
    @IBAction func btnRetryClicked() {
        
        PHStickerLoader.shared.loadStickers()
                
        addStickers()
        
        //webGetStickers(isRefresh: true)
    }
    
    @IBAction func btnCloseClicked() {
        
        self.delegate?.didCloseSticker()
    }
    
    // MARK: - Utility Methods
    func setLayoutAndDesigns() {
        
//        pageIndicator.currentPageIndicatorTintColor = appearences.redColor
//        pageIndicator.pageIndicatorTintColor = appearences.placeholderColor
        
        activity.tintColor = appearences.redColor
        activity.stopAnimating()
        
        cvStickers.delegate = self
        cvStickers.dataSource = self
        
        if isFirstPageOnly {
        
            pageIndicator.isHidden = true
            cvStickers.isPagingEnabled = false
        }
        
        addObservers()
        
        addStickers()
                
        //webGetStickers(isRefresh: true)
    }
    
    func addStickers() {

        if PHStickerLoader.shared.isCallingAPI {

            self.activity.startAnimating()
            self.activity.isHidden = false
            self.btnRetry.isHidden = true

            return
        }

        if PHStickerLoader.shared.arrStickers.count > 0 {

            let stickers = PHStickerLoader.shared.arrStickers
            
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.btnRetry.isHidden = true

            let pages = Double(stickers.count)/12.0
            pageIndicator.numberOfPages = Int(ceil(pages))

            arrStickers.removeAll()

            if isFirstPageOnly {
                
                pageIndicator.isHidden = true
                
                if stickers.count > 10 {
                    
                    arrStickers.append(contentsOf: stickers[0...9])
                }
                else {

                    arrStickers.append(contentsOf: stickers)
                }
                
                viewClose.isHidden = false
            }
            else {

                pageIndicator.isHidden = false
                arrStickers.append(contentsOf: stickers)
            }

            cvStickers.reloadData()
        }
        else {

            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.btnRetry.isHidden = false
        }
    }
    
    func addObservers() {
        
        Notifications.stickersLoaded.add(viewController: self, selector: #selector(stickersLoaded))
    }
    
    @objc func stickersLoaded() {
        
        addStickers()
    }
}

// MARK: - CollectionView Delegte & DataSource Methods
extension PHStickersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrStickers.count == 0 && !apiCallStatus.isFirstCall && btnRetry.isHidden {
            
            collectionView.setPlaceholder(title: "", detail: stringConstants.noStickersFound)
        }
        else {
            
            collectionView.backgroundView = nil
        }
        
        return arrStickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isFirstPageOnly {
            
            cellHeight = collectionView.frame.size.height - 18
            
            let collectionWidth: CGFloat = collectionView.frame.size.width
            
            let numberOfCell = Int(collectionWidth / cellHeight)
            
            cellWidth = collectionWidth / CGFloat(numberOfCell)
            
            cellWidth =  cellWidth - ((cellWidth * 0.60) / CGFloat(numberOfCell))
            
            if cellWidth < 0 {
                
                cellWidth = 0
            }
            
            if cellHeight < 0 {
                
                cellHeight = 0
            }
        }
        else {
            
            let numberOfCell: CGFloat = 4
            
            cellWidth = (macros.screenWidth) / numberOfCell
            
            if cellWidth < 0 {
                
                cellWidth = 0
            }
            
            cellHeight = (collectionView.frame.size.height/3) - 12
            
            if cellHeight < 0 {
                
                cellHeight = 0
            }
        }
        
        return CGSize.init(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if isFirstPageOnly {
            
            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PHStickerCollectionCell", for: indexPath) as! PHStickerCollectionCell
        
        let sticker = arrStickers[indexPath.row]
        
        if let photo = sticker.photo?.thumb {
            
            cell.imgViewPic.sd_imageTransition = .fade
            
            cell.imgViewPic.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "sticker_placeholder"), options: .highPriority, context: [:])
        }
        
        cell.imgViewPic.backgroundColor = .clear
        cell.imgViewPic.contentMode = .scaleAspectFit
        
        if isFirstPageOnly {
            
            cell.cnstImgViewPicHeight.constant = cellHeight - 18
            cell.cnstImgViewPicWidth.constant = cellWidth - 10
        }
        else {
            
            cell.cnstImgViewPicHeight.constant = cellHeight - 18
            cell.cnstImgViewPicWidth.constant = cellWidth - 10
        }
        
        if let price = sticker.coins {
            
            cell.lblPrice?.text = "\(price)"
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        if apiCallStatus.isLoadMore && !isFirstPageOnly && !apiCallStatus.isCalling {
//
//            webGetStickers(isRefresh: false)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sticker = arrStickers[indexPath.row]

        self.delegate?.didSelectSticker(stickerView: self, sticker: sticker)
    }
}

// MARK: - ScrollView Delegate Methods
extension PHStickersView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == cvStickers {
            
            let index = scrollView.contentOffset.x/cvStickers.frame.size.width
            
            pageIndicator?.currentPage = Int(ceil(index))
        }
    }
}

// MARK: - Web Service Methods
extension PHStickersView {
    
    func webGetStickers(isRefresh: Bool) {
        
//        web?.cancel()
//
//        if isRefresh {
//
//            self.activity.startAnimating()
//            self.activity.isHidden = false
//        }
//
//        self.btnRetry.isHidden = true
//
//        var dictParams = [String:Any]()
//
//        if isRefresh {
//
//            dictParams["page"] = 1
//        }
//        else {
//
//            dictParams["page"] = apiCallStatus.page + 1
//        }
//
//        apiCallStatus.isCalling = true
//
//        let api = webConstants.stickers
//
//        let web = WebService(showInternetProblem: false, isCloud: false, loaderView: nil)
//
//        web.execute(type: .get, name: api, params: dictParams as [String : AnyObject]) { (status, msg, dict) in
//
//            self.viewClose?.isHidden = false
//
//            self.apiCallStatus.isFirstCall = false
//            self.apiCallStatus.isLoadMore = false
//            self.apiCallStatus.isCalling = false
//            self.activity.stopAnimating()
//            self.activity.isHidden = true
//            self.cvStickers.reloadData()
//
//            if status {
//
//                guard let dictRes = dict else {
//
//                    return
//                }
//
//                if let error = dictRes["error"] as? Bool, error == true {
//
//                    if let arrErrors = dictRes["error_messages"] as? [String] {
//
//                    }
//                    else {
//
//                    }
//
//                    self.btnRetry.isHidden = false
//
//                    return
//                }
//
//                guard let dictData = dictRes["data"] as? [String:Any] else {
//
//                    self.btnRetry.isHidden = false
//
//                    return
//                }
//
//                guard let arrStickers = dictData["list"] as? [Any] else {
//
//                    self.btnRetry.isHidden = false
//
//                    return
//                }
//
//                if let paginate_data = dictData["paginate_data"] as? [String: Any] {
//
//                    if let pagination = PaginationStats.object(paginate_data) {
//
//                        if let last_page = pagination.last_page, let current_page = pagination.current_page {
//
//                            if last_page > current_page {
//
//                                self.apiCallStatus.isLoadMore = true
//                            }
//                        }
//
//                        if let totalPages = pagination.last_page, totalPages > 1 , self.isFirstPageOnly == false {
//
//                            self.setNumberOfPages(pagination)
//                            self.pageIndicator.isHidden = false
//                        }
//                        else {
//
//                            self.pageIndicator.isHidden = true
//                        }
//                    }
//                    else {
//
//                        self.pageIndicator.isHidden = true
//                    }
//                }
//
//                print(arrStickers)
//
//                if let stickers = CommentSticker.object(arrStickers) {
//
//                    if stickers.count > 0 {
//
//                        if isRefresh {
//
//                            self.arrStickers.removeAll()
//                            self.arrStickers.append(contentsOf: stickers)
//
//                            self.apiCallStatus.page = 1
//                        }
//                        else {
//
//                            self.arrStickers.append(contentsOf: stickers)
//                            self.apiCallStatus.page = self.apiCallStatus.page + 1
//                        }
//
//                        self.btnRetry.isHidden = true
//                    }
//                }
//
//                self.cvStickers.reloadData()
//            }
//            else {
//
//                self.btnRetry.isHidden = false
//            }
//        }
    }
    
    func setNumberOfPages(_ pagination: PaginationStats) {
        
//        "paginate_data" =     {
//            "current_page" = 1;
//            "first_page_url" = "";
//            from = 1;
//            "last_page" = 4;
//            path = "";
//            "per_page" = 12;
//            to = 12;
//            total = 37;
//        }
        
        if let totalItems = pagination.total {
            
            let pages = Double(totalItems)/12.0
            
            pageIndicator.numberOfPages = Int(ceil(pages))
        }
    }
}
