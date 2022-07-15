//
//  RequestListModelController.swift
//  AnkitaDave
//
//  Created by Shriram on 21/12/20.
//

import UIKit
// VC Call new
import StoreKit
import SwiftyJSON
import SwiftyStoreKit
import MoEngage
import NVActivityIndicatorView
import IQKeyboardManagerSwift

import CoreSpotlight
import MobileCoreServices
import SafariServices

protocol RequestListModelControllerDelegate:class {
    func joinVideoCall(request:VideoCallRequest)
}
class RequestListModelController: NSObject {
    // VC CALL new
    weak var delegate:RequestListModelControllerDelegate?
    weak var joinVCCollectionView: UICollectionView?
    weak var joinVCView: UIView?
    var VCRequestList = [JSON]()
    lazy var arrRequests = [VideoCallRequest]()
    
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
    var strNewID : String?
    var strNewDuration : String?
    var strNewTimeSlots : String?
    var strNewDate : String?
    var strnNewCustomer : String?
    var newServerTime: ServerTime?
    //var myView = UIView()

    var serverTimeFinal: ServerTime?
    var webVideoCall: WebService? = nil
    var apiCallStatus = (shouldShowLoader:true, shouldShowNotFound:false, isCalling:false, page:1, isLoadMore: false)
    
    var items = [1,2,3,4,5]
    // VC Call new
    private var isDragging: Bool {
        return self.joinVCCollectionView?.isDragging ?? false
    }
    
    func onViewAppear() {
        //self.getVideoCallList()
        self.webGetVideoCallList()
        self.setupCollectionView()
    }
}

