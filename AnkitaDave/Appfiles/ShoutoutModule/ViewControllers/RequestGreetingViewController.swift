//
//  RquestGreetingViewController.swift
//  VideoGreetings
//
//  Created by Apple on 04/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit
import SDWebImage
import CountryPickerView
import IQKeyboardManagerSwift

import CoreSpotlight
import MobileCoreServices
import SafariServices


class RequestGreetingViewController: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    fileprivate var selectedDate: Date?
    fileprivate var occasions: [Occasion] = [] {
        didSet {
            reasonPicker.reloadAllComponents()
        }
    }
    fileprivate var shouldEnableRequest: Bool = false {
        didSet {
            if shouldEnableRequest {
                requestButton.isEnabled = true
                requestButton.backgroundColor = #colorLiteral(red: 0.9109638929, green: 0.05280861259, blue: 0, alpha: 1)
            } else {
                requestButton.isEnabled = false
                requestButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
    }
    fileprivate var reasonPicker = UIPickerView()
    fileprivate var relationPicker = UIPickerView()
    fileprivate var countryPicker = CountryPickerView()
    fileprivate var messageTolTip: EasyTipView?
   fileprivate let messagePlaceholder: String = "Ex:I Want You To Wish Me On My Birthday!"
      fileprivate let messageInfoText: String = "Please be concise while writing your message as it will help your favourite celebrity to respond better."

    
    // MARK: - IBOutlets.
    @IBOutlet weak var messageInfoButton: UIButton!
   // @IBOutlet weak var occasionTitleLabel: UILabel!
//    @IBOutlet weak var dateTitleLabel: UILabel!
   // @IBOutlet weak var toTitleLabel: UILabel!
  //  @IBOutlet weak var forTitleLabel: UILabel!
    @IBOutlet weak var messageTitleLabel: UILabel!
   // @IBOutlet weak var fromTitleLabel: UILabel!
    @IBOutlet weak var tAndCButton: UIButton!
    @IBOutlet weak var rechargeInstructionLabel: UILabel!
    @IBOutlet weak var rechargeButton: UIButton!
  //  @IBOutlet weak var reasonLabel: UILabel!
   // @IBOutlet weak var reasonImageView: UIImageView!
   // @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    //@IBOutlet weak var toTextField: UITextField!
  //  @IBOutlet weak var greetingForTextField: UITextField!
   // @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var numberOfCharInMessage: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var mobileNumberTextfield: UITextField!
  //  @IBOutlet weak var mobileNumberInstruction: UILabel!
    @IBOutlet weak var rechargeNowView: UIView!
    @IBOutlet weak var makePrivateCheckbox: UIButton!
    @IBOutlet weak var makePrivateLabel: UILabel!
    //@IBOutlet weak var otherOccasionTextField: UITextField!
   // @IBOutlet weak var otherOccasionTitleLabel: UILabel!
//    @IBOutlet weak var dateViewTopConstraint: NSLayoutConstraint! // Intial constant = 50.
//    @IBOutlet weak var charityLabel: UILabel!
    @IBOutlet weak var dateInfoLabel: UILabel!
    @IBOutlet weak var requestButtonTitleLabel: UILabel!
    var projects:[[String]] = []

    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        IQKeyboardManager.shared.enableAutoToolbar = true
        setupView()
        setupUIProperties()
        didFetchOccasions()
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        requestButton.centerImageAndTitleVertically()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        messageTolTip?.dismiss()
        if  CustomMoEngage.Celebye == true {
                       
                   }else{
                         CustomMoEngage.shared.sendEventCelebytePurchase(coins: ShoutoutConfig.coinsToRequestVG, status: "Cancelled", reason: "User pressed back button")
                   }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rechargeNowView.isHidden = ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG
    }
    
    // MARK: - IBActions.
    @IBAction func didTapTermsAndConditions(_ sender: UIButton) {
        ShoutoutConfig.InAppNavigation.toTermsAndCondition(inViewController: self)
    }
    
    @IBAction func didTapCheckbox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        shouldEnableRequest = sender.isSelected
    }
    
    @IBAction func didTapRequest(_ sender: UIButton) {
        if let validationError = validateInputForm() {
            // Validation fail.
            Alert.show(in: self, title: "", message: validationError, cancelTitle: nil, comletionForAction: nil)
        } else {
            // Validation success.
            sendToProceedToPay()
        }
    }
    
    @IBAction func didTapRechargeNow(_ sender: UIButton) {
        ShoutoutConfig.InAppNavigation.toPurchaseCoin(inViewController: self)
    }
    
    @IBAction func didTapMakeVideoPrivate(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
        projects.append( [String (messageInfoText)] )
        index(item: 0)
        let view = EasyTipView(text: messageInfoText, preferences: preferences)
        if let toolTipView = messageTolTip {
            messageTolTip = nil
            toolTipView.dismiss()
        } else {
            messageTolTip = view
            view.show(forView: sender, withinSuperview: self.navigationController?.view!)
        }
    }
}

