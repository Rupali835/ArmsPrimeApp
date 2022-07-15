//
//  GiftsViewController.swift
//  Karan Kundrra Official
//
//  Created by Razr Corp on 17/05/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import UIKit

protocol GiftsViewControllerDelegate {
    func sendGift(giftImage: String, giftId: String, combo: String, cost: Int)
}

class GiftsViewController: BaseViewController {
    
    @IBOutlet weak var sendContainer : UIView!
    @IBOutlet weak var norecentStickerView : UIView!
    @IBOutlet weak var totalCoinsView : UIView!
    @IBOutlet weak var sendContentview: UIView!
    @IBOutlet weak var totalCoins: UILabel!
    @IBOutlet weak var containerVIew: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var giftCollectionView: UICollectionView!
    @IBOutlet weak var giftsMultiplierButton: UIButton!
    @IBOutlet weak var multiplerValue: UIButton!
    @IBOutlet weak var buyCoinsButton: UIButton!

    @IBOutlet weak var recentButton : UIButton!
    @IBOutlet weak var allstickerButton : UIButton!

    var multiplierTableView : UITableView! = nil
    var currentIndexPath,PrevIndexPath : Int!
    var selectedGift : Gift!
    var giftsDataArray : [Gift]!
    var quantityArray : Array<Any>!
    var currentMulitiplierValue : String!
    var isLogin = false
    var delegate: GiftsViewControllerDelegate?
    var purchaseCoinOnLiveController: PurchaseCoinOnLiveViewController?
    var recentGiftArray: [Gift]?
//    var selectedState: GiftViewState = .all
    var giftDataSource = [Gift]()

    enum GiftViewState {
        case recent(giftArray: [Gift])
        case all(giftArray: [Gift])
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        buyCoinsButton.addBorderWithCornerRadius(width: 2, cornerRadius: 8, color: BlackThemeColor.yellow)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCoins(_:)), name: NSNotification.Name(rawValue: "updatedCoins"), object: nil)
        
        totalCoins.text = "\(CustomerDetails.coins ?? 0)"
        if (quantityArray != nil && quantityArray.count > 0) {
            currentMulitiplierValue = "\(quantityArray[0])"
        } else {
            currentMulitiplierValue = "1"
        }
        self.sendContentview.layer.borderWidth = 1.0
        self.sendContentview.layer.borderColor  = UIColor.gray.cgColor
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 2)
        layout.itemSize = CGSize(width: 100, height: 80)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
//        self.giftCollectionView.contentInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        self.giftCollectionView.collectionViewLayout = layout
        self.giftCollectionView.showsHorizontalScrollIndicator = false
        self.giftCollectionView.dataSource = self
        self.giftCollectionView.delegate = self
        self.giftCollectionView.isPagingEnabled = true
