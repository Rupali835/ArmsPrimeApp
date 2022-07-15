//
//  SettingViewController.swift
//  AnveshiJain
//
//  Created by webwerks on 05/08/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import MoEngage
import Branch
class SettingViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    var tittlArray = ["Privacy Policy","Terms & Conditions","FAQ","Help & Support"]
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.checkIsUserLoggedIn() {
            tittlArray = ["Privacy Policy","Terms & Conditions","APM Community Guidelines", "Copyright Policy", "Data Retention and Archiving Policy", "FAQ","Help & Support","Log Out"]
        }
        self.setNavigationView(title: "SETTINGS")
        self.navigationItem.backBarButtonItem?.title = ""
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationView(title: "SETTINGS")
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tittlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "SlideBarCell1", for: indexPath) as! SlideBarTableViewCell
        cell.iconNameLabel.text = tittlArray[indexPath.row].uppercased()
        return cell
    }
}

extension SettingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingTableView.deselectRow(at: indexPath, animated: true)
        let currentName = tittlArray[indexPath.row]
        
        if currentName == "Log Out"{
            let alert = UIAlertController(title: "", message: "Are you sure want to Logout?", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "Log out", style: .destructive) { action in
                CustomMoEngage.shared.sendEventDialog("Are you sure want to Logout?", "Log out", nil)
                UserDefaults.standard.set("LoginSessionOut", forKey: "LoginSession")
                UserDefaults.standard.set("", forKey: "logintype")
                UserDefaults.standard.synchronize()
                ShoutoutConfig.UserDefaultsManager.clearShoutoutUserData()
                UserDefaults.standard.removeObject(forKey: UserDefaultKey.recentSticker.rawValue)
                Constants.TOKEN = ""
                CustomerDetails.custId = ""
                CustomerDetails.account_link = [:]
                CustomerDetails.badges = ""
                CustomerDetails.coins = 0
                CustomerDetails.email = ""
                CustomerDetails.directline_room_id = ""
                CustomerDetails.firstName = nil
                CustomerDetails.lastName = nil
                CustomerDetails.token = ""
                CustomerDetails.picture = ""
                CustomerDetails.gender = ""
                CustomerDetails.mobileNumber = ""
                CustomerDetails.mobile_verified = false
               UserDefaults.standard.set(false, forKey: "profile_completed")
                 UserDefaults.standard.synchronize()
                 UserDefaults.standard.set(false, forKey: "email_verified")
                 UserDefaults.standard.synchronize()
                 UserDefaults.standard.set(false, forKey: "mobile_verified")
                 UserDefaults.standard.synchronize()
                UserDefaults.standard.removeObject(forKey: "dob")
                 UserDefaults.standard.removeObject(forKey: "mobile_code")
                UserDefaults.standard.removeObject(forKey: "customerstatus")
                //                menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                //                            UserDefaults.standard.set(nil, forKey: "kKeyImage")
                GIDSignIn.sharedInstance().signOut()
                AccessToken.current = nil
                Profile.current = nil
                LoginManager().logOut()
                //                            self.walletBalanceLabel.text = "0"
                let database = DatabaseManager.sharedInstance
                let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let writePath = documents + "/ConsumerDatabase.sqlite"
                database.dbPath = writePath
                database.deleteAllData()
                //                            self.displayLayout()
                
                CustomMoEngage.shared.sendEvent(eventType: MoEventType.logOut, action: "Log Out", status: "Success", reason: "", extraParamDict: nil)
                CustomMoEngage.shared.resetMoUserInfo()
                Branch.getInstance().logout()
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                if #available(iOS 11.0, *) {
                    let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    //                    self.toast(message: "successfully logged out", duration: 5)
                    
                    self.navigationController?.pushViewController(resultViewController, animated: false)
                } else {
                    // Fallback on earlier versions
                }
                
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                CustomMoEngage.shared.sendEventDialog("Are you sure want to Logout?", "Cancel", nil)
            })
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
            }
            self.present(alert, animated: true, completion: nil)
        }
        else if currentName == "Privacy Policy" {
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                   resultViewController.navigationTitle = currentName
                   let str = ArtistConfiguration.sharedInstance().static_url?.privacy_policy ?? "http://www.armsprime.com/arms-prime-privacy-policy.html"
                   resultViewController.openUrl = str
                   self.navigationController?.pushViewController(resultViewController, animated: true)
                   
               } else if currentName == "Terms & Conditions" {
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                   resultViewController.navigationTitle = currentName
                   let str = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ?? "http://armsprime.com/terms-conditions.html"
                   resultViewController.openUrl = str
                   self.navigationController?.pushViewController(resultViewController, animated: true)
               }
               else if currentName == "APM Community Guidelines" {
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                   resultViewController.navigationTitle = currentName
                   let str = ArtistConfiguration.sharedInstance().static_url?.ott_community_guidelines_url ?? "https://www.armsprime.com//ott-community-guidelines.html"
                   resultViewController.openUrl = str
                   self.navigationController?.pushViewController(resultViewController, animated: true)
               }
               else if currentName == "Copyright Policy"{
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                   resultViewController.navigationTitle = currentName
                   let str = "https://www.armsprime.com/copyright-policy.html"
                   resultViewController.openUrl = str
                   self.navigationController?.pushViewController(resultViewController, animated: true)
               }
               else if currentName == "Data Retention and Archiving Policy"{
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                   resultViewController.navigationTitle = currentName
                   let str = "https://www.armsprime.com/dataretention-archiving-policy.html"
                   resultViewController.openUrl = str
                   self.navigationController?.pushViewController(resultViewController, animated: true)
               }
               else if currentName == "FAQ" {
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
                   resultViewController.navigationTitle = currentName
                   let str = ArtistConfiguration.sharedInstance().static_url?.faqs ?? "http://www.armsprime.com/faqs.html"
                   resultViewController.openUrl = str
                   self.navigationController?.pushViewController(resultViewController, animated: true)
           } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
}
