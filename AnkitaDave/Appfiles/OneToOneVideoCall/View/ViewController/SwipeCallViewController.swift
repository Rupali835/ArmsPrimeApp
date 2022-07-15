//
//  SwipeCallViewController.swift
//  AnkitaDave
//
//  Created by Shriram on 18/12/20.
//

import UIKit

import StoreKit
import SwiftyJSON
import SwiftyStoreKit
import MoEngage
import NVActivityIndicatorView
import IQKeyboardManagerSwift

import CoreSpotlight
import MobileCoreServices
import SafariServices


//public func delay(_ delay: Double, closure: @escaping () -> Void) {
//    let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//    DispatchQueue.main.asyncAfter(
//        deadline: deadline,
//        execute: closure
//    )
//}

class SwipeCallViewController: BaseViewController {
    @IBOutlet weak var joinVCCollectionView: UICollectionView!
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
    
    @IBOutlet var lblNoTransaction: UILabel!
    
    var strNewID : String?
    var strNewDuration : String?
    var strNewTimeSlots : String?
    var strNewDate : String?
    var strnNewCustomer : String?
    
    //var myView = UIView()
    
    var items = [1,2,3,4,5]
    
//    private lazy var paginationManager: HorizontalPaginationManager = {
//        let manager = HorizontalPaginationManager(scrollView: self.joinVCCollectionView!)
//        manager.delegate = self
//        return manager
//    }()
    
    private var isDragging: Bool {
        return self.joinVCCollectionView.isDragging
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
//        self.setupPagination()
//        self.fetchItems()
         
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.showLoader()
        self.getVideoCallList()
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
                        
                        //                    if self.list.count == 0 {
                        //                        self.lblNoTransaction.isHidden = false
                        //                        self.lblNoTransaction.text? = "No Transaction History"
                        //                        self.lblNoTransaction.adjustsFontSizeToFitWidth = true
                        //                        self.lblNoTransaction.textAlignment = NSTextAlignment.center
                        //                    }
                    }
                    DispatchQueue.main.async {
                        self.joinVCCollectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                    self.stopLoader()
                }
            }
        }
    }
    
}

extension SwipeCallViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        self.joinVCCollectionView?.delegate = self
        self.joinVCCollectionView?.dataSource = self
        self.joinVCCollectionView?.alwaysBounceHorizontal = true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HorizontalCollectionCell",
            for: indexPath
            ) as! HorizontalCollectionCell
        let jsonObject = self.list[indexPath.row]
        cell.loadData(jsonObject: jsonObject, serverTime: strServerTime ?? "")
        cell.btnJoinCall.tag = indexPath.row
        cell.btnJoinCall.addTarget(self, action: #selector(clickOnJoinVideoCall(sender:)), for: .touchUpInside)
        self.videoCallRequestID = jsonObject["_id"].stringValue
        self.strNewDuration = jsonObject["duration"].stringValue
        self.strnNewCustomer = jsonObject["customer"]["name"].stringValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
    
    @objc func clickOnJoinVideoCall(sender: UIButton) {
        
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

extension SwipeCallViewController: HorizontalPaginationManagerDelegate {
    
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
            self.items = [1, 2, 3, 4, 5]
            self.joinVCCollectionView.reloadData()
            completion(true)
        }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        delay(2.0) {
            self.items.append(contentsOf: [6, 7, 8, 9, 10])
            self.joinVCCollectionView.reloadData()
            completion(true)
        }
    }
}