// MARK: - Custom Methods.
extension RequestGreetingViewController {
    fileprivate func setupView() {
        title = "Request for video message"
        self.requestButton.cornerRadius = 5
        [ mobileNumberTextfield,dateTextField].forEach { (textField) in
            textField?.delegate = self
        }
        
        if CustomerDetails.mobileNumber  == "" {
            let mobNo = self.mobileNumberTextfield.text
            self.mobileNumberTextfield.text = mobNo
        } else {
            self.mobileNumberTextfield.text = CustomerDetails.mobileNumber
        }
        
        self.requestButtonTitleLabel.text = "REQUEST NOW @\(ShoutoutConfig.coinsToRequestVG)"
        projects.append( [String (self.requestButtonTitleLabel.text ?? "")] )
         projects.append( [String ("REQUEST NOW @\(ShoutoutConfig.coinsToRequestVG)")] )
        index(item: 0)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        datePicker.locale = Locale(identifier: "en_IN")
        datePicker.addTarget(self, action: #selector(didSelectDate), for: .valueChanged)
        dateTextField.inputView = datePicker
        reasonPicker.delegate = self
        reasonPicker.dataSource = self
        relationPicker.delegate = self
        relationPicker.dataSource = self
        
        
        
        let emptyLeftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 65.0, height: 40.0))
        emptyLeftView.backgroundColor = .clear
        
        
        // Default date as current date.
        dayLabel.textColor = .lightGray
        monthLabel.textColor = .lightGray
        yearLabel.textColor = .lightGray
        
        dayLabel.text = Date().toString(to: .dd)
        monthLabel.text = Date().toString(to: .MMMM)
        yearLabel.text = Date().toString(to: .yyyy)
         projects.append( [String (dayLabel.text ?? "")] )
         projects.append( [String (monthLabel.text ?? "")] )
         projects.append( [String (yearLabel.text ?? "")] )
        index(item: 0)

        checkboxButton.isSelected = false
        //shouldEnableRequest = false
        
        makePrivateCheckbox.isSelected = false
        
        messageTextView.text = messagePlaceholder
        messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate = self
        
        requestButton.centerImageAndTitleVertically()
        
        // Country Picker.
        countryPicker.showCountryCodeInView = true
        countryPicker.font = ShoutoutFont.regular.withSize(size: .medium)
        countryPicker.flagSpacingInView = 2.0
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        let countryPickerContainer = UIView()
        let separator = UIView()
        
        separator.backgroundColor = UIColor.black
        countryPickerContainer.addSubview(separator)
        countryPickerContainer.addSubview(countryPicker)
        
        // UITextField LeftView issue fix for iOS 13.0
        if #available(iOS 13.0, *) {
            countryPickerContainer.translatesAutoresizingMaskIntoConstraints = false
            separator.translatesAutoresizingMaskIntoConstraints = false
            countryPicker.translatesAutoresizingMaskIntoConstraints = false
            
