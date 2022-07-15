//
//  RescheduleVideoCallViewController.swift
//  Producer
//
//  Created by Parikshit on 14/12/20.
//  Copyright © 2020 developer2. All rights reserved.
//

import UIKit

class RescheduleVideoCallViewController: UIViewController {

    @IBOutlet weak var cvDates: UICollectionView!
    @IBOutlet weak var cvTime: UICollectionView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblSelectedMonth: UILabel!
    @IBOutlet weak var vcMonths: UIView!
    @IBOutlet weak var vcSlots: UIView!


    var currentDate = Date()
    var selectedDate: Date!
    var selectedSlot:String? = nil
    var videoCallDuration: String?
    var strnNewCustomer: String?
    var customerFirstName : String?
       var customerLastName : String?
       var customerFullName : String?
     var videoCallRequestID : String? = " "
    var arrSlots = [String]()
    
     var request: VideoCallRequest!
    //var request: VGShoutout!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLayoutAndDesign()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
            vcMonths.roundCorners(corners: [.topLeft, .topRight], radius: 8)
            vcSlots.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
       }
}

// MARK: - IBAction
extension RescheduleVideoCallViewController {
    
    @IBAction func btnDoneClicked() {
        
        webRescheduleVideoCall()
    }
}

// MARK: - Utility Methods
extension RescheduleVideoCallViewController {
    
    func setLayoutAndDesign() {
        
        self.navigationItem.title = stringConstants.titleRescheduleVideoCall
        
        btnDone.cornerRadius = btnDone.frame.size.height/2
        btnDone.isEnabled = false
        
        selectedDate = currentDate
        webGetSlots()
        
        setComponentVisibility()
        
        setCustName()
    }
 
    func setCurrentMonth() {
        
        let date = selectedDate
        
        lblSelectedMonth.text = date?.toString(to: .MMMM).uppercased()
    }
    
    func setCustName() {
        
        customerFirstName = CustomerDetails.firstName
        customerLastName = CustomerDetails.lastName
        let combined2 = "\(customerFirstName ?? "")  \(customerLastName ?? "")"
        
        
        let nameCust = Constants.celebrityName//combined2 //"Ram Kadam"
//        var nameCust = "Ram Kadam"
//
////        if let name = request?.customer?.name {
////
////            nameCust = name
////        }
        
        let msg = "Reschedule your video call with \(nameCust)"
        
        let strAtt = NSMutableAttributedString(string: msg)
        
        strAtt.addAttributes([NSAttributedString.Key.font : fonts.light(size: 22)], range: (msg as NSString).range(of: msg))
        
        strAtt.addAttributes([NSAttributedString.Key.font : fonts.bold(size: 22)], range: (msg as NSString).range(of: nameCust))
        
        lblDesc.attributedText = strAtt
    }
    
    func setComponentVisibility() {
                
        if selectedDate != nil && selectedSlot != nil {
            
            btnDone.isEnabled = true
            btnDone.backgroundColor = appearences.yellowColor
            btnDone.setTitleColor(.white, for: .normal)
        }
        else {
            
            btnDone.isEnabled = false
            btnDone.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            btnDone.setTitleColor(.gray, for: .normal)
        }
        setCurrentMonth()
    }
}

// MARK: - CollectionView Delegate & DataSource Methods
extension RescheduleVideoCallViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == cvDates {
            