//        self.giftCollectionView.backgroundColor = UIColor.white
        self.giftCollectionView.register(UINib.init(nibName: "GiftsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"GiftCellID" )
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapOnView(_ :)))
        self.sendContainer.tag = 5052
        self.sendContainer.addGestureRecognizer(tapGesture)

        sendContentview.layer.borderWidth = 1
        sendContentview.layer.borderColor = BlackThemeColor.yellow.cgColor
        sendContentview.layer.cornerRadius = 5
        
        let tapOnCoinsView : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapOnCoinsView(_ :)))
        self.totalCoinsView.addGestureRecognizer(tapOnCoinsView)
        if (UserDefaults.standard.object(forKey: "LoginSession") != nil) {
            if (UserDefaults.standard.object(forKey: "LoginSession") as! String == "LoginSessionIn") {
                self.isLogin = true
            }
        }

        if (self.isLogin) {
            self.totalCoinsView.isHidden = false
        } else {
            self.totalCoinsView.isHidden = true
        }

         let isBuyButtonEnable = RCValues.sharedInstance.bool(forKey: .showBuyCoinsLiveBtniOS)
        buyCoinsButton.isHidden = !isBuyButtonEnable

        let recentgiftarray = fetchRecentGifts()
        if recentgiftarray.count > 0 {
            setViewState(state: .recent(giftArray: recentgiftarray))
        } else {
            setViewState(state: .all(giftArray: giftsDataArray))
        }
        self.view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        containerVIew.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
    }

    private func fetchRecentGifts() -> [Gift] {
        if let recentGiftsData = UserDefaults.standard.array(forKey:  UserDefaultKey.recentSticker.rawValue) as? [Data]{
                   return  recentGiftsData.map { try! JSONDecoder().decode(Gift.self, from: $0) }
        }
        return []
    }

    private func setViewState(state: GiftViewState) {
        if multiplierTableView != nil {
            multiplierTableView.isHidden = true
        }

        switch state {
        case .all(let giftArray):
            norecentStickerView.isHidden = true
            giftDataSource = giftArray
            selectAllsticker()
            pageControl.isHidden = false
            pageControl.currentPage = 0
        case .recent(let giftArray):

            if giftArray.count > 0 {
                    norecentStickerView.isHidden = true
            } else {
                    norecentStickerView.isHidden = false
            }
            pageControl.isHidden = true
            giftDataSource = giftArray
            selectRecentButton()
        }
        currentIndexPath = nil
        giftCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "GiftSend"), object: nil)
    }
    
    @objc func updateCoins(_ notification: NSNotification) {
        if let coins = notification.userInfo?["updatedCoins"] as? Int {
            totalCoins.text = "\(coins)"
            CustomerDetails.coins = coins
            let database = DatabaseManager.sharedInstance
            database.updateCustomerCoins(coinsValue: CustomerDetails.coins)
            checkMobileVerification()
        }
    }
    
    @objc func didTapOnView(_ sender : UIGestureRecognizer )  {
        
        if (multiplierTableView != nil && sender.view?.tag == 5052) {
            
            multiplierTableView.isHidden = true
        }
    }
    
    @objc func didTapOnCoinsView(_ sender : UIGestureRecognizer )  {
        
        if (multiplierTableView != nil) {
            
            multiplierTableView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didTapGiftsView(_ sender : UIGestureRecognizer) {
        if (self.multiplierTableView != nil) {
            self.multiplierTableView.isHidden = true
        }
    }

    private func selectRecentButton() {

        recentButton.setTitleColor(BlackThemeColor.yellow, for: .normal)
            allstickerButton.setTitleColor(BlackThemeColor.tabGray, for: .normal)

        if let selectedImage = UIImage(named: "recentSelected") {
            recentButton.setImage(selectedImage, for: .normal)
        }
        if let unselectedSticker = UIImage(named: "allstickerUnselected") {
            allstickerButton.setImage(unselectedSticker, for: .normal)
        }
    }

    private func selectAllsticker() {
        recentButton.setTitleColor(BlackThemeColor.tabGray, for: .normal)
        allstickerButton.setTitleColor(BlackThemeColor.yellow, for: .normal)

            if let selectedImage = UIImage(named: "allstickerSelected") {
                   allstickerButton.setImage(selectedImage, for: .normal)
               }
               if let unselectedSticker = UIImage(named: "recentUnselected") {
                  recentButton.setImage(unselectedSticker, for: .normal)
               }
    }

    @IBAction func recentClick(sender: Any) {
       let recentGifts = fetchRecentGifts()
        setViewState(state: .recent(giftArray: recentGifts))
    }

    @IBAction func AllStikerClick(sender: Any) {
        setViewState(state: .all(giftArray: giftsDataArray))
    }
    
    @IBAction func onSelectGiftsMultiplier(_ sender: Any) {
        if (multiplierTableView == nil) {
            multiplierTableView  = UITableView.init(frame: CGRect(x: self.sendContentview.frame.origin.x + (self.sendContentview.frame.width / 2) - 30, y: (self.containerVIew.frame.maxY - self.sendContentview.height) - 210, width: 60, height: 200))
            multiplierTableView.dataSource = self
            multiplierTableView.delegate = self
            self.view.addSubview(multiplierTableView)
            multiplierTableView.layer.borderWidth = 1.0
            multiplierTableView.backgroundColor = BlackThemeColor.lightBlack
            multiplierTableView.layer.borderColor = BlackThemeColor.yellow.cgColor
            multiplierTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "GiftMultiplierCellID")
            multiplierTableView.separatorStyle = .none
            self.view.bringSubviewToFront(multiplierTableView)
        } else {
            self.multiplierTableView.isHidden = !self.multiplierTableView.isHidden
        }
        
    }

    @IBAction func rechargeOnClick(sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        self.purchaseCoinOnLiveController = story.instantiateViewController(withIdentifier: "PurchaseCoinOnLiveViewController") as? PurchaseCoinOnLiveViewController
        guard let purchaseCoinOnLiveController = self.purchaseCoinOnLiveController else {
            return
        }

        purchaseCoinOnLiveController.view.frame = CGRect(x: 0, y: self.view.frame.size.height
                - 300, width: self.view.frame.size.width, height: 300)
        self.view.addSubview(purchaseCoinOnLiveController.view)
        self.view.bringSubviewToFront(purchaseCoinOnLiveController.view)
    }
    
    @IBAction func onSelectGiftSend(_ sender: Any) {
        guard (selectedGift != nil) else {
            showToast(message: "Please select gift.")
            return
        }
        if let giftPrice = selectedGift.coins, let giftId =  selectedGift.id{
            if let image = selectedGift.spendingPhoto?.thumb {
                guard (CustomerDetails.coins != nil) else {
                    return
                }
                if let currentCoins = CustomerDetails.coins, let comboNumber = Int(currentMulitiplierValue), currentCoins >= (giftPrice * comboNumber) {
                        CustomerDetails.coins = currentCoins - (giftPrice * comboNumber)
                    totalCoins.text = "\(CustomerDetails.coins ?? 0)"
                    self.delegate?.sendGift(giftImage: image, giftId: giftId, combo: currentMulitiplierValue, cost: giftPrice)
                    saveSelectedGift(gift:selectedGift )
                } else {
                    self.showToast(message: "Not Enough coins please recharge")
                }
            }
        }
        
    }

    private func saveSelectedGift(gift: Gift) {
        if let recentGiftsData = UserDefaults.standard.array(forKey:  UserDefaultKey.recentSticker.rawValue) as? [Data]{
            var giftarray = recentGiftsData.map { try! JSONDecoder().decode(Gift.self, from: $0) }

            let filterselectedGift = giftarray.filter { $0.id == gift.id }
            if filterselectedGift.count > 0 {
                return
            }

            giftarray.insert(gift, at: 0)
            if giftarray.count > 12 {
                giftarray.removeLast()
            }
            let giftArrayData = giftarray.map({ try? JSONEncoder().encode($0) })
            UserDefaults.standard.set(giftArrayData, forKey: UserDefaultKey.recentSticker.rawValue)
        } else {
            let giftArray = [gift]
            let giftArrayData = giftArray.map({ try? JSONEncoder().encode($0) })
            UserDefaults.standard.set(giftArrayData, forKey: UserDefaultKey.recentSticker.rawValue)
        }
    }
    
}

