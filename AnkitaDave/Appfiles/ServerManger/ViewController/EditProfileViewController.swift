import UIKit
import Foundation
import AVFoundation
import SDWebImage
import Alamofire
import SwiftyJSON


protocol ProfileDataDelegate {
    func sendProfileData(dict: [String: Any])
}

class EditProfileViewController: BaseViewController, UITextFieldDelegate
{
    @IBOutlet weak var ivProfilePic: UIImageView!
    @IBOutlet weak var tfFName: UITextField!
    @IBOutlet weak var tfLName: UITextField!
    @IBOutlet weak var tfContactNo: UITextField!
    @IBOutlet weak var tfMailId: UITextField!
    //    @IBOutlet weak var viwCameraBg: UIView!
    @IBOutlet weak var maleRadioImage: UIImageView!
    @IBOutlet weak var femaleRadioImage: UIImageView!
    //    @IBOutlet weak var profileBackgroundBlur: UIImageView!
    @IBOutlet weak var genderFemale: UIButton!
    @IBOutlet weak var genderMale: UIButton!
    //    @IBOutlet weak var btnMale: UIButton!
    //    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var firstNameHeight: NSLayoutConstraint!
    @IBOutlet weak var submitButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var emailimgVerified: UIImageView!
    var delegate: ProfileDataDelegate?
    var flagMale: Bool = true
    var gender = "male"
    var isProfileImageSelected = false
    private var overlayView = LoadingOverlay.shared
    @IBOutlet weak var screenBackView: UIView!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var fnameView: UIView!
    @IBOutlet weak var lnameView: UIView!
    @IBOutlet weak var contactNoView: UIView!
    @IBOutlet weak var emailView: UIView!
    var isEditedProfile: Bool = false
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
     
        DispatchQueue.main.async {
            
            self.setupUi()
            self.screenBackView.backgroundColor = .white
        }
        
        //        self.navigationItem.title = "EDIT PROFILE"
        //        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!,  NSAttributedString.Key.foregroundColor: UIColor.black]
       
        self.setNavigationView(title: "EDIT PROFILE")
        self.tabBarController?.tabBar.isHidden = true
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //        self.view.backgroundColor = UIColor(patternImage: image)
        self.tfFName.delegate = self
        self.tfLName.delegate = self
        self.tfMailId.delegate = self
        self.tfContactNo.delegate = self
        
        ivProfilePic.layer.cornerRadius = self.ivProfilePic.frame.size.width / 2
        ivProfilePic.layer.masksToBounds = false
        ivProfilePic.clipsToBounds = true
        ivProfilePic.layer.borderColor = UIColor.black.cgColor
        ivProfilePic.layer.borderWidth = 1
        
        self.btnSubmit.layer.cornerRadius = 4//self.btnSubmit.frame.height/2
        
        //        self.viwCameraBg.layer.cornerRadius = self.viwCameraBg.frame.size.width / 2
        //        self.viwCameraBg.layer.masksToBounds = false
        //        self.viwCameraBg.clipsToBounds = true
        
        if CustomerDetails.customerData.last_name != nil {
            if CustomerDetails.customerData.last_name != "" {
                self.tfLName.text = CustomerDetails.customerData.last_name ?? ""
            } else {
                self.tfLName.text = CustomerDetails.lastName
            }
            
            
        }
        if CustomerDetails.customerData.email != nil {
            self.tfMailId.text = CustomerDetails.customerData.email ?? ""
        }
        if CustomerDetails.customerData.first_name != nil {
            if CustomerDetails.customerData.first_name != "" {
                self.tfFName.text = CustomerDetails.customerData.first_name ?? ""
            } else {
                self.tfLName.text = CustomerDetails.firstName
            }
            
        }
        
        if CustomerDetails.customerData.gender != nil {
            if CustomerDetails.customerData.gender!.lowercased() == "male" {
                gender = "male"
                self.maleRadioImage.image = UIImage(named: "radioSelect")
                self.femaleRadioImage.image = UIImage(named: "radioUnSelect")
                flagMale = true
            } else {
                gender = "female"
                self.maleRadioImage.image = UIImage(named: "radioUnSelect")
                self.femaleRadioImage.image = UIImage(named: "radioSelect")
                flagMale = false
            }
            print(CustomerDetails.customerData.gender)
        }
        
        if CustomerDetails.mobileNumber != nil {
            self.tfContactNo.text = CustomerDetails.mobileNumber
        } else if let mobNo = CustomerDetails.customerData.mobile {
            self.tfContactNo.text = mobNo
        }
        
