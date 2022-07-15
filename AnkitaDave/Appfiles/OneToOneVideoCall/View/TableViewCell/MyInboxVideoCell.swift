//
//  MyInboxVideoCell.swift
//  Gunjan Aras App
//
//  Created by Shriram on 18/06/20.
//  Copyright © 2020 armsprime. All rights reserved.
//

import UIKit
import SwiftyJSON

import CoreSpotlight
import MobileCoreServices
import SafariServices
protocol MyInboxVideoCellDelegate {
    func subscribeTapped(at indexPath:IndexPath, sender:UIButton)
}
class MyInboxVideoCell: UITableViewCell {
    var status : String? = " "
    var strArtistName : String? = " "
        var strCoins : String? = " "
        var strDate : String? = " "
       
       var projects:[[String]] = []


    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnMoreDetails: UIButton!
    @IBOutlet weak var lblCircle: UILabel!
    @IBOutlet weak var lblCoins: UILabel!

    
    var delegate:MyInboxVideoCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnMoreDetails.addTarget(self, action: #selector(subscribeTapped(_:)), for: .touchUpInside)
        
      
        lblCircle.layer.cornerRadius = lblCircle.frame.width/2
        lblCircle.layer.masksToBounds = true

    }
    
    func loadData(jsonObject:JSON){
        projects.append(([String(describing: jsonObject)]))
               index(item: 0)
        self.lblTitle?.text = jsonObject["artist"]["name"].stringValue
        self.lblDate?.text = jsonObject["created_at"].stringValue
        self.lblCoins?.text = jsonObject["coins"].stringValue
       //self.lblCoins?.text = CustomerDetails.coins
        
         //self.lblCoins?.text = String (CustomerDetails.coins)
       // self.lblCoins.adjustsFontSizeToFitWidth = true
      //  self.lblCoins.textAlignment = NSTextAlignment.left
        status = jsonObject["status"].stringValue
        strCoins = jsonObject["coins"].stringValue
        strDate = jsonObject["created_at"].stringValue
        strArtistName = jsonObject["artist"]["name"].stringValue
        if status == "rejected"{
           
            self.lblStatus?.text = status
            projects.append( [(status ?? "")] )
                       projects.append( [(strCoins ?? "")] )
                       projects.append( [(strDate ?? "")] )
                       projects.append( [(strArtistName ?? "")] )
                        index(item: 0)
            self.lblStatus.text = status?.capitalized
            self.lblStatus?.textColor = .red
            self.lblCircle?.backgroundColor = .red
//            self.lblStatus.adjustsFontSizeToFitWidth = true
//            self.lblStatus.textAlignment = NSTextAlignment.center
        }; if status == "pending"{
                   
                   self.lblStatus?.text = status
            projects.append( [(status ?? "")] )
                        projects.append( [(strCoins ?? "")] )
                        projects.append( [(strDate ?? "")] )
                        projects.append( [(strArtistName ?? "")] )
                       index(item: 0)
                self.lblStatus.text = status?.capitalized
                   self.lblStatus?.textColor = .systemYellow
                   self.lblCircle?.backgroundColor = .systemYellow
           // self.lblStatus.adjustsFontSizeToFitWidth = true
         //   self.lblStatus.textAlignment = NSTextAlignment.center
             projects.append( [(status ?? "")] )
             projects.append( [(strCoins ?? "")] )
             projects.append( [(strDate ?? "")] )
             projects.append( [(strArtistName ?? "")] )
             index(item: 0)
            
               }
            if status == "accepted"{
                self.lblStatus?.text = status
                self.lblStatus.text = status?.capitalized
                self.lblStatus?.textColor = .systemGreen
                self.lblCircle?.backgroundColor = .systemGreen
//                self.lblStatus.adjustsFontSizeToFitWidth = true
//                self.lblStatus.textAlignment = NSTextAlignment.center
                projects.append( [(status ?? "")] )
                           projects.append( [(strCoins ?? "")] )
                           projects.append( [(strDate ?? "")] )
                           projects.append( [(strArtistName ?? "")] )
                           index(item: 0)
               
        };if status == "completed"{
                self.lblStatus?.text = status
            self.lblStatus.text = status?.capitalized
                self.lblStatus?.textColor = .white
                self.lblCircle?.backgroundColor = .white
//            self.lblStatus.adjustsFontSizeToFitWidth = true
//            self.lblStatus.textAlignment = NSTextAlignment.center
            projects.append( [(status ?? "")] )
                       projects.append( [(strCoins ?? "")] )
                       projects.append( [(strDate ?? "")] )
                       projects.append( [(strArtistName ?? "")] )
                       index(item: 0)
            }
            if status == "rescheduled"{
                        self.lblStatus?.text = status
                        self.lblStatus.text = status?.capitalized
                        self.lblStatus?.textColor = .white
                        self.lblCircle?.backgroundColor = .white
        //                self.lblStatus.adjustsFontSizeToFitWidth = true
        //                self.lblStatus.textAlignment = NSTextAlignment.center
                projects.append( [(status ?? "")] )
                projects.append( [(strCoins ?? "")] )
                projects.append( [(strDate ?? "")] )
                projects.append( [(strArtistName ?? "")] )
                index(item: 0)
                       

                       
                }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func subscribeTapped(_ sender: UIButton){
        guard let indexPath = self.tableView?.indexPath(for: self) else { return }
        self.delegate?.subscribeTapped(at: indexPath, sender: sender)
    }
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
