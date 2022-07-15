//
//  PurchaseViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 12/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

protocol  PurchaseViewControllerDelegate: class {
    func callTransDetailVC(_ purchase:[Purchase] , atIndexPath indexpath:IndexPath)
}

class PurchaseViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate,PurchaseTableViewCellDelegate
{

    @IBOutlet weak var purchaseTableView: UITableView!
    @IBOutlet weak var noPurchaseLabel: UILabel!
    
    var purchase :[Purchase] = [Purchase]()
    var pageNumber = 0
    var currentPage = 0
    var totalPages = 0
    var totalItems = 0
    var iswating = false
    var purchaseId = ""
    let spinner = UIActivityIndicatorView(style: .white)
    private let refreshControl = UIRefreshControl()
    var isFirstTime = true
    let database = DatabaseManager.sharedInstance
    weak var delegate: PurchaseViewControllerDelegate?
    
    @IBOutlet weak var topConstraintOfTable: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.purchase = [Purchase]()
        
        pageNumber = 1
        purchaseTableView.dataSource = self
        purchaseTableView.delegate = self
//        setTopOfTable()
        self.getData()
        purchaseTableView.register(UINib(nibName: "PurchaseTableViewCell", bundle: nil), forCellReuseIdentifier: "PurchasCell")
        self.purchaseTableView.rowHeight = 130
        self.purchaseTableView.estimatedRowHeight = purchaseTableView.rowHeight
        self.purchaseTableView.setNeedsUpdateConstraints()
        
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
        topConstraintOfTable.constant = topConstraint
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 10.0, *) {
            purchaseTableView.refreshControl = refreshControl
        } else {
            purchaseTableView.addSubview(refreshControl)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GlobalFunctions.screenViewedRecorder(screenName: "History Purchase Screen")
        
        
    }
    
    @IBAction func rechargeWalletAction(_ sender: Any) {
        print("Action...........................")
        let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
        let SocialPhotosViewController = mainstoryboad.instantiateViewController(withIdentifier: "TransactionsDetailsViewController") as! TransactionsDetailsViewController
        SocialPhotosViewController.transactionArray = self.purchase
        SocialPhotosViewController.pageIndex = 0
        self.navigationController?.pushViewController(SocialPhotosViewController, animated: true)
    }
    @objc private func refreshPhotosData(_ sender: Any) {
        guard Reachability.isConnectedToNetwork() else {
            self.showToast(message: Constants.NO_Internet_MSG)
            self.refreshControl.endRefreshing()
            return
        }
        self.pageNumber = 1
        self.purchase.removeAll()
        self.getData()
    }
    
    func didPressButton(_ purchase : Purchase) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
        let dict = purchase._id
        let purchaseId = dict
        resultViewController.PurchaseId = purchaseId ?? ""
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    func getData() {
        
        if Reachability.isConnectedToNetwork() {
            if (isFirstTime == true) {
                self.showLoader()
            }
            let apiName = Constants.PURCHASE + "?page=\(self.pageNumber)" + "&artistid=\(Constants.CELEB_ID)" + "&v=\(String(describing: Constants.VERSION))"
            
            ServerManager.sharedInstance().getRequest(postData: nil, apiName:apiName , extraHeader: nil) { (result) in
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
                        CustomMoEngage.shared.sendEvent(eventType: MoEventType.walletPassbook, action: "PurchaseHistory", status: "Failed", reason:  "\(data["error"])", extraParamDict: payloadDict)
                        return
                        
                    } else {
                        DispatchQueue.main.async {
                            let  payloadDict = NSMutableDictionary()
                            payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                            CustomMoEngage.shared.sendEvent(eventType: MoEventType.walletPassbook, action: "PurchaseHistory", status: "Success", reason:  "", extraParamDict: payloadDict)
                    if let total = data["data"]["paginate_data"]["total"].int, let totalPages = data["data"]["paginate_data"]["last_page"].int, let currentPage =  data["data"]["paginate_data"]["current_page"].int{
                        self.totalPages = totalPages
                        self.currentPage = currentPage
                        self.totalItems = total
                    }
                            print("paginate_data \(self.currentPage)")
                    if let purchase = data["data"]["list"].array {
                        
                        self.database.createPurchaseTable()
                        
                        for purchase in purchase {
                            if let purchaseDictionry = purchase.dictionaryObject {
                                self.spinner.stopAnimating()
                                let purchase = Purchase(dict: purchaseDictionry)
                                self.database.insertIntoPurchaseTable(purchaseData: purchase)
                                self.purchase.append(purchase)
                                
                            }
                        }
                        
                        if purchase.count <= 0{
//                            self.showToast(message: "No record found")
                             self.noPurchaseLabel.isHidden = false
                        }
                        self.purchaseTableView.reloadData()
                    }
                        self.stopLoader()
                        self.refreshControl.endRefreshing()
                        

                    }
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        let  payloadDict = NSMutableDictionary()
                        payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                        CustomMoEngage.shared.sendEvent(eventType: MoEventType.walletPassbook, action: "PurchaseHistory", status: "Failed", reason:error.localizedDescription, extraParamDict: payloadDict)
                        self.stopLoader()
                        self.refreshControl.endRefreshing()
                        
                    }
                    
                }
            }
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
            self.stopLoader()
            self.refreshControl.endRefreshing()
            if (self.database != nil) {
                
                 self.purchase = self.database.getFormPurchaseTable()
                self.purchaseTableView.reloadData()

            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.purchase.count - 1 && self.totalPages > pageNumber
        {
             if ( Reachability.isConnectedToNetwork() == true) {
            pageNumber = pageNumber + 1
            spinner.color = UIColor.gray
            
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: purchaseTableView.bounds.width, height: CGFloat(10))
            
            self.purchaseTableView.tableFooterView = spinner
            self.purchaseTableView.tableFooterView?.isHidden = false
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
        if  self.purchase.count > 0
        {
            return self.purchase.count
            
        } else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PurchaseTableViewCell = purchaseTableView.dequeueReusableCell(withIdentifier: "PurchasCell", for: indexPath)as!PurchaseTableViewCell
        
        cell.cellDelegate = self
        cell.tag = indexPath.row
        
        if  self.purchase.count > 0
        {
            let purchase = self.purchase[indexPath.row]
            cell.currentPurchase = purchase

            cell.dateLabel.text = purchase.updated_at
            if let coins = purchase.package_coins {
                cell.packageCoinsLabel.text = "\(coins)"
            }
            cell.transtionsIDLabel.text = purchase._id
            
            if let PackagePrice = purchase.transaction_price {
                cell.packagePriceLabel.text = "\(PackagePrice)"
            }
            if let firstname = purchase.artist?.first_name{
                if let lastname = purchase.artist?.last_name{
                    
                    cell.celbNameLabel.text = "The \(firstname+" "+lastname) App"
                    cell.celbNameLabel.text = cell.celbNameLabel.text//?.uppercased()
                    
                }
            }
            cell.currencyCodeLabel.text = purchase.currency_code
            if purchase.order_status == "successful" {
                cell.orderStatusLabel.layer.cornerRadius = cell.orderStatusLabel.layer.frame.height / 2
                cell.orderStatusLabel.layer.borderWidth = 1
                cell.orderStatusLabel.layer.borderColor = hexStringToUIColor(hex: "#167e33").cgColor
                cell.reportButton.isUserInteractionEnabled = false
                cell.reportButton.isHidden = true
                cell.orderStatusLabel.clipsToBounds = true
                cell.orderStatusLabel.text = purchase.order_status?.uppercased()
            } else {
                cell.reportButton.isHidden = false
                cell.reportButton.isUserInteractionEnabled = true
                cell.orderStatusLabel.layer.cornerRadius = cell.orderStatusLabel.layer.frame.height / 2
                cell.orderStatusLabel.layer.borderWidth = 1
                cell.orderStatusLabel.layer.borderColor = UIColor.orange.cgColor
                cell.orderStatusLabel.clipsToBounds = true
                cell.orderStatusLabel.text = purchase.order_status?.uppercased()
            }
            
        }
        return cell
    }
    
    var exmpleForSomeoneElseView : UIView!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if (purchase != nil && purchase.count > 0) {
            delegate?.callTransDetailVC(self.purchase, atIndexPath: indexPath)
//           let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
//            let SocialPhotosViewController = mainstoryboad.instantiateViewController(withIdentifier: "TransactionsDetailsViewController") as! TransactionsDetailsViewController
//            SocialPhotosViewController.transactionArray = self.purchase
//            SocialPhotosViewController.pageIndex = indexPath.row
//            self.navigationController?.pushViewController(SocialPhotosViewController, animated: true)
            
        }
}
}