        if UserDefaults.standard.bool(forKey: "mobile_verified") {
            self.tfContactNo.isUserInteractionEnabled = false
            self.imgVerified.isHidden = false
        } else {
            self.tfContactNo.isUserInteractionEnabled = true
            self.imgVerified.isHidden = true
        }
        if UserDefaults.standard.bool(forKey: "email_verified") {
            tfMailId.isUserInteractionEnabled = false
            self.emailimgVerified.isHidden = false
            
        }else{
            tfMailId.isUserInteractionEnabled = true
            self.emailimgVerified.isHidden = true
            
        }
        if CustomerDetails.customerData.picture != nil {
            
            self.ivProfilePic.sd_imageIndicator?.startAnimatingIndicator()
            self.ivProfilePic.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.ivProfilePic.sd_imageTransition = .fade
            self.ivProfilePic.sd_setImage(with: URL(string:CustomerDetails.customerData.picture!), completed: nil)
            //            self.profileBackgroundBlur.sd_setImage(with: URL(string:CustomerDetails.picture), completed: nil)
        }
            
            
        else{
            ivProfilePic.image = UIImage(named: "profileph")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GlobalFunctions.screenViewedRecorder(screenName: "Edit Profile Screen")
        CustomMoEngage.shared.sendEventUIComponent(componentName: "EditProfile_Screen", extraParamDict: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnUploadProfilePicClicked(_ sender: UIButton)
    {
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
                
                //DispatchQueue.main.async {
                
                let picker = UIImagePickerController()
                picker.sourceType = type
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                //}
                
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
    
    @IBAction func selectGender(_ sender: UIButton) {
        isEditedProfile = true
        if sender.isEqual(genderMale)
        {
            self.maleRadioImage.image = UIImage(named: "radioSelect")
            self.femaleRadioImage.image = UIImage(named: "radioUnSelect")
            gender = "male"
            flagMale = true
        }else
        {
            self.maleRadioImage.image = UIImage(named: "radioUnSelect")
            self.femaleRadioImage.image = UIImage(named: "radioSelect")
            gender = "female"
            flagMale = false
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func checkValidation() -> Bool {
        if tfFName.text!.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showToast(message: "Please enter first name")
            return false
        } else if tfLName.text!.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showToast(message: "Please enter last name")
            return false
        }
            //        else if tfContactNo.text!.trimmingCharacters(in: .whitespaces).count == 0 {
            //            self.showToast(message: "Please enter contact number")
            //            return false
            //        }
        else if (tfContactNo.text!.trimmingCharacters(in: .whitespaces).count > 0) && (tfContactNo.text!.trimmingCharacters(in: .whitespaces).count < 10) {
            self.showToast(message: "Please enter valid contact number")
            return false
        }
        else if tfMailId.text!.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showToast(message: "Please enter email ID")
            return false
        }else if !isValidEmail(testStr: tfMailId.text!) {
            self.showToast(message: "Please enter valid email ID")
            return false
        }
        
        return true
    }
    
 /*   @IBAction func submitProfileData(_ sender: UIButton) {
        
        //        if (!(tfFName.text?.isEmpty)! && !(tfLName.text?.isEmpty)! && !(tfMailId.text?.isEmpty)! && !(tfContactNo.text?.isEmpty)!)
        //        {
        //            if isValidEmail(testStr: tfMailId.text!)
        //            {
        if !isEditedProfile {
            self.toast(message: "Profile Updated Successfully", duration: 5)
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if checkValidation(){
            if Reachability.isConnectedToNetwork()
            {
                //                    self.showLoader()
                self.overlayView.showOverlay(view: self.view)
                let dict = ["first_name": tfFName.text!, "last_name": tfLName.text!,"mobile": tfContactNo.text!, "gender": self.gender,  "platform": "ios" ]
                ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.UPDATE_PROFILE, extraHeader: nil, closure: { (result) in
                    switch result {
                    case .success(let data):
                        print(data)
                        
                        if(data["error"] as? Bool == true){
                            //                                self.stopLoader()
                            self.overlayView.hideOverlayView()
                            self.showToast(message: "Something went wrong. Please try again!")
                            CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason: "Something went wrong. Please try again!", extraParamDict: nil)
                            return
                            
                        }else{
                            if self.isProfileImageSelected {
                                self.uploadImage(image: self.ivProfilePic.image!)
                            } else {
                                if  let dict = data["data"]["customer"].object as? NSDictionary {
                                print("Login Successful")
                                    if   let customer : Customer = Customer.init(dictionary: dict as! NSDictionary){
                                CustomerDetails.customerData = customer
                                CustomerDetails.badges = customer.badges
                                self.updateDataToDatabase(cust: customer)
                                        if let Customer_Id = dict.object(forKey: "_id") as? String{
                                    CustomerDetails.custId = Customer_Id
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
                                        if let Customer_Picture = dict.object(forKey: "picture") as? String{
                                    CustomerDetails.picture = Customer_Picture
                                    print("profile image 1\(Customer_Picture)")
                                }
                                
                                CustomerDetails.identity = customer.identity
                                CustomerDetails.lastVisited = customer.last_visited
                                CustomerDetails.status = customer.status
                                CustomerDetails.gender = customer.gender
                                CustomerDetails.mobileNumber = customer.mobile
                                CustomerDetails.coins = customer.coins
                                
                                CustomMoEngage.shared.updateUserInfo(customer: customer)
                                //                                CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Update Profile", status: "Success", reason: "", extraParamDict: nil)
                                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Success", reason: "", extraParamDict: nil)
                                //                                self.stopLoader()
                                self.toast(message: "Profile Updated Successfully", duration: 5)
                                // self.dismiss(animated: true, completion: nil)
                                self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        //                            self.stopLoader()
                        self.overlayView.hideOverlayView()
                        
                        //                              CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Update Profile", status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                        CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                        print(error)
                    }
                })
                
                //                     self.showToast(message: "Profile Updated Successfully")
            }else {
                self.showToast(message: Constants.NO_Internet_MSG)
                //                     CustomMoEngage.shared.sendEvent(eventType: MoEventType.userlogin, action: "Update Profile", status: "Failed", reason: Constants.NO_Internet_MSG, extraParamDict: nil)
                
                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason:  Constants.NO_Internet_MSG, extraParamDict: nil)
            }
        }
        //            }else {
        //                showToast(message: "Please enter correct Email Id")
        //            }
        //        }else {
        //            showToast(message: "Please enter correct Info")
        //        }
        
    } */
    
    
    @IBAction func submitProfileData(_ sender: UIButton) {
        
        if !isEditedProfile {
            self.toast(message: "Profile Updated Successfully", duration: 5)
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if checkValidation(){
            if Reachability.isConnectedToNetwork()
            {
               
                self.overlayView.showOverlay(view: self.view)
                self.uploadImage()
            
            }else {
                self.showToast(message: Constants.NO_Internet_MSG)
                
                CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason:  Constants.NO_Internet_MSG, extraParamDict: nil)
            }
        }
    
        
    }
    
    func insertCustomerDataToDatabase(cust : Customer){
        
        let database =  DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath  = documents + "/ConsumerDatabase.sqlite"
        database.dbPath = writePath
        
        if(database != nil){
            database.createCustomerTable()
        }
        database.insertIntoCustomer(customer: cust)
        
    }
    
    func updateDataToDatabase(cust : Customer) {
        
        let database =  DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath  = documents + "/ConsumerDatabase.sqlite"
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isEditedProfile = true
        if textField == tfContactNo {
            if string == "" {
                return true
            }
            if (tfContactNo.text?.utf16.count)! > 9 {
                return false
            }
            if textField == tfContactNo {
                let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
            }
        }else if textField == tfFName {
            if string == "" {
                return true
            }
            
            if (tfFName.text?.utf16.count)! > 14 {
                return false
            }
        }else if textField == tfLName {
            if string == "" {
                return true
            }
            if (tfLName.text?.utf16.count)! > 14 {
                return false
            }
        }
        return true
    }
}

extension EditProfileViewController{
    func setupUi(){
        //        fnameView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .white)
        //        lnameView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .white)
        //        contactNoView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .white)
        //        emailView.addBorderWithCornerRadius(width: 1, cornerRadius: 4, color: .white)
        
        fnameView.addunderlinedWithColor(color: .black)
        lnameView.addunderlinedWithColor(color: .black)
        contactNoView.addunderlinedWithColor(color: .black)
        emailView.addunderlinedWithColor(color: .black)
        
        tfFName.changePlaceholderColor(color: UIColor.black.withAlphaComponent(0.6))
        tfLName.changePlaceholderColor(color: UIColor.black.withAlphaComponent(0.6))
        tfMailId.changePlaceholderColor(color: UIColor.black.withAlphaComponent(0.6))
        tfContactNo.changePlaceholderColor(color: UIColor.black.withAlphaComponent(0.6))
        
        // submitButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 16.0)
//        btnSubmit.titleLabel?.font = UIFont(name: AppFont.extrabold.rawValue, size: 20.0)
        
        tfFName.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        tfLName.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        tfMailId.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        tfContactNo.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        genderLabel.font = UIFont(name: AppFont.light.rawValue, size: 16.0)
        maleLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        femaleLabel.font = UIFont(name: AppFont.light.rawValue, size: 14.0)
        
        tfFName.textColor = .black
        tfLName.textColor = .black
        tfMailId.textColor = .black
        tfContactNo.textColor = .black
        genderLabel.textColor = .black
        femaleLabel.textColor = .black
        maleLabel.textColor = .black
        
        tfFName.tintColor = .black
        tfLName.tintColor = .black
        tfMailId.tintColor = .black
        tfContactNo.tintColor = .black
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isEditedProfile = true
        if let chosenImg : UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            ivProfilePic.image = chosenImg
            isProfileImageSelected = true
            //            UserDefaults.standard.set(chosenImg.pngData(), forKey: "kKeyImage")
        }else if let chosenImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            ivProfilePic.image = chosenImg
            isProfileImageSelected = true
            //        UserDefaults.standard.set(chosenImg.pngData(), forKey: "kKeyImage")
        }else
        {
            print ("something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    
    //this method is not being called
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //use image here!
        dismiss(animated: true, completion: nil)
        print("org image size \(image.size)")
        print("compress image Size \(image.imageWithSize(CGSize(width: 300.0, height: 300.0)).size)")
        DispatchQueue.main.async {
            let choosenImg: UIImage = image!
            self.ivProfilePic.image = choosenImg
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() {
        
        var imgprofile = UIImage()
        let urlString = Constants.App_BASE_URL + Constants.UPDATE_PROFILE
        
        let parameters = ["first_name": tfFName.text!,
                          "last_name": tfLName.text!,
                          "gender": self.gender,
                          "platform": "ios" ]
        
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
        
        if isProfileImageSelected
              {
                  imgprofile = self.ivProfilePic.image!
              }
        let caputerdImage = imgprofile.fixOrientation()
        let imageData = caputerdImage.jpegData(compressionQuality: 0.75)
        //        let imageData = image.jpegData(compressionQuality: 0.75)
        
        
        
        //        UIImage *originalImage = [requestBody objectForKey:keyUploadImage];
        //
        //        UIImage *imageToUpload =
        //            [UIImage imageWithCGImage:[originalImage CGImage]
        //                scale:[originalImage scale]
        //                orientation: UIImageOrientationUp];
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imageData{
                multipartFormData.append(data, withName: "photo", fileName: "image.png", mimeType: "image/png")
            }
            for (key, value) in parameters {
                       multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                   }
            
        },usingThreshold: UInt64.init(), with: urlRequest) { (result) in
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
                                        let customer : Customer = Customer.init(dictionary: dict as NSDictionary)!
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
                                        
                                        if let customer_email = dict["email"] as? String{
                                            CustomerDetails.email = customer_email
                                        }
                                        if let Customer_FirstName = dict["first_name"] as? String{
                                            CustomerDetails.firstName = Customer_FirstName
                                        }
                                        if let Customer_LastName = dict["last_name"] as? String{
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
                                        
                                        UserDefaults.standard.set(CustomerDetails.mobile_verified, forKey: "mobile_verified")
                                        UserDefaults.standard.synchronize()
                                        if let Customer_Picture = dict["picture"] as? String{
                                            CustomerDetails.picture = Customer_Picture
                                            print("profile image 1\(Customer_Picture)")
                                        }
                                        
                                        CustomerDetails.identity = customer.identity
                                        CustomerDetails.lastVisited = customer.last_visited
                                        CustomerDetails.status = customer.status
                                        CustomerDetails.gender = customer.gender
                                        CustomerDetails.mobileNumber = customer.mobile
                      //                  CustomerDetails.coins = customer.coins
                                        
                                        CustomMoEngage.shared.updateUserInfo(customer: customer)
                                    }
                                }
                                //                                self.stopLoader()
                                self.overlayView.hideOverlayView()
                                self.toast(message: "Profile Updated Successfully", duration: 5)
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
}

extension EditProfileViewController {
    
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




