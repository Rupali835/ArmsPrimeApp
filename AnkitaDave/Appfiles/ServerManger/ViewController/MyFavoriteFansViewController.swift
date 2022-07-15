//
//  MyFavoriteFansViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 18/04/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import SDWebImage

class MyFavoriteFansViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet weak var loyalFanName: UILabel!
    @IBOutlet weak var topFanBackgroundView: UIView!
    @IBOutlet weak var dieHardName: UILabel!
    @IBOutlet weak var loyalFan: UIImageView!
    @IBOutlet weak var dieHardFan: UIImageView!
    @IBOutlet weak var loyalFanbatch: UIImageView!
    @IBOutlet weak var dieHardFanbatch: UIImageView!
    let database = DatabaseManager.sharedInstance
    @IBOutlet weak var fanimg: UIImageView!
    @IBOutlet weak var fnamelbl: UILabel!
    @IBOutlet weak var ficonimg: UIImageView!
    var selectedIndexVal: Int!
    @IBOutlet var TopfancollectionViewTable: UITableView!
//
    @IBOutlet weak var superFantxtLabel: UILabel!
    @IBOutlet weak var topFanTxtLabel: UILabel!
    @IBOutlet weak var loyalTxtLabel: UILabel!
    @IBOutlet weak var dieHardTxtLabel: UILabel!
    var fanArray = NSMutableArray()
    var arrData : [Users] = [Users]()
    var topTwoFan = [Users]()
    var arrStoredDetails = NSMutableArray()
//    private var overlayView = LoadingOverlay.shared
    var navigationTittle = ""
    var bucketid: String = ""
    var identity = [String]()

    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView!

  
    var lastY: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
         

        
        TopfancollectionViewTable.register(UINib(nibName: "TopFanTableViewCell", bundle: nil), forCellReuseIdentifier: "TopFanTableViewCell")

        TopfancollectionViewTable.rowHeight = 72

        self.loyalFanbatch.layer.borderWidth = 1
        self.loyalFanbatch.layer.borderColor = UIColor.clear.cgColor
        self.loyalFanbatch.layer.cornerRadius = loyalFanbatch.frame.size.width / 2
        self.loyalFanbatch.layer.masksToBounds = false
        self.loyalFanbatch.clipsToBounds = true


        self.dieHardFanbatch.layer.borderWidth = 1
        self.dieHardFanbatch.layer.borderColor = UIColor.clear.cgColor
        self.dieHardFanbatch.layer.cornerRadius = dieHardFanbatch.frame.size.width / 2
        self.dieHardFanbatch.layer.masksToBounds = false
        self.dieHardFanbatch.clipsToBounds = true


        self.loyalFan.layer.borderWidth = 2
        self.loyalFan.layer.borderColor = UIColor.white.cgColor
        self.loyalFan.layer.cornerRadius = loyalFan.frame.size.width / 2
        self.loyalFan.layer.masksToBounds = false
        self.loyalFan.clipsToBounds = true


        self.dieHardFan.layer.borderWidth = 2
        self.dieHardFan.layer.borderColor = UIColor.white.cgColor
        self.dieHardFan.layer.cornerRadius = dieHardFan.frame.size.width / 2
        self.dieHardFan.layer.masksToBounds = false
        self.dieHardFan.clipsToBounds = true


        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.isTranslucent = false

        }

            self.tabBarController?.tabBar.isHidden = false

//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//            case 960:
//                print("iPhone 4")
//
//                fanLeftlayout.constant = 1
//                monthLeftlayout.constant = 1
//                namelayout.constant = 1
//
//            case 1136:
//                print("iPhone 5 or 5S or 5C")
//
//                fanLeftlayout.constant = 5
//                monthLeftlayout.constant = 5
//                namelayout.constant = 5
//
//            case 1334:
//                print("iPhone 6/6S/7/8")
//
//
//
//            case 2208:
//                print("iPhone 6+/6S+/7+/8+")
//
//                fanLeftlayout.constant = 45
//                monthLeftlayout.constant = 45
//                namelayout.constant = 45
//
//            case 2436:
//                print("iPhone X")
//
//
//            default:
//                print("unknown")
//            }
//        }

        self.navigationController?.isNavigationBarHidden = false

