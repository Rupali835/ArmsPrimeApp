//
//  VideoCallListViewController.swift
//  AnkitaDave
//
//  Created by Shriram on 12/12/20.
//

import StoreKit
import SwiftyJSON
import SwiftyStoreKit
import MoEngage
import NVActivityIndicatorView
import IQKeyboardManagerSwift

import CoreSpotlight
import MobileCoreServices
import SafariServices

class VideoCallListViewController: BaseViewController {
    
    var list = [JSON]()
    var serverTime : String?
    // MARK: - Properties.
    //  var loaderIndicator: NVActivityIndicatorView!
    var projects:[String] = []
    var strServerTime : String? = " "
     private var overlayView = LoadingOverlay.shared
    var selectVideoMessage = false
    var selectVideoCall = false
    var videoCallRequestID : String? = " "
    var strVideoCallCoin : String? = " "
    var status : String?
    @IBOutlet var tblMyInbox: UITableView!
    @IBOutlet var lblNoTransaction: UILabel!
    
    var strNewID : String?
    var strNewDuration : String?
    var strNewTimeSlots : String?
    var strNewDate : String?
    var strnNewCustomer : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Requests"

        self.configureView()
       // self.getVideoCallList()
        //self.getVideoCallList()
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
       
        self.navigationItem.hidesBackButton = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
         self.showLoader()
        if self.checkIsUserLoggedIn() {
            self.getVideoCallList()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    private func configureView(){
        tblMyInbox.register(UINib(nibName: "VideoCallListCell", bundle: nil), forCellReuseIdentifier: "VideoCallListCell")
        tblMyInbox.dataSource = self
        tblMyInbox.delegate = self
        self.tblMyInbox.rowHeight = 93
        self.tblMyInbox.estimatedRowHeight = tblMyInbox.rowHeight
        self.tblMyInbox.setNeedsUpdateConstraints()
        self.overlayView.hideOverlayView()

    }
    
    private func getVideoCallList() {
         if Reachability.isConnectedToNetwork(){
            self.showLoader()
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getVideoCallList, extraHeader: nil) { [weak self] (result) in
            guard let `self` = self else {return}
            print(result)
            switch result {
            case .success(let data):
                print(data)
                self.stopLoader()
             //   self.list.removeAll()
                if(data["error"] as? Bool == true){
                    self.stopLoader()
                    return
                }else {
                    self.strServerTime = data["data"]["server_time"]["ist"].stringValue
                    
                    self.list.append(contentsOf: data["data"]["list"].arrayValue)
                    
                    if self.list.count == 0 {
                        self.lblNoTransaction.isHidden = false
                        self.lblNoTransaction.text? = "No Transaction History"
                        self.lblNoTransaction.adjustsFontSizeToFitWidth = true
                        self.lblNoTransaction.textAlignment = NSTextAlignment.center
                    }
                }
                DispatchQueue.main.async {
                    self.tblMyInbox?.reloadData()
                }
               
            case .failure(let error):
                print(error)
                self.stopLoader()
            }
        }
    }
    }
    
    // MARK: - API  Update Videocall (On Click Accept button)
    private func rescheduleVideoCallRequest() {
     
        if Reachability.isConnectedToNetwork()
        {
            self.showLoader()

             let dict = ["_id": videoCallRequestID ?? "", "updated_by": "customer","status": "accepted"]
            ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.videoCallUpdate, extraHeader: nil, closure: { (result) in
                switch result {
                case .success(let data):
                  self.stopLoader()
                    print(data)
                  self.getVideoCallList()
                    self.showToast(message: " Request updated Successfully")
                  self.tblMyInbox.reloadData()
                    if (data["error"] as? Bool == true) {
                        //                                self.stopLoader()
                        self.showToast(message: "Something went wrong. Please try again!")
                       
                        return
                        
                    } else {
                        self.showToast(message: "Something went wrong. Please try again!")
                       // self.stopLoader()
                        //self.navigationController?.popViewController(animated: true)
                        
                    }
                case .failure(let error):
                    self.stopLoader()
 
                    print(error)
                }
            })
           //  self.overlayView.hideOverlayView()
//             self.showToast(message: " Request updated Successfully")
           
        }
          
    }
}


extension VideoCallListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  return self.list.count
        if self.list.count == 0 {
        }
        return self.list.count
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //    {
    //        return 16.0
    //    }
    //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMyInbox.dequeueReusableCell(withIdentifier: "VideoCallListCell", for: indexPath) as!  VideoCallListCell
        cell.delegate = self
        let jsonObject = self.list[indexPath.row]
        cell.loadData(jsonObject: jsonObject, serverTime: strServerTime ?? "")
        status = jsonObject["status"].stringValue
       
       
        let project = self.list[indexPath.row]
        cell.textLabel?.attributedText = makeAtributedString(title: (project).string ?? "", subtitle: (project).string ?? "")
        // cell.textLabel?.attributedText = makeAtributedString(title: project, subtitle: project)
        
        index(item: indexPath.row )
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 223
       /* let jsonObject = self.list[indexPath.row]
        self.status = jsonObject["status"].stringValue
        if status == "rescheduled" && status == "accepted" {
            return 223
        }else{
          return 167
        }*/
    }
    
    func setEmptyView(title: String, message: String) {
        
    }
}

