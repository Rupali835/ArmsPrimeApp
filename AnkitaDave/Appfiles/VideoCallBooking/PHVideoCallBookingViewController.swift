//
//  PHVideoCallBookingViewController.swift
//  Multiplex
//
//  Created by Parikshit on 27/10/20.
//  Copyright © 2020 Armsprime Media. All rights reserved.
//

import UIKit

fileprivate enum collectionType: Int {
    
    case date = 0
   case duration = 1
    case time = 2
}

class PHVideoCallBookingCollectionView: UICollectionView {
    
    fileprivate var type:collectionType = .date
}

class PHVideoCallBookingViewController: BaseViewController, PurchaseContentProtocol {
    func contentPurchaseSuccessful(index: Int) {
       // <#code#>
    }
    
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
       // <#code#>
    }
    var atristConfigCoins = ArtistConfiguration.sharedInstance()

    @IBOutlet weak var cvDates: PHVideoCallBookingCollectionView!
    @IBOutlet weak var cvDurations: PHVideoCallBookingCollectionView!
    @IBOutlet weak var cvTimes: PHVideoCallBookingCollectionView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountDetails: UILabel!
    @IBOutlet weak var lblSelectedMonth: UILabel!
    @IBOutlet weak var viewSelectDurationToSeeCost: UIView!
    @IBOutlet weak var loaderSlots: UIActivityIndicatorView!
    @IBOutlet weak var loaderRequest: UIActivityIndicatorView!
    @IBOutlet weak var messageInfoButton: UIButton!
    @IBOutlet weak var languageInfoButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    //@IBOutlet weak var lbldurationTitle: UILabel!
    @IBOutlet weak var imgDropdown: UIImageView!
    @IBOutlet weak var viewLanguage: UIView!
    @IBOutlet weak var txtLanguageSelection: UITextField!
     @IBOutlet weak var viewLanguageHeight: NSLayoutConstraint!
   // @IBOutlet weak var viewLabelsHeight: NSLayoutConstraint!
     @IBOutlet weak var outerScrollView: UIScrollView!
    @IBOutlet weak var vcMonths: UIView!
    @IBOutlet weak var vcSlots: UIView!
    private var overlayView = LoadingOverlay.shared
    var durationList = [Int64]()
    var languageList = [Int64]()

    var coinsList = [Int64]()
    var defaultDurationKey = [Int64]()
    var selectedDuration: Int64?
    var selectedLanguage: String?
    var selectedCoins:  Int64?
    var selectedDefaultRatecard: String?
    fileprivate var messageTolTip: EasyTipView?
    //fileprivate let messagePlaceholder: String = "Write a message"
    fileprivate let messageInfoText: String = "Type the Message you would want Ankita Dave to speak in the video."
    
     fileprivate let languageInfoText: String = "Language Preferred by Ankita Dave is English and Hindi."
    
    var currentDate = Date()
    var selectedDate: Date!
    
    var arrSlots = [String]()
    
    var selectedRateCard: Int64?
    var selectedSlot:String? = nil
    
    var isCallingGetSlotsAPI = false
    
    var webServiceGetSlots: WebService? = nil
            
    override func viewDidLoad() {
        super.viewDidLoad()
         title = "Video Call Booking"
        createPickerView()
        dismissPickerView()
        
        if let StrCallDuration = atristConfigCoins.privateVideoCallrateCard?.durations {
            self.durationList = StrCallDuration
            print("multiple call Duration: \(StrCallDuration)")
        }
        
        
        if let StrMultipleCoinsvalue = atristConfigCoins.privateVideoCallrateCard?.coins {
            self.coinsList = StrMultipleCoinsvalue
            print("multiple coins: \(StrMultipleCoinsvalue)")
        }
        
        if let defaultRatecardValue = atristConfigCoins.privateVideoCallrateCard?.defaultRatecard {
            self.defaultDurationKey = defaultRatecardValue
            if let index = defaultRatecardValue.firstIndex(of:1){
                selectedDuration = durationList[index]
            }

        }
        

//       if self.selectedLanguage == nil
//       {
//          // self.lbldurationTitle?.isHidden = true
//           self.txtLanguageSelection?.isHidden = true
//           self.imgDropdown?.isHidden = true
//
//           viewLanguageHeight.constant = 0
//           self.view.layoutSubviews()
//
//
//       }else{
//            self.txtLanguageSelection?.isHidden = false
//            self.imgDropdown?.isHidden = false
//          // viewDurationHeight.constant = 0
//       }

        // Do any additional setup after loading the view.
        
        setLayoutAndDesigns()
    }
    
    deinit {
        
        loaderSlots.stopAnimating()
        loaderRequest.stopAnimating()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        messageTolTip?.dismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        outerScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+30)
        //[scrollView setContentSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];

        
        vcMonths.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        vcSlots.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)

    }
     
    @IBAction func didTapMessageInfo(_ sender: UIButton) {
        
      
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
      
        let view = EasyTipView(text: messageInfoText, preferences: preferences)
        if let toolTipView = messageTolTip {
            messageTolTip = nil
            toolTipView.dismiss()
        } else {
            messageTolTip = view
            view.show(forView: sender, withinSuperview: self.navigationController?.view!)
        }
    }
   
    
    
    @IBAction func didTapLanguageInfo(_ sender: UIButton) {
        
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
      
        let view = EasyTipView(text: languageInfoText, preferences: preferences)
        if let toolTipView = messageTolTip {
            messageTolTip = nil
            toolTipView.dismiss()
        } else {
            messageTolTip = view
            view.show(forView: sender, withinSuperview: self.navigationController?.view!)
        }
    }
    
    
}

