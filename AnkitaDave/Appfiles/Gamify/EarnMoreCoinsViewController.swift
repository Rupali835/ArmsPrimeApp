//
//  EarnMoreCoinsViewController.swift
//  AnveshiJain
//
//  Created by Macbook on 07/10/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreSpotlight
import AVFoundation
import SDWebImage
import Alamofire
import SwiftyJSON
import IQKeyboardManagerSwift
import CountryPickerView


class EarnMoreCoinsViewController: BaseViewController, UITabBarControllerDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firstNameTickImageView: UIImageView!
    @IBOutlet weak var lastNameTickImageView: UIImageView!
    @IBOutlet weak var emailIdtickImageView: UIImageView!
    @IBOutlet weak var mobileTickImageView: UIImageView!
    @IBOutlet weak var DOBTickImageView: UIImageView!
    @IBOutlet weak var genderTickImageView: UIImageView!
    @IBOutlet weak var AddImageView: UIImageView!
    var window: UIWindow?
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var verifyLineLabel: UILabel!
    @IBOutlet weak var verifyEmailButton: UIButton!
    @IBOutlet weak var verifyEmailLineLabel: UILabel!
    @IBOutlet weak var mobileView: UIView!
    private var overlayView = LoadingOverlay.shared
    fileprivate var messageTolTip: EasyTipView?
    var timer = Timer()
    var projects:[[String]] = []
    var captureType:String!
    fileprivate var selectedDate: Date?
    fileprivate var selectedPickerDate: Date?
    var isProfileImageSelected = false
    var isEditedProfile: Bool = false
    var completedProfile = false
    var saveMessageProfile = ""
    let indiaCountryCode = "91"
    var countryPicker: CountryPickerView? = nil
    fileprivate var requestParameters: [String: Any] = [String: Any]()
    var lastName = ""
    var FirstName = ""
    var gender = ""
    var comingTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setProfileImageOnBarButton(onlyLiveButton: true)
        self.dayLabel.text = "Day"
        self.monthLabel.text = "Month"
        self.yearLabel.text = "Year"
        setupView()
        getData()
        if comingTitle == "" || comingTitle == nil
        {
            self.title = "Earn More Coins"
        }else
        {
            self.title = comingTitle
        }
