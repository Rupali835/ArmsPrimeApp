//
//  VideoCallListingViewController.swift
//  Producer
//
//  Created by Parikshit on 19/10/20.
//  Copyright © 2020 developer2. All rights reserved.
//

import UIKit

class VideoCallListingViewController: UIViewController {
    
    @IBOutlet weak var tblVideoCalls: UITableView!

    lazy var arrRequests = [VideoCallRequest]()

    var refreshControlTable:UIRefreshControl? = nil

    var apiCallStatus = (shouldShowLoader:true, shouldShowNotFound:false, isCalling:false, page:1, isLoadMore: false)

    var webVideoCall: WebService? = nil

    var serverTime: ServerTime?
    var passbookData: PassbookList?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setLayoutAndDesigns()

//        if let is_default = User.getLoggedInUser()?.config?.workingDays?.is_default, is_default == true {
//
//            gotoVideoCallPreferredDaysScreen()
//        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
        setStatusBarStyle(isBlack: true)
        self.navigationItem.hidesBackButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        webGetVideoCallList(isRefresh: true)
    }
}

// MARK: - Utility Methods
extension VideoCallListingViewController {

    func setLayoutAndDesigns() {

        self.navigationItem.title =  stringConstants.titleVideoCall //"My Requests"

        tblVideoCalls.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 12))

        addAllRefreshControl()

        Notifications.videoCallUpdated.add(viewController: self, selector: #selector(refreshTriggered))
    }

    func stopAllRefreshControl() {

        if refreshControlTable!.isRefreshing {

            refreshControlTable?.endRefreshing()
        }
    }

    func addAllRefreshControl() {

        refreshControlTable = UIRefreshControl()
        refreshControlTable?.tintColor = appearences.newTheamColor
        refreshControlTable?.addTarget(self, action: #selector(refreshTriggered), for: UIControl.Event.valueChanged)
        tblVideoCalls.addSubview(refreshControlTable!)
    }
}

// MARK: - Navigations
extension VideoCallListingViewController {

    func gotoVideoCallScreen(_ request: VideoCallRequest) {

        let videoCallVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallViewController.self)

        videoCallVC.request = request

        self.navigationController?.pushViewController(videoCallVC, animated: true)
    }

    func gotoVideoCallDetailsScreen(_ request: VideoCallRequest) {

        guard let callId = request._id else { return }

        let videoCallDetailVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallViewController.self)

      //  videoCallDetailVC.requestId = callId
        videoCallDetailVC.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(videoCallDetailVC, animated: true)
    }

    func gotoRescheduleScreen(_ request: VideoCallRequest) {

        let rescheduleVC = Storyboard.main.instantiateViewController(viewController: RescheduleVideoCallViewController.self)

       rescheduleVC.request = request
        rescheduleVC.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(rescheduleVC, animated: true)
        
       
    }
    
    
    func gotoHelpSupportScreen(_ request: VideoCallRequest) {

        let helpSupportVC = Storyboard.main.instantiateViewController(viewController: HelpAndSupportViewController.self)
        helpSupportVC.request = request
       // helpSupportVC.PurchaseId =  passbookData?._id ?? ""
        helpSupportVC.PurchaseId =  request.passbook_id ?? ""
        helpSupportVC.isSelectedVideoCall = true
        helpSupportVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(helpSupportVC, animated: true)
    }

//    func gotoVideoCallPreferredDaysScreen() {
//
//        let preferredDaysVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallsPreferredDaysViewController.self)
//
//        preferredDaysVC.hidesBottomBarWhenPushed = true
//
//        self.navigationController?.pushViewController(preferredDaysVC, animated: false)
//    }
}

// MARK: - TableView Delegate & DataSource Methods
extension VideoCallListingViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        if arrRequests.count == 0 && apiCallStatus.shouldShowNotFound {

            tableView.setPlaceholder(title: stringConstants.noRecordsFound, detail: "")
        }
        else {

            tableView.backgroundView = nil
        }

        return arrRequests.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 202
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 12
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 12))

        viewHeader.backgroundColor = .clear

        return viewHeader
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCallListingTableCell") as! VideoCallListingTableCell

        let request = arrRequests[indexPath.section]
        cell.setDetails(request, serverTime: serverTime)

        cell.btnJoinNow.tag = indexPath.section
        cell.btnSchedule.tag = indexPath.section
        cell.btnHelpAndSupport.tag = indexPath.section

        cell.btnJoinNow.addTarget(self, action: #selector(cellBtnJoinNowClicked(btn:)), for: .touchUpInside)
        cell.btnSchedule.addTarget(self, action: #selector(cellBtnRescheduleClicked(btn:)), for: .touchUpInside)
         cell.btnHelpAndSupport.addTarget(self, action: #selector(cellBtnHelpAndSupportClicked(btn:)), for: .touchUpInside)
       
        
        
        cell.noSelectionStyle()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let request = arrRequests[indexPath.section]
//
//        gotoVideoCallDetailsScreen(request)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if apiCallStatus.isLoadMore && indexPath.section == arrRequests.count - 1 {

            loadMoreTriggered()
        }
    }

    // Cell Methods
    @objc func cellBtnJoinNowClicked(btn: UIButton) {
         let request = arrRequests[btn.tag]
        if let rescheduledBy = request.rescheduled_by, rescheduledBy == "producer" && request.status != "accepted"{
            webAcceptRequest(request, toStatus: "accepted")
             print("Call accept api")
            
        }else{
            let request = arrRequests[btn.tag]
             gotoVideoCallScreen(request)
        }
        
    }

    @objc func cellBtnRescheduleClicked(btn: UIButton) {

        let request = arrRequests[btn.tag]

        gotoRescheduleScreen(request)
    }
    
    
    @objc func cellBtnHelpAndSupportClicked(btn: UIButton) {

        let request = arrRequests[btn.tag]

        gotoHelpSupportScreen(request)
    }
    
    
    
}

