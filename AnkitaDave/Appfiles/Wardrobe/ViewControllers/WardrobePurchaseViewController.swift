//
//  WardrobePurchaseViewController.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 23/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit
import AVKit

class WardrobePurchaseViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgProductView: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var imgOutOfStock: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtName: UITextField!
//    @IBOutlet weak var txtAddress: UITextField!
//    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var txtContry: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgHomeImage: UIImageView!
    @IBOutlet weak var imgWorkImage: UIImageView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var btnGiftWrap: UIButton!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var imgGiftWrapImage: UIImageView!
    @IBOutlet weak var lblDeliveryNote: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var deliveryNoteHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var mediaPageControl: UIPageControl!
    
    // MARK: - Properties
    fileprivate let playerController = AVPlayerViewController()
    fileprivate let orderPlacedView = OrderPlacedView.instanceFromNib()
    fileprivate var requestParameters: [String: Any] = [String: Any]()
    fileprivate var place: String = "home"
    fileprivate var arrMediaList: [Media] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    fileprivate var picker = UIPickerView()
    var arrCountries = [[String: String]]()

    var productData: ProductList?
    var isProductPurchased: Bool = false
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let outofstock = productData?.outofstock, outofstock == "no" {
            let colors = [hexStringToUIColor(hex: "F6AE7B"), hexStringToUIColor(hex: "E77C2D")]
            btnBuyNow.setGradientBackground(color: colors)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if !isProductPurchased {
            if let coins = productData?.coins {
                CustomMoEngage.shared.sendEventWardrobePurchase(coins: coins,
                                                                status: "Cancelled",
                                                                reason: "User pressed back button")
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func selectPlace(_ sender: UIButton) {
        
        if sender.isEqual(btnHome) {
            imgHomeImage.image = #imageLiteral(resourceName: "radioSelected")
            imgWorkImage.image = #imageLiteral(resourceName: "radioUnSelected")
            place = "home"
        } else {
            imgHomeImage.image = #imageLiteral(resourceName: "radioUnSelected")
            imgWorkImage.image = #imageLiteral(resourceName: "radioSelected")
            place = "work"
        }
    }
    
    @IBAction func selectGiftWrap(_ sender: UIButton) {
        imgGiftWrapImage.image = imgGiftWrapImage.image == #imageLiteral(resourceName: "checkboxUnSelected") ? #imageLiteral(resourceName: "checkboxSelected") : #imageLiteral(resourceName: "checkboxUnSelected")
    }
    
    @IBAction func didTapBuyNow(_ sender: UIButton) {
        
        if !self.checkIsUserLoggedIn() {
            self.loginPopPop()
            return
        }
        
        if let coins = productData?.coins {
            if !isBalanceAvailable(coins) {
                rechargeCoinsPopUp(cost: coins)
                return
            }
        }
        
        if validateData() {
            didCallPlaceOrderAPI()
        }
    }
    
    @IBAction func didTapTermsAndConditions(_ sender: UIButton) {
        
        let termeAndConditionsVC = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
        termeAndConditionsVC.navigationTitle = "Terms & Conditions"
        termeAndConditionsVC.openUrl = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ?? ""
        
        self.navigationController?.pushViewController(termeAndConditionsVC, animated: true)
    }
    
    @IBAction func didTapOpenMedia(_ sender: UIButton) {
        
        UIView.transition(with: self.mediaView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.mediaView.alpha = 1
        })
    }
    
    @IBAction func didTapCloseMedia(_ sender: UIButton) {
        
        UIView.transition(with: self.mediaView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.mediaView.alpha = 0
            self.collectionView.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
        })
    }
}

// MARK: - Custom Methods
extension WardrobePurchaseViewController {
    