            return 30
        }
        
        if collectionView == cvTime {
            
            if arrSlots.count == 0 {
                
                if selectedDate == nil {
                    
                    collectionView.setPlaceholderDetails(title: "", detail: stringConstants.selectDurationToSeeAvailableSlots, titleColor: .clear, detailColor: utility.rgb(0, 0, 0, 0.25), detailFont: fonts.regular(size: 12))
                }
                else {
                    
                    collectionView.setPlaceholderDetails(title: "", detail: stringConstants.noAvailableSlots, titleColor: .clear, detailColor: utility.rgb(0, 0, 0, 0.25), detailFont: fonts.regular(size: 12))
                }
            }
            else {
                
                collectionView.removePlaceholder()
            }
            
            return arrSlots.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        if collectionView == cvDates {
            
            return CGSize(width: 60, height: 80)
        }
        else {
            
            return CGSize(width: 80, height: 34)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        if collectionView == cvDates {
            
            let cell = cellForDate(indexPath: indexPath)
            return cell
        }
        else {
            
            let cell = cellForTime(indexPath: indexPath)
            return cell
        }
    }
    
    func cellForDate(indexPath: IndexPath) -> RescheduleVideoCallDateCollectionCell {
        
        let cell = cvDates.dequeueReusableCell(withCell: RescheduleVideoCallDateCollectionCell.self, indexPath: indexPath)
        
        cell?.setDetails(currentDate: currentDate, offset: indexPath.row, selectedDate: selectedDate!)
                  
        return cell!
    }
    
    func cellForTime(indexPath: IndexPath) -> RescheduleVideoCallTimeCollectionCell {
        
        let cell = cvTime.dequeueReusableCell(withCell: RescheduleVideoCallTimeCollectionCell.self, indexPath: indexPath)
        
        cell?.setDetails(slot: arrSlots[indexPath.item], selected: selectedSlot)
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == cvDates, let date = currentDate.dateByAdding(day: indexPath.row) {
            
            selectedDate = date
                        
            cvDates.reloadData()
            
            webGetSlots()
        }
        
        if collectionView == cvTime {
            
            selectedSlot = arrSlots[indexPath.item]
            
            cvTime.reloadData()
        }
        
        setComponentVisibility()
    }
}

// MARK: - Web Service
extension RescheduleVideoCallViewController {
    
    func webGetSlots() {
        
        var dictParams = [String: Any]()
        
        let strDate = selectedDate.toString(to: .yyyyMMdd)
        dictParams["date"] = strDate
        
        if let duration = request?.duration {
            
            dictParams["duration"] =  duration//videoCallDuration ?? ""
        }
        
         let api = Constants.getVideoCallGetSlots
        
        
      //  let web = WebService(showInternetProblem: true, isCloud: false, loaderView: self.view)
            let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)

        
        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { [weak self] (status, msg, dict) in
                        
            guard let self = self else { return }
            
            if status {
                
                guard let dictRes = dict else {
                    
                    utility.showToast(msg: stringConstants.somethingWentWrong)
                                        
                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {
                    
                    self.selectedSlot = nil
                    
                    self.arrSlots.removeAll()
                    
                    self.cvTime.reloadData()

                    self.setComponentVisibility()
                    
                    if let arrErrors = dictRes["error_messages"] as? [String] {
                        
                        utility.showToast(msg: arrErrors[0])
                    }
                    else {
                        
                        utility.showToast(msg: stringConstants.somethingWentWrong)
                    }
                    
                    return
                }
                
                guard let dictData = dictRes["data"] as? [String: Any] else {
                    
                    utility.showToast(msg: stringConstants.somethingWentWrong)
                    
                    return
                }
                
                guard let artistSlots = dictData["slots"] as? [String] else {
                    
                    utility.showToast(msg: stringConstants.somethingWentWrong)
                    
                    return
                }
                
                self.selectedSlot = nil
                
                self.arrSlots.removeAll()
                
                self.arrSlots.append(contentsOf: artistSlots)
                
                self.cvTime.reloadData()
                
                self.setComponentVisibility()
            }
            else {
                
                utility.showToast(msg: msg!)
            }
        }
    }
    
    func webRescheduleVideoCall() {
        
        guard let callId = request?._id else { return }
        
        var dictParams = [String: Any]()
        
        let strDate = selectedDate.toString(to: .yyyyMMdd)
        dictParams["date"] = strDate
        
        dictParams["_id"] = callId
        dictParams["updated_by"] = "customer"
        dictParams["status"] = "rescheduled"
       // dictParams["_id"] = callId
        
//       // if let duration = request.duration {
//
//            dictParams["duration"] = videoCallDuration
//     //   }
        if let duration = request.duration {
            
            dictParams["duration"] = duration
        }
        
        dictParams["time"] = selectedSlot
        
       // let api = Constants.updateVideoCall
       let api = Constants.updateVideoCall
        
      //  let web = WebService(showInternetProblem: true, isCloud: false, loaderView: self.view)
         let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)

        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { [weak self] (status, msg, dict) in
                        
            guard let self = self else { return }
            
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
                    
                    return
                }
                
                utility.showToast(msg: msg)
                
                Notifications.videoCallUpdated.post(object: nil)
                
                self.navigationController?.popViewController(animated: true)
            }
            else {
                
                utility.showToast(msg: msg!)
            }
        }
    }
}