// MARK: - Web Service
extension VideoCallListingViewController {

    @objc func refreshTriggered() {

        webGetVideoCallList(isRefresh: true)
    }

    @objc func loadMoreTriggered() {

        stopAllRefreshControl()
        webGetVideoCallList(isRefresh: false)
    }

    func webGetVideoCallList(isRefresh: Bool) {

        webVideoCall?.cancel()

        var dictParams = [String:Any]()

        if isRefresh {

            dictParams["page"] = 1
        }
        else {

            dictParams["page"] = apiCallStatus.page + 1
        }

        //dictParams["status"] = "upcoming"

         let api = Constants.getVideoCallList

        
         let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: apiCallStatus.shouldShowLoader ? self.view : nil)

        
        web.shouldPrintLog = true

        apiCallStatus.shouldShowLoader = false


        web.execute(type: .get, name: api, params: dictParams as [String : AnyObject]) { [weak self] (status, msg, dict) in

            guard let self = self else { return }

            self.apiCallStatus.isLoadMore = false
            self.apiCallStatus.isCalling = false
            self.apiCallStatus.shouldShowNotFound = true
            self.stopAllRefreshControl()

            if status {

                guard let dictRes = dict else {

                    utility.showToast(msg: stringConstants.somethingWentWrong)

                    return
                }

                if let error = dictRes["error"] as? Bool, error == true {

                    if let arrErrors = dictRes["error_messages"] as? [String] {

                        utility.showToast(msg: arrErrors[0])
                    }
                    else {

                        utility.showToast(msg: stringConstants.somethingWentWrong)
                    }

                    return
                }

                guard let dictData = dictRes["data"] as? [String:Any] else {

                    utility.showToast(msg: stringConstants.somethingWentWrong)

                    return
                }

                if let paginate_data = dictData["paginate"] as? [String: Any] {

                    if let pagination = PaginationStats.object(paginate_data) {

                        if let last_page = pagination.last_page, let current_page = pagination.current_page {

                            if last_page > current_page {

                                self.apiCallStatus.isLoadMore = true
                            }
                        }
                    }
                }

                if let server_time = dictData["server_time"] as? [String:Any], let objServerTime = ServerTime.object(server_time) {

                    self.serverTime = objServerTime
                }

                guard let arrList = dictData["list"] as? [[String:Any]], let arrReqs = VideoCallRequest.object(arrList) else {

                    utility.showToast(msg: stringConstants.somethingWentWrong)

                    return
                }

                if arrReqs.count > 0 {

                    if isRefresh {

                        self.arrRequests.removeAll()
                        self.arrRequests.append(contentsOf: arrReqs)

                        self.tblVideoCalls.reloadData()

                        self.apiCallStatus.page = 1
                    }
                    else {

                        self.arrRequests.append(contentsOf: arrReqs)

                        self.tblVideoCalls.reloadData()

                        self.apiCallStatus.page = self.apiCallStatus.page + 1
                    }
                }
                else {

                    if isRefresh {

                        self.apiCallStatus.page = 1

                        self.arrRequests.removeAll()
                        self.tblVideoCalls.reloadData()
                    }
                }
            }
            else {

                utility.showToast(msg: msg!)
            }
        }
    }

    func webAcceptRequest(_ request: VideoCallRequest, toStatus: String) {

        guard let requestId = request._id else {

            return
        }

        var dictParams = ["_id": requestId]

        dictParams["status"] = toStatus
        dictParams["updated_by"] = "customer"

        let api = Constants.updateVideoCall

         let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
        

        web.shouldPrintLog = true

        web.execute(type: .post, name: api, params: dictParams as [String : AnyObject]) { [weak self] (status, msg, dict) in

            if status {

                guard let dictRes = dict else {

                     utility.showToast(msg: stringConstants.somethingWentWrong)
                    return
                }

                if let error = dictRes["error"] as? Bool, error == true {

                    if let arrErrors = dictRes["error_messages"] as? [String] {

                        utility.showToast(msg: arrErrors[0])

                    }
                    else {
                        utility.showToast(msg: stringConstants.somethingWentWrong)
                    }

                    return
                }
                guard let msg = dictRes["message"] as? String else {
                    
                    utility.showToast(msg: stringConstants.somethingWentWrong)
                    request.status = toStatus
                    self?.arrRequests.removeAll()
                     self?.addAllRefreshControl()
                    self?.tblVideoCalls.reloadData()
                    return
                }
                
                utility.showToast(msg: msg)
                
                Notifications.videoCallUpdated.post(object: nil)
                
            }
            else {
                utility.showToast(msg: msg!)
//                self?.showError(msg: msg!)
            }
        }
    }
}

extension UITableViewCell {
    func noSelectionStyle() {
        self.selectionStyle = .none
    }
}