    fileprivate func setupView() {
        
//        view.removeGradient()
        
        if let aCountries = NSArray(contentsOfFile: utility.application("countries.plist")) {
            arrCountries = aCountries as? [[String: String]] ?? []
        }
        
        let colors = [hexStringToUIColor(hex: "F6AE7B"), hexStringToUIColor(hex: "E77C2D")]
        imgProductView.setGradientBackground(color: colors)
        
        txtContry.tintColor = UIColor.clear
        txtContry.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        
        orderPlacedView.delegate = self
        setUpCollectionView()
        
        if let media = productData?.media, media.count > 0 {
            if let img = media[0].url, let url = URL(string: img) {
                imgProduct.sd_setImage(with: url, completed: nil)
            }
        }
        
        if let name = productData?.name {
            lblProductName.text = name
            self.title = name
        }
        
        if let coins = productData?.coins {
            lblCoin.text = "\(coins)"
        }
        
        if let description = productData?.description {
            if description == "" || description == " " {
                descriptionView.layer.shadowColor = UIColor.clear.cgColor
                descriptionTopConstraint.constant = 0
                descriptionBottomConstraint.constant = 0
            } else {
                lblDescription.text = description
            }
        } else {
            descriptionView.layer.shadowColor = UIColor.clear.cgColor
            descriptionTopConstraint.constant = 0
            descriptionBottomConstraint.constant = 0
        }
        
        if let media = productData?.media {
            arrMediaList = media
            pageControl.numberOfPages = media.count
            mediaPageControl.numberOfPages = media.count
        }
        
        if let outofstock = productData?.outofstock, outofstock == "yes" {
            txtName.isUserInteractionEnabled = false
//            txtAddress.isUserInteractionEnabled = false
//            txtPincode.isUserInteractionEnabled = false
            txtContry.isUserInteractionEnabled = false
            txtPhone.isUserInteractionEnabled = false
            txtEmail.isUserInteractionEnabled = false
            btnHome.isUserInteractionEnabled = false
            btnWork.isUserInteractionEnabled = false
            btnGiftWrap.isUserInteractionEnabled = false
            btnBuyNow.isUserInteractionEnabled = false
            imgOutOfStock.isHidden = false
            
            btnBuyNow.backgroundColor = .lightGray
            btnBuyNow.setTitle("SOLD OUT", for: .normal)
            btnBuyNow.removeGradient()
        } else {
            btnBuyNow.setGradientBackground(color: colors)
        }
        
        if CustomerDetails.firstName != nil && CustomerDetails.firstName != ""{
            if CustomerDetails.lastName != nil  && CustomerDetails.lastName != "" {
                self.txtName.text = CustomerDetails.firstName! + " " + CustomerDetails.lastName
            } else {
                self.txtName.text = CustomerDetails.firstName!
            }
        }
        
        if CustomerDetails.email != nil {
            self.txtEmail.text = CustomerDetails.email!
        }
        
        if CustomerDetails.mobileNumber != nil {
            self.txtPhone.text = CustomerDetails.mobileNumber!
        }

        var deliveryNote = RCValues.sharedInstance.string(forKey: .messageWardrobeDeliveryNoteIos)
        
        if deliveryNote == "" {
            deliveryNote = "Item collection from Mumbai or can be couriered on Freight.\n\nDomestic - We deliver items in 3 to 4 days\n\nInternational - We deliver item in 15 working days\n\nDelivery at Home - Timing 7pm-9pm-Mon-Sat\n\nOffice - Timings 10am-5pm Mon-Sat"
        }
        
        let height = deliveryNote.height(width: UIScreen.main.bounds.size.width - 46, font: UIFont.systemFont(ofSize: 20))

       // lblDeliveryNote.text = deliveryNote
         lblDeliveryNote.text = deliveryNote.replacingOccurrences(of: "\\n", with: "\n")

        deliveryNoteHeightConstraint.constant = height
    }
    
    fileprivate func setUpCollectionView() {
        collectionView.registerNib(withCell: MediaCollectionViewCell.self)
    }
    
    fileprivate func validateData() -> Bool {
        
        guard let name = txtName.text, name.isNotEmpty else {
            DispatchQueue.main.async {
                self.showToast(message: "Please enter name")
                self.txtName.becomeFirstResponder()
            }
            return false
        }
        
        guard name.count > 3 else {
            DispatchQueue.main.async {
                self.showToast(message: "Please enter valid name")
                self.txtName.becomeFirstResponder()
            }
            return false
        }
        
//        guard let address = txtAddress.text, address.isNotEmpty else {
//            DispatchQueue.main.async {
//                self.showToast(message: "Please enter address")
//                self.txtAddress.becomeFirstResponder()
//            }
//            return false
//        }
//
//        guard let pincode = txtPincode.text, pincode.isNotEmpty else {
//            DispatchQueue.main.async {
//                self.showToast(message: "Please enter pincode")
//                self.txtPincode.becomeFirstResponder()
//            }
//            return false
//        }
        
        guard let phone = txtPhone.text, phone.isNotEmpty else {
            DispatchQueue.main.async {
                self.showToast(message: "Please enter phone number")
                self.txtPhone.becomeFirstResponder()
            }
            return false
        }
        
        guard let email = txtEmail.text, email.isNotEmpty else {
            DispatchQueue.main.async {
                self.showToast(message: "Please enter email")
                self.txtEmail.becomeFirstResponder()
            }
            return false
        }
        
        guard email.isValidEmail else {
            DispatchQueue.main.async {
                self.showToast(message: "Please enter valid email address")
                self.txtEmail.becomeFirstResponder()
            }
            return false
        }
        
        requestParameters = ["delivery_name": name,
//                             "delivery_address": address,
//                             "delivery_pincode": pincode,
                             "delivery_mobile": phone,
                             "delivery_email": email]
//                             "delivery_place": place]
        
        if let id = productData?._id {
            requestParameters["product_id"] = id
        }
        
        if let ip = utility.getIPAddress() {
            requestParameters["ip"] = ip
        }
        
        return true
    }
    
