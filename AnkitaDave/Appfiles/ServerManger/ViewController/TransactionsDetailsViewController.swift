//
//  TransactionsDetailsViewController.swift
//  SoundaryaShrmaOfficialApp
//
//  Created by RazrTech2 on 29/12/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import SDWebImage

class TransactionsDetailsViewController: UIViewController {

    @IBOutlet weak var celbView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var successfulView: UIView!
    @IBOutlet weak var uiviewheight: NSLayoutConstraint!
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var closingBalanceLabel: UILabel!
    @IBOutlet weak var closingBalanceTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currenceCode: UILabel!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var celbImageIcon: UIImageView!
    @IBOutlet weak var coinIcon: UIImageView!
    @IBOutlet weak var celbName: UILabel!
    @IBOutlet weak var PlatformLabel: UILabel!
    
    @IBOutlet weak var platformImgView: UIImageView!
    @IBOutlet weak var vendorTypeLabel: UILabel!
    var transaction:LedgerTransaction?
    var transactionArray:[Purchase] = [Purchase]()
    var pageIndex = 0
    
    @IBOutlet weak var helpSupportButton: UIButton!
    @IBOutlet weak var tranIDTitleLabel: UILabel!
    
    @IBOutlet weak var amountTitleLabel: UILabel!
    var passbookData: PassbookList?
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.successfulView.layer.cornerRadius = 5
        self.successfulView.clipsToBounds = true
        
        /*
         @IBOutlet weak var transactionIdLabel: UILabel!
         @IBOutlet weak var amountLabel: UILabel!
         @IBOutlet weak var closingBalanceLabel: UILabel!
         @IBOutlet weak var closingBalanceTextLabel: UILabel!
         @IBOutlet weak var timeLabel: UILabel!
         @IBOutlet weak var currenceCode: UILabel!
         @IBOutlet weak var paymentStatusLabel: UILabel!
         @IBOutlet weak var uiView: UIView!
         @IBOutlet weak var celbImageIcon: UIImageView!
         @IBOutlet weak var coinIcon: UIImageView!
         @IBOutlet weak var celbName: UILabel!
         @IBOutlet weak var PlatformLabel: UILabel!
         
         @IBOutlet weak var platformImgView: UIImageView!
         @IBOutlet weak var vendorTypeLabel: UILabel!
         */
        tranIDTitleLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        amountTitleLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        transactionIdLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        amountLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        closingBalanceLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        closingBalanceTextLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        closingBalanceLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        currenceCode.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        paymentStatusLabel.font = UIFont(name: AppFont.bold.rawValue, size: 20.0)
        celbName.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        celbName.textColor = hexStringToUIColor(hex: MyColors.cellNameLabelTextColor)
        vendorTypeLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        PlatformLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        timeLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        helpSupportButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 12.0)
        helpSupportButton.titleLabel?.textColor = .white
        
        
//        self.navigationItem.title = "TRANSACTIONS DETAILS"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setNavigationView(title: "TRANSACTIONS DETAILS")
        if let status = passbookData?.status {
            paymentStatusLabel.text = " Payment \(status.captalizeFirstCharacter())"
        }
        if let vendor = passbookData?.meta_info?.description {
            vendorTypeLabel.text = "Paid via - \(vendor)"
        }
        