//        self.title = "Earn More Coins"
    }
    override func viewWillDisappear(_ animated: Bool) {
           messageTolTip?.dismiss()
    }
    
    func setupView(){
        if CustomerDetails.profile_completed == true{
            self.progress.setProgress(1.0, animated: true)
            percentLabel.text = "100%"
        }else
        {
            self.progress.setProgress(0.4, animated: true)
            percentLabel.text = "42%"
        }
        IQKeyboardManager.shared.toolbarTintColor = .white
        IQKeyboardManager.shared.enableAutoToolbar = true
        mobileView.layer.cornerRadius = 5
        mobileView.clipsToBounds = true
        firstNameTextField.keyboardAppearance = .dark
        lastNameTextField.keyboardAppearance = .dark
        emailIdTextField.keyboardAppearance = .dark
        mobileNumberTextField.keyboardAppearance = .dark
        datePickerTextField.keyboardAppearance = .dark
        
        updateButton.layer.cornerRadius = 10
        updateButton.clipsToBounds = true
        dateView.layer.cornerRadius = 5
        dateView.clipsToBounds = true
        
        userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.borderWidth = 1
        userImageView.clipsToBounds = true
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
    //    datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
//        datePicker.locale = Locale(identifier: "en_IN")
        datePicker.addTarget(self, action: #selector(didSelectDate), for: .valueChanged)
        datePickerTextField.inputView = datePicker
        
        let maxDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
        datePicker.maximumDate = maxDate
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        // Default date as current date.
        dayLabel.textColor = .lightGray
        monthLabel.textColor = .lightGray
        yearLabel.textColor = .lightGray
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailIdTextField.delegate = self
        mobileNumberTextField.delegate = self
        
        firstNameTextField.setAttributedPlaceholder(text:"Enter your first Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.7)])
        firstNameTextField.tintColor = .lightGray
        lastNameTextField.setAttributedPlaceholder(text: "Enter your last Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.7)])
        lastNameTextField.tintColor = .lightGray
        emailIdTextField.setAttributedPlaceholder(text: "example@gmail.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.7)])
        emailIdTextField.tintColor = .lightGray
        mobileNumberTextField.setAttributedPlaceholder(text: "Enter your phone number", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.7)])
        mobileNumberTextField.tintColor = .lightGray
        genderTextField.tintColor = .clear
        datePickerTextField.tintColor = .clear
        
    }
    @objc fileprivate func didSelectDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
        self.selectedPickerDate = selectedDate
        dayLabel.textColor = .white
        monthLabel.textColor = .white
        yearLabel.textColor = .white
        
        dayLabel.text = sender.date.toString(to: .dd)
        monthLabel.text = sender.date.toString(to: .MMMM)
        yearLabel.text = sender.date.toString(to: .yyyy)
        projects.append( [String (dayLabel.text ?? "")] )
        projects.append( [String (monthLabel.text ?? "")] )
        projects.append( [String (yearLabel.text ?? "")] )
        index(item: 0)
    }
    
    @objc func lastNameTickImageViewtapped(){
        self.view.endEditing(true)
    utility.showToast(msg: stringConstants.lastNameMessage, delay: 0, duration: 2.0, bottom: 80)
    }
    @objc func emailTickImageViewtapped(){
        self.view.endEditing(true)
       utility.showToast(msg: stringConstants.emailIdMessage, delay: 0, duration: 2.0, bottom: 80)
       }
    @objc func firstNameImageViewtapped(){
        self.view.endEditing(true)
    utility.showToast(msg: stringConstants.firstNameMessage, delay: 0, duration: 2.0, bottom: 80)
    }
    @objc func dobImageViewtapped(){
        self.view.endEditing(true)
    utility.showToast(msg: stringConstants.dobMessage, delay: 0, duration: 2.0, bottom: 80)
    }
    @objc func genderImageViewtapped(){
        self.view.endEditing(true)
    utility.showToast(msg: stringConstants.genderMessage, delay: 0, duration: 2.0, bottom: 80)
    }
    @objc func mobileImageViewtapped(){
        self.view.endEditing(true)
    utility.showToast(msg: stringConstants.mobileNumberMessage, delay: 0, duration: 2.0, bottom: 80)
    }
    func getData(){
        _ = self.getOfflineUserData()
        self.linkTextField.text = "https://bak6n.app.link/zRDzfAkmrab"
        let str = lastNameTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 2
        if lastName == ""{
        if CustomerDetails.customerData.last_name != "" && str >= 3{
            
                lastNameTickImageView.image = UIImage(named: "Verifed Tick")
                self.lastNameTextField.text = CustomerDetails.customerData.last_name ?? ""
            
        }else{
            lastNameTickImageView.image = UIImage(named: "exclamation")
            self.lastNameTextField.text = CustomerDetails.customerData.last_name ?? ""
            let tap = UITapGestureRecognizer(target: self, action: #selector(EarnMoreCoinsViewController.lastNameTickImageViewtapped))
            lastNameTickImageView.addGestureRecognizer(tap)
            lastNameTickImageView.isUserInteractionEnabled = true
        }
        }else{
            self.lastNameTextField.text = self.lastName
             lastNameTickImageView.image = UIImage(named: "Verifed Tick")
        }
        if CustomerDetails.customerData.email != "" {
            emailIdtickImageView.image = UIImage(named: "Verifed Tick")
            self.emailIdTextField.text = CustomerDetails.customerData.email ?? ""
            self.emailIdTextField.isUserInteractionEnabled = false
            self.verifyEmailLineLabel.isHidden = true
            self.verifyEmailButton.isHidden = true
            self.emailIdtickImageView.isHidden = false

        }else{
            emailIdtickImageView.image = UIImage(named: "exclamation")
            self.emailIdTextField.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(EarnMoreCoinsViewController.emailTickImageViewtapped))
            emailIdtickImageView.addGestureRecognizer(tap)
            emailIdtickImageView.isUserInteractionEnabled = true

        }
        let str2 = firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 2
        if FirstName == ""{
        if CustomerDetails.customerData.first_name != "" && str2 >= 3{
            
                firstNameTickImageView.image = UIImage(named: "Verifed Tick")
                self.firstNameTextField.text = CustomerDetails.customerData.first_name ?? ""
    
        }else{
            firstNameTickImageView.image = UIImage(named: "exclamation")
            self.firstNameTextField.text = CustomerDetails.customerData.first_name ?? ""
            let tap = UITapGestureRecognizer(target: self, action: #selector(EarnMoreCoinsViewController.firstNameImageViewtapped))
            firstNameTickImageView.addGestureRecognizer(tap)
            firstNameTickImageView.isUserInteractionEnabled = true
        }
        }else {
            firstNameTickImageView.image = UIImage(named: "Verifed Tick")
            self.firstNameTextField.text = self.FirstName
        }
        if UserDefaults.standard.value(forKey: "mobile_code") as? String != "" {
                let mobileCode = UserDefaults.standard.value(forKey: "mobile_code") as? String
            self.countryCodeLabel.text = mobileCode ?? ""
        
        }
        if selectedPickerDate == nil {
        if UserDefaults.standard.value(forKey: "dob") as? String != ""{
            if  let ipdate = (UserDefaults.standard.value(forKey: "dob") as? String){
             
            DOBTickImageView.image = UIImage(named: "Verifed Tick")
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
         if let dateFromString : NSDate = dateFormatter.date(from: ipdate) as NSDate? {
            dateFormatter.dateFormat = "dd-MMMM-yyyy"
            let datenew = dateFormatter.string(from: dateFromString as Date)

              print(datenew)
            
            guard let date = dateFormatter.date(from: datenew) else {
                return
            }
            selectedDate = date
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: date)
            dayLabel.text = day
            
            dateFormatter.dateFormat = "MMMM"
            let month = dateFormatter.string(from: date)
            monthLabel.text = month
            
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: date)
            yearLabel.text = year
            }
        }
            
        }else {
            DOBTickImageView.image = UIImage(named: "exclamation")
            let tap = UITapGestureRecognizer(target: self, action: #selector(EarnMoreCoinsViewController.dobImageViewtapped))
            DOBTickImageView.addGestureRecognizer(tap)
            DOBTickImageView.isUserInteractionEnabled = true
                       dayLabel.text = "DD"
                       monthLabel.text = "MM"
                       yearLabel.text = "YYYY"
        }
        }else{
            if  let ipdate = (UserDefaults.standard.value(forKey: "dob") as? String){
                 
                DOBTickImageView.image = UIImage(named: "Verifed Tick")
                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
             if let dateFromString : NSDate = dateFormatter.date(from: ipdate) as NSDate? {
                dateFormatter.dateFormat = "dd-MMMM-yyyy"
                let datenew = dateFormatter.string(from: dateFromString as Date)

                  print(datenew)
                
                guard let date = dateFormatter.date(from: datenew) else {
                    return
                }
                selectedPickerDate = date
                dateFormatter.dateFormat = "dd"
                let day = dateFormatter.string(from: date)
                dayLabel.text = day
                
                dateFormatter.dateFormat = "MMMM"
                let month = dateFormatter.string(from: date)
                monthLabel.text = month
                
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: date)
                yearLabel.text = year
                }
            }
        }
        
    if gender == ""{
        if CustomerDetails.customerData.gender != "" {
            self.captureType = CustomerDetails.customerData.gender
            self.genderTextField.text = CustomerDetails.customerData.gender?.captalizeFirstCharacter()
            genderTickImageView.image = UIImage(named: "Verifed Tick")

        }else{
            self.genderTextField.text = "Select"
             genderTickImageView.image = UIImage(named: "exclamation")
            let tap = UITapGestureRecognizer(target: self, action: #selector(EarnMoreCoinsViewController.genderImageViewtapped))
            genderTickImageView.addGestureRecognizer(tap)
            genderTickImageView.isUserInteractionEnabled = true
        }
      }else {
        self.genderTextField.text = self.captureType
        genderTickImageView.image = UIImage(named: "Verifed Tick")
        }
        
        if CustomerDetails.customerData.mobile != "" {
           
            self.mobileNumberTextField.text = CustomerDetails.customerData.mobile
        }else{
          
            let tap = UITapGestureRecognizer(target: self, action: #selector(EarnMoreCoinsViewController.mobileImageViewtapped))
            mobileTickImageView.addGestureRecognizer(tap)
            mobileTickImageView.isUserInteractionEnabled = true
        }
        
        if UserDefaults.standard.bool(forKey: "mobile_verified") {
             self.mobileTickImageView.image = UIImage(named: "Verifed Tick")
            self.mobileNumberTextField.isUserInteractionEnabled = false
            self.mobileTickImageView.isHidden = false
            self.verifyButton.isHidden = true
            self.verifyLineLabel.isHidden = true
        } else {
           
            self.mobileTickImageView.image = UIImage(named: "exclamation")
            self.mobileTickImageView.isHidden = false
            self.verifyButton.isHidden = true
            self.verifyLineLabel.isHidden = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(EarnMoreCoinsViewController.mobileImageViewtapped))
            mobileTickImageView.addGestureRecognizer(tap)
            mobileTickImageView.isUserInteractionEnabled = true
            self.mobileNumberTextField.isUserInteractionEnabled = true
        }
         if UserDefaults.standard.bool(forKey: "email_verified") {
            self.emailIdtickImageView.image = UIImage(named: "Verifed Tick")
             self.emailIdTextField.isUserInteractionEnabled = false
             self.emailIdtickImageView.isHidden = false
             self.verifyEmailButton.isHidden = true
             self.verifyEmailLineLabel.isHidden = true
        
         }else{
            if isValidEmail(testStr: emailIdTextField.text ?? ""){
               self.emailIdtickImageView.isHidden = true
               self.verifyEmailButton.isHidden = false
               self.verifyEmailLineLabel.isHidden = false
            }else{
               self.emailIdtickImageView.image = UIImage(named: "exclamation")
                self.emailIdTextField.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(EarnMoreCoinsViewController.emailTickImageViewtapped))
                          emailIdtickImageView.addGestureRecognizer(tap)
                          emailIdtickImageView.isUserInteractionEnabled = true
            }
             
           
        }
    
        if CustomerDetails.customerData.picture != nil {
            
            self.userImageView.sd_imageIndicator?.startAnimatingIndicator()
            self.userImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.userImageView.sd_imageTransition = .fade
            self.userImageView.sd_setImage(with: URL(string:CustomerDetails.customerData.picture!), completed: nil)
            self.AddImageView.image = UIImage(named: "Profile Image Verifed")
        }
        else {
            userImageView.image = UIImage(named: "profileph")
            self.AddImageView.image = UIImage(named: "Add Profile Image")
        }
    }
    
    func setNewDOB()
    {
        if  let ipdate = (UserDefaults.standard.value(forKey: "dob") as? String){
             
            DOBTickImageView.image = UIImage(named: "Verifed Tick")
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "dd-MMMM-yyyy"
         if let dateFromString : NSDate = dateFormatter.date(from: ipdate) as NSDate? {
            dateFormatter.dateFormat = "dd-MMMM-yyyy"
            let datenew = dateFormatter.string(from: dateFromString as Date)

              print(datenew)
            
            guard let date = dateFormatter.date(from: datenew) else {
                return
            }
            selectedPickerDate = date
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: date)
            dayLabel.text = day
            
            dateFormatter.dateFormat = "MMMM"
            let month = dateFormatter.string(from: date)
            monthLabel.text = month
            
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: date)
            yearLabel.text = year
            }
        }
    }
    
    func messageInfo(message:String,senderid:UIButton){
        var preferences = EasyTipView.Preferences()
               preferences.drawing.backgroundColor = UIColor.black.withAlphaComponent(0.8)
               preferences.drawing.foregroundColor = UIColor.white
               preferences.drawing.textAlignment = NSTextAlignment.center
               preferences.drawing.font = ShoutoutFont.light.withSize(size: .small)
               preferences.drawing.arrowPosition = .left

               preferences.animating.dismissTransform = CGAffineTransform(translationX: 100, y: 0)
               preferences.animating.showInitialTransform = CGAffineTransform(translationX: 100, y: 0)
               preferences.animating.showInitialAlpha = 0
               preferences.animating.showDuration = 1
               preferences.animating.dismissDuration = 1

               preferences.positioning.maxWidth = 200
               projects.append( [String (message)] )
               index(item: 0)
               let view = EasyTipView(text: message, preferences: preferences)
               if let toolTipView = messageTolTip {
                   messageTolTip = nil
                   toolTipView.dismiss()
               } else {
                   messageTolTip = view
                   view.show(forView: senderid, withinSuperview: self.navigationController?.view!)
               }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setNewDOB()
        self.getData()
    }
    
   @IBAction func verifyEmailButtonAction(_ sender: UIButton) {
    self.view.endEditing(true)

        let email = emailIdTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        self.showLoader()
        webLogin(id: nil, email: email, firstname: nil, lastname: nil, phone: nil, countryCode: nil, type: .email)
         
    }
    func isValidFormData() -> Bool {

            let str = emailIdTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)

            if str?.count == 0 {

                utility.showToast(msg: stringConstants.errEmptyEmailAddress, delay: 0, duration: 2.0, bottom: 80)
                return false
            }

            if !utility.isValidEmail(emailStr: str!) {
                    
//                utility.showToast(msg: stringConstants.errInvalidEmailAddress, delay: 0, duration: 2.0, bottom: 80)

                return false
            }
        

        return true
    }
    
    @IBAction func verifyButtonAction(_ sender: UIButton) {
        if mobileNumberTextField.text!.trimmingCharacters(in: .whitespaces).count >= 12 {
            mobileNumberTextField.resignFirstResponder()
             utility.showToast(msg: stringConstants.mobileValidatemessage, delay: 0, duration: 1.2, bottom: 80)
    }else{
            let phone = mobileNumberTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
            let countryCode = countryCodeLabel.text
            self.showLoader()
             webLogin(id: nil, email: nil, firstname: nil, lastname: nil, phone: phone, countryCode: countryCode, type: .phone)
        }
    }
    
    func gotoVerifyOTPScreen(type:String) {
        self.stopLoader()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifyOTPVC : VerifyOTPViewController = storyboard.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
        
        verifyOTPVC.phone = mobileNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if type == "mobile"{

            verifyOTPVC.phone = mobileNumberTextField.text
            verifyOTPVC.countryCode = countryCodeLabel.text

            verifyOTPVC.type = .phone
        }
        else {

            verifyOTPVC.email = emailIdTextField.text
            verifyOTPVC.type = .email
        }
        verifyOTPVC.isCommingFromEarnCoinView = true
        verifyOTPVC.activityType = .verify
        
        self.navigationController?.pushViewController(verifyOTPVC, animated: true)
    }
    
    @IBAction func profileUpdateButtonAction(_ sender: UIButton) {
       var type : UIImagePickerController.SourceType = .camera
       
       let picker = UIImagePickerController()
       picker.viewWillLayoutSubviews()
       picker.delegate = self
       let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
           action in

           type = .camera
           DispatchQueue.main.async {

               self.checkCameraPermissions()
         
           }
       }))
       alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
           action in
           type = .photoLibrary
           DispatchQueue.main.async {
               
               self.showImagePicker(type)
           }
       }))
       alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       self.present(alert, animated: true) {
       }
        
    }
    
    func showImagePicker(_ type: UIImagePickerController.SourceType) {
        
        if type == UIImagePickerController.SourceType.camera {
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {

                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                imgPicker.mediaTypes = [kUTTypeImage] as [String]
                imgPicker.sourceType = .camera
                imgPicker.cameraDevice = .front
                imgPicker.allowsEditing = false
                imgPicker.imageExportPreset = .compatible
                imgPicker.modalPresentationStyle = .overFullScreen
                
                self.present(imgPicker, animated: true, completion: nil)
            }
            else {
                
                self.showToast(message: "Sorry! Camera not Available on this device.")
            }
            
        } else {
            
            //DispatchQueue.main.async {
            
            let picker = UIImagePickerController()
            picker.sourceType = type
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
            //}
        }
    }
    @IBAction func shareButtonAction(_ sender: UIButton) {
       if let link = NSURL(string: "https://bak6n.app.link/zRDzfAkmrab")
       {
           let objectsToShare = [link]
           let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
       }
    }
    
    @IBAction func genderButtonAction(_ sender: UIButton) {
       let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
       
       alert.addAction(UIAlertAction(title: "Male", style: .default) { action in
           self.genderTextField.text = "Male"
           self.captureType = "male"
        self.gender = self.captureType
        self.genderTickImageView.image = UIImage(named: "Verifed Tick")
       })
       
       alert.addAction(UIAlertAction(title: "Female", style: .default) { action in
           self.genderTextField.text = "Female"
           self.captureType = "female"
           self.gender = self.captureType
        self.genderTickImageView.image = UIImage(named: "Verifed Tick")
       })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       
       if UIDevice.current.userInterfaceIdiom == .pad {
           if let popoverController = alert.popoverPresentationController {
               popoverController.sourceView = self.view
               popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
               popoverController.permittedArrowDirections = []
           }
       }
       self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func profileUpdateInfoButtonAction(_ sender: UIButton) {
        self.messageInfo(message:stringConstants.profile,senderid:sender)
    }
    @IBAction func dateInfoButtonAction(_ sender: UIButton) {
       self.messageInfo(message:stringConstants.dateOfBirth,senderid:sender)
    }
    @IBAction func firstNameInfoButtonAction(_ sender: UIButton) {
        self.messageInfo(message:stringConstants.firsName,senderid:sender)
    }
    @IBAction func lastNameInfoButtonAction(_ sender: UIButton) {
       self.messageInfo(message:stringConstants.lastName,senderid:sender)
    }
    @IBAction func emailIdInfoButtonAction(_ sender: UIButton) {
       self.messageInfo(message:stringConstants.emailMessage,senderid:sender)
    }
    @IBAction func mobileNumberInfoButtonAction(_ sender: UIButton) {
       self.messageInfo(message:stringConstants.mobileNumber,senderid:sender)
    }
    @IBAction func genderInfoButtonAction(_ sender: UIButton) {
       self.messageInfo(message:stringConstants.gender,senderid:sender)
    }
    
}
extension EarnMoreCoinsViewController {
   