//        self.navigationItem.title = navigationTittle.uppercased()
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
        self.setNavigationView(title: navigationTittle.uppercased())
        self.getData()

        arrData.removeAll()
        fanArray.removeAllObjects()
        arrStoredDetails.removeAllObjects()

//        addSlideMenuButton()

       
        TopfancollectionViewTable.dataSource = self

        self.activityIndicator = UIActivityIndicatorView()
        let screen = UIScreen.main.bounds
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: screen.size.width, height: screen.size.height)
        self.activityIndicator.backgroundColor = UIColor.black
        self.activityIndicator.alpha = 0.3
        self.view.addSubview(activityIndicator)

        self.fanimg.layer.borderWidth = 2
        self.fanimg.layer.borderColor = UIColor.white.cgColor
        self.fanimg.layer.cornerRadius = fanimg.frame.size.width / 2
        self.fanimg.layer.masksToBounds = false
        self.fanimg.clipsToBounds = true


        self.ficonimg.layer.borderWidth = 1
        self.ficonimg.layer.borderColor = UIColor.clear.cgColor
        self.ficonimg.layer.cornerRadius = ficonimg.frame.size.width / 2
        self.ficonimg.layer.masksToBounds = false
        self.ficonimg.clipsToBounds = true

        superFantxtLabel.font = UIFont(name: AppFont.bold.rawValue, size: 14.0)
        dieHardTxtLabel.font = UIFont(name: AppFont.bold.rawValue, size: 14.0)
        topFanTxtLabel.font = UIFont(name: AppFont.bold.rawValue, size: 14.0)
        loyalTxtLabel.font = UIFont(name: AppFont.bold.rawValue, size: 14.0)
        
        fnamelbl.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        dieHardName.font = UIFont(name: AppFont.light.rawValue, size: 12.0)
        loyalFanName.font = UIFont(name: AppFont.light.rawValue, size: 12.0)

      
    }
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        if scrollView.contentOffset.y <= 0
        {
            scrollView.contentOffset = CGPoint.zero
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrData.count > 0
        {
            return self.arrData.count
        } else
        {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = TopfancollectionViewTable.dequeueReusableCell(withIdentifier: "TopFanTableViewCell", for: indexPath)as! TopFanTableViewCell
        
        cell.logoiconImageView.image = nil
        cell.numbercount.text = "#\(indexPath.row + 4)"
        
        if let user = self.arrData[indexPath.row] as? Users {
            
            if let imageUrl = user.picture as? String {
                cell.profileImageView.sd_imageIndicator?.startAnimatingIndicator()
                cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.profileImageView.sd_imageTransition = .fade
                cell.profileImageView.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage(named: "profileph"), options: .refreshCached, context: nil)
                cell.profileImageView.contentMode = .scaleAspectFill
                cell.profileImageView.clipsToBounds = true
            } else {
                cell.profileImageView.image = UIImage(named: "profileph")
            }
            if let firstname = user.first_name {
                
                cell.namelbl.text = firstname
                cell.namelbl.text = cell.namelbl.text?.uppercased()
                //                    if let lastname = dict.object(forKey: "last_name")as? String{
                //
                //                        cell.namelbl.text = firstname+" "+lastname
                //
                //                    }
            }
            
            let identifier = user.identity
            
            if identifier == "email"
            {
                cell.logoiconImageView.image = UIImage(named:"email_icon")
                
            } else if identifier == "google"
            {
                cell.logoiconImageView.image = UIImage(named:"gplus")
                
            } else  if identifier == "facebook"
            {
                cell.logoiconImageView.image = UIImage(named:"img_fb")
                
            }
            
//            if let badge = dict.object(forKey: "badge")as? NSDictionary{
//            
//                            if let iconimage = user.badgeIcon {
//                                cell.superfanlogoImageView.sd_addActivityIndicator()
//                                cell.superfanlogoImageView.sd_setImage(with: URL(string: iconimage), completed: nil)
//                                cell.superfanlogoImageView.sd_removeActivityIndicator()
//           }
            
            if let superfan = user.badgeName{
                
                cell.superfanLabel.text = superfan
                cell.superfanLabel.text = cell.superfanLabel.text?.uppercased()
                
            }
            
            
            //            }
            
        }

        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.isTranslucent = false

        }
        GlobalFunctions.screenViewedRecorder(screenName: "Top Fan Leader Board Screen")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getData()
    {
        self.showLoader()
        if Reachability.isConnectedToNetwork()
        {
            //             self.overlayView.showOverlay(view: self.view)
            //            self.activityIndicator.startAnimating()
            var strUrl = Constants.cloud_base_url + Constants.artist_leaderboards + "&v=\(Constants.VERSION)"

            strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

            let url = URL(string: strUrl)
            let request = NSMutableURLRequest(url: url!)

            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.API_KEY, forHTTPHeaderField: "apiKey")
            request.addValue(Constants.TOKEN, forHTTPHeaderField: "authorization")

            let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
                if error != nil{
                    self.stopLoader()
                    DispatchQueue.main.async {

                    self.showToast(message: Constants.NO_Internet_MSG)
                            let userObj : Users =  self.database.getFanOfMonth()
                            if let profileimage = userObj.picture {
                                self.fanimg.sd_imageIndicator?.startAnimatingIndicator()
                                self.fanimg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                                self.fanimg.sd_imageTransition = .fade
                                self.fanimg.sd_setImage(with: URL(string: profileimage), completed: nil)
                                self.fanimg.contentMode = .scaleAspectFill
                                self.fanimg.clipsToBounds = true
                            } else {
                                self.fanimg.image = UIImage(named: "profileph")

                            }

                            if let firstname = userObj.first_name {
                                if let lastname = userObj.last_name{

                                    self.fnamelbl.text = firstname+" "+lastname
                                    self.fnamelbl.text = self.fnamelbl.text?.uppercased()

                                }
                            }
//                            if let iconimage = userObj.badgeIcon{
//                                self.ficonimg.sd_setImage(with: URL(string: iconimage), completed: nil)
//                            }
                            self.arrData =  self.database.getFansData()
                            self.TopfancollectionViewTable.reloadData()

                    }
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                    DispatchQueue.main.async {

                        if let dictData = json?.object(forKey: "data") as? NSMutableDictionary {
                            print(dictData)

                    if let fanmonth  = dictData.object(forKey: "fan_of_the_month") as? NSMutableDictionary {


                        self.database.createLeaderboardTable()

                        let userObj = Users(dict: fanmonth as? [String : Any])
                    if let badges  = fanmonth.value(forKey: "badge") as? NSDictionary{
                            userObj.badgeIcon = badges.value(forKey: "icon") as? String
                            userObj.badgeName = badges.value(forKey: "name") as? String
                        }
                        self.database.insertIntoFansTable(user: userObj)

                        if let profileimage = userObj.picture {
                            self.fanimg.sd_imageIndicator?.startAnimatingIndicator()
                            self.fanimg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                             self.fanimg.sd_imageTransition = .fade
                            self.fanimg.sd_setImage(with: URL(string: profileimage), completed: nil)
                            self.fanimg.contentMode = .scaleAspectFill
                            self.fanimg.clipsToBounds = true
                        } else {
                            self.fanimg.image = UIImage(named: "profileph")

                        }

                        if let firstname = userObj.first_name {
                            if let lastname = userObj.last_name{

                                self.fnamelbl.text = firstname+" "+lastname
                                self.fnamelbl.text = self.fnamelbl.text?.uppercased()

                            }
                        }
//                        if let badge = fanmonth?.object(forKey: "badge")as? NSDictionary{
//                            if let iconimage = userObj.badgeIcon{
//                                self.ficonimg.sd_setImage(with: URL(string: iconimage), completed: nil)
//                            }
//                        }

                            if  let leader  = dictData.object(forKey: "leader_board_users") as? [NSDictionary] {

                        if leader.count > 0
                        {
                            for leaderData in leader{

                            let userObj = Users(dict: leaderData as! [String : Any])
                                if let badges  = leaderData.value(forKey: "badge") as? NSDictionary{
                                userObj.badgeIcon = badges.value(forKey: "icon") as? String
                                userObj.badgeName = badges.value(forKey: "name") as? String
                            }
                            self.database.insertIntoFansTable(user: userObj)
                            self.arrData.append(userObj)


                            }
                            
                            self.topTwoFan = Array(self.arrData.prefix(2))
                            self.topfan()
                            self.arrData.removeFirst(2)
                        
                        }
                                
                         }
                    }
                        
                    }

                    }

                    //                    }
                    self.stopLoader()
                } catch let error as NSError {
                    print(error)
                    self.stopLoader()
                }

                DispatchQueue.main.async {
                    self.TopfancollectionViewTable.reloadData()
                }
            }
            task.resume()

            //            self.overlayView.hideOverlayView()
            //            self.activityIndicator.stopAnimating()
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
            self.stopLoader()
            self.refreshControl.endRefreshing()
             DispatchQueue.main.async {
            let userObj : Users =  self.database.getFanOfMonth()
            if let profileimage = userObj.picture {
                self.fanimg.sd_imageIndicator?.startAnimatingIndicator()
                self.fanimg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                 self.fanimg.sd_imageTransition = .fade
                self.fanimg.sd_setImage(with: URL(string: profileimage), completed: nil)
                self.fanimg.contentMode = .scaleAspectFill
                self.fanimg.clipsToBounds = true
            } else {
                self.fanimg.image = UIImage(named: "profileph")

            }

            if let firstname = userObj.first_name {
                if let lastname = userObj.last_name{

                    self.fnamelbl.text = firstname+" "+lastname
                    self.fnamelbl.text = self.fnamelbl.text?.uppercased()

                }
            }
//            if let iconimage = userObj.badgeIcon{
//                self.ficonimg.sd_setImage(with: URL(string: iconimage), completed: nil)
//            }
            self.arrData =  self.database.getFansData()
                DispatchQueue.main.async {
                    self.TopfancollectionViewTable.reloadData()
                }
            
            }
        }
    }

    func topfan() {
        
         let topfan1 = self.topTwoFan[0]
         let topfan2 = self.topTwoFan[1]

        if let firstname = topfan1.first_name {
            print(firstname)
            self.dieHardName.text = firstname.uppercased()
                        if let lastname = topfan1.last_name{

                            self.dieHardName.text = firstname+" "+lastname
                            self.dieHardName.text = self.dieHardName.text?.uppercased()

                        }
                    }

        if let profileimage = topfan1.picture {
            self.dieHardFan.sd_imageIndicator?.startAnimatingIndicator()
            self.dieHardFan.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.dieHardFan.sd_imageTransition = .fade
                        self.dieHardFan.sd_setImage(with: URL(string: profileimage), completed: nil)
                        self.dieHardFan.contentMode = .scaleAspectFill
                        self.dieHardFan.clipsToBounds = true
                    } else {
                        self.dieHardFan.image = UIImage(named: "profileph")

                    }
        

        if let firstname1 = topfan2.first_name {
            print(firstname1)
            self.loyalFanName.text = firstname1.uppercased()
            if let lastname1 = topfan2.last_name{

                    self.loyalFanName.text = firstname1+" "+lastname1
                    self.loyalFanName.text = self.loyalFanName.text?.uppercased()

            }
        }

        if let profileimage1 = topfan2.picture {
            self.loyalFan.sd_imageIndicator?.startAnimatingIndicator()
            self.loyalFan.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.loyalFan.sd_imageTransition = .fade
                    self.loyalFan.sd_setImage(with: URL(string: profileimage1), completed: nil)
                    self.loyalFan.contentMode = .scaleAspectFill
                    self.loyalFan.clipsToBounds = true
            } else {
                    self.loyalFan.image = UIImage(named: "profileph")

            }
  
    }

}

