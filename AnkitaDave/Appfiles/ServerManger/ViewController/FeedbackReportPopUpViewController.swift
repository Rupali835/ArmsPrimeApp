//
//  FeedbackReportPopUpViewController.swift
//  ScarlettRose
//
//  Created by Razrtech3 on 21/05/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import UIKit
import EasyTipView
import Darwin
import Alamofire
import IQKeyboardManagerSwift

class reportContentData {
    var reportedName: String = ""
    var selectedReport : Bool

    init(cReportNm: String, cSelectedReport: Bool) {
        self.reportedName = cReportNm
        self.selectedReport = cSelectedReport
    }
}

class FeedbackReportPopUpViewController: BaseViewController,EasyTipViewDelegate {
    
    @IBOutlet weak var hgtOfFeedbackView: NSLayoutConstraint!
    @IBOutlet weak var tblReportContent: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
   
    @IBOutlet weak var lblcomment: UILabel!
    @IBOutlet weak var FeebbackView: UIView!
    
    @IBOutlet weak var txtviewComment: UITextView!
    @IBOutlet weak var hgtOfCommentView: NSLayoutConstraint!
    @IBOutlet weak var commentView: UIView!
    
    var selectedFlag = false
    var datePicker : UIDatePicker!
    var selectedReportName : String!
    var reportarr = [reportContentData]()
    var isSelected : Int!
    var firstSelect : Bool!
    var labelwidth : Bool!
    weak var tipView: EasyTipView?
    let entityId = UserDefaults.standard.value(forKey: "entityId")
    
    override func viewWillAppear(_ animated: Bool)
    {
      //  self.hgtOfFeedbackView.mu
      //  self.hgtOfFeedbackView.multiplier = 0.6
        
        firstSelect = true
        labelwidth = true
        let newConstraint = hgtOfFeedbackView.constraintWithMultiplier(0.65)
        view.removeConstraint(hgtOfFeedbackView)
        view.addConstraint(newConstraint)
        view.layoutIfNeeded()
        hgtOfFeedbackView = newConstraint
        
        self.hgtOfCommentView.constant = 0
        self.commentView.isHidden = true
        
        for index in 0..<artistConfig.reported_tagsArray!.reported_tags.count
        {
            artistConfig.reported_tagsArray!.reported_tags[index].isSelectedRepoprt = false
        }
        self.selectedReportName = ""
        self.txtviewComment.text = ""
        self.lblcomment.isHidden = false
        self.txtviewComment.delegate = self
        self.tblReportContent.reloadData()
        
       // self.navigationController?.navigationBar.isHidden = true
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let data = artistConfig.reported_tagsArray?.reported_tags
        print(data)
//        view.removeGradient()
        view.backgroundColor = hexStringToUIColor(hex:MyColors.primaryDark).withAlphaComponent(0.3)
        
        self.showAnimate()
       
        self.FeebbackView.layer.cornerRadius = 10
        self.FeebbackView.clipsToBounds = true
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        
        EasyTipView.globalPreferences = preferences
        
      //  self.reportarr = [reportContentData(cReportNm: "nudity", cSelectedReport: false), reportContentData(cReportNm: "spamming 12323", cSelectedReport: false), reportContentData(cReportNm: "2345678", cSelectedReport: false), reportContentData(cReportNm: "hgfgfhg", cSelectedReport: false)]
        
        self.tblReportContent.delegate = self
        self.tblReportContent.dataSource = self
        self.tblReportContent.allowsSelection = true
        
        self.txtviewComment.layer.cornerRadius = 5.0
        self.txtviewComment.masksToBounds = true
        self.txtviewComment.layer.borderWidth = 0.8
        self.txtviewComment.layer.borderColor = UIColor.lightGray.cgColor
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true

     
    }
    
    
    @IBAction func closeCommentview_onclick(_ sender: Any) {
        
//        self.commentView.isHidden = true
//        self.hgtOfCommentView.constant = 0
//        self.hgtOfFeedbackView.constant = 500
    }
    