extension RequestListModelController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        self.joinVCCollectionView?.delegate = self
        self.joinVCCollectionView?.dataSource = self
        self.joinVCCollectionView?.alwaysBounceHorizontal = true
        
        
        // self.joinVCCollectionView?.scrollToItem(at: IndexPath(item: 2, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        
    }
    
    
   /*
     private func getVideoCallList() {
        if Reachability.isConnectedToNetwork(){
            
            let dict = ["page": "1", "status": "upcoming_today"]
            
            ServerManager.sharedInstance().getRequest(postData: dict, apiName: Constants.getVideoCallList, extraHeader: nil) { [weak self] (result) in
                guard let `self` = self else {return}
                print(result)
                switch result {
                case .success(let data):
                    
                    print(data)
                    if(data["error"] as? Bool == true){
                        return
                    }else {
                        self.strServerTime = data["data"]["server_time"]["ist"].stringValue
                        self.VCRequestList.append(contentsOf: data["data"]["list"].arrayValue)
                    }
                    self.joinVCCollectionView?.reloadData()
                    //                    DispatchQueue.main.async {
                    //                        self.joinVCCollectionView?.reloadData()
                    //                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
     */
    
    
    func webGetVideoCallList() {
        
        webVideoCall?.cancel()
        
        var dictParams = [String:Any]()
        
        //        if isRefresh {
        //
        //            dictParams["page"] = 1
        //        }
        //        else {
        //
        //            dictParams["page"] = apiCallStatus.page + 1
        //        }
        dictParams["page"] = 1
        dictParams["status"] = "upcoming_today"
        
        let api = Constants.getVideoCallList
        
        
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: apiCallStatus.shouldShowLoader ? self.joinVCView : nil)
        
        
        web.shouldPrintLog = true
        
        apiCallStatus.shouldShowLoader = false
        
        
        web.execute(type: .get, name: api, params: dictParams as [String : AnyObject]) { [weak self] (status, msg, dict) in
            
            guard let self = self else { return }
            
            self.apiCallStatus.isLoadMore = false
            self.apiCallStatus.isCalling = false
            self.apiCallStatus.shouldShowNotFound = true
            //self.stopAllRefreshControl()
            
            if status {
                
                guard let dictRes = dict else {
                    self.joinVCCollectionView?.reloadData()
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
                    self.joinVCCollectionView?.reloadData()
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
                    
                    self.serverTimeFinal = objServerTime
                }
                
                guard let arrList = dictData["list"] as? [[String:Any]], let arrReqs = VideoCallRequest.object(arrList) else {
                    
                    utility.showToast(msg: stringConstants.somethingWentWrong)
                    return
                }
                if let list = dictData["list"] as? [[String:Any]]{
                    if list.count == 0{
                        self.joinVCCollectionView?.isHidden = true
                    }else{
                        self.joinVCCollectionView?.isHidden = false
                    }
                    
                }
                self.arrRequests.removeAll()
                self.arrRequests.append(contentsOf: arrReqs)
                
                self.joinVCCollectionView?.reloadData()
                
                self.apiCallStatus.page = self.apiCallStatus.page + 1
            }
            else {
                
                utility.showToast(msg: msg!)
            }
        }
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrRequests.count
//        if arrRequests.count == 0 && apiCallStatus.shouldShowNotFound {
//
//            self.joinVCCollectionView?.setPlaceholder(title: stringConstants.noRecordsFound, detail: "")
//        }
//        else {
//
//            self.joinVCCollectionView?.backgroundView = nil
//        }
//
//        return arrRequests.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HorizontalCollectionCell",
            for: indexPath
            ) as! HorizontalCollectionCell
        
        
        let request = arrRequests[indexPath.row]
        // cell.setDetails(request, serverTime: ServerTime)
        cell.setDetails(request, serverTime: serverTimeFinal)
        // let jsonObject = self.arrRequests[indexPath.section]
        // cell.loadData(jsonObject: jsonObject, serverTime: strServerTime ?? "")
        cell.btnJoinCall.tag = indexPath.row
        // cell.btnJoinCall.addTarget(self, action: #selector(clickOnJoinVideoCall(sender:)), for: .touchUpInside)
        cell.btnJoinCall.addTarget(self, action: #selector(clickOnJoinVideoCall(btn:)), for: .touchUpInside)
        
        //    self.videoCallRequestID = jsonObject["_id"].stringValue
        //    self.strNewDuration = jsonObject["duration"].stringValue
        //    self.strnNewCustomer = jsonObject["customer"]["name"].stringValue
        //cell.setDetails(request, serverTime: PHDashboardManager.shared.serverTime)
        // cell.setDetails(request, serverTime: serverTime)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
    
    @objc func clickOnJoinVideoCall(btn: UIButton) {
        
        /* let videoCallVC = Storyboard.videoCall.instantiateViewController(viewController: VideoCallViewController.self)
         videoCallVC.videoCallreRuestIdOnAcceptedCall = videoCallRequestID
         videoCallVC.strVideoCallCoin = strVideoCallCoin
         videoCallVC.completionCallEnded = { [weak self] in
         //self?.showVideoCallFeedbackScreen(videoCallRequestID)
         }
         videoCallVC.hidesBottomBarWhenPushed = false
         self.navigationController?.pushViewController(videoCallVC, animated: true)*/
        let request = arrRequests[btn.tag]
        self.delegate?.joinVideoCall(request: request)
    }
    
}

extension RequestListModelController: HorizontalPaginationManagerDelegate {
    
    //    private func setupPagination() {
    //        self.paginationManager.refreshViewColor = .clear
    //        self.paginationManager.loaderColor = .white
    //    }
    //
    //    private func fetchItems() {
    //        self.paginationManager.initialLoad()
    //    }
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
        delay(2.0) {
            //  self.items = [1, 2, 3, 4, 5]
            self.joinVCCollectionView?.reloadData()
            completion(true)
        }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        delay(2.0) {
            // self.items.append(contentsOf: [6, 7, 8, 9, 10])
            self.joinVCCollectionView?.reloadData()
            completion(true)
        }
    }
    
    
    
    
}