//        if let currencyCode = passbookData?.meta_info?.currency_code {
//            currenceCode.text = "\(currencyCode)"
//        }
        if let id = passbookData?._id{
            self.transactionIdLabel.text = "\(id)"
        }
        
        if let amount = passbookData?.coins{
            self.amountLabel.text = "\(amount)"
        }
        
        if let date = passbookData?.created_at{
             self.timeLabel.text = "\(date)"
        }
        
        if let firstname = passbookData?.artist?.first_name{
            if let lastname = passbookData?.artist?.last_name{
                
                self.celbName.text = "The \(firstname+" "+lastname) App"
                self.celbName.text = self.celbName.text
                
            }
        }
        
        if passbookData?.status == "success" {
            paymentStatusLabel.textColor = #colorLiteral(red: 0.1278283894, green: 0.5185144544, blue: 0.1342647076, alpha: 1)
            
            if let balance = passbookData?.coins_after_txn {
                if balance == 0 {
                    closingBalanceLabel.isHidden = true
                    closingBalanceTextLabel.isHidden = true
                    coinIcon.isHidden = true
                    uiviewheight.constant = 60
                } else {
                    closingBalanceLabel.text = "\(balance)"
                }
            } else {
                closingBalanceLabel.isHidden = true
                closingBalanceTextLabel.isHidden = true
                coinIcon.isHidden = true
                uiviewheight.constant = 60
            }
        } else if passbookData?.status == "pending" {
            paymentStatusLabel.textColor = #colorLiteral(red: 0.9926999211, green: 0.7809402943, blue: 0, alpha: 1)
            closingBalanceLabel.isHidden = true
            closingBalanceTextLabel.isHidden = true
            coinIcon.isHidden = true
            uiviewheight.constant = 60
        } else if passbookData?.status == "failed" {
            paymentStatusLabel.textColor = #colorLiteral(red: 0.9109638929, green: 0.05280861259, blue: 0, alpha: 1)
            closingBalanceLabel.isHidden = true
            closingBalanceTextLabel.isHidden = true
            coinIcon.isHidden = true
            uiviewheight.constant = 60
        }
        
        if let platform = passbookData?.platform, platform != "" {
            self.PlatformLabel.text = platform
            if platform.lowercased() == "ios" {
                platformImgView.image = UIImage(named: "AppleIcon")
            } else if platform.lowercased() == "android" {
                platformImgView.image = UIImage(named: "AndroidIcon")
            } else {
                platformImgView.image = UIImage(named: "webicon")
            }
        } else {
            PlatformLabel.text = nil
            platformImgView.image = nil
        }
        
    }
    
    @IBAction func celbAppButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func contactHelpAndSupportButtonAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
        resultViewController.PurchaseId =  passbookData?._id ?? ""//transactionArray[pageIndex]._id ?? ""
        resultViewController.isFromTransDetails = true
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    class CopyableLabel: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.sharedInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.sharedInit()
        }
        
        func sharedInit() {
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
        }
        
        @objc func showMenu(sender: AnyObject?) {
            self.becomeFirstResponder()
            
            let menu = UIMenuController.shared
            
            if !menu.isMenuVisible {
                menu.setTargetRect(bounds, in: self)
                menu.setMenuVisible(true, animated: true)
            }
        }
        
        override func copy(_ sender: Any?) {
            let board = UIPasteboard.general
            
            board.string = text
            
            let menu = UIMenuController.shared
            
            menu.setMenuVisible(false, animated: true)
        }
        
        override var canBecomeFirstResponder: Bool {
            return true
        }
        
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return action == #selector(UIResponderStandardEditActions.copy)
        }
    }
    
    
    /*
 
 var transactionArray:[Purchase] = [Purchase]()
    var pageIndex = 0
    var transcationId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.successfulView.layer.cornerRadius = 5
        self.successfulView.clipsToBounds = true
//        self.successfulView.layer.borderWidth = 1
//        self.successfulView.layer.borderColor = UIColor.lightGray.cgColor
       
        self.navigationItem.title = "TRANSACTIONS DETAILS"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedStringKey.foregroundColor: UIColor.white]
      
     if transactionArray[pageIndex].order_status == "successful"{
        
        if let id = transactionArray[pageIndex]._id{
            self.transactionIdLabel.text = "\(id)"
        }
        if let currenceCode = transactionArray[pageIndex].currency_code{
            self.currenceCode.text = "\(currenceCode)"
        }
        if let amount = transactionArray[pageIndex].transaction_price{
            self.amountLabel.text = "\(amount)"
        }
        if let balance = transactionArray[pageIndex].coins_after_purchase{
            self.closingBalanceLabel.text = "\(balance)"
        }
        if let time = transactionArray[pageIndex].created_at{
            self.timeLabel.text = "\(time)"
        }
        if let status = transactionArray[pageIndex].order_status{
            self.paymentStatusLabel.text = " Payment \(status.captalizeFirstCharacter())"
            self.paymentStatusLabel.textColor = hexStringToUIColor(hex: "#167e33")
        }
        if let firstname = transactionArray[pageIndex].artist?.first_name{
            if let lastname = transactionArray[pageIndex].artist?.last_name{
                
                self.celbName.text = "The \(firstname+" "+lastname) App"
                self.celbName.text = self.celbName.text
  
            }
        }
        if let celbImage = transactionArray[pageIndex].artist?.cover?.thumb{
            self.celbImageIcon.sd_setImage(with:URL(string: celbImage), completed: nil)
        }
        
        } else if transactionArray[pageIndex].order_status == "pending"{
        
        if let id = transactionArray[pageIndex]._id{
            self.transactionIdLabel.text = "\(id)"
        }
        if let currenceCode = transactionArray[pageIndex].currency_code{
            self.currenceCode.text = "\(currenceCode)"
        }
        if let amount = transactionArray[pageIndex].transaction_price{
            self.amountLabel.text = "\(amount)"
        }
        if let status = transactionArray[pageIndex].order_status{
            self.paymentStatusLabel.text = " Payment \(status.captalizeFirstCharacter())"
            self.paymentStatusLabel.textColor = UIColor.orange
        }
        if let firstname = transactionArray[pageIndex].artist?.first_name{
            if let lastname = transactionArray[pageIndex].artist?.last_name{
                
                self.celbName.text = "The \(firstname+" "+lastname) App"
                self.celbName.text = self.celbName.text
                
            }
        }
        if let celbImage = transactionArray[pageIndex].artist?.cover?.thumb{
            self.celbImageIcon.sd_setImage(with:URL(string: celbImage), completed: nil)
        }
        if let time = transactionArray[pageIndex].created_at{
            self.timeLabel.text = "\(time)"
        }
        
        self.closingBalanceLabel.isHidden = true
        self.closingBalanceTextLabel.isHidden = true
        self.coinIcon.isHidden = true
        self.uiviewheight.constant = 60
        
     } else if transactionArray[pageIndex].order_status == "failed"{
        if let id = transactionArray[pageIndex]._id{
            self.transactionIdLabel.text = "\(id)"
        }
        if let currenceCode = transactionArray[pageIndex].currency_code{
            self.currenceCode.text = "\(currenceCode)"
        }
        if let amount = transactionArray[pageIndex].transaction_price{
            self.amountLabel.text = "\(amount)"
        }
        if let status = transactionArray[pageIndex].order_status{
            self.paymentStatusLabel.text = " Payment \(status.captalizeFirstCharacter())"
            self.paymentStatusLabel.textColor = UIColor.red
        }
        if let firstname = transactionArray[pageIndex].artist?.first_name{
            if let lastname = transactionArray[pageIndex].artist?.last_name{
                
                self.celbName.text = "The \(firstname+" "+lastname) App"
                self.celbName.text = self.celbName.text
                
            }
        }
        if let celbImage = transactionArray[pageIndex].artist?.cover?.thumb{
            self.celbImageIcon.sd_setImage(with:URL(string: celbImage), completed: nil)
        }
        if let time = transactionArray[pageIndex].created_at{
            self.timeLabel.text = "\(time)"
        }
        
        self.closingBalanceLabel.isHidden = true
        self.closingBalanceTextLabel.isHidden = true
        self.coinIcon.isHidden = true
        self.uiviewheight.constant = 60
        }
       
    }

    @IBAction func celbAppButtonAction(_ sender: Any) {

    }
    
    @IBAction func contactHelpAndSupportButtonAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
        let dict = transactionArray[pageIndex]._id
        let purchaseId = dict
        resultViewController.PurchaseId = purchaseId ?? ""
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
   
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
*/
}