            countryPickerContainer.widthAnchor.constraint(equalToConstant: 108.0).isActive = true
            countryPickerContainer.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            
            countryPicker.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
            countryPicker.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            countryPicker.leadingAnchor.constraint(equalTo: countryPickerContainer.leadingAnchor, constant: 10.0).isActive = true
            countryPicker.centerYAnchor.constraint(equalTo: countryPickerContainer.centerYAnchor).isActive = true
            
            separator.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
            separator.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            separator.centerYAnchor.constraint(equalTo: countryPickerContainer.centerYAnchor).isActive = true
            separator.trailingAnchor.constraint(equalTo: countryPickerContainer.trailingAnchor, constant: -1.0).isActive = true
            
        } else {
            // Fallback on earlier versions.
            // LeftView frame works as expected on earlier versions.
            countryPickerContainer.frame = CGRect(x: 0.0, y: 0.0, width: 108.0, height: 50.0)
            separator.frame = CGRect(x: countryPickerContainer.frame.width - 1.0, y: 5.0, width: 1.0, height: countryPickerContainer.frame.height - 10.0)
            countryPicker.frame = CGRect(x: 10.0, y: 0.0, width: 90, height: 50.0)
        }
        
        mobileNumberTextfield.leftView = countryPickerContainer
        mobileNumberTextfield.leftViewMode = .always
        
        rechargeNowView.isHidden = ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG
         projects.append( [ ("Request for Greeting")] )
         projects.append( [String (mobileNumberTextfield.text ?? "")] )
         projects.append( [String (messageTextView.text ?? "")] )
         projects.append( [String (ShoutoutConfig.nameOfUser)] )
         projects.append( [String (dayLabel.text ?? "")] )
         projects.append( [String (monthLabel.text ?? "")] )
         projects.append( [String (yearLabel.text ?? "")] )
         projects.append( [String ((ShoutoutConfig.isShoutoutForCharity ? "Your contribution will go to " + ShoutoutConfig.charityDescription : nil) ?? "")] )
        index(item: 0)
        
    }
    
    fileprivate func setupUIProperties() {
        view.setGradientBackground()
        [ messageTitleLabel, mobileNumberLabel].forEach { (label) in
            label?.font = ShoutoutFont.light.withSize(size: .small)
            label?.textColor = .white//UIColor.black
        }
        
        rechargeInstructionLabel.font = ShoutoutFont.light.withSize(size: .small)
        
        [dayLabel, monthLabel, yearLabel]
            .forEach { (label) in
                label?.font = ShoutoutFont.regular.withSize(size: .medium)
        }
        
        [numberOfCharInMessage, dateInfoLabel].forEach { (label) in
            label?.font = ShoutoutFont.light.withSize(size: .smaller)
            label?.textColor = .white//UIColor.black
        }
        
        monthLabel.adjustsFontSizeToFitWidth = true
        
        [mobileNumberTextfield].forEach { (textField) in
            textField?.font = ShoutoutFont.regular.withSize(size: .medium)
            textField?.borderWidth = 0.5
            textField?.borderColor = UIColor.gray
        }
        
        messageTextView.borderWidth = 0.5
        messageTextView.borderColor = UIColor.gray
        
        messageInfoButton.tintColor = UIColor.white
        
        tAndCButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .medium)
        makePrivateLabel.font = ShoutoutFont.regular.withSize(size: .medium)
        makePrivateLabel.textColor = .white
        
        requestButton.titleLabel?.font = ShoutoutFont.medium.withSize(size: .small)
        requestButtonTitleLabel.font = ShoutoutFont.medium.withSize(size: .small)
        rechargeButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .medium)
    }
    
    @objc fileprivate func didSelectDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
        
        dayLabel.textColor = .black
        monthLabel.textColor = .black
        yearLabel.textColor = .black
        
        dayLabel.text = sender.date.toString(to: .dd)
        monthLabel.text = sender.date.toString(to: .MMMM)
        yearLabel.text = sender.date.toString(to: .yyyy)
        projects.append( [String (dayLabel.text ?? "")] )
        projects.append( [String (monthLabel.text ?? "")] )
        projects.append( [String (yearLabel.text ?? "")] )
        index(item: 0)
    }
