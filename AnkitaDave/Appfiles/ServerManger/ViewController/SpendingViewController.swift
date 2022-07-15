//
//  SpendingViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 12/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import SDWebImage
import ExpandableLabel

class SpendingViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var topOfTable: NSLayoutConstraint!
    
    @IBOutlet weak var spendingTableView: UITableView!
    @IBOutlet weak var noSpendingLabel: UILabel!
    var isFirstTime = true
    var pageNumber = 0
    var currentPage = 0
    var totalPages = 0
    var totalItems = 0
    var iswating = false
    let spinner = UIActivityIndicatorView(style: .white)
    var spendings = [Spending]()
     private let refreshControl = UIRefreshControl()
    let database = DatabaseManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
//        setTopOfTable()
        pageNumber = 1
        spendingTableView.dataSource = self
        spendingTableView.delegate = self
        
        self.getData()
        
        spendingTableView.register(UINib(nibName: "SpendingTableViewCell", bundle: nil), forCellReuseIdentifier: "SpendingCell")
//        self.spendingTableView.estimatedRowHeight = 44
        self.spendingTableView.rowHeight = 130//UITableViewAutomaticDimension
        self.spendingTableView.estimatedRowHeight = spendingTableView.rowHeight
        self.spendingTableView.setNeedsUpdateConstraints()
        refreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
        refreshControl.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)//UIColor(red:0, green:0, blue:0, alpha:1.0)
    }
    func setTopOfTable() {
        var topConstraint:CGFloat = 204.00
         if UIDevice().userInterfaceIdiom == .phone {
         switch UIScreen.main.nativeBounds.height {
         case 1136:
         print("iPhone 5 or 5S or 5C")
         
         case 1334:
         print("iPhone 6/6S/7/8")
         
         case 1920, 2208:
         print("iPhone 6+/6S+/7+/8+")
         
         case 1792:
         print("IPHONE XR")
         topConstraint = 300.00
         
         case 2436:
         print("iPhone X,IPHONE XS")
         topConstraint = 220.00
        
         case 2688:
         print("IPHONE XS_MAX")
         topConstraint = 220.00
         
         
         default:
         print("unknown")
         
         }
         } else {
         }
        topOfTable.constant = topConstraint
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 10.0, *) {
            spendingTableView.refreshControl = refreshControl
        } else {
            spendingTableView.addSubview(refreshControl)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GlobalFunctions.screenViewedRecorder(screenName: "History Spending Screen")
    }
    
    @objc private func refreshPhotosData(_ sender: Any) {
        guard Reachability.isConnectedToNetwork() else {
            self.showToast(message: Constants.NO_Internet_MSG)
            self.refreshControl.endRefreshing()
            return
        }
        self.pageNumber = 1
        self.spendings.removeAll()
        self.getData()
    }
    
    func getData() {
      
        let apiName = Constants.SPENDING + "?page=\(pageNumber)" + "&artistid=\(Constants.CELEB_ID)" + "&perpage=\(5)" + "&v=\(Constants.VERSION)"

        if Reachability.isConnectedToNetwork() {
            if (isFirstTime == true) {
                
                self.showLoader()

            }
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: apiName, extraHeader: nil) { (result) in
            self.isFirstTime = false

            switch result {
            case .success(let data):
                
                print(data)
                if (data["error"] as? Bool == true) {
                    self.stopLoader()
                    self.refreshControl.endRefreshing()
                    self.showToast(message: "Something went wrong. Please try again!")
                    let  payloadDict = NSMutableDictionary()
                    payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.walletPassbook, action: "SpendingHistory", status: "Failed", reason:  "\(data["error"])", extraParamDict: payloadDict)
                    return
                    
                } else {
                    let  payloadDict = NSMutableDictionary()
                    payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.walletPassbook, action: "SpendingHistory", status: "Success", reason:  "", extraParamDict: payloadDict)
                if let total = data["data"]["paginate_data"]["total"].int, let totalPages = data["data"]["paginate_data"]["last_page"].int, let currentPage =  data["data"]["paginate_data"]["current_page"].int{
                    self.totalPages = totalPages
                    self.currentPage = currentPage
                    self.totalItems = total
                }
                if let spendings = data["data"]["list"].array {
                    
                    self.database.createSpendingTable()
                    
                    for spending in spendings {
                        
                        if let spendingDictionry = spending.dictionaryObject {
                            self.spinner.stopAnimating()
                            let spending = Spending.init(dict: spendingDictionry)
                            self.database.insertIntoSpending(spendingData: spending)
                            self.spendings.append(spending)
                        }
                        
                    }
                   
                    if spendings.count <= 0{
//                        self.showToast(message: "No record found")
                         self.noSpendingLabel.isHidden = false
                    }
                    DispatchQueue.main.async {
                        self.spendingTableView.reloadData()
                    }
                    
                }
                DispatchQueue.main.async {
                    self.stopLoader()
                    self.refreshControl.endRefreshing()
                    
                }
                }
            case .failure(let error):
                
                print(error)
                let  payloadDict = NSMutableDictionary()
                payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                CustomMoEngage.shared.sendEvent(eventType: MoEventType.walletPassbook, action: "SpendingHistory", status: "Failed", reason:error.localizedDescription, extraParamDict: payloadDict)
                DispatchQueue.main.async {
                    self.stopLoader()
                    
                    self.refreshControl.endRefreshing()
                    
                }
            }
            
        }
        } else
        {
            self.stopLoader()
            self.refreshControl.endRefreshing()
            self.showToast(message: Constants.NO_Internet_MSG)
            self.spendings =  self.database.getFormSpending()
            self.spendingTableView.reloadData()
        }
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == self.spendings.count - 1 && self.totalPages > pageNumber
        {
           if ( Reachability.isConnectedToNetwork() == true) {
            pageNumber = pageNumber + 1
            spinner.color = UIColor.gray

            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: spendingTableView.bounds.width, height: CGFloat(10))

            self.spendingTableView.tableFooterView = spinner
            self.spendingTableView.tableFooterView?.isHidden = false
            self.getData()
           } else {
            showToast(message: Constants.NO_Internet_MSG)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.spendings.count > 0
        {
            return self.spendings.count
            
        } else
        {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = spendingTableView.dequeueReusableCell(withIdentifier: "SpendingCell", for: indexPath)as!SpendingTableViewCell
//        cell.payContentName.text = ""
//        cell.payContentName.text =  nil
        if  self.spendings.count > 0
        {
            
            let spending = self.spendings[indexPath.row]
            if spending.entity == "gifts" {
                if let thumbImage = spending.gift?.spendingPhoto?.thumb {
                    let imageURL = URL(string: thumbImage)
                    cell.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                    cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.profileImageView.sd_imageTransition = .fade
                    cell.profileImageView.sd_setImage(with: imageURL, completed: nil)
                }
                cell.dateLabel.text = spending.updated_at
                //           let giftName = spending.gift?.name ?? ""
                cell.nameLabel.text = "Gift Purchased" //"Gift : \(giftName.uppercased())"
                //            cell.nameLabel.text = cell.nameLabel.text?.uppercased()
                let transcationId = spending.gift?.id ?? ""
                cell.transactionIdLabel.text =  "Txn ID : \(transcationId)"
                let coins : Int? = spending.gift?.coins
                cell.coinCountLabel.text = String.init(format: "%d", coins ?? 0)
                
                if let beforCoinsPurchase =  spending.coins_before_purchase {
                    cell.beforeCoinsBalance.text = "\(beforCoinsPurchase)"
                }
                if let afterCoinsPurchase =  spending.coins_after_purchase {
                    cell.afterCoinsBalance.text = "\(afterCoinsPurchase)"
                }
                
                //                if let slug = spending.content?.slug {
                //                    cell.payContentName.text = "\((slug))"
                //                }
                if let firstname = spending.artist?.first_name{
                    if let lastname = spending.artist?.last_name{
                        
                        cell.celbNameLabel.text = "on The \(firstname+" "+lastname) App"
                        cell.celbNameLabel.text = cell.celbNameLabel.text//?.uppercased()
                        
                    }
                }
                
            }
            if spending.spending_type == "photo"{
                if let thumbImage = spending.content?.photo?.cover{
                    let imageURL = URL(string: thumbImage)
                    cell.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                    cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.profileImageView.sd_imageTransition = .fade
                    cell.profileImageView.sd_setImage(with: imageURL, completed: nil)
                    cell.profileImageView.contentMode = .scaleAspectFill
                    cell.profileImageView.clipsToBounds = true
                }
                cell.dateLabel.text = spending.updated_at
                cell.nameLabel.text =  "Photo Purchased"//spending.type
                let transcationId = spending.id ?? ""
                cell.transactionIdLabel.text = "Txn ID : \(transcationId)"
                let coins : Int? = spending.coins
                cell.coinCountLabel.text = String.init(format: "%d", coins ?? 0)
                
                if let beforCoinsPurchase =  spending.coins_before_purchase {
                    cell.beforeCoinsBalance.text = "\(beforCoinsPurchase)"
                }
                if let afterCoinsPurchase =  spending.coins_after_purchase {
                    cell.afterCoinsBalance.text = "\(afterCoinsPurchase)"
                }
//                if let slug = spending.content?.slug,slug != "" && slug != nil {
//                    cell.payContentName.text = "(\(slug))"
//                }
                if let firstname = spending.artist?.first_name{
                    if let lastname = spending.artist?.last_name{
                        
                        cell.celbNameLabel.text = " on The \(firstname+" "+lastname) App "
                        cell.celbNameLabel.text = cell.celbNameLabel.text//?.uppercased()
                        
                    }
                }
            }
            if spending.spending_type == "video"{
                
                if let thumbImage = spending.content?.video?.cover{
                    let imageURL = URL(string: thumbImage)
                    cell.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                    cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.profileImageView.sd_imageTransition = .fade
                    cell.profileImageView.sd_setImage(with: imageURL, completed: nil)
                    cell.profileImageView.contentMode = .scaleAspectFill
                    cell.profileImageView.clipsToBounds = true
                }
                cell.videoImage.isHidden = false
                cell.dateLabel.text = spending.updated_at
                cell.nameLabel.text =  "Video Purchased"//spending.type
                let transcationId = spending.id ?? ""
                cell.transactionIdLabel.text = "Txn ID : \(transcationId)"
                let coins : Int? = spending.coins
                cell.coinCountLabel.text = String.init(format: "%d", coins ?? 0)
                
                if let beforCoinsPurchase =  spending.coins_before_purchase {
                    cell.beforeCoinsBalance.text = "\(beforCoinsPurchase)"
                }
                if let afterCoinsPurchase =  spending.coins_after_purchase {
                    cell.afterCoinsBalance.text = "\(afterCoinsPurchase)"
                }
//                if let slug = spending.content?.slug,slug != "" && slug != nil {
//                    cell.payContentName.text = "(\(slug))"
//                }
                if let firstname = spending.artist?.first_name{
                    if let lastname = spending.artist?.last_name{
                        
                        cell.celbNameLabel.text = "on The \(firstname+" "+lastname) App"
                        cell.celbNameLabel.text = cell.celbNameLabel.text//?.uppercased()
                        
                    }
                }
                
            }
            if spending.spending_type == "audio"{
                
                if let thumbImage = spending.content?.audio?.cover{
                    let imageURL = URL(string: thumbImage)
                    cell.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                    cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.profileImageView.sd_imageTransition = .fade
                    cell.profileImageView.sd_setImage(with: imageURL, completed: nil)
                    cell.profileImageView.contentMode = .scaleAspectFill
                    cell.profileImageView.clipsToBounds = true
                }
                cell.dateLabel.text = spending.updated_at
                cell.nameLabel.text =  "Audio Purchased"//spending.type
                let transcationId = spending.id ?? ""
                cell.transactionIdLabel.text = "Txn ID : \(transcationId)"
                let coins : Int? = spending.coins
                cell.coinCountLabel.text = String.init(format: "%d", coins ?? 0)
                
                if let beforCoinsPurchase =  spending.coins_before_purchase {
                    cell.beforeCoinsBalance.text = "\(beforCoinsPurchase)"
                }
                if let afterCoinsPurchase =  spending.coins_after_purchase {
                    cell.afterCoinsBalance.text = "\(afterCoinsPurchase)"
                }
//                if let slug = spending.content?.slug,slug != "" && slug != nil {
//                    cell.payContentName.text = "(\(slug))"
//                }
                if let firstname = spending.artist?.first_name{
                    if let lastname = spending.artist?.last_name{
                        
                        cell.celbNameLabel.text = "on The \(firstname+" "+lastname) App"
                        cell.celbNameLabel.text = cell.celbNameLabel.text//?.uppercased()
                        
                    }
                }
                
            }
            if spending.entity == "stickers" {
                //                if let thumbImage = spending.content?.video?.cover{
                //                    let imageURL = URL(string: thumbImage)
//                cell.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
//                cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                cell.profileImageView.sd_imageTransition = .fade
                let placeHolderImage = UIImage(named: "celebrityProfileDP")
                cell.profileImageView.image = placeHolderImage //sd_setImage(with: AppIcon, completed: nil)
                cell.profileImageView.contentMode = .scaleAspectFill
                cell.profileImageView.clipsToBounds = true
                //                }
                cell.dateLabel.text = spending.updated_at
                cell.nameLabel.text =  "Sticker Purchased"//spending.type
                let transcationId = spending.id ?? ""
                cell.transactionIdLabel.text = "Txn ID : \(transcationId)"
                let coins : Int? = spending.coins
                cell.coinCountLabel.text = String.init(format: "%d", coins ?? 0)
                
                if let beforCoinsPurchase =  spending.coins_before_purchase {
                    cell.beforeCoinsBalance.text = "\(beforCoinsPurchase)"
                }
                if let afterCoinsPurchase =  spending.coins_after_purchase {
                    cell.afterCoinsBalance.text = "\(afterCoinsPurchase)"
                }
                //                if let slug = spending.content?.slug {
                //                    cell.payContentName.text = "\((slug))"
                //                }
                if let firstname = spending.artist?.first_name{
                    if let lastname = spending.artist?.last_name{
                        
                        cell.celbNameLabel.text = "on The \(firstname+" "+lastname) App"
                        cell.celbNameLabel.text = cell.celbNameLabel.text//?.uppercased()
                        
                    }
                }
                
            }
            
        }
        return cell
    }
  
    var thereIsCellTapped = false
    var selectedRowIndex = -1
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.spendingTableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.gray
        
        // avoid paint the cell is the index is outside the bounds
        if self.selectedRowIndex != -1 {
//            self.spendingTableView.cellForRow(at: indexPath(forRow: self.selectedRowIndex, inSection: 0) as IndexPath)?.backgroundColor = UIColor.white
          
           
        }
        
        if selectedRowIndex != indexPath.row {
            self.thereIsCellTapped = true
            self.selectedRowIndex = indexPath.row
        }
        else {
            // there is no cell selected anymore
            self.thereIsCellTapped = false
            self.selectedRowIndex = -1
        }
        
        self.spendingTableView.beginUpdates()
        self.spendingTableView.endUpdates()
        
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == selectedRowIndex && thereIsCellTapped {
        return 200
    }
    
    return 130
    }

}