    func submitReportContent()
    {
        var entityID : String?
        if entityId != nil
        {
            entityID = entityId as? String
        }
        
        let commentdesc = self.txtviewComment.text
        
        let url = Constants.App_BASE_URL + Constants.reportContent
        let param = ["artist_id" : Constants.CELEB_ID,
                     "platform" : "ios",
                     "v" : Constants.VERSION,
                     "product" : "apm",
                     "entity_id" : entityID,
                     "comment" : commentdesc,
                     "tags" : self.selectedReportName!] as? [String : Any]
        print(param)
        let header = ["ApiKey" : Constants.API_KEY,
                      "Authorization" : Constants.TOKEN,
                      "Product" : "apm",
                      "DeviceId" : Constants.DEVICE_ID,
                      "DeviceIp" : utility.getIPAddress()] as? HTTPHeaders
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                print("content uploaded successfully")
                self.showToast(message: "Thank you for reporting!")
                self.removeAnimate()
                self.view.removeFromSuperview()
                break
                
            case .failure(let err):
                print("Error : \(err.localizedDescription)")
                break
            }
        }
     
    }

    func validData()
    {
//        if !self.checkIsUserLoggedIn() {
//              self.loginPopPop()
//              return
//        }else
//        {
            if UserDefaults.standard.value(forKey: "dob") as? String != "" {
                if  let ipdate = (UserDefaults.standard.value(forKey: "dob") as? String) {
                    print(ipdate)
                    
                    // check dob year
                    //
                    let dateFormatter = DateFormatter()

                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                 if let dateFromString : NSDate = dateFormatter.date(from: ipdate) as NSDate? {
                    dateFormatter.dateFormat = "dd-MMMM-yyyy"
                    let datenew = dateFormatter.string(from: dateFromString as Date)
                    
                    
                    let diffs = Calendar.current.dateComponents([.year], from: dateFromString as Date, to: Date())
                    print(diffs.year!)
                    
                    if diffs.year! < 12
                    {
                        //if year is less than 12 then update dob... open datpicker
                        
                        self.showAlertForDobButton(title: "UPDATE DOB", msg: "Please update your dob for reporting content")
                        
                    }else{
                        
                        self.submitReportContent()
                    }

                 }

                }
                
            }else
            {
                self.showAlertForDobButton(title: "SET DOB", msg: "Please set your dob for reporting content")
            }
      //  }

    }
     
    func showAlertForProfile(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Go to Profile",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        
            // open earnmorecoinsvc // fill profile page
              
            let vc = self.storyboard?.instantiateViewController(identifier: "EarnMoreCoinsViewController") as? EarnMoreCoinsViewController
            vc?.comingTitle = "Profile"
            self.navigationController?.pushViewController(vc!, animated: true)
                                        
           // self.present(vc!, animated: true, completion: nil)
                                        
                                        
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertForDobButton(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Set DOB",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
            
                                        self.ShowDatePickerView()
                                        
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func ShowDatePickerView()
    {
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
        
        self.datePicker?.backgroundColor = UIColor.black
        let maxDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
        datePicker.maximumDate = maxDate

        self.datePicker?.datePickerMode = .date
        self.datePicker.center = view.center
        
        self.datePicker.addTarget(self, action: #selector(FeedbackReportPopUpViewController.handleDatePicker), for: UIControl.Event.valueChanged)
        
        view.addSubview(self.datePicker)
       
    }
   
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateval = dateFormatter.string(from: datePicker.date)
        print(dateval)
        self.showToast(message: "Now you can report the content...!")
        UserDefaults.standard.setValue(dateval, forKey: "dob") as? String
    
        
        //textfield.resignFirstResponder()
        self.datePicker.removeFromSuperview()
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        
        removeAnimate()
    }
    
    @IBAction func SubmitButtonAction(_ sender: UIButton) {
       
        guard Reachability.isConnectedToNetwork() else {
            self.showToast(message: "No Internet connection!")
            return
        }
        
        if !self.checkIsUserLoggedIn() {
              self.loginPopPop()
              return
        }else {
            
            if CustomerDetails.profile_completed == true {
                if self.selectedReportName != "" && self.selectedReportName != nil
                {
                    if self.txtviewComment.text != "" {
                        
                       // self.validData()
                        self.submitReportContent()
                        
                        
                    }else {
                        self.showToast(message: "Please write a comment for selected report content")
                    }
                }else {
                    self.showToast(message: "Please select the option first")
                }

            }else {
                //self.showToast(message: "Please complete your profile first..")
                
                self.showAlertForProfile(title: "Complete Profile", msg: "Kindly verify your profile first to report the issue.")
                
            }
          
        }
        
        
  //      validData()
//        if selectedFlag == true {
//            removeAnimate()
//            guard Reachability.isConnectedToNetwork() else {
//                self.showToast(message: "No Internet connection!")
//                return
//            }
//
//            let alertController = UIAlertController(title: "Message", message: "Thank you for communicating your concerns.Our editorial team will review as per our guidelines and take effective measures and actions if required.", preferredStyle: .alert)
//
//            // Create the actions
//            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
//                UIAlertAction in
//                self.removeAnimate()
//            }
//
//
//            // Add the actions
//            alertController.addAction(okAction)
//
//
//            // Present the controller
//            self.present(alertController, animated: true, completion: nil)
//        }else{
//            self.showToast(message: "Please select the issue for which you are reporting.")
//        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @objc func infoTouched(_ sender: UIButton) {
        if let tipView = tipView {
            tipView.dismiss(withCompletion: {
                print("Completion called!")
            })
        } else {
            //let text = "EasyTipView is an easy to use tooltip view. It can point to any UIView"
            
            let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: self.tblReportContent)
            let indexPath = self.tblReportContent.indexPathForRow(at: buttonPosition)
            let lcReportedTags = artistConfig.reported_tagsArray!.reported_tags[indexPath!.row]
            let text = lcReportedTags.description
            var preferences = EasyTipView.globalPreferences
            preferences.drawing.shadowColor = UIColor.black
            preferences.drawing.shadowRadius = 2
            preferences.drawing.shadowOpacity = 0.75
            preferences.drawing.arrowPosition = .left
            
            preferences.drawing.backgroundColor = UIColor.black
            preferences.drawing.foregroundColor = UIColor.white
        
            
            let tip = EasyTipView(text: text, preferences: preferences, delegate: self)
            
            tip.show(forView: sender, withinSuperview: self.view)
            //tip.show(forItem: toolbarItem)
            tipView = tip
        }
    }
    
    func easyTipViewDidTap(_ tipView: EasyTipView) {
        print("\(tipView) did tap!")
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        print("\(tipView) did dismiss!")
    }
    
}
extension FeedbackReportPopUpViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (artistConfig.reported_tagsArray?.reported_tags.count)!
      //  return self.reportarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tblReportContent.dequeueReusableCell(withIdentifier: "ReportContentCell", for: indexPath) as! ReportContentCell
        
        let item = artistConfig.reported_tagsArray?.reported_tags[indexPath.row]
        
        cell.lblreporteNm.text = item?.label
        