//
//    fileprivate func validateInputForm() -> String? {
//
//       if messageTextView.text == messagePlaceholder {
//        projects.append( [String (messageTextView.text ?? "")] )
//        index(item: 0)
//           return ValidationError.greetingMessage
//       }
//        if selectedDate == nil {
//                   return ValidationError.date
//               }
//        if checkboxButton.isSelected {
//
//        } else {
//           return ValidationError.tAndCMessage
//        }
//
//        if let mobileNumber = mobileNumberTextfield.text, mobileNumber.count > 0 && mobileNumber.count < ShoutoutConstants.charLimitForMobileNumber {
//            return ValidationError.invalidMobileNumber
//        }
//
//        return nil
//    }
//
//    fileprivate func toggleOtherOccasion(show: Bool) {
//
//    }
    
    fileprivate func validateInputForm() -> String? {
         
        if messageTextView.text == messagePlaceholder {
            return ValidationError.greetingMessage
        }
         if selectedDate == nil {
                    return ValidationError.date
                }
         if mobileNumberTextfield.text!.trimmingCharacters(in: .whitespaces).count == 0 {
             
             return ValidationError.enterMobileNumber
         }else if mobileNumberTextfield.text!.trimmingCharacters(in: .whitespaces).count < 6 {
             return ValidationError.invalidMobileNumber
            }
         if checkboxButton.isSelected {
             
         }else{
            return ValidationError.tAndCMessage
         }
    
         return nil
     }
    
    fileprivate func toggleOtherOccasion(show: Bool) {
       
    }
}

// MARK: - Web Services.
extension RequestGreetingViewController {
    fileprivate func didFetchOccasions() {
        WebService.shared.callGetMethod(endPoint: .occassionList, parameters: nil, responseType: VGOccasionsResponseModel.self) { [weak self] (response, error) in
            
            if let occasionList = response?.data?.list {
                self?.occasions = occasionList
            }
        }
    }
    
    fileprivate func sendToProceedToPay() {
        guard let occasionId = occasions[reasonPicker.selectedRow(inComponent: 0)]._id,
            let isOtherOccasion = occasions[reasonPicker.selectedRow(inComponent: 0)].is_other,
          
            let scheduleAt = selectedDate?.toString(to: .yyyyMMdd),
            let message = messageTextView.text else { return }
        projects.append( [String (scheduleAt)] )
        projects.append( [String (message)] )
        index(item: 0)
        var parameters: [String: Any] = ["artist_id": ShoutoutConfig.artistID,
                                        "platform": ShoutoutConfig.platform,
                                        "occassion_id": occasionId,
                                        "schedule_at": scheduleAt,
                                        "message": message,
                                        "make_private": makePrivateCheckbox.isSelected,
                                        "v": ShoutoutConfig.version]
        
        if let mobileNumber = mobileNumberTextfield.text, mobileNumber.count > 0 {
            let countryCode = countryPicker.selectedCountry.phoneCode
            parameters["from_mobile_code"] = countryCode
            parameters["from_mobile"] = mobileNumber
        }
        
       
        
        let proceedToPay = Storyboard.videoGreetings.instantiateViewController(viewController: ProceedToPayViewController.self)
        proceedToPay.requestParameters = parameters
        
        
        let flag = (selectedDate?.days(from: Date()) ?? 0) >= ShoutoutConstants.recommendeDaysPriorToMakeShoutoutRequest ? false : true
        
        proceedToPay.doesSelectedDateResultInsufficientTime = flag
        
        let navController = NavigationBarUtils.setupNavigationController(rootViewController: proceedToPay)
        navController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(navController, animated: false, completion: nil)
    }
}