    fileprivate func inAppHandleUpdateCoins(coins: Int?) {
        
        if let updatedCoins = coins {
            CustomerDetails.coins = updatedCoins
            let coinDict:[String: Int] = ["updatedCoins": updatedCoins]
            DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins)
            CustomMoEngage.shared.updateMoEngageCoinAttribute()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: coinDict)
        }
    }
    
    fileprivate func playVideoInAVPlayerController(urlStr: String) {
        
        guard let url = URL(string: urlStr) else { return }
        
        let avPlayer = AVPlayer(url: url)
        playerController.player = avPlayer
        playerController.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(WardrobePurchaseViewController.didFinishPlaying(info:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
       
        self.present(playerController, animated: true) {
            self.playerController.player?.play()
        }
    }
    
    fileprivate func isBalanceAvailable(_ coins:  Int) -> Bool {
        return CustomerDetails.coins >= coins ? true : false
    }
    
    fileprivate func rechargeCoinsPopUp(cost: Int) {
       
        let popOverVC = Storyboard.main.instantiateViewController(viewController: PurchaseContentViewController.self)
        self.addChild(popOverVC)
        popOverVC.isComingFrom = "Wardrobe"
        popOverVC.coins = cost
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    @objc fileprivate func didTapPlayButton(_ sender: UIButton) {
    
        if let url = arrMediaList[sender.tag].url {
            playVideoInAVPlayerController(urlStr: url)
        }
    }
    
    @objc func didFinishPlaying(info: NSNotification) {
        playerController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Web Services
extension WardrobePurchaseViewController {
    
    fileprivate func didCallPlaceOrderAPI() {
        
        WebServiceHelper.shared.callPostMethod(endPoint: Constants.productPurchase, parameters: requestParameters, responseType: ProductPurchaseResponseModel.self, showLoader: true, httpHeaders: nil) { [weak self] (response, error) in
            
            if let purchaseData = response?.data?.purchase {
                
                if response?.error == false {
                    self?.inAppHandleUpdateCoins(coins: purchaseData.coins_after_txn)
                    UIView.transition(with: self?.view ?? UIView(),
                                      duration: 0.25,
                                      options: UIView.AnimationOptions.transitionCrossDissolve,
                                      animations: { self?.view.addSubview(self?.orderPlacedView ?? UIView()) },
                                      completion: nil)
                }
            } else if (response?.error ?? false) {
                if let messages = response?.error_messages, messages.count > 0 {
                    Alert.show(in: self, title: "", message: messages[0], cancelTitle: nil, comletionForAction: nil)
                }
            } else {
                Alert.show(in: self, title: "", message: "Something went wrong.", cancelTitle: nil, comletionForAction: nil)
            }
        }
    }
}

// MARK: - CollectionView Delegte & DataSource Methods
extension WardrobePurchaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrMediaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as! MediaCollectionViewCell
        
        cell.configurCell(media: arrMediaList[indexPath.row])
        
        cell.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(didTapPlayButton(_:)), for: .touchUpInside)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       let visibleRect = CGRect(origin: collectionView.contentOffset, size: self.collectionView.bounds.size)
       let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
       if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
            mediaPageControl.currentPage = visibleIndexPath.row
       }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        mediaPageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
}

// MARK: - UITextFieldDelegate
extension WardrobePurchaseViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPhone {
            return string.isEmpty || Int(string) != nil
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var index = 0
        switch textField {
        case txtContry:
            if let txt = txtContry.text {
                if getCodeIndex().contains(txt) {
                    index = getCodeIndex().index(of: txt) ?? 0
                }
                break
            }
            
        default:
            break
        }
        picker.reloadAllComponents()
        picker.selectRow(index, inComponent: 0, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let row = picker.selectedRow(inComponent: 0)
        switch textField {
        case txtContry:
            if arrCountries.count > 0 {
                txtContry.text = arrCountries[row]["dial_code"] ?? ""
            }
            break
        default:
            break
        }
    }
    
    func getCodeIndex() -> [String] {
        return arrCountries.map({$0["dial_code"] ?? ""})
    }
}

// MARK: - UIPickerViewDataSource
extension WardrobePurchaseViewController: UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCountries.count
    }
}

// MARK: - UIPickerViewDelegate
extension WardrobePurchaseViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCountries[row]["dial_code"] ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arrCountries.count > 0 {
            txtContry.text = arrCountries[row]["dial_code"] ?? ""
        }
    }
}

// MARK: - OrderPlacedViewDelegate
extension WardrobePurchaseViewController: OrderPlacedViewDelegate {
    
    func orderPlaced() {
        isProductPurchased = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "outOfStock"), object: nil, userInfo: nil)
        self.navigationController?.popViewController(animated: false)
    }
}

// MARK: - AVPlayerViewControllerDelegate
extension WardrobePurchaseViewController: AVPlayerViewControllerDelegate {}
