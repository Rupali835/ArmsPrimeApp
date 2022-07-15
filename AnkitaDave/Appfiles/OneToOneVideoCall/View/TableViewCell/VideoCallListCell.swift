//
//  VideoCallListCell.swift
//  AnkitaDave
//
//  Created by Shriram on 12/12/20.
//

import UIKit
import SwiftyJSON

import CoreSpotlight
import MobileCoreServices
import SafariServices

protocol VideoCallListCellDelegate {
    func clickOnRescheduleButton(at indexPath:IndexPath, sender:UIButton)
    func clickOnRescheduleSecondButton(at indexPath:IndexPath, sender:UIButton)
    func clickOnJoinNowButton(at indexPath:IndexPath, sender:UIButton)
}
class VideoCallListCell: UITableViewCell {
    var status : String? = " "
    var strArtistName : String? = " "
    var strNewDate : String? = " "
    var strCustomerName : String? = " "
    var strCoins : String? = " "
    var strDate : String? = " "
    var strStartTime : String?
    var strEndTime : String?
    var projects:[[String]] = []
    
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblTimeSlots: UILabel!
    @IBOutlet weak var btnReschedule: UIButton!
    @IBOutlet weak var btnJoinNow: UIButton!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var viewJoin: UIView!
    @IBOutlet weak var viewReschedule: UIView!
    @IBOutlet weak var vwBottomHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewRescheduleSecond: UIView!
    @IBOutlet weak var btnRescheduleSecond: UIButton!


    
    var delegate:VideoCallListCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnReschedule.addTarget(self, action: #selector(clickOnRescheduleButton(_:)), for: .touchUpInside)
        
        self.btnJoinNow.addTarget(self, action: #selector(clickOnJoinNowButton(_:)), for: .touchUpInside)
        
        
         self.btnRescheduleSecond.addTarget(self, action: #selector(clickOnRescheduleSecondButton(_:)), for: .touchUpInside)
        
        
    }
    
    
    
    func loadData(jsonObject:JSON, serverTime:String){
        
        projects.append(([String(describing: jsonObject)]))
        index(item: 0)
        self.lblTitle?.text = jsonObject["artist"]["name"].stringValue
        self.lblDate?.text = jsonObject["date"].stringValue.toDateString(fromFormat: .yyyyMMdd, toFormat: .ddMMM)
        self.lblTimeSlots?.text = jsonObject["time_slot"].stringValue
        self.lblCoins?.text = jsonObject["coins"].stringValue
        
        status = jsonObject["status"].stringValue
        
        strCoins = jsonObject["coins"].stringValue
        strDate = jsonObject["created_at"].stringValue
        strArtistName = jsonObject["artist"]["name"].stringValue
        strCustomerName = jsonObject["customer"]["name"].stringValue
        // print("serverTime: \(serverTime)")
        

                    if status == "accepted"{
                        self.lblStatus?.text = status
                        self.lblStatus?.text = status?.capitalized
                        self.lblStatus?.textColor = .systemGreen
                        projects.append( [(status ?? "")] )
                        projects.append( [(strCoins ?? "")] )
                        projects.append( [(strDate ?? "")] )
                        projects.append( [(strArtistName ?? "")] )
                        index(item: 0)
                        self.viewJoin?.backgroundColor = appearences.newIndigoColor
                        self.btnJoinNow?.setTitle("Join Now", for: .normal)
                        self.btnJoinNow?.setTitleColor(.white, for: .normal)
                }
        
                        if status == "rescheduled"{
                        self.viewJoin?.backgroundColor = .green
                        self.btnJoinNow?.setTitle("Accept", for: .normal)
                        self.btnJoinNow?.setTitleColor(.black, for: .normal)
                 
                        projects.append( [(status ?? "")] )
                        projects.append( [(strCoins ?? "")] )
                        projects.append( [(strDate ?? "")] )
                        projects.append( [(strArtistName ?? "")] )
                        index(item: 0)
                    }
         
        
        
        strStartTime = jsonObject["scheduled_at"].stringValue
        strEndTime = jsonObject["scheduled_end_at"].stringValue
        
        let dateString = serverTime
        let newDate = dateString.toDate(dateFormat: DateFormat.yyyyMMddHHmmss.rawValue)
        print("Date is \(newDate)")
        print("serverTime: \(serverTime)")
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ" //Your date format
//        dateFormatter.timeZone = TimeZone(abbreviation: "IST+0:00") //Current time zone
//        if let datea = dateFormatter.date(from: serverTime){
//            print("datea: \(datea)")
//        }
//
        /*
        if let scheduled_at = strStartTime, let scheduled_end = strEndTime, let _ = scheduled_at.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .ddMMMyyyy), let time = scheduled_at.toDateString(fromFormat: .ddMMMyyyyhhmmWithComma, toFormat: .hhmma), let scheduledAt = scheduled_at.toDate(from: .ddMMMyyyyhhmmWithComma), let scheduledEnd = scheduled_end.toDate(from: .ddMMMyyyyhhmmWithComma){
            
            let now = newDate
            
            if (Calendar.current.compare(now, to: scheduledAt, toGranularity: .day) == .orderedSame) && (Calendar.current.compare(now, to: scheduledAt, toGranularity: .month) == .orderedSame) && (Calendar.current.compare(now, to: scheduledAt, toGranularity: .year) == .orderedSame) {
                
                lblDate.text = "Today"
            }
            else {
                
                lblDate.text = jsonObject["date"].stringValue.toDateString(fromFormat: .yyyyMMdd, toFormat: .ddMMM)
                self.lblTimeSlots?.text = jsonObject["time_slot"].stringValue
            }
            
            lblTimeSlots.text = time + ","
            
            let diffStart = utility.getDateDiff(start: now, end: scheduledAt)
            
            if diffStart < 0 {
                
                let diffEnd = utility.getDateDiff(start: now, end: scheduledEnd)
                
                if diffEnd < 0 {
                    
                    viewJoin.isHidden = true
                    viewRescheduleSecond.isHidden = false
                }
                else {
                    
                    viewJoin.isHidden = false
                    viewRescheduleSecond.isHidden = true
                }
            }
            else {
                
                if diffStart <= 300 {
                    
                    viewJoin.isHidden = false
                    viewRescheduleSecond.isHidden = true
                }
                else {
                    
                    viewJoin.isHidden = true
                    viewRescheduleSecond.isHidden = false
                }
            }
        }

        else {
            
            // lblDate.text = "N/A"
            
            //  lblTime.text = "Video call @ " + "N/A" + ","
            
           viewJoin.isHidden = true
        viewRescheduleSecond.isHidden = false
            
        }*/
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func clickOnRescheduleButton(_ sender: UIButton){
        guard let indexPath = self.tableView?.indexPath(for: self) else { return }
        self.delegate?.clickOnRescheduleButton(at: indexPath, sender: sender)
    }
    
    @objc func clickOnRescheduleSecondButton(_ sender: UIButton){
        guard let indexPath = self.tableView?.indexPath(for: self) else { return }
        self.delegate?.clickOnRescheduleSecondButton(at: indexPath, sender: sender)
    }
    
    @objc func clickOnJoinNowButton(_ sender: UIButton){
        guard let indexPath = self.tableView?.indexPath(for: self) else { return }
        self.delegate?.clickOnJoinNowButton(at: indexPath, sender: sender)
    }
    
    
    // MARK- SPOTLIGHT SEARCH
    func index(item:Int) {
        
        let project = projects[item]
        let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attrSet.title = project[0]
        //attrSet.contentDescription = project[1]
        attrSet.contentDescription = project[0]
        
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
}
extension String
{
    func toDate( dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "IST") as TimeZone?
        return (dateFormatter.date(from: self))!
    }
    
}