// MARK: - UITextField Delegate Methods.
extension RequestGreetingViewController: UITextFieldDelegate {
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
//        if textField == otherOccasionTextField {
//            if textField.text == "" || textField.text == nil {
//                dateTitleLabel.text = "Select date for occasion"
//            } else {
//                dateTitleLabel.text = "Select date for \(textField.text ?? "")"
//            }
//        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == mobileNumberTextfield), let text = textField.text {
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
           
            return textField == mobileNumberTextfield ? numberOfChars <= 15 : numberOfChars <= ShoutoutConstants.charLimitForOtherOccasion
        } else {
            
            return true
        }
    }
}

// MARK: - UITextView Delegate Methods.
extension RequestGreetingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if numberOfChars <= ShoutoutConstants.charLimitForMessageInVGRequest {
            numberOfCharInMessage.text = "\(numberOfChars)/250"
            projects.append( [String (newText )] )
            projects.append( [String (numberOfChars )] )
            projects.append( [String ("Characters \(numberOfChars)/250")] )
            projects.append( [String (numberOfCharInMessage.text  ?? "" )] )
             index(item: 0)
        }
        return numberOfChars <= ShoutoutConstants.charLimitForMessageInVGRequest
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == messagePlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
            projects.append( [String (textView.text ?? "")] )
            index(item: 0)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = messagePlaceholder
            textView.textColor = UIColor.lightGray
            projects.append( [String (textView.text ?? "")] )
            index(item: 0)
        }
    }
}

extension RequestGreetingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == reasonPicker ? occasions.count : ShoutoutConstants.relationships.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let cellView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 35.0))
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = ShoutoutFont.regular.withSize(size: .large)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if pickerView == reasonPicker {
            let iconView = UIImageView()
            iconView.contentMode = .scaleAspectFit
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            iconView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            
            stackView.addArrangedSubview(iconView)
            
            if let iconURL = occasions[row].photo?.thumb {
                iconView.sd_setImage(with: URL(string: iconURL), completed: nil)
                iconView.backgroundColor = nil
            } else {
                iconView.backgroundColor = .lightGray
            }
            titleLabel.text = occasions[row].name
            
            stackView.alignment = .center
        }
        
        if pickerView == relationPicker {
            stackView.alignment = .center
            titleLabel.text = ShoutoutConstants.relationships[row]
        }
        
        stackView.addArrangedSubview(titleLabel)
        cellView.addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        stackView.distribution = .fill
        
        stackView.centerXAnchor.constraint(equalTo: cellView.centerXAnchor, constant: 0.0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 0.0).isActive = true
        stackView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.7, constant: 0.0).isActive = true
        
        return cellView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == reasonPicker, row < occasions.count {
           projects.append( [String (occasions[row].name ?? "")] )
//            let dateInstructForOccasion: String = (occasions[row].is_other ?? false) ? "Select date for occasion" : "Select date for \(occasions[row].name ?? "")"
//            dateTitleLabel.text = dateInstructForOccasion
            
            let shouldToggleOtherOccasion = occasions[row].is_other ?? false
            toggleOtherOccasion(show: shouldToggleOtherOccasion)
        }
        
        if pickerView == relationPicker, row < ShoutoutConstants.relationships.count  {
           
        }
    }
}

// MARK: - CountryPickerView DataSource and Delegate.
extension RequestGreetingViewController: CountryPickerViewDataSource, CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select your country"
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .hidden
    }
}

extension RequestGreetingViewController: UIScrollViewDelegate, EasyTipViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let toolTip = messageTolTip {
            toolTip.dismiss()
        }
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        messageTolTip = nil
    }
}

extension RequestGreetingViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let toolTip = messageTolTip {
            toolTip.dismiss()
        }
    }
}

// MARK: - Custom Methods.
extension RequestGreetingViewController {
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



