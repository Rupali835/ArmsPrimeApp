//
//  DobCheckerVC.swift
//  Ramya Inti
//
//  Created by Rupali on 27/05/21.
//  Copyright © 2021 Rohit Desai. All rights reserved.
//

import UIKit
import Alamofire


class DobCheckerVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var lblpreviousDate: UILabel!
    var newDob : String?
    var isNew : Bool?
    var isDobPresent : String?
    var age_differnce : Int?
    
    @IBOutlet weak var presentDOB: UIDatePicker!
    let lcDateFormater = DateFormatter()
    fileprivate var selectedDate: Date?

    @IBOutlet weak var confirmView: UIView!
    
    @IBOutlet weak var txtSelectDob: UITextField!
    
    var is_new_user = UserDefaults.standard.value(forKey: "newUSerFlag") as? Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmView.isHidden = true
        self.txtSelectDob.isUserInteractionEnabled = false
        
        self.navigationController?.navigationBar.isHidden = true

        
        DispatchQueue.main.async {
            if self.isNew!
            {
                
            }else  //existing user
            {
                if self.isDobPresent != "" && self.isDobPresent != nil
                {
                    self.lblpreviousDate.text = self.isDobPresent
                    self.txtSelectDob.text = self.isDobPresent
                    self.confirmView.isHidden = false
                    self.presentDOB.isHidden = true
                    self.btnsubmit.isUserInteractionEnabled = false
                    self.txtSelectDob.text = self.lblpreviousDate.text

                }else{
                    self.confirmView.isHidden = true
                    self.presentDOB.isHidden = false
                    self.txtSelectDob.placeholder = "Select DOB"
                    self.btnsubmit.isUserInteractionEnabled = true

                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if m_cBirthDatePicker != nil
//        {
//            self.m_cBirthDatePicker.isHidden = false
//        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if(nil == self.presentDOB)
//        {
            if #available(iOS 13.4, *) {
                self.presentDOB.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
    
            self.presentDOB.setValue(UIColor.white, forKeyPath: "textColor")
        self.presentDOB.setValue(UIColor.init(white: 0.5, alpha: 0.5), forKey: "backgroundColor")
         
       // }
               
        let maxDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())

        self.presentDOB.maximumDate = maxDate! as Date
        lcDateFormater.dateFormat = "dd-MMMM-yyyy"
        txtSelectDob.inputView = presentDOB
        presentDOB.datePickerMode = .date
        txtSelectDob.text = lcDateFormater.string(from: presentDOB.date)
        
//        presentDOB.layer.borderColor = UIColor.white.cgColor
//        presentDOB.layer.borderWidth = 1.0
//        presentDOB.layer.cornerRadius = 5.0
//        presentDOB.clipsToBounds = true
        
    
    }
    
    @IBAction func changeDob_onclick(_ sender: Any) {
        
        self.selectedDate = presentDOB.date
        
        txtSelectDob.text = lcDateFormater.string(from: (sender as AnyObject).date)
        
//        UserDefaults.standard.setValue(txtSelectDob.text, forKey: "dob")
//        UserDefaults.standard.synchronize()
        
        if let dateFromString : NSDate = lcDateFormater.date(from: txtSelectDob.text ?? "") as NSDate?
        {
           lcDateFormater.dateFormat = "dd-MMMM-yyyy"
           let datenew = lcDateFormater.string(from: dateFromString as Date)

           let diffs = Calendar.current.dateComponents([.year], from: dateFromString as Date, to: Date())
           print(diffs.year!)
           
            UserDefaults.standard.setValue(diffs.year, forKey: "age_difference")
            UserDefaults.standard.synchronize()

        }
        
        self.newDob = txtSelectDob.text
        view.endEditing(true)
        
    }
    
    @IBAction func btnupdate_onclick(_ sender: Any) {
        self.confirmView.isHidden = true
        self.presentDOB.isHidden = false
        self.btnsubmit.isUserInteractionEnabled = true

     //   ShowDatePickerView()
        
    }
    
    @IBAction func btnTrue_onclick(_ sender: Any) {
        self.confirmView.isHidden = true
        let alert = UIAlertController.init(title: "Message", message: "Your age is not as per the application rating (17+).\n Kindly update and verify it to continue access the application", preferredStyle: .alert)
       
        let action1 = UIAlertAction(title: "DISMISS", style: .cancel) { (action) in
            self.confirmView.isHidden = true
            self.presentDOB.isHidden = false
            self.txtSelectDob.text = self.lblpreviousDate.text
        }
        self.btnsubmit.isUserInteractionEnabled = true

        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func btnSubmit_onclick(_ sender: Any) {
        
        // call update profile api
        var ageDiff : Int? = 0
        if validData() {
            
            if self.newDob != "" && self.newDob != nil {
                lcDateFormater.dateFormat = "dd-MMMM-yyyy"
                if let dateFromString : NSDate = lcDateFormater.date(from: self.newDob!) as NSDate? {
                lcDateFormater.dateFormat = "yyyy-MM-dd hh:mm:ss" //mm-dd-yyyy
                
                self.newDob = lcDateFormater.string(from: dateFromString as Date)
                    
                    var diffs = Calendar.current.dateComponents([.year], from: dateFromString as Date, to: Date())
                    print(diffs.year!)
                    ageDiff = diffs.year
                    UserDefaults.standard.setValue(diffs.year, forKey: "age_difference")

             }
            }else{
                let defaultdate = txtSelectDob.text
                
                lcDateFormater.dateFormat = "dd-MMMM-yyyy"
                if let dateFromString : NSDate = lcDateFormater.date(from: defaultdate!) as NSDate? {
                lcDateFormater.dateFormat = "yyyy-MM-dd hh:mm:ss" //mm-dd-yyyy
                
                self.newDob = lcDateFormater.string(from: dateFromString as Date)
                    
                    var diffs = Calendar.current.dateComponents([.year], from: dateFromString as Date, to: Date())
                    print(diffs.year!)
                    ageDiff = diffs.year
                    UserDefaults.standard.setValue(diffs.year, forKey: "age_difference")
            
                }
            
            }
            
            if ageDiff! >= 17 {
             
            
           // let scheduleAt = selectedDate?.toString(to: .yyyyMMdd)
            
            let profileApi = Constants.App_BASE_URL + Constants.UPDATE_PROFILE
            
           let requestParameters = [
                "first_name": CustomerDetails.firstName ?? "",
                "last_name": CustomerDetails.lastName ?? "",
                "mobile": CustomerDetails.mobileNumber ?? "",
                "gender": CustomerDetails.gender ?? "",
                "platform": "ios",
                "dob": self.newDob]
           
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": Constants.TOKEN,
                "ApiKey": Constants.API_KEY,
                "ArtistId": Constants.CELEB_ID,
                "Platform": Constants.PLATFORM_TYPE,
                "platform": Constants.PLATFORM_TYPE,
                "V": Constants.VERSION,
                ]
            
            Alamofire.request(profileApi, method: .post, parameters: requestParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (resp) in
                print(resp)
                
                switch resp.result
                {
                case .success(let data) :
                    print(data)
                    
                    CustomerDetails.dob = self.newDob
                    UserDefaults.standard.setValue(CustomerDetails.dob, forKey: "dob")
                    UserDefaults.standard.synchronize()
                    
                    if self.isNew!
                    {
                        self.goToTabMenu(desc: nil, isRewardGet: true)
                    }else {
                        self.goToTabMenu(desc: nil, isRewardGet: false)
                    }
                 
                    
                    break
                    
                case .failure(_):
                    break
                }
            }
            }else {
                let alert = UIAlertController.init(title: "Message", message: "Your age is not as per the application rating (17+).\n Kindly update and verify it to continue access the application", preferredStyle: .alert)
               
                let action1 = UIAlertAction(title: "DISMISS", style: .cancel) { (action) in
                    self.confirmView.isHidden = true
                   // self.presentDOB.isHidden = false
                    self.txtSelectDob.text = self.lblpreviousDate.text
                }
             //   self.btnsubmit.isUserInteractionEnabled = true

                alert.addAction(action1)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
         
    }
    
    func validData() -> Bool
    {
        if txtSelectDob.text == "" && txtSelectDob.text == nil
        {
            let alert = UIAlertController.init(title: "Alert", message: "Kindly select date", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    

    func goToTabMenu(desc: String? , isRewardGet: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let tabVC : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
               macros.appDel?.tabVC = tabVC
               tabVC.isCommingFromRewardView = isRewardGet
               tabVC.descMsg = desc
               self.navigationController?.pushViewController(tabVC, animated: true)
               self.navigationController?.viewControllers = [tabVC]
    }

}