extension GiftsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quantityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftMultiplierCellID", for: indexPath)
        cell.backgroundColor = BlackThemeColor.lightBlack
        cell.textLabel?.textColor = BlackThemeColor.yellow
        cell.textLabel?.text =  "\(quantityArray[indexPath.row])"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 10.0)
        return cell
    }
    
}

extension GiftsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isHidden = true
        currentMulitiplierValue = "\(quantityArray[indexPath.row])"
        self.multiplerValue.setTitle("×\(currentMulitiplierValue!)" , for: .normal)
    }
    
}

extension GiftsViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.giftDataSource != nil) {
            return self.giftDataSource.count
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : GiftsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCellID", for: indexPath) as! GiftsCollectionViewCell
        if (self.giftDataSource != nil) {
            let giftDict: Gift = self.giftDataSource[indexPath.item]
            
            
            let photoDict = giftDict.spendingPhoto
                        let strImageUrl : URL? = URL(string: photoDict?.thumb ?? "")
                        cell.giftsImageView.sd_imageIndicator?.startAnimatingIndicator()
            //            cell.giftsImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.giftsImageView.sd_imageTransition = .fade
                        cell.giftsImageView.sd_setImage(with: strImageUrl)
            //            cell.giftsImageView.layer.cornerRadius = cell.giftsImageView.frame.size.height/2
            
//            let imageURL = UIImage.gifImageWithURL(photoDict?.thumb ?? "")
//            if let image = imageURL {
//                cell.giftsImageView.image = image
//            } else {
//                cell.giftsImageView.image =  UIImage(named: "emoji-icon")
//            }
            
            let coins : Int? = giftDict.coins
            cell.coins.text = String.init(format: "%d", coins!)
//            cell.giftContainer.backgroundColor = UIColor.clear
            
        }
        if (currentIndexPath != nil && currentIndexPath == indexPath.item) {
//            cell.giftContainer.backgroundColor = BlackThemeColor.lightBlack
            cell.layer.borderColor = BlackThemeColor.white.cgColor
        } else {
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        
        let pages:Int = Int (floor(collectionView.contentSize.width / collectionView.frame.size.width));
        self.pageControl.numberOfPages = pages
        cell.layer.cornerRadius = 5.0
        return cell
    }
    
}

extension GiftsViewController : UICollectionViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (currentIndexPath != nil) {
            PrevIndexPath = currentIndexPath
            let prevCell : GiftsCollectionViewCell? = collectionView.cellForItem(at: NSIndexPath.init(item: PrevIndexPath, section: 0) as IndexPath) as? GiftsCollectionViewCell
            prevCell?.layer.borderColor = UIColor.clear.cgColor
//            prevCell?.backgroundColor = BlackThemeColor.lightBlack
//            prevCell?.giftContainer.backgroundColor = BlackThemeColor.lightBlack
        } else {
            PrevIndexPath = indexPath.item
        }
        
        currentIndexPath = indexPath.item
        let cell : GiftsCollectionViewCell? = collectionView.cellForItem(at: indexPath) as? GiftsCollectionViewCell
//        cell?.giftContainer.backgroundColor = BlackThemeColor.lightBlack
        cell?.layer.borderColor = BlackThemeColor.white.cgColor

        if (self.multiplierTableView != nil) {
            self.multiplierTableView.isHidden = true
        }
        selectedGift = self.giftDataSource[indexPath.item]
    }
    
}

extension GiftsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = ( collectionView.bounds.height / 3) - hardCodedPadding
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