// MARK: - IBActions
extension PHVideoCallBookingViewController {
    
    @IBAction func btnContinueClicked() {
             //webSendVideoCallRequest()
        butnBookNowClicked()
       /* let coins = selectedRateCard?.coins
        
        if !PHBalanceManager.shared.isBalanceAvailable(coins) {

            Notifications.videoCallbookingShowRecharge.post(object: coins)
        }
        else {

            webSendVideoCallRequest()
        }*/
    }
}

// MARK: - Utility Methods
extension PHVideoCallBookingViewController {
    
    func setLayoutAndDesigns() {
       // messageTextView.text = messagePlaceholder
        messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate = self
        
        self.txtLanguageSelection.delegate = self
       
        
        cvDates.type = collectionType.date
        cvDurations.type = collectionType.duration
        cvTimes.type = collectionType.time
        
        btnContinue.corner = 8.0
        
        selectedDate = currentDate
        
        setComponentVisibility()
    }
    
    func setComponentVisibility() {
        messageTextView.borderWidth = 0.5
        messageTextView.borderColor = UIColor.gray
        
//        if let duraion = self.selectedDuration{
//        self.txtLanguageSelection?.text = String(duraion) + " minutes"
//        }
        
        if selectedRateCard != nil {
            
            lblAmountDetails.isHidden = false
            viewSelectDurationToSeeCost.isHidden = true
            viewAmount.isHidden = false
        }
        else {
            
            lblAmountDetails.isHidden = true
            viewSelectDurationToSeeCost.isHidden = false
            viewAmount.isHidden = true
        }
        
        if selectedDate != nil && selectedRateCard != nil && selectedSlot != nil {
            
            btnContinue.isEnabled = true
            btnContinue.backgroundColor = appearences.yellowColor
        }
        else {
            
            btnContinue.isEnabled = false
            btnContinue.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        
        btnContinue.setTitle(stringConstants.strContinue.uppercased(), for: .normal)
        
        loaderRequest.stopAnimating()
        loaderRequest.isHidden = true
        
        setSelectedMonth()
        
        setCost()
    }
    
    func setSelectedMonth() {
        
        let month = selectedDate.toString(to: .MMMM)
            
        lblSelectedMonth.text = month.uppercased()
    }
    
    func setCost() {
      
        if  let selectedDuration = selectedRateCard, let  index = self.durationList.index(of: selectedDuration){
            if let coins = atristConfigCoins.privateVideoCallrateCard?.coins[index]
            {
                
                lblAmount.text = "\(coins)"
            }else {
                
                lblAmount.text = "0"
            }
            
        }else {
            
            lblAmount.text = "0"
        }
 
        
        if let duration =  selectedRateCard //  atristConfigCoins.privateVideoCallrateCard?.durations
        {
            
            lblAmountDetails.text = "\(duration) mins duration"
        }
        else {
            
            lblAmount.text = "0 mins duration"
        }
    }
}

// MARK: - CollectionView Delegate & DataSource Methods
extension PHVideoCallBookingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
               
