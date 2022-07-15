//
//  VideoCallListingTableCell.swift
//  Producer
//
//  Created by Parikshit on 19/10/20.
//  Copyright © 2020 developer2. All rights reserved.
//

import UIKit

class VideoCallListingTableCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var btnJoinNow: UIButton!
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnHelpAndSupport: UIButton!
    @IBOutlet weak var lblAccpetdedTitle: UILabel!
    
    var customerFirstName : String?
    var customerLastName : String?
    var customerFullName : String?
    var serverTime: ServerTime?
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayoutAndDesigns()
    }
    
    func setLayoutAndDesigns() {
        
        viewContainer.cornerRadius = 10
        viewContainer.borderWidth = 1
        viewContainer.borderColor = utility.rgb(234, 234, 234, 1)
    }
    
    func setDetails(_ request: VideoCallRequest, serverTime: ServerTime?) {
        
        customerFirstName = CustomerDetails.firstName
        customerLastName = CustomerDetails.lastName
        let combined2 = "\(customerFirstName ?? "")   \(customerLastName ?? "")"
        
        lblName.text = combined2.uppercased()
        
        func updateDateLabel(){
            
            self.lblAccpetdedTitle.text = stringConstants.titleAcceptedVideoRequest
            let now = serverTime?.istDate ?? Date()
            if let scheduleAt = request.scheduled_at, let scheduledAt = scheduleAt.toDate(from: .ddMMMyyyyhhmmWithComma), let startTime = scheduleAt.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .hhmma), let scheduleEnd = request.scheduled_end_at, let endTime = scheduleEnd.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .hhmma), let scheduleDate = scheduleAt.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .ddMMMyyyy){
                
                lblDate.text = scheduleDate
                lblTiming.text = startTime + " - " + endTime
                
                
                if (Calendar.current.compare(now, to: scheduledAt, toGranularity: .day) == .orderedSame) && (Calendar.current.compare(now, to: scheduledAt, toGranularity: .month) == .orderedSame) && (Calendar.current.compare(now, to: scheduledAt, toGranularity: .year) == .orderedSame) {
                    lblDate.text = "Today"
                }else if let date = scheduleAt.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .ddMMMyyyy) {
                    lblDate.text = date
                }else{
                    lblDate.text = "N/A"
                    lblTiming.text = "N/A" + " - " + "N/A"
                }
            }
        }
        
        func checkJoinNowVisibility()->Bool{
            
            self.lblAccpetdedTitle.isHidden = true
            if let scheduleAt = request.scheduled_at, let scheduledAt = scheduleAt.toDate(from: .ddMMMyyyyhhmmWithComma), let scheduleEnd = request.scheduled_end_at, let scheduledEnd = scheduleEnd.toDate(from: .ddMMMyyyyhhmmWithComma) {
                
                let now = serverTime?.istDate ?? Date()
                
                let diffStart = utility.getDateDiff(start: now, end: scheduledAt)
                
                if diffStart < 0 {
                    
                    let diffEnd = utility.getDateDiff(start: now, end: scheduledEnd)
                    
                    if diffEnd < 0 {
                        return false
                    }
                    return true
                }else {
                    if diffStart <= 300 {
                        return true
                    }
                    return false
                }
            }
            return  false
        }
        
        let status = request.status ?? ""
        let rescheduledBy = request.rescheduled_by ?? ""
        updateDateLabel()
        if status == "completed" {
            if rescheduledBy != "producer"{
                self.btnJoinNow?.isHidden = true
            }
            self.btnJoinNow?.isHidden = true
            self.lblAccpetdedTitle.isHidden = true
            btnSchedule.setTitle(status.capitalized, for: .normal)
            btnSchedule.borderWidth = 1
            btnSchedule.borderColor = utility.rgb(234, 234, 234, 1)
            btnSchedule.setTitleColor(utility.rgb(102, 102, 102, 1), for: .normal)
            btnSchedule.isUserInteractionEnabled = false
        } else if status == "rejected" {
            if rescheduledBy != "producer"{
                self.btnJoinNow?.isHidden = true
            }
            updateDateLabel()
            self.btnJoinNow?.isHidden = true
            self.lblAccpetdedTitle.isHidden = true
            btnSchedule.setTitle(status.capitalized, for: .normal)
            btnSchedule.borderWidth = 1
            btnSchedule.borderColor = utility.rgb(234, 234, 234, 1)
            btnSchedule.setTitleColor(utility.rgb(102, 102, 102, 1), for: .normal)
            btnSchedule.isUserInteractionEnabled = false
        }else if status == "pending" {
            if rescheduledBy != "producer"{
                self.btnJoinNow?.isHidden = true
            }
            updateDateLabel()
            self.btnJoinNow?.isHidden = true
            self.lblAccpetdedTitle.isHidden = true
            btnSchedule.setTitle(status.capitalized, for: .normal)
            btnSchedule.borderWidth = 1
            btnSchedule.borderColor = utility.rgb(234, 234, 234, 1)
            btnSchedule.setTitleColor(utility.rgb(102, 102, 102, 1), for: .normal)
            btnSchedule.isUserInteractionEnabled = false
        }else if status == "accepted" || rescheduledBy == "customer" {
            btnSchedule.isUserInteractionEnabled = true
             btnSchedule.borderWidth = 1
            btnSchedule.borderColor = utility.rgb(234, 234, 234, 1)
            btnSchedule.setTitleColor(utility.rgb(255, 255, 255, 1), for: .normal)
            btnSchedule.setTitle("Reschedule", for: .normal)
            self.btnJoinNow?.backgroundColor = appearences.newIndigoColor
            self.btnJoinNow?.setTitle("Join Now", for: .normal)
            self.btnJoinNow?.setTitleColor(.white, for: .normal)
            let  isVisible = checkJoinNowVisibility()
            self.btnJoinNow?.isHidden = !isVisible
            self.lblAccpetdedTitle.isHidden = isVisible
        }else{
            
            btnSchedule.isUserInteractionEnabled = true
            btnSchedule.borderWidth = 1
            btnSchedule.borderColor = utility.rgb(234, 234, 234, 1)
            btnSchedule.setTitleColor(utility.rgb(255, 255, 255, 1), for: .normal)
            btnSchedule.setTitle("Reschedule", for: .normal)
            self.lblAccpetdedTitle.isHidden = false
            
            if rescheduledBy == "producer" || status == "rescheduled"
            {
                self.btnJoinNow?.isHidden = false
                self.btnJoinNow?.backgroundColor = utility.rgb(0, 77, 0, 1)
                self.btnJoinNow?.setTitle("Accept", for: .normal)
                self.btnJoinNow?.setTitleColor(.white, for: .normal)
                self.lblAccpetdedTitle.isHidden = true
            }else{
                self.btnJoinNow?.isHidden = true
            }
        }
        
    }
}




