//
//  WalletPaginationViewController.swift
//  AnveshiJain
//
//  Created by webwerks on 21/05/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit

class WalletPaginationViewController: UIViewController {

    @IBOutlet weak var pageView: UIView!
    var pageViewController: UIPageViewController?
    var pages = [UIViewController]()
    
    @IBOutlet weak var coinInfoLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var spendingButton: UIButton!
    @IBOutlet weak var rewardButton: UIButton!
    @IBOutlet weak var purchaseBottomView: UIView!
    @IBOutlet weak var spendingBottomView: UIView!
    @IBOutlet weak var rewardBottomView: UIView!
    var lastPendingViewControllerIndex:Int = 0
    var customBottomX:CGFloat = 0
    
    @IBOutlet weak var customBottomView: UIView!
    
    @IBOutlet weak var accountInfoView: UIView!
    @IBOutlet weak var accountHeaderLabel: UILabel!
    
    @IBOutlet weak var rechargeWalletView: UIView!
    
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var recharegWalletLabel: UILabel!
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.setNavigationView(title: "My Wallet")
        self.navigationController?.navigationBar.isHidden = false
        
        let purchase = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1") as! PurchaseViewController
        purchase.delegate = self
        purchase.view.tag = 0
        let spending = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child2")
        spending.view.tag = 1
        let reward = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child3")
        reward.view.tag = 2
        pages = [purchase,spending,reward]
        
        pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.view.frame = CGRect(x: 0, y: 0, width: pageView.frame.width, height: pageView.frame.height)
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        pageView.addSubview(pageViewController!.view)
        
        if let firstVC = pages.first
        {
            pageViewController!.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
        setUpCoinInfo()
        
        accountHeaderLabel.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
        coinInfoLabel.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
        rechargeWalletView.setGradientBackground()
        recharegWalletLabel.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        purchaseButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        spendingButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        rewardButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        accountHeaderLabel.textColor = UIColor.black
        coinInfoLabel.textColor = UIColor.black
        
        accountInfoView.backgroundColor = UIColor.white
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.setNavigationView(title: "My Wallet")
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GlobalFunctions.screenViewedRecorder(screenName: "Wallet Screen")
        CustomMoEngage.shared.sendEventUIComponent(componentName: "Wallet_History", extraParamDict: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
    }
    func setUpCoinInfo() {
        if let coins = CustomerDetails.coins as? Int {
            self.coinInfoLabel.text = "\(coins)"
        }
    }
    
    @IBAction func rechargeWalletAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseCoinsViewController") as! PurchaseCoinsViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    @IBAction func tabButtonAction(_ sender: Any) {
        let button = sender as! UIButton
        changeTabBarUI(tag: button.tag)
        switch button.tag {
        case 0:
           let firstVC = pages.first
           pageViewController!.setViewControllers([firstVC!], direction: .forward, animated: false, completion: nil)
            break
        case 1:
            let firstVC = pages[1]
            pageViewController!.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
            break
        case 2:
            let firstVC = pages[2]
            pageViewController!.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
            break
        default:
             break
        }
    }
    
    func changeTabBarUI(tag:Int) {
        switch tag {
        case 0:
            purchaseButton.titleLabel?.textColor = .white
            spendingButton.titleLabel?.textColor = hexStringToUIColor(hex: "#706E70")
            rewardButton.titleLabel?.textColor = hexStringToUIColor(hex: "#706E70")
            UIView.animate(withDuration: 0.3) {
                self.purchaseBottomView.backgroundColor = .white
                self.spendingBottomView.backgroundColor = .clear
                self.rewardBottomView.backgroundColor = .clear
                self.customBottomView.frame = CGRect(x: 0, y: 47, width: self.purchaseButton.frame.width, height: 3)
            }
           
            break
        case 1:
            purchaseButton.titleLabel?.textColor = hexStringToUIColor(hex: "#706E70")
            spendingButton.titleLabel?.textColor = .white
            rewardButton.titleLabel?.textColor = hexStringToUIColor(hex: "#706E70")
             UIView.animate(withDuration: 0.3) {
                self.purchaseBottomView.backgroundColor = .clear
                self.spendingBottomView.backgroundColor = .white
                self.rewardBottomView.backgroundColor = .clear
                 self.customBottomView.frame = CGRect(x: self.purchaseButton.frame.width, y: 47, width: self.purchaseButton.frame.width, height: 3)
            }
            break
        case 2:
            purchaseButton.titleLabel?.textColor = hexStringToUIColor(hex: "#706E70")
            spendingButton.titleLabel?.textColor = hexStringToUIColor(hex: "#706E70")
            rewardButton.titleLabel?.textColor = .white
            
             UIView.animate(withDuration: 0.3) {
                self.purchaseBottomView.backgroundColor = .clear
                self.spendingBottomView.backgroundColor = .clear
                self.rewardBottomView.backgroundColor = .white
                self.customBottomView.frame = CGRect(x: self.purchaseButton.frame.width*2, y: 47, width: self.purchaseButton.frame.width, height: 3)
            }
            break
        default:
            purchaseButton.titleLabel?.textColor = .white
            spendingButton.titleLabel?.textColor = hexStringToUIColor(hex: "#706E70")
            rewardButton.titleLabel?.textColor = hexStringToUIColor(hex: "#706E70")
            
            purchaseBottomView.backgroundColor = .white
            spendingBottomView.backgroundColor = .clear
            rewardBottomView.backgroundColor = .clear
            break
        }
    }
}



extension WalletPaginationViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        
        guard previousIndex >= 0 else { return pages.last }
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
       
        return pages[nextIndex]
    }
}

extension WalletPaginationViewController:UIPageViewControllerDelegate{

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        }
         changeTabBarUI(tag: pageViewController.viewControllers!.first!.view.tag)
    }
}
extension WalletPaginationViewController: PurchaseViewControllerDelegate{
    func callTransDetailVC(_ purchase: [Purchase], atIndexPath indexpath: IndexPath) {
        let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
        let SocialPhotosViewController = mainstoryboad.instantiateViewController(withIdentifier: "TransactionsDetailsViewController") as! TransactionsDetailsViewController
        SocialPhotosViewController.transactionArray = purchase
        SocialPhotosViewController.pageIndex = indexpath.row
        self.navigationController?.pushViewController(SocialPhotosViewController, animated: true)
    }
}
