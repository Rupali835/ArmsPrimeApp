//
//  RewardViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 12/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import SDWebImage
//import XLPagerTabStrip

class RewardViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate //,IndicatorInfoProvider
{

    @IBOutlet weak var topConstraintOfTable: NSLayoutConstraint!
    @IBOutlet weak var rewardTableView: UITableView!
    @IBOutlet weak var noRewardLabel: UILabel!
    var reward = [Rewards]()
    var isFirstTime = true
    let database = DatabaseManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
//        setTopOfTable()
        rewardTableView.dataSource = self
        rewardTableView.delegate = self
        
        self.getData()
        rewardTableView.register(UINib(nibName: "RewardsTableViewCell", bundle: nil), forCellReuseIdentifier: "RewardsCell")
        //        self.purchaseTableView.estimatedRowHeight = 44
        self.rewardTableView.rowHeight = 100//UITableViewAutomaticDimension
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GlobalFunctions.screenViewedRecorder(screenName: "History Reward Screen")
        
        
    }
    func getData() {
        
        if Reachability.isConnectedToNetwork() {

        let parameter = ["page": "1",
                         "perpage": "25"]
        if (isFirstTime == true) {
            self.showLoader()
        }
  
        let apiName = Constants.REWARDS + "?page=\(1)" + "&artistid=\(Constants.CELEB_ID)" + "&perpage=\(25)" + "&v=\(Constants.VERSION)"

        
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: apiName, extraHeader: nil) { (result) in
            self.isFirstTime = false
            switch result {
                
            case .success(let data):
                print(data)
                 if (data["error"] as? Bool == true) {
                    let  payloadDict = NSMutableDictionary()
                    payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.walletPassbook, action: "RewardHistory", status: "Failed", reason:  "\(data["error"])", extraParamDict: payloadDict)
                    self.stopLoader()
                    self.showToast(message: "Something went wrong. Please try again!")
                    return
                    
                 } else {
                    let  payloadDict = NSMutableDictionary()
                    payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.walletPassbook, action: "RewardHistory", status: "Success", reason:  "", extraParamDict: payloadDict)
                    DispatchQueue.main.async {
                        if let rewards = data["data"]["list"].array {
                            self.database.createRewardsTable()
                            for reward in rewards {
                                if let rewardDictionry = reward.dictionaryObject {
                                    let rewardObj = Rewards(dict: rewardDictionry)
                                    self.database.insertIntoReward(reward: rewardObj)
                                    self.reward.append(rewardObj)
                                }
                            }
                            
                            if rewards.count <= 0{
//                                self.showToast(message: "No record found")
                                self.noRewardLabel.isHidden = false
                            }
                            
                            self.rewardTableView.reloadData()
                        }
                        self.stopLoader()

                    }

                }
            case .failure(let error):
                 self.stopLoader()
                print(error)
                 let  payloadDict = NSMutableDictionary()
                 payloadDict.setObject(Constants.CELEB_ID, forKey: "artist_id" as NSCopying)
                 CustomMoEngage.shared.sendEvent(eventType: MoEventType.walletPassbook, action: "RewardHistory", status: "Failed", reason:error.localizedDescription, extraParamDict: payloadDict)
            }
        }
        } else
        {
            self.stopLoader()
            self.reward =  self.database.getRewards()
            self.rewardTableView.reloadData()
            self.showToast(message: Constants.NO_Internet_MSG)
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.reward.count > 0
        {
            return self.reward.count

        } else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rewardTableView.dequeueReusableCell(withIdentifier: "RewardsCell", for: indexPath)as!RewardsTableViewCell
        
        let reward = self.reward[indexPath.row]

        if let thumbImage = reward.artist?.cover?.thumb {
            let imageURL = URL(string: thumbImage)
            cell.rewardImageView.sd_imageIndicator?.startAnimatingIndicator()
            cell.rewardImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.rewardImageView.sd_imageTransition = .fade
             cell.rewardImageView.sd_setImage(with: imageURL, completed: nil)
//            cell.rewardImageView.sd_setImage(with: imageURL, completed: nil)
        }
        
        cell.createdatLabel.text = reward.created_at
        cell.descriptionLabel.text = reward.description
  
        return cell
    }
    
    
    
//    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return IndicatorInfo(title: "REWARD")
//    }

}