        let cv = collectionView as! PHVideoCallBookingCollectionView

        if cv.type == .date {
            
            return 30
        }
        
        if cv.type == .duration
        {
            
            return durationList.count
        }
        
        if cv.type == .time {
            
            if isCallingGetSlotsAPI == true {
                
                loaderSlots.startAnimating()
                loaderSlots.isHidden = false
                cv.removePlaceholder()
            }
            else {
                
                loaderSlots.stopAnimating()
                loaderSlots.isHidden = true
                
                if arrSlots.count == 0 {
                    
                    if selectedRateCard == nil {
                        
                        cv.setPlaceholderDetails(title: "", detail: stringConstants.selectDurationToSeeAvailableSlots, titleColor: .clear, detailColor: utility.rgb(0, 0, 0, 0.25), detailFont: fonts.regular(size: 12))
                    }
                    else {
                        
                        cv.setPlaceholderDetails(title: "", detail: stringConstants.noAvailableSlots, titleColor: .clear, detailColor: utility.rgb(0, 0, 0, 0.25), detailFont: fonts.regular(size: 12))
                    }
                }
                else {
                    
                    cv.removePlaceholder()
                }
            }
            
            return arrSlots.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cv = collectionView as! PHVideoCallBookingCollectionView
        
        if cv.type == .date {
            
            return CGSize(width: 60, height: 80)
        }
        else if cv.type == .duration {
            
            return CGSize(width: 80, height: 34)
        }
        else {
            
            return CGSize(width: 80, height: 34)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cv = collectionView as! PHVideoCallBookingCollectionView
        
        if cv.type == .date {
            
            let cell = cellForDate(indexPath: indexPath)
            return cell
        }
        else if cv.type == .duration {
            
            let cell = cellForDuration(indexPath: indexPath)
            return cell
        }
        else {
            
            let cell = cellForTime(indexPath: indexPath)
            return cell
        }
    }
    
    func cellForDate(indexPath: IndexPath) -> PHVideoCallBookingDateCollectionCell {
        
        let cell = cvDates.dequeueReusableCell(withCell: PHVideoCallBookingDateCollectionCell.self, indexPath: indexPath)
        
        cell?.setDetails(currentDate: currentDate, offset: indexPath.row, selectedDate: selectedDate!)
                  
        return cell!
    }
    
    func cellForDuration(indexPath: IndexPath) -> PHVideoCallBookingDurationCollectionCell {
        
        let cell = cvDurations.dequeueReusableCell(withCell: PHVideoCallBookingDurationCollectionCell.self, indexPath: indexPath)
        
        
        let card =  durationList[indexPath.row]
        let isSelected = card == selectedRateCard ?? 0
        cell?.setDetails(duration: card, isCoinSelected: isSelected)
        
        
        return cell!
    }
    
    func cellForTime(indexPath: IndexPath) -> PHVideoCallBookingTimeCollectionCell {
        
        let cell = cvTimes.dequeueReusableCell(withCell: PHVideoCallBookingTimeCollectionCell.self, indexPath: indexPath)
        
        cell?.setDetails(slot: arrSlots[indexPath.item], selected: selectedSlot)
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cv = collectionView as! PHVideoCallBookingCollectionView
        
        if cv.type == .date, let date = currentDate.dateByAdding(day: indexPath.row) {
            
            selectedDate = date
                        
            cvDates.reloadData()
            
            webGetSlots()
        }
        
        if cv.type == .duration {
            
            let card =   artistConfig.privateVideoCall?.privateVideoCallrateCard?.durations[indexPath.item]
                       
                       selectedRateCard = card
            self.setCost()
            cvDurations.reloadData()
                        
            webGetSlots()
        }
        
        if cv.type == .time {
            
            selectedSlot = arrSlots[indexPath.item]
            
            cvTimes.reloadData()
        }
        
        setComponentVisibility()
    }
}

// MARK: - Web Services
extension PHVideoCallBookingViewController {
    
    func cancelAPIs() {
        
        selectedSlot = nil
        arrSlots.removeAll()
        cvTimes.reloadData()
        
        webServiceGetSlots?.cancel()
        webServiceGetSlots = nil
        
        isCallingGetSlotsAPI = false
        cvTimes.reloadData()
    }
    