extension VideoCallListViewController : VideoCallListCellDelegate {
    func clickOnRescheduleButton(at indexPath: IndexPath, sender: UIButton) {
         let jsonObject = self.list[indexPath.row]
               print("jsonObject: \(jsonObject)")
        self.videoCallRequestID = jsonObject["_id"].stringValue
       self.strNewDuration = jsonObject["duration"].stringValue
       self.strnNewCustomer = jsonObject["customer"]["name"].stringValue
        if  let videoCallRescheduleVC = storyboard?.instantiateViewController(withIdentifier: "RescheduleVideoCallViewController")  as? RescheduleVideoCallViewController {
             videoCallRescheduleVC.videoCallDuration = strNewDuration
             videoCallRescheduleVC.strnNewCustomer = strnNewCustomer
             videoCallRescheduleVC.videoCallRequestID = videoCallRequestID
            
            self.navigationController?.pushViewController(videoCallRescheduleVC, animated: true)
        }
    }
    
    
    func clickOnRescheduleSecondButton(at indexPath: IndexPath, sender: UIButton) {
         let jsonObject = self.list[indexPath.row]
               print("jsonObject: \(jsonObject)")
        self.videoCallRequestID = jsonObject["_id"].stringValue
       self.strNewDuration = jsonObject["duration"].stringValue
       self.strnNewCustomer = jsonObject["customer"]["name"].stringValue
        if  let videoCallRescheduleVC = storyboard?.instantiateViewController(withIdentifier: "RescheduleVideoCallViewController")  as? RescheduleVideoCallViewController {
             videoCallRescheduleVC.videoCallDuration = strNewDuration
             videoCallRescheduleVC.strnNewCustomer = strnNewCustomer
             videoCallRescheduleVC.videoCallRequestID = videoCallRequestID
            
            self.navigationController?.pushViewController(videoCallRescheduleVC, animated: true)
        }
    }
    
    func clickOnJoinNowButton(at indexPath: IndexPath, sender: UIButton) {
        
        let jsonObject = self.list[indexPath.row]
        print("jsonObject: \(jsonObject)")
        self.videoCallRequestID = jsonObject["_id"].stringValue
        self.strVideoCallCoin = jsonObject["coins"].stringValue
        self.status = jsonObject["status"].stringValue
        
        self.strnNewCustomer = jsonObject["customer"]["name"].stringValue
        self.strNewDuration = jsonObject["duration"].stringValue
        self.strNewDate = jsonObject["date"].stringValue
        self.strNewTimeSlots = jsonObject["time"].stringValue
        
        
        if status == "rescheduled"{
         //   print("status rescheduled: \(status ?? "")")
            rescheduleVideoCallRequest()
            
        }else{
            let videoCallVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallViewController.self)
            videoCallVC.videoCallreRuestIdOnAcceptedCall = videoCallRequestID
            videoCallVC.strVideoCallCoin = strVideoCallCoin
            videoCallVC.completionCallEnded = { [weak self] in
                //self?.showVideoCallFeedbackScreen(videoCallRequestID)
            }
            videoCallVC.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(videoCallVC, animated: true)
        }
    }
}


// MARK: - Custom Methods.
extension VideoCallListViewController {
    func index(item:Int) {
        
        // let project = list.count
        let project = list[item]
        
        let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        //attrSet.title = String (project)
        attrSet.title =  (project).string
        //attrSet.contentDescription = project[1]
        // attrSet.contentDescription = String (project)
        attrSet.contentDescription = (project).string
        
        let item = CSSearchableItem(
            uniqueIdentifier: "\(item)",
            domainIdentifier: "kho.arthur",
            attributeSet: attrSet )
        
        CSSearchableIndex.default().indexSearchableItems( [item] )
        { error in
            
            if let error = error
            { print("Indexing error: \(error.localizedDescription)")
            }
            else
            { print("Search item successfully indexed.")
            }
        }
        
    }
    
    
    func deindex(item:Int) {
        
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"])
        { error in
            
            if let error = error
            { print("Deindexing error: \(error.localizedDescription)")
            }
            else
            { print("Search item successfully removed.")
            }
        }
        
    }
    func makeAtributedString(title:String, subtitle:String) -> NSAttributedString {
        
        let attrsTitle = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline ),
            NSAttributedString.Key.foregroundColor: UIColor.purple
        ]
        
        let attrsSubtitle = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline )
        ]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: attrsTitle )
        
        let subtitleString = NSMutableAttributedString(string: subtitle, attributes: attrsSubtitle )
        
        titleString.append( subtitleString )
        
        return titleString
        
    }
    
}