    @IBAction func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        if let toolTip = messageTolTip {
                  toolTip.dismiss()
              }
        self.view.endEditing(true)
    }
}

// MARK: - Custom Methods.
extension EarnMoreCoinsViewController {
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
                DispatchQueue.main.async {
                self.DOBTickImageView.image = UIImage(named: "Verifed Tick")
                self.DOBTickImageView.isUserInteractionEnabled = false

                }

            }
        }
        
    }
   
}
extension EarnMoreCoinsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//    isEditedProfile = true
      if let chosenImg : UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
          {
              userImageView.image = chosenImg
              isProfileImageSelected = true
              //            UserDefaults.standard.set(chosenImg.pngData(), forKey: "kKeyImage")
          } else if let chosenImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        self.userImageView.image = chosenImg
              isProfileImageSelected = true
              //        UserDefaults.standard.set(chosenImg.pngData(), forKey: "kKeyImage")
          } else
          {
              print ("something went wrong")
          }
          dismiss(animated: true, completion: nil)
}


func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
   }
}
extension EarnMoreCoinsViewController {
    
    func checkCameraPermissions() {
        
        let permissionManager = PHPermissionManager()
        permissionManager.controller = self
        permissionManager.permissionType = .camera
        permissionManager.isAutoHandleNoPermissionEnabled = true
        permissionManager.completionBlock = { isGranted in
            
            if isGranted {
                
                self.showImagePicker(UIImagePickerController.SourceType.camera)
            }
            else {
                
            }
        }
        
        permissionManager.askForPermission()
    }
    