    func webGetSlots() {
        
        cancelAPIs()
        
        guard let artistId =  Constants.CELEB_ID as? String //macros.appDel?.channelDetails?.channel?._id
            else {
            
            return
        }
        
        guard let duration = selectedRateCard else {
            
            return
        }
                
        isCallingGetSlotsAPI = true
        cvTimes.reloadData()
        
        self.view.isUserInteractionEnabled = false
        
        var dictParams = [String: Any]()
        
        dictParams["duration"] = duration
        
        let strDate = selectedDate.toString(to: .yyyyMMdd)
        dictParams["date"] = strDate
        
        dictParams["artist_id"] = artistId
        
        let api = Constants.getVideoCallGetSlots
        
//        webServiceGetSlots = WebService(showInternetProblem: true, isCloud: false, loaderView: nil)
         let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
      
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { (status, msg, dict) in
     
                            
            self.isCallingGetSlotsAPI = false
            self.view.isUserInteractionEnabled = true
            
            if status {
                
                guard let dictRes = dict else {
                                            
                    self.showAlertMsg(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {
                    
                    if let arrErrors = dictRes["error_messages"] as? [String] {
                        
                        self.showAlertMsg(msg: arrErrors[0])
                    }
                    else {
                                                    
                        self.showAlertMsg(msg: stringConstants.errSomethingWentWrong)
                    }
                    
                    return
                }
                
                guard let dictData = dictRes["data"] as? [String: Any] else {
                                            
                    self.showAlertMsg(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                
                guard let artistSlots = dictData["slots"] as? [String] else {
                                            
                    self.showAlertMsg(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                                
                self.arrSlots.removeAll()
                self.arrSlots.append(contentsOf: artistSlots)
                
                self.cvDurations.reloadData()
                
                self.cvTimes.reloadData()
                
                self.setComponentVisibility()
            }
            else {
                
                self.showAlertMsg(msg: msg!)
            }
        }
    }
    
    func webSendVideoCallRequest() {
        var artistId: String {
            return Constants.CELEB_ID
        }

        
        guard let duration = selectedRateCard else {
            
            return
        }
        
        btnContinue.setTitle("", for: .normal)
        
        loaderRequest.startAnimating()
        loaderRequest.isHidden = false
        
        var dictParams = [String: Any]()
        if let email = CustomerDetails.customerData.email {
            
            dictParams["email"] = email
        }
        
        
        dictParams["duration"] = duration
        
        let strDate = selectedDate.toString(to: .yyyyMMdd)
        dictParams["date"] = strDate
        
        dictParams["artist_id"] = artistId
        
        dictParams["time"] = selectedSlot!
        
        if let mobileNumber = CustomerDetails.customerData.mobile, mobileNumber.count > 0,
            let countryCode = CustomerDetails.customerData.countryCode {
                
            dictParams["mobile_code"] = countryCode
            dictParams["mobile"] = mobileNumber
        }
        
        self.view.isUserInteractionEnabled = false
        
        let api =  Constants.videoCallRequest //webConstants.videoCallRequest
        
        let web = WebServiceApp(showInternetProblem: true, isCloud: false, loaderView: self.view)
        
        
        web.execute(type: .post, name: api, params: dictParams as [String: AnyObject]) { [weak self] (status, msg, dict) in
            
            self?.view.isUserInteractionEnabled = true
            
            if status {
                
                guard let dictRes = dict else {
                    
                    self?.showAlertMsg(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                
                if let error = dictRes["error"] as? Bool, error == true {
                    
                    if let arrErrors = dictRes["error_messages"] as? [String] {
                        
                        self?.showAlertMsg(msg: arrErrors[0])
                    }
                    else {
                        
                        self?.showAlertMsg(msg: stringConstants.errSomethingWentWrong)
                    }
                    
                    return
                }
                
                guard let dictData = dictRes["data"] as? [String:Any] else {
                    
                    self?.showAlertMsg(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                
                    
                   /*  guard let obj = VideoCallBookingResponse.object(dictData), let balance = obj.coin_after_transactio
                    else {
                    
                    self?.showAlertMsg(msg: stringConstants.errSomethingWentWrong)
                    
                    return
                }
                
             //   PHBalanceManager.shared.setBalance(balance)
                
                self?.loaderRequest.stopAnimating()
                self?.loaderRequest.isHidden = true
                
                Notifications.videoCallBookingDone.post(object: obj)*/
                
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "VideoCallBookingStatusViewController")  as? VideoCallBookingStatusViewController
               // self.overlayView.hideOverlayView()
                // vc?.strVideoCAllBookingID = self.VideoCAllBookingID
               // let jsonObject = data
               // vc!.Details = jsonObject
                self?.navigationController?.pushViewController(vc!, animated: true)
            }
            else {
               
                self?.showAlertMsg(msg: msg!)
            }
        }
    }
    
    func showAlertMsg(msg:String) {
                
        self.cvTimes.reloadData()
        
        loaderRequest.stopAnimating()
        loaderRequest.isHidden = true
        
        btnContinue.setTitle(stringConstants.strContinue.uppercased(), for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            
            self?.showError(msg: msg)
        }
    }
}

extension PHVideoCallBookingViewController: UIScrollViewDelegate, EasyTipViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let toolTip = messageTolTip {
            toolTip.dismiss()
        }
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        messageTolTip = nil
    }
}

extension PHVideoCallBookingViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let toolTip = messageTolTip {
            toolTip.dismiss()
        }
    }
}
// MARK: - UITextView Delegate Methods.
extension PHVideoCallBookingViewController: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
////        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
////        let numberOfChars = newText.count
//////        if numberOfChars <= ShoutoutConstants.charLimitForMessageInVGRequest {
////            numberOfCharInMessage.text = "\(numberOfChars)/250"
////            projects.append( [String (newText )] )
////            projects.append( [String (numberOfChars )] )
////            projects.append( [String ("Characters \(numberOfChars)/250")] )
////            projects.append( [String (numberOfCharInMessage.text  ?? "" )] )
////             index(item: 0)
////        }
////        return numberOfChars <= ShoutoutConstants.charLimitForMessageInVGRequest
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "" //messagePlaceholder
        {
            textView.text = ""
            textView.textColor = UIColor.black
            
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
          //  textView.text = ""//messagePlaceholder
            textView.textColor = UIColor.lightGray
            
        }
    }
}

// MARK: - TextFiled Delegate Methods.
extension PHVideoCallBookingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if (textField == mobileNumberTextfield), let text = textField.text {
//            let newText = (text as NSString).replacingCharacters(in: range, with: string)
//            let numberOfChars = newText.count
//
//            return textField == mobileNumberTextfield ? numberOfChars <= 15 : numberOfChars <= ShoutoutConstants.charLimitForOtherOccasion
//        } else {
//
//            return true
//        }
//    }
}


// MARK: - PickerView Methods.
   extension PHVideoCallBookingViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return artistConfig.artistLanguage?.languages.count ?? 0
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return artistConfig.artistLanguage?.languages[row].language ?? ""
          
       }
       
       
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguage =  artistConfig.artistLanguage?.languages[row].language ?? ""
           self.txtLanguageSelection.text = selectedLanguage
        
    }
       