//        if labelwidth == true {
//            cell.lblreporteNm.widthAnchor.constraint(equalToConstant: 15+cell.lblreporteNm.intrinsicContentSize.width).isActive = true
//            labelwidth = false
//        }
        
        if item!.isSelectedRepoprt {
            cell.imgSelected.image = UIImage(named: "radioSelect")
        }else{
            cell.imgSelected.image = UIImage(named: "radioUnSelect")
        }
        
        cell.btnReportInfo.addTarget(self, action: #selector(FeedbackReportPopUpViewController.infoTouched(_:)), for: .touchUpInside)
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        self.isSelected = indexPath.row
  
        for index in 0..<artistConfig.reported_tagsArray!.reported_tags.count {
            
            if index == self.isSelected
            {
                artistConfig.reported_tagsArray!.reported_tags[index].isSelectedRepoprt = true
                
                self.selectedReportName = artistConfig.reported_tagsArray!.reported_tags[index].slug
            }else{
                artistConfig.reported_tagsArray!.reported_tags[index].isSelectedRepoprt = false
            }
            
           
        }
        
        if firstSelect {
            let newConstraint = hgtOfFeedbackView.constraintWithMultiplier(0.75)
            view.removeConstraint(hgtOfFeedbackView)
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            hgtOfFeedbackView = newConstraint
            
            self.hgtOfCommentView.constant = 130
            
            firstSelect = false
        }
      
        
        
        self.tblReportContent.reloadData()
        
      //  self.hgtOfFeedbackView.constant = self.hgtOfFeedbackView.constant + 130
        self.commentView.isHidden = false

        
    }
    
}
extension FeedbackReportPopUpViewController : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.lblcomment.isHidden = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
           //  create the updated text string
            let currentText:String = txtviewComment.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.count == 0 {
            self.lblcomment.isHidden = false
        }
        

       return true
    }
}
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    
}