    func checkLibraryPermission() {
        
        let permissionManager = PHPermissionManager()
        permissionManager.controller = self
        permissionManager.permissionType = .photoLibrary
        permissionManager.isAutoHandleNoPermissionEnabled = true
        permissionManager.completionBlock = { isGranted in
            
            if isGranted {
                
                self.showImagePicker(UIImagePickerController.SourceType.photoLibrary)
                
            }
            else {
                
            }
        }
        
        permissionManager.askForPermission()
    }
}
// MARK: - TextField Delegate Methods
extension EarnMoreCoinsViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == firstNameTextField {
            self.FirstName = textField.text ?? ""
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
           if str.count > 2 {
                firstNameTickImageView.image = UIImage(named: "Verifed Tick")
                firstNameTickImageView.isUserInteractionEnabled = false
           }else{
                firstNameTickImageView.image = UIImage(named: "exclamation")
                firstNameTickImageView.isUserInteractionEnabled = true
            }
            
        }else if textField == lastNameTextField {
            self.lastName = textField.text ?? ""
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if str.count > 2 {
                lastNameTickImageView.image = UIImage(named: "Verifed Tick")
                lastNameTickImageView.isUserInteractionEnabled = false
            }else{
                lastNameTickImageView.image = UIImage(named: "exclamation")
                lastNameTickImageView.isUserInteractionEnabled = true
            }
            
        }else if textField == emailIdTextField {
            if !isValidFormData() {
                self.verifyEmailButton.isHidden = true
                self.verifyEmailLineLabel.isHidden = true
                emailIdtickImageView.isUserInteractionEnabled = true
            }else {
                self.emailIdtickImageView.isHidden = true
                self.verifyEmailButton.isHidden = false
                self.verifyEmailLineLabel.isHidden = false
                emailIdtickImageView.isUserInteractionEnabled = false
            }
            
            
        }
       
        if textField == mobileNumberTextField {
            if countryCodeLabel.text == indiaCountryCode{
                let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                if str.count == 0  {
                    self.mobileTickImageView.isHidden = false
                    mobileTickImageView.isUserInteractionEnabled = true
                    self.verifyButton.isHidden = true
                    self.verifyLineLabel.isHidden = true
                }
                
                if str.count > 10 && string != "" {
                    
                    return false
                }
                
                if str.count == 10 {
                    
                    self.mobileTickImageView.isHidden = true
                    self.verifyButton.isHidden = false
                    self.verifyLineLabel.isHidden = false
                    mobileTickImageView.isUserInteractionEnabled = false
                    
                    
                }
                else {
                   
                   self.mobileTickImageView.isHidden = false
                    mobileTickImageView.isUserInteractionEnabled = true
                    self.verifyButton.isHidden = true
                    self.verifyLineLabel.isHidden = true
                }

            }else{
                let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                if str.count == 0  {
                    self.mobileTickImageView.isHidden = false
                    mobileTickImageView.isUserInteractionEnabled = true
                    self.verifyButton.isHidden = true
                    self.verifyLineLabel.isHidden = true
                }else{
                    self.mobileTickImageView.isHidden = true
                    self.verifyButton.isHidden = false
                    self.verifyLineLabel.isHidden = false
                    mobileTickImageView.isUserInteractionEnabled = false
                }
            }
        }
        if (textField == mobileNumberTextField), let text = textField.text {
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
           
            return textField == mobileNumberTextField ? numberOfChars <= 10 : numberOfChars <= ShoutoutConstants.charLimitForOtherOccasion
        }
        return true
     }

}
// MARK: - Web Service Methods
extension EarnMoreCoinsViewController {
    