       func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           self.txtLanguageSelection?.inputView = pickerView
           
           
       }
       
       
       func dismissPickerView() {
           let toolBar = UIToolbar()
           toolBar.sizeToFit()
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
           let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
           toolBar.setItems([button], animated: true)
           toolBar.isUserInteractionEnabled = true
           self.txtLanguageSelection.inputAccessoryView = toolBar
       }
       
       @objc func action() {
           view.endEditing(true)
       }
       
   }



// MARK: - Web Services to Call Request
extension PHVideoCallBookingViewController {
    
    func checkValidation() -> Bool {
//        if tfMailId.text!.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showToast(message: "Please enter email ID")
//            return false
//        }else if !isValidEmail(testStr: tfMailId.text!) {
//            self.showToast(message: "Please enter valid email ID")
//            return false
//        } else if mobileNumberTextfield.text!.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showToast(message: "Please enter mobile number")
//            return false
//        } else if mobileNumberTextfield.text!.trimmingCharacters(in: .whitespaces).count < 6 {
//            self.showToast(message: "Please enter valid mobile number")
//            return false
//        }else if messageTextView.text!.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showToast(message: "Please enter your message")
//            return false
//        }else if isTermCond == false {
//            self.showToast(message: "Please accept terms and conditions")
        if messageTextView.text!.trimmingCharacters(in: .whitespaces).count == 0 {
        self.showToast(message: "Please enter your message")
        //return false
            self.loaderRequest.isHidden = true
            return false
        }
        return true
    }
    
