//
//  HorizontalCollectionCell.swift
//  PaginationUIManager-Example
//
//  Created by Abhishek Thapliyal on 14/07/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import UIKit
import SwiftyJSON

import CoreSpotlight
import MobileCoreServices
import SafariServices

protocol HorizontalCollectionCellDelegate {
    func clickOnJoinNowButton(at indexPath:IndexPath, sender:UIButton)
}
class HorizontalCollectionCell: UICollectionViewCell {
    
    var status : String? = " "
    var strArtistName : String? = " "
    var strVCDate : String? = " "
    var strCustomerName : String? = " "
    var strCoins : String? = " "
    var strDate : String? = " "
    var strStartTime : String?
    var strEndTime : String?
    var projects:[[String]] = []
     var serverTime: ServerTime?
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var btnJoinCall: UIButton!
     @IBOutlet weak var lblTimeDiff: UILabel!
    
    var delegate:HorizontalCollectionCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnJoinCall.isHidden = true
      }
     
    func update(index: Int) {
        self.lblTime.text = "Video Call @ \(index)"
        self.backgroundColor = index % 2 == 0 ? .lightGray : .lightText
    }
    
    func loadData(jsonObject:JSON, serverTime:String){
    
        status = jsonObject["status"].stringValue
        strArtistName = jsonObject["artist"]["name"].stringValue
        strVCDate = jsonObject["time"].stringValue
        //self.btnJoinCall.isHidden = true
        
    
            self.btnJoinCall?.isHidden = false
            
            strStartTime = jsonObject["scheduled_at"].stringValue
            strEndTime = jsonObject["scheduled_end_at"].stringValue
            
            let dateString = serverTime
            let newDate = dateString.toDate(dateFormat: DateFormat.yyyyMMddHHmmss.rawValue)
            print("Date is \(newDate)")
            print("serverTime: \(serverTime)")
            
      
           
             if let scheduleAt = strStartTime, let scheduledAt = scheduleAt.toDate(from: .ddMMMyyyyhhmmWithComma), let startTime = scheduleAt.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .hhmma), let scheduleEnd = strEndTime, let endTime = scheduleEnd.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .hhmma), let scheduleDate = scheduleAt.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .ddMMMyyyy), let date = scheduleAt.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .ddMMMyyyy), let scheduledEnd = scheduleEnd.toDate(from: .ddMMMyyyyhhmmWithComma){
                
                lblDate.text = scheduleDate
                lblTimeDiff?.text = startTime + " - " + endTime
                lblTime.text = "Video Call @ " + jsonObject["time"].stringValue
                lblArtistName.text = "with " +  jsonObject["artist"]["name"].stringValue
                let now = newDate
                
                
                
                if (Calendar.current.compare(now, to: scheduledAt, toGranularity: .day) == .orderedSame) && (Calendar.current.compare(now, to: scheduledAt, toGranularity: .month) == .orderedSame) && (Calendar.current.compare(now, to: scheduledAt, toGranularity: .year) == .orderedSame) {

                    lblDate.text = "Today"
                }
                else {

                    lblDate.text = date
                }
                
//                lblTime.text = time + ","
                 lblTime.text = "Video Call @ " + jsonObject["time"].stringValue
                
                let diffStart = utility.getDateDiff(start: now, end: scheduledAt)
                
                if diffStart < 0 {
                    
                    let diffEnd = utility.getDateDiff(start: now, end: scheduledEnd)
                    
                    if diffEnd < 0 {
                        
                        btnJoinCall.isHidden = true
                    }
                    else {
                        
                        btnJoinCall.isHidden = false
                    }
                }
                else {
                    
                    if diffStart <= 300 {
                        
                        btnJoinCall.isHidden = false
                    }
                    else {
                        
                        btnJoinCall.isHidden = true
                    }
                }
            }
                
            else {
                
                lblDate.text = "N/A"
                lblTime.text = "Video call @ " + "N/A" + ","
                btnJoinCall.isHidden = true
        }
    }
    
    

        func setDetails(_ request: VideoCallRequest, serverTime: ServerTime?) {

    //        if let imgURL = request.customer?.picture, imgURL.count > 0 {
    //
    ////            imgViewProfilePic.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "profile_placeholder_small"), options: .highPriority, context: [:])
    //        }
    //        else {
    //
    ////            imgViewProfilePic.image = UIImage(named: "profile_placeholder_small")
    //        }
            
    //        if CustomerDetails.firstName != nil && CustomerDetails.firstName != ""{
    //            if CustomerDetails.lastName != nil {
    //                self.lblName.text = CustomerDetails.firstName! + " " + CustomerDetails.lastName
    //            } else {
    //                self.lblName.text = CustomerDetails.firstName!
    //            }
    //
    //            self.lblName.text = lblName.text?.uppercased()
    //        }

           // if let name = CustomerDetails.firstName + CustomerDetails.lastName {
            
         
    //        else {
    //
    //            lblName.text = ""
    //        }

            if let scheduleAt = request.scheduled_at, let scheduledAt = scheduleAt.toDate(from: .ddMMMyyyyhhmmWithComma), let startTime = scheduleAt.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .hhmma), let scheduleEnd = request.scheduled_end_at, let endTime = scheduleEnd.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .hhmma), let scheduleDate = scheduleAt.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .ddMMMyyyy), let date = scheduleAt.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .ddMMMyyyy), let scheduledEnd = scheduleEnd.toDate(from: .ddMMMyyyyhhmmWithComma) {

                lblDate.text = scheduleDate
                lblTime.text = "Video Call @ " + startTime + " - " + endTime
                

                let now = serverTime?.istDate ?? Date()

                if (Calendar.current.compare(now, to: scheduledAt, toGranularity: .day) == .orderedSame) && (Calendar.current.compare(now, to: scheduledAt, toGranularity: .month) == .orderedSame) && (Calendar.current.compare(now, to: scheduledAt, toGranularity: .year) == .orderedSame) {

                    lblDate.text = "Today"

                }
                else {

                    lblDate.text = date
                }

                let diffStart = utility.getDateDiff(start: now, end: scheduledAt)

                if diffStart < 0 {

                    let diffEnd = utility.getDateDiff(start: now, end: scheduledEnd)

                    if diffEnd < 0 {

                        btnJoinCall.isHidden = true
                    }
                    else {

                        btnJoinCall.isHidden = false
                    }
                }
                else {

                    if diffStart <= 300 {

                        btnJoinCall.isHidden = false
                    }
                    else {

                        btnJoinCall.isHidden = true
                    }
                }
            }
            else {
                lblDate.text = "N/A"
                lblTime.text = "N/A" + " - " + "N/A"
    //            lblDate.text = request.date?.toDateString(fromFormat: .yyyyMMdd, toFormat: .ddMMM) //scheduleDate
    //            lblTiming.text = request.time//startTime + " - " + endTime
                btnJoinCall.isHidden = true
            }
         
        }
    
    
}