    func webLogin(id: String?, email: String?, firstname: String?, lastname: String?, phone: String?, countryCode: String?, type: LoginType) {
        
        let api = Constants.requestloginOTP
    
        var dictParams = [String: Any]()
        
        let activity = VerifyOTPActivityType.verify.rawValue

        dictParams["activity"] = activity //verify
        dictParams["identity"] = type.rawValue

        if let emailId = email {
               
               dictParams["email"] = emailId
        }
        if let mobile = phone {
            
            dictParams["mobile"] = mobile
        }
        
        if let phoneCode = countryCode {
            
            dictParams["mobile_code"] = phoneCode
        }
        
        if let fname = firstname {
            
            dictParams["first_name"] = fname
        }
        
        if let lname = lastname {
            
            dictParams["last_name"] = lname
        }
        
        if CustomBranchHandler.shared.referralCustomerID != "" {
            dictParams["referrer_customer_id"] = CustomBranchHandler.shared.referralCustomerID
        }
        
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
        
        web.shouldPrintLog = true
        
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { (status, msg, dict) in

            var loginEventStatus: LoginEventStatus = .success
            self.stopLoader()
            if status {
                
                guard let dictRes = dict else {
                    loginEventStatus = .failure(message: "response is nil")
                    self.showError(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {
                    
                    if let arrErrors = dictRes["error_messages"] as? [String], arrErrors.count > 0 {
                        loginEventStatus = .failure(message: arrErrors[0])
                        self.showError(msg: arrErrors[0])
                    }
                    else {
                        loginEventStatus = .failure(message: "error not found")
                        self.showError(msg: stringConstants.errSomethingWentWrong)
                    }
                    
                    return
                }
                
   
                self.gotoVerifyOTPScreen(type:type.rawValue)

                
            }
            else {
                loginEventStatus = .failure(message: msg ?? "")
                utility.alert(message: msg, delegate: self, cancel: nil, completion: nil)
            }
        }
    }

}

extension EarnMoreCoinsViewController {
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
        
        if self.isProfileImageSelected {
            
            self.uploadImage(image: self.userImageView.image!)
            
        }else{
           updateProfile()
        }
      
    }
    func updateProfile(){
        if checkValidation()
              {
                  if checkValidationEmailOrMobileVerify(){
                      submitted()
                  }else{
                      self.showToast(message: "Kindly verify email or mobile no.")
                  }
                   
              }

    }
    func submitted(){
        if Reachability.isConnectedToNetwork() {
                      self.overlayView.showOverlay(view: self.view)
                      let scheduleAt = selectedDate?.toString(to: .yyyyMMdd)
               
            
//            lcDateFormater.dateFormat = "dd-MMMM-yyyy"
//            if let dateFromString : NSDate = lcDateFormater.date(from: self.newDob!) as NSDate? {
//            lcDateFormater.dateFormat = "yyyy-MM-dd hh:mm:ss" //mm-dd-yyyy
//
//            self.newDob = lcDateFormater.string(from: dateFromString as Date)
//         }
            
            let diffs = Calendar.current.dateComponents([.year], from: selectedDate! as Date, to: Date())
            print(diffs.year!)
            
             UserDefaults.standard.setValue(diffs.year, forKey: "age_difference")
             UserDefaults.standard.synchronize()

            
               requestParameters = ["first_name": firstNameTextField.text!,"last_name": lastNameTextField.text!,"mobile": mobileNumberTextField.text!, "gender": self.captureType,  "platform": "ios", "dob":scheduleAt]
                  
                      ServerManager.sharedInstance().postRequest(postData: requestParameters as Parameters, apiName: Constants.UPDATE_PROFILE, extraHeader: nil, closure: { (result) in
                                        switch result {
                                        case .success(let data):
                                            print(data)
                                            
                                            if (data["error"] as? Bool == true) {
                                                self.stopLoader()
                                                self.overlayView.hideOverlayView()
                                                self.showToast(message: "Something went wrong. Please try again!")
                                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason: "Something went wrong. Please try again!", extraParamDict: nil)
                                                return
                                                
                                            } else {
                                                 self.stopLoader()
                                                  if  let dict = data["data"]["customer"].object as? NSDictionary {
                                                    print("Login Successful")
                                                      if   let customer : Customer = Customer.init(dictionary: dict as! NSDictionary){
                                                    CustomerDetails.customerData = customer
                                                    CustomerDetails.badges = customer.badges
                                                    self.updateDataToDatabase(cust: customer)
                                                    if let Customer_Id = dict.object(forKey: "_id") as? String{
                                                        CustomerDetails.custId = Customer_Id
                                                    }
                                                  
                                                  if let customer_gender = dict.object(forKey: "gender") as? String{
                                                      CustomerDetails.gender = customer_gender
                                                  }
                                                    if let Customer_Account_Link = dict.object(forKey: "account_link") as? NSMutableDictionary{
                                                        CustomerDetails.account_link = Customer_Account_Link
                                                    }
                                                    
                                                    if let customer_email = dict.object(forKey: "email") as? String{
                                                        CustomerDetails.email = customer_email
                                                    }
                                                    if let Customer_FirstName = dict.object(forKey: "first_name") as? String{
                                                        CustomerDetails.firstName = Customer_FirstName
                                                    }
                                                    if let Customer_LastName = dict.object(forKey: "last_name") as? String{
                                                        CustomerDetails.lastName = Customer_LastName
                                                    }
                                                    if let Customer_dob = dict.object(forKey: "dob") as? String{
                                                     UserDefaults.standard.setValue(Customer_dob, forKey: "dob")
                                                     UserDefaults.standard.synchronize()
                                                       CustomerDetails.dob = Customer_dob
                                                    }
                                                  if let Customer_mobile_code = dict.object(forKey: "mobile_code") as? String{
                                                                                                                                                    UserDefaults.standard.setValue(Customer_mobile_code, forKey: "mobile_code")
                                                                                                                                                    UserDefaults.standard.synchronize()
                                                                                                                                                       CustomerDetails.mobile_code = Customer_mobile_code
                                                                                                              }
                                                    if let Customer_MobileVerified = dict.object(forKey: "mobile_verified") as? Bool {
                                                        CustomerDetails.mobile_verified = Customer_MobileVerified
                                                    }
                                                    
                                                    if let Customer_MobileVerified = dict.object(forKey: "mobile_verified") as? Int {
                                                        if Customer_MobileVerified == 0 {
                                                            CustomerDetails.mobile_verified = false
                                                        } else if Customer_MobileVerified == 1 {
                                                            CustomerDetails.mobile_verified = true
                                                        }
                                                    }
                                                    
                                                    UserDefaults.standard.set(CustomerDetails.mobile_verified, forKey: "mobile_verified")
                                                    UserDefaults.standard.synchronize()
                                                          
                                                  if let Customer_EmailVerified = dict.object(forKey: "email_verified") as? Bool {
                                                          CustomerDetails.email_verified = Customer_EmailVerified
                                                      }
                                                    if let Customer_EmailVerified = dict.object(forKey: "email_verified") as? Int {
                                                        if Customer_EmailVerified == 0 {
                                                            CustomerDetails.email_verified = false
                                                        } else if Customer_EmailVerified == 1 {
                                                            CustomerDetails.email_verified = true
                                                        }
                                                    }
                                                    
                                                    UserDefaults.standard.set(CustomerDetails.email_verified, forKey: "email_verified")
                                                    UserDefaults.standard.synchronize()
                                                          
                                                    if let Customer_Picture = dict.object(forKey: "picture") as? String{
                                                        CustomerDetails.picture = Customer_Picture
                                                        print("profile image 1\(Customer_Picture)")
                                                    }
                                                  if let profile_completed = dict.object(forKey: "profile_completed") as? Bool {
                                                      CustomerDetails.profile_completed = profile_completed
                                                      
                                                  }
                                                  UserDefaults.standard.set(CustomerDetails.profile_completed, forKey: "profile_completed")
                                                    CustomerDetails.identity = customer.identity
                                                    CustomerDetails.lastVisited = customer.last_visited
                                                    CustomerDetails.status = customer.status
                                                    CustomerDetails.email = customer.email
                                                    CustomerDetails.gender = customer.gender
                                                    CustomerDetails.mobileNumber = customer.mobile
                                                    CustomerDetails.coins = customer.coins
                                                    CustomerDetails.dob = customer.dob
                                                  CustomerDetails.profile_completed = customer.profile_completed
                                                    CustomMoEngage.shared.updateUserInfo(customer: customer)
                                                   
                                                    CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Success", reason: "", extraParamDict: nil)

                                                        if self.isProfileImageSelected {
                                                            self.stopLoader()
                                                            self.updateButton.isUserInteractionEnabled = true
                                                            if self.saveMessageProfile == "Customer data"{
                                                            let message = data["message"].string
                                                            self.navigationController?.popViewController(animated: true)
                                                              NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: ["message":message])
                                                            } else {
                                                                self.navigationController?.popViewController(animated: true)
                                                                                                                           NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: ["message":self.saveMessageProfile])
                                                            }
                                                            
                                                           
                                                            
                                                        }else{
                                                            self.stopLoader()
                                                            self.updateButton.isUserInteractionEnabled = true
                                                            let message = data["message"].string
                                                            self.navigationController?.popViewController(animated: true)
                                                              NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: ["message":message])
                                                        }
                                              

                                                  self.overlayView.hideOverlayView()
                                                          
                                               }
                                                  }else{
                                                      self.overlayView.hideOverlayView()
                                                      self.navigationController?.popViewController(animated: true)

//                                                  }
                                                }
                                            }
                                        case .failure(let error):
                                            self.stopLoader()
                                            self.overlayView.hideOverlayView()
                                       
                                            CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                                            print(error)
                                        }
                                    })
                                    
                                }  else {
                                    self.showToast(message: Constants.NO_Internet_MSG)
                                    //                     CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Update Profile", status: "Failed", reason: Constants.NO_Internet_MSG, extraParamDict: nil)
                                    self.stopLoader()
                                    CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason:  Constants.NO_Internet_MSG, extraParamDict: nil)
                                }
    }
    func checkValidationEmailOrMobileVerify() -> Bool {
    if UserDefaults.standard.bool(forKey: "email_verified") == false{
        let str = self.emailIdTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 1
        if str <= 0 {
            utility.showToast(msg: stringConstants.errEmptyEmailAddress, delay: 0, duration: 2.0, bottom: 80)
          return false
        }
            let alert = UIAlertController(title: "", message: "Please verify your email address and earn free coins. Do you want to continue?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in

                     //  self.completedProfile = true
                       
                      // self.updateProfile()
                        
                       
                   }))
                  alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
                   self.view.endEditing(true)

                   let email = self.emailIdTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
                   self.showLoader()
                   
                   self.webLogin(id: nil, email: email, firstname: nil, lastname: nil, phone: nil, countryCode: nil, type: .email)
                  
                  }))
           
                  self.present(alert, animated: true, completion: nil)
           return false
       }else if UserDefaults.standard.bool(forKey: "mobile_verified") == false {
       let str = self.mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 1
       if str <= 0 {
           utility.showToast(msg: stringConstants.errEmptyPhoneNumber, delay: 0, duration: 2.0, bottom: 80)
         return false
       }
        let alert = UIAlertController(title: "", message: "Please verify your mobile number and earn free coins. Do you want to continue?", preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in

             //self.completedProfile = true
           // self.updateProfile()
           
                }))
          
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            if self.mobileNumberTextField.text!.trimmingCharacters(in: .whitespaces).count >= 12 {
                self.mobileNumberTextField.resignFirstResponder()
                        utility.showToast(msg: stringConstants.mobileValidatemessage, delay: 0, duration: 1.2, bottom: 80)
               }else{
                let phone = self.mobileNumberTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
                let countryCode = self.countryCodeLabel.text
                       self.showLoader()
                self.webLogin(id: nil, email: nil, firstname: nil, lastname: nil, phone: phone, countryCode: countryCode, type: .phone)
                   }

        }))
      
        self.present(alert, animated: true, completion: nil)
          
        return false
    }
         return true
    }
    func checkValidation() -> Bool {
        if firstNameTextField.text!.trimmingCharacters(in: .whitespaces).count <= 2 {
            self.view.endEditing(true)
            utility.showToast(msg: stringConstants.firstNameMessage, delay: 0, duration: 2.0, bottom: 80)
            return false
        } else if lastNameTextField.text!.trimmingCharacters(in: .whitespaces).count <= 2 {
            self.view.endEditing(true)
            utility.showToast(msg: stringConstants.lastNameMessage, delay: 0, duration: 2.0, bottom: 80)
            return false
        } else if mobileNumberTextField.text!.trimmingCharacters(in: .whitespaces).count == 0 {
            self.view.endEditing(true)
            utility.showToast(msg: stringConstants.mobileNumberMessage, delay: 0, duration: 2.0, bottom: 80)
            return false
        } else if (mobileNumberTextField.text!.trimmingCharacters(in: .whitespaces).count > 0)  {
            let isIndia = (countryCodeLabel.text == indiaCountryCode) ? true : false
                   if isIndia == true {
                   if mobileNumberTextField.text?.count == 10 {
                      
                   }else{
                    self.view.endEditing(true)
                    utility.showToast(msg: stringConstants.mobileNumberMessage, delay: 0, duration: 2.0, bottom: 80)
                    return false
                    }
            }
           
        }
        else if emailIdTextField.text!.trimmingCharacters(in: .whitespaces).count == 0 {
            self.view.endEditing(true)
            utility.showToast(msg: stringConstants.emailIdMessage, delay: 0, duration: 2.0, bottom: 80)
            return false
        } else if !isValidEmail(testStr: emailIdTextField.text!) {
            self.view.endEditing(true)
            utility.showToast(msg: stringConstants.emailIdMessage, delay: 0, duration: 2.0, bottom: 80)
            return false
        }
        
        return true
    }
     func uploadImage(image: UIImage) {
         let urlString = Constants.App_BASE_URL + Constants.UPDATE_PROFILE
        self.showLoader()
        updateButton.isUserInteractionEnabled = false
         let headers: HTTPHeaders = [
             "Authorization": Constants.TOKEN,
             "Content-Type": "application/json",
             "ApiKey": Constants.API_KEY,
             "ArtistId": Constants.CELEB_ID,
             "Platform": Constants.PLATFORM_TYPE
         ]
         guard let url = URL(string: urlString) else { return }
         var urlRequest = URLRequest(url: url)
         urlRequest.timeoutInterval = 600
         urlRequest.allHTTPHeaderFields = headers
         urlRequest.httpMethod = "POST"
         let caputerdImage = image.fixOrientation()
         let imageData = caputerdImage.jpegData(compressionQuality: 0.75)
    
         Alamofire.upload(multipartFormData: { (multipartFormData) in
             if let data = imageData{
                 multipartFormData.append(data, withName: "photo", fileName: "image.png", mimeType: "image/png")
             }
             
         }, usingThreshold: UInt64.init(), with: urlRequest) { (result) in
             switch result{
             case .success(let upload, _, _):
                 upload.responseJSON { response in
                     print("Succesfully uploaded")
                     if let responseJson = response.result.value as? JSON {
                         print(responseJson)
                     }
                     if let responseInDict = response.result.value as? [String: Any] {
                         if let responseStatus = responseInDict["status_code"] as? Int, responseStatus == 200 {
                             if let data = responseInDict["data"] as? [String: Any] {
                                 if let dict = data["customer"] as? [String: Any] {
                                     if let profileImage = dict["picture"] as? String {
                                         DatabaseManager.sharedInstance.updateCustomerProfileImage(imageValue: profileImage)
                                         print("profile image 2\(profileImage)")
                                         let customer : Customer = Customer.init(dictionary: dict as! NSDictionary)!
                                         CustomerDetails.picture = profileImage
                                         CustomerDetails.customerData = customer
                                         CustomerDetails.badges = customer.badges
                                         self.updateDataToDatabase(cust: customer)
                                         if let Customer_Id = dict["_id"] as? String{
                                             CustomerDetails.custId = Customer_Id
                                         }
                                         if let Customer_Account_Link = dict["account_link"] as? NSMutableDictionary{
                                             CustomerDetails.account_link = Customer_Account_Link
                                         }
                                         if let customer_gender = dict["gender"] as? String as? String{
                                             CustomerDetails.gender = customer_gender
                                         }
                                         if let customer_email = dict["email"] as? String{
                                             CustomerDetails.email = customer_email
                                         }
                                         if let Customer_FirstName = dict["first_name"] as? String{
                                             CustomerDetails.firstName = Customer_FirstName
                                         }
                                         if let Customer_LastName = dict["last_name"] as? String {
                                             CustomerDetails.lastName = Customer_LastName
                                         }
                                         
                                         if let Customer_MobileVerified = dict["mobile_verified"] as? Bool {
                                             CustomerDetails.mobile_verified = Customer_MobileVerified
                                         }
                                         
                                         if let Customer_MobileVerified = dict["mobile_verified"] as? Int {
                                             if Customer_MobileVerified == 0 {
                                                 CustomerDetails.mobile_verified = false
                                             } else if Customer_MobileVerified == 1 {
                                                 CustomerDetails.mobile_verified = true
                                             }
                                         }
                                        if let Customer_EmailVerified = dict["email_verified"] as? Bool {
                                        CustomerDetails.email_verified = Customer_EmailVerified
                                        }
                                        
                                        if let Customer_EmailVerified = dict["email_verified"] as? Int{
                                            if Customer_EmailVerified == 0 {
                                                CustomerDetails.email_verified = false
                                            } else if Customer_EmailVerified == 1 {
                                                CustomerDetails.email_verified = true
                                            }
                                        }
                                        
                                        UserDefaults.standard.set(CustomerDetails.email_verified, forKey: "email_verified")
                                        UserDefaults.standard.synchronize()
                                        
                                        if let Customer_mobile_code = dict["mobile_code"] as? String{
                                                                                                   UserDefaults.standard.setValue(Customer_mobile_code, forKey: "mobile_code")
                                                                                                   UserDefaults.standard.synchronize()
                                                                                                      CustomerDetails.mobile_code = Customer_mobile_code
                                                                                               }
                                      
                                        
                                        if let Customer_dob = dict["dob"] as? String{
                                         UserDefaults.standard.setValue(Customer_dob, forKey: "dob")
                                         UserDefaults.standard.synchronize()
                                            CustomerDetails.dob = Customer_dob
                                        }
                                      
                                        
                                         UserDefaults.standard.set(CustomerDetails.mobile_verified, forKey: "mobile_verified")
                                         UserDefaults.standard.synchronize()
                                         
                                         if let Customer_Picture = dict["picture"] as? String {
                                             CustomerDetails.picture = Customer_Picture
                                             print("profile image 1\(Customer_Picture)")
                                         }
                                         
                                         CustomerDetails.identity = customer.identity
                                         CustomerDetails.lastVisited = customer.last_visited
                                         CustomerDetails.status = customer.status
                                         CustomerDetails.gender = customer.gender
                                         CustomerDetails.mobileNumber = customer.mobile
                                         CustomerDetails.coins = customer.coins
                                         CustomerDetails.dob = customer.dob
                                         CustomMoEngage.shared.updateUserInfo(customer: customer)
                                     }
                                 }
                                 //                                self.stopLoader()
                                 self.overlayView.hideOverlayView()
                                self.updateProfile()
                                let message = responseInDict["message"] as? String
                                self.saveMessageProfile = message ?? ""
//                            self.navigationController?.popViewController(animated: true)
//                            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: ["message":message])
                             }else{
                                 self.overlayView.hideOverlayView()
                                self.navigationController?.popViewController(animated: true)

                            }
                         } else {
                             if let message = responseInDict["message"] as? String {
                                 //                                self.stopLoader()
                                 self.overlayView.hideOverlayView()
                                 self.toast(message: message, duration: 5)
                             } else {
                                 //                                self.stopLoader()
                                 self.overlayView.hideOverlayView()
                                 self.toast(message: "Something went wrong...", duration: 5)
                             }
                         }
                     }
                     if let err = response.error{
                         self.toast(message: err.localizedDescription, duration: 5)
                         return
                     }
                 }
             case .failure(let error):
                 //                self.stopLoader()
                 self.overlayView.hideOverlayView()
                 print("Error in upload: \(error.localizedDescription)")
             }
         }
         
     }
    func updateDataToDatabase(cust : Customer) {
        
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        database.updateCustomerData(customer: cust)
    }
    public func toast(message: String, duration: Double) {
        let toast: UIAlertView = UIAlertView.init(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
        toast.show()
        self.overlayView.hideOverlayView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toast.dismiss(withClickedButtonIndex: 0, animated: true)
        }
    }
}
extension EarnMoreCoinsViewController{
    