    func rechargeCoinsPopPop(){
         self.loaderRequest.isHidden = true
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
        self.addChild(popOverVC)
        popOverVC.delegate = self
        popOverVC.isComingFrom = "private_video_call"
        // popOverVC.coins = Int(100)
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
   // func rechargeCoinsPopPop()
     func butnBookNowClicked() {
         loaderRequest.startAnimating()
         loaderRequest.isHidden = false
         if checkValidation(){
             if Reachability.isConnectedToNetwork()
             {
                
                 if CustomerDetails.coins == 0 {
                     //rechareAlert()
                     rechargeCoinsPopPop()
                   
                 } else if CustomerDetails.coins ?? 0  < (atristConfigCoins.privateVideoCall?.coins ?? 1) {
                     // rechareAlert()
                     rechargeCoinsPopPop()
                     
                 }else{
                     self.overlayView.showOverlay(view: self.view)
                    
                    var dict = [String:Any]()


                            guard let duration = selectedRateCard else {
                                       
                                       return
                                   }
                    let strDate = selectedDate.toString(to: .yyyyMMdd)
                                     
                    
                    if self.selectedLanguage == nil
                     {
                        dict = ["email": CustomerDetails.customerData.email as Any, "message": messageTextView.text!,"date": strDate, "duration": duration,"time": selectedSlot!, "artist_id": Constants.CELEB_ID ] as [String : Any]
                         
                         if let mobileNumber = CustomerDetails.customerData.mobile, mobileNumber.count > 0 {
                             let countryCode = CustomerDetails.customerData.countryCode
                             dict["mobile_code"] = countryCode
                             dict["mobile"] = mobileNumber
                         }
                     }else{
                        dict = ["email": CustomerDetails.customerData.email as Any, "message": messageTextView.text!,"date": strDate, "duration": duration,"time": selectedSlot!,"language": self.txtLanguageSelection.text!, "artist_id": Constants.CELEB_ID ] as [String : Any]
                         
                         if let mobileNumber = CustomerDetails.customerData.mobile, mobileNumber.count > 0 {
                             let countryCode = CustomerDetails.customerData.countryCode
                             dict["mobile_code"] = countryCode
                             dict["mobile"] = mobileNumber
                         }
                         
                     }
                     
                     print(dict)
                     ServerManager.sharedInstance().postRequest(postData: dict, apiName: Constants.videoCallRequest, extraHeader: nil, closure: { (result) in
                         switch result {
                         case .success(let data):
                             print(data)
                             self.stopLoader()
                             if(data["error"] as? Bool == true){
                                 //                                self.stopLoader()
                                 self.overlayView.hideOverlayView()
                                // self.showToast(message: "The mobile field is required.")
                                 self.showToast(message: "Something went wrong. Please try again!")
                                 //                                    CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason: "Something went wrong. Please try again!", extraParamDict: nil)
                                 return
                                 
                             } else {
                                 
                                 self.messageTextView.text = " "
                                self.loaderRequest.isHidden = true
                                 
                                 self.overlayView.hideOverlayView()
                                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoCallBookingStatusViewController")  as? VideoCallBookingStatusViewController
                                 self.overlayView.hideOverlayView()
                                 // vc?.strVideoCAllBookingID = self.VideoCAllBookingID
                                 let jsonObject = data
                                 vc!.Details = jsonObject
                                 self.navigationController?.pushViewController(vc!, animated: true)
                             }
                         case .failure(let error):
                             //                            self.stopLoader()
                             self.overlayView.hideOverlayView()
                             
                             CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                             self.showToast(message: "Something went wrong. Please try again!")
                             print(error)
                         }
                     })
                 }
             }else {
                 self.showToast(message: Constants.NO_Internet_MSG)
                 
                 CustomMoEngage.shared.sendEventSignUpLogin(eventType: .updateprofile, status: "Failed", reason:  Constants.NO_Internet_MSG, extraParamDict: nil)
                 self.showToast(message: "No Internet Connection")
                 
             }
         }
         
     }
    
    
}