    @IBAction func btnCountryCodeClicked() {
           
           self.view.endEditing(true)
           
           showCountryPicker()
       }
    
    func showCountryPicker() {
           
           countryPicker = CountryPickerView()
           countryPicker?.delegate = self
           countryPicker?.dataSource = self
           
           countryPicker?.showCountriesList(from: self)
       }
    func isValidEmail(testStr:String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           
           let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailTest.evaluate(with: testStr)
       }
}
// MARK: - Country Picker Delegate & DataSource Methods
extension EarnMoreCoinsViewController: CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    func sectionTitleLabelColor(in countryPickerView: CountryPickerView) -> UIColor? {
        
        return UIColor.white
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        
        return stringConstants.titleSelectCountry
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {

        return .navigationBar
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        
        return true
    }
    
    func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale {
        
        return Locale.current
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
                
        countryCodeLabel.text = (country.phoneCode as NSString).replacingOccurrences(of: "+", with: "")
        
        let isIndia = (countryCodeLabel.text == indiaCountryCode) ? true : false
        if isIndia == true {
        if mobileNumberTextField.text?.count == 10 {
            
            self.mobileTickImageView.isHidden = true
            self.verifyButton.isHidden = false
            self.verifyLineLabel.isHidden = false
            mobileTickImageView.isUserInteractionEnabled = false
        }
        else {
            self.mobileTickImageView.isHidden = false
            mobileTickImageView.isUserInteractionEnabled = true
            self.verifyButton.isHidden = true
            self.verifyLineLabel.isHidden = true

            }
        }else{
            self.mobileTickImageView.isHidden = true
            self.verifyButton.isHidden = false
            self.verifyLineLabel.isHidden = false
            mobileTickImageView.isUserInteractionEnabled = false
        }
    }
}

