//
//  DirectLinkViewController.swift
//  Shweta Pal
//
//  Created by Rohit Mac Book on 06/02/20.
//  Copyright © 2020 ArmsprimeMedia. All rights reserved.
//

import UIKit
import CoreServices
import SKPhotoBrowser
import PopItUp
import ActiveLabel

class ChatReceiverTableCell: UITableViewCell {
    
    @IBOutlet weak var lblChat: ActiveLabel!
    @IBOutlet weak var imgViewBubble: UIImageView!
    @IBOutlet weak var imgViewProfilePic: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var imgViewState: UIImageView!
    @IBOutlet weak var imgViewChoch: UIImageView!
}

class ChatSenderTableCell: UITableViewCell {
    
    @IBOutlet weak var lblChat: ActiveLabel!
    @IBOutlet weak var imgViewBubble: UIImageView!
    @IBOutlet weak var imgViewProfilePic: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var imgViewState: UIImageView!
    @IBOutlet weak var imgViewChoch: UIImageView!
    @IBOutlet weak var imgViewSticker: UIImageView!
    @IBOutlet weak var cnstStickerWidth: NSLayoutConstraint!
    @IBOutlet weak var cnstStickerHeight: NSLayoutConstraint!
}

class ChatStatusTableCell: UITableViewCell {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    override func layoutSubviews() {
        
        DispatchQueue.main.async { [weak self] in
            
            if let obj = self {
                
                obj.viewContainer.layer.cornerRadius = obj.viewContainer.frame.size.height/2
                obj.viewContainer.layer.masksToBounds = true
            }
        }
    }
}

class DirectLinkViewController: BaseViewController, UITextViewDelegate,PurchaseContentProtocol {
    func contentPurchaseSuccessful(index: Int, contentId: String?) {
        
    }

    @IBOutlet weak var caracterView: UIView!
    @IBOutlet weak var caraterLimitLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var CommentTextHorizontalView: UICollectionView!
    @IBOutlet weak var cnstTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var viewTextViewComment: PHCommentTextView!

    var selectedIndexVal: Int!
    var commentTextArrayData = ["Hey Hottie!!","Beautiful Woman!","Yo Womaniya!","Chalti kya 9 se 12","Come to me Baby","Janeman tum to maar hi dalogi","You're in my"]
    
    var arrChats = [ChatMessageModel]()
    
    var strStatus: String? = nil
    
    var apiCallStatus = (shouldShowLoader:true, shouldShowNotFound:false, isCalling:false, page:1, isLoadMore: false)
    
    var refreshControlTable:UIRefreshControl? = nil
    
    var maxCharCount = 500
    var msgCoins = 199
    
    var chatRoom: ChatRoomMessageModel? = nil
    
    enum messageType: String {
        
        case text = "text"
        case photo = "photo"
        case gift = "gift"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.setProfileImageOnBarButton()
        setLayoutAndDesign()
        
        //        maxCharCount = Int(artistConfig.directLine?.message_length ?? 500)
        
        //        commentTextView.font = UIFont.systemFont(ofSize: 14)
        //        commentTextView.keyboardDistanceFromTextField = 20
        //        commentTextView.maxHeight = 100
        //        //commentTextView.placeholder = "Send me a message"
        //        commentTextView.textColor = UIColor.black
        //        commentTextView.maxCharCount = maxCharCount
        //        commentTextView.delegateGrowing = self
        //        commentTextView.keyboardDismissMode = .interactive
        
        //        self.caraterLimitLabel.text = "0/\(maxCharCount)"
        
        msgCoins = Int(artistConfig.directLine?.coins ?? 199)
        
        //        lblCoins.text = "\(msgCoins)"
        
        //        commentTextView.autocorrectionType = .no
        //        commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentcell")
        //        self.commentBackgroundView.layer.cornerRadius = commentBackgroundView.layer.frame.height / 2
        //        self.commentBackgroundView.layer.borderWidth = 0.5
        //        self.commentBackgroundView.layer.borderColor = UIColor.black.cgColor
        //        self.commentBackgroundView.clipsToBounds = true
        //
        //        self.sendButtonView.layer.cornerRadius = sendButtonView.layer.frame.width / 2
        //        self.sendButtonView.clipsToBounds = true
        
        if let directline_room_id =  CustomerDetails.directline_room_id, directline_room_id.count != 0 {
            
            self.webGetChatRoomHistory()
        }
        else {
            
            print(CustomerDetails.directline_room_id ?? "\n\n\n---------No id found-----------\n\n\n")
            
            webCreateChatRoom()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationView(title: "DIRECT LINE")
        
        self.setProfileImageOnBarButton()
        if arrChats.count > 0 {
            
            apiCallStatus.shouldShowLoader = true
            apiCallStatus.shouldShowNotFound = true
            apiCallStatus.isLoadMore = false
            apiCallStatus.page = 1
            
            arrChats.removeAll()
            
            removeAllRefreshControl()
            
            commentTableView.reloadData()
            
            webGetChatRoomHistory(isRefresh: true)
        }
        
        utility.setIQKeyboardManager(false, showToolbar: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        utility.setIQKeyboardManager(true, showToolbar: true)
        if  CustomMoEngage.DirectLine == true {
                                            
                   }else{
                       
                      CustomMoEngage.shared.sendEventDirectLinePurchase(coins: Int(artistConfig.directLine?.coins ?? 199), status: "Cancelled", reason: "App has been stopped without User sending Direct Line")
                   }
    }
    
    // MARK: - IBActions
    @IBAction func SendAction(_ sender: Any) {
                
        self.view.endEditing(true)
        
        if !self.checkIsUserLoggedIn() {
              self.loginPopPop()
             return
        }
        
//        if let txt = commentTextView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), txt.count != 0 {
//
//            commentTextView.text = ""
//            self.caraterLimitLabel.text = "0/\(self.maxCharCount)"
//            webSendChatMessage(txt)
//        }
//        else {
//
//            self.showToast(message: "The message field is required")
//            return
//        }
     
    }
    func rechargeCoinsPopPop() {
         let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseContentViewController") as! PurchaseContentViewController
               self.addChild(popOverVC)
                 popOverVC.delegate = self
                 popOverVC.isComingFrom = "DirectLine"
                 popOverVC.coins = Int(msgCoins)
                 popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                 self.view.addSubview(popOverVC.view)
                 popOverVC.didMove(toParent: self)
             
  
     }
//     func commentTextHorizontal() {
//
//                self.CommentTextHorizontalView.showsHorizontalScrollIndicator = false
//                self.CommentTextHorizontalView.dataSource = self
//                self.CommentTextHorizontalView.delegate = self
//                self.CommentTextHorizontalView.isPagingEnabled = true
//                self.CommentTextHorizontalView.backgroundColor = UIColor.clear
//                self.CommentTextHorizontalView.register(UINib.init(nibName: "CommentTextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"commentTextCell" )
//        self.CommentTextHorizontalView.reloadData()
//
//    }
}

// MARK: - Utility Methods
extension DirectLinkViewController {
    
    func setLayoutAndDesign() {
                
        let viewHeader = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 10))
        viewHeader.backgroundColor = .clear
        commentTableView.tableHeaderView = viewHeader
        
//        let viewFooter = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 10))
//        viewFooter.backgroundColor = .clear
//        commentTableView.tableFooterView = viewFooter
        
        if let tabBarHeight = self.tabBarController?.tabBar.frame.size.height {
            
            viewTextViewComment.tabbarHeight = tabBarHeight
        }
        
        viewTextViewComment.tapView = commentTableView
        viewTextViewComment.delegate = self
        
        utility.setIQKeyboardManager(false, showToolbar: false)
    }
    
    func addAllRefreshControl() {
        
        if refreshControlTable == nil {
            
            refreshControlTable = UIRefreshControl()
            refreshControlTable?.tintColor = UIColor.gray
            refreshControlTable?.addTarget(self, action: #selector(loadMoreTrigerred), for: UIControl.Event.valueChanged)
            commentTableView.addSubview(refreshControlTable!)
        }
    }
    
    func stopAllRefreshControl() {
        
        if let refresh = refreshControlTable, refresh.isRefreshing {
            
            refreshControlTable?.endRefreshing()
        }
    }
    
    func removeAllRefreshControl() {
        
        refreshControlTable?.removeFromSuperview()
        refreshControlTable = nil
    }
    
    func updateDataToDatabase(cust : Customer) {
        
        let database = DatabaseManager.sharedInstance
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath  = documents + Constants.databaseName
        database.dbPath = writePath
       /* if let dbURL = GlobalFunctions.createDatabaseUrlPath() {
            database.dbPath = dbURL.path
        }*/
        database.updateCustomerData(customer: cust)
    }
    
    func scrollToBottom() {
        
        DispatchQueue.main.async {
            if self.arrChats.count != 0 {
                let indexPath = IndexPath(row: self.arrChats.count-1, section: 0)
                self.commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func isBalanceAvailable(_ price:Int) -> Bool {
        
        if CustomerDetails.coins >= price {
            
            return true
        }
        else {
            
            return false
        }
    }
    
    func updateBalanceAfterMessage(sticker: CommentSticker? = nil, isPhoto:Bool = false) {
        
        var coins = 0
        
        if isPhoto {
            
            coins = CustomerDetails.coins - msgCoins
        }
        else {
            
            if let gift = sticker {
                
                coins = CustomerDetails.coins - Int(gift.coins ?? 0)
            }
            else {
                
                coins = CustomerDetails.coins - msgCoins
            }
        }
                
        CustomerDetails.coins = coins

        DatabaseManager.sharedInstance.updateCustomerCoins(coinsValue: CustomerDetails.coins)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: nil)
    }
    
    func updateChatRoomState() {
        
        if chatRoom == nil {
            
            setChatRoomState(isEnabled: true)
        }
        else {
            
            if chatRoom?.send_message == true {
                
                setChatRoomState(isEnabled: true)
            }
            else {
                
                setChatRoomState(isEnabled: false)
            }
        }
    }
    
    func setChatRoomState(isEnabled: Bool) {
        
        viewTextViewComment.isUserInteractionEnabled = isEnabled
        
//        if isEnabled == true{
//            commentTextView.isUserInteractionEnabled = isEnabled
//            sendButton.isEnabled = isEnabled
//            sendButtonView.alpha = 1.0
//            caracterView.alpha = 1.0
//        } else {
//            commentTextView.isUserInteractionEnabled = isEnabled
//            sendButton.isEnabled = isEnabled
//            sendButtonView.alpha = 0.5
//            caracterView.alpha = 0.5
//        }
    }
    
    func showCamera() {
        
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.mediaTypes = [kUTTypeImage] as [String]
        imgPicker.sourceType = .camera
        imgPicker.cameraDevice = .front
        imgPicker.allowsEditing = false
        if #available(iOS 11.0, *) {
            imgPicker.imageExportPreset = .compatible
        } else {
            // Fallback on earlier versions
        }
        imgPicker.modalPresentationStyle = .overFullScreen
        
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func showPhotoLibrary() {
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
        
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.mediaTypes = [kUTTypeImage] as [String]
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = false
        imgPicker.modalPresentationStyle = .overFullScreen
    
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func showPhotoPreviewBeforeSending(image: UIImage) {
        
        let photoVC = Storyboard.main.instantiateViewController(viewController: DirectLinePhotoViewController.self)
        
        photoVC.image = image
        photoVC.delegate = self
                  
        self.presentedViewController?.presentPopup(photoVC, animated: true, backgroundStyle: PopupBackgroundStyle.blur(UIBlurEffect.Style.dark), constraints: [], transitioning: PopupTransition.zoom, autoDismiss: true, completion: nil)
    }
    
    func sendPhoto(image: UIImage) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let data = image.jpegData(compressionQuality: 1) {
            
            if (data.count/(1024*1024)) > 7 {
                
                self.showOnlyAlert(message: stringConstants.errorPhotoSize)
            }
            else {
                
                webSendChatPhoto(data: data)
            }
        }
        else {
            
            self.showOnlyAlert(message: stringConstants.errorPhotoIssue)
        }
    }
    
    func showPhotoPreview(photo: String, view: UIView) {
                
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(photo)
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        SKPhotoBrowserOptions.swapCloseAndDeleteButtons = true

        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images, initialPageIndex: 0)
        present(browser, animated: true, completion: {})
    }
}

// MARK: - Growing Textview Delegate Methods
extension DirectLinkViewController: PHGrowingTextViewDelegate {
    
    func didBeginEditing(textView: PHGrowingTextView) {

//        if commentTextView.text == "Send me a message" {
//           commentTextView.text = ""
//           commentTextView.textColor = UIColor.black.withAlphaComponent(1)
//
//        }
        
    }
    
    func didEndEditing(textView: PHGrowingTextView) {
        
//        if commentTextView.text == "" {
//
//           commentTextView.text = "Send me a message"
//            commentTextView.textColor = UIColor.lightGray
//        }
    }
    
    func didChangeEmptyState(textView: PHGrowingTextView, isEmpty: Bool) {
        
    }
    
    func didChangeHeight(textView: PHGrowingTextView, height: CGFloat) {
        
        print("didChangeHeight = \(height)")
        
        self.cnstTextViewHeight.constant = height

        UIView.animate(withDuration: 0.3) {
            
//            self.textView.layoutIfNeeded()
        }
    }
    
    func didChangeCount(textView:PHGrowingTextView, count: Int) {
        
        self.caraterLimitLabel.text = "\(count)/\(maxCharCount)"
    }
}

// MARK: - TableView Delegate & DataSource Methods
extension DirectLinkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !self.checkIsUserLoggedIn() {

            return 2
        }
        if arrChats.count == 0 && apiCallStatus.shouldShowNotFound {
          
            tableView.setPlaceholder(title: "No record found", detail: "")
        }
        else {
            
            tableView.backgroundView = nil
        }
        
        return arrChats.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        if !self.checkIsUserLoggedIn() {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverTableCell") as! ChatReceiverTableCell
                cell.lblChat.text = "Hey! Welcome to my Direct Line. You can send me DM here (upto 500 characters) and I will respond only to you. Just avoid bad language coz I would hate that. Let's chat!"
                let color = BlackThemeColor.lightBlack
                cell.imgViewProfilePic.layer.cornerRadius = cell.imgViewProfilePic.frame.size.height/2
                cell.imgViewProfilePic.layer.masksToBounds = true
                cell.imgViewProfilePic.layer.borderWidth = 1.5
                cell.imgViewProfilePic.layer.borderColor = UIColor.black.cgColor
                cell.imgViewBubble.backgroundColor = color
                cell.imgViewChoch.tintColor = color
                return cell
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatStatusTableCell") as! ChatStatusTableCell
                
                cell.lblStatus.text = "Max limit of 500 characters per message.While sending your requests refrain from using obscene, derogatory, insulting and offensive language. Non compliance to this will result in rejection of your request and coins/money will not be refunded."
                
                cell.viewContainer.layer.cornerRadius = cell.viewContainer.frame.size.height/2
                cell.viewContainer.layer.masksToBounds = true
                cell.viewContainer.backgroundColor = BlackThemeColor.lightBlack
                return cell
            }
        }
        else
        {
            let message = arrChats[indexPath.row]
            
            if message.system == true {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatStatusTableCell") as! ChatStatusTableCell
                
                cell.lblStatus.text = message.message
                
                cell.viewContainer.layer.cornerRadius = cell.viewContainer.frame.size.height/2
                cell.viewContainer.layer.masksToBounds = true
                cell.viewContainer.backgroundColor = BlackThemeColor.lightBlack
                                
                cell.selectionStyle = .none
                
                return cell
            }
            
            if message.message_by == "producer" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReceiverTableCell") as! ChatReceiverTableCell
                cell.lblChat.text = message.message
                cell.lblChat.enabledTypes = [.url]
                cell.lblChat.handleURLTap { (URL) in
                  print("Click URL")
                 self.showHyperLinkUrl(url: URL)
                 }

                cell.lblUsername.text = message.name?.capitalized
                cell.imgViewBubble.clipsToBounds = true
                cell.imgViewBubble.layer.cornerRadius = 10
                if #available(iOS 11.0, *) {
                    cell.imgViewBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
                } else {
                    // Fallback on earlier versions
                }
                
                cell.imgViewProfilePic.layer.cornerRadius = cell.imgViewProfilePic.frame.size.height/2
                cell.imgViewProfilePic.layer.masksToBounds = true
                cell.imgViewProfilePic.layer.borderWidth = 1.5
                cell.imgViewProfilePic.layer.borderColor = UIColor.black.cgColor
                
                if let photo = message.picture {
                    
                    cell.imgViewProfilePic.sd_setImage(with: URL(string:photo), placeholderImage: UIImage(named: "celebrityProfileDP"), options: .refreshCached, context: nil)
                }
                else {
                    cell.imgViewProfilePic.image = UIImage(named: "celebrityProfileDP")
                }
                
                let color = BlackThemeColor.lightBlack
                
                cell.imgViewBubble.backgroundColor = color
                
                cell.imgViewChoch.tintColor = color
                
                cell.lblDateTime.text = message.date ?? ""
                
                cell.selectionStyle = .none
                
                return cell
            }
            else {
                                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSenderTableCell") as! ChatSenderTableCell
                
                if message.read == true{
                    
                    cell.imgViewState.isHidden = false
                }
                else {
                    
                    cell.imgViewState.isHidden = true
                }
                
                cell.lblUsername.text = CustomerDetails.firstName?.capitalized
                
                cell.imgViewBubble.clipsToBounds = true
                cell.imgViewBubble.layer.cornerRadius = 10
                if #available(iOS 11.0, *) {
                    cell.imgViewBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
                } else {
                    // Fallback on earlier versions
                }
                
                cell.imgViewProfilePic.layer.cornerRadius = cell.imgViewProfilePic.frame.size.height/2
                cell.imgViewProfilePic.layer.masksToBounds = true
                                
                if let photo = CustomerDetails.picture {
                    
                    cell.imgViewProfilePic.sd_setImage(with: URL(string:photo), placeholderImage: UIImage(named: "profileph"), options: .refreshCached, context: nil)
                }
                else {
                    
                    cell.imgViewProfilePic.image = UIImage(named: "profileph")
                }
                
                cell.imgViewProfilePic.layer.borderWidth = 1.5
                cell.imgViewProfilePic.layer.borderColor = UIColor.black.cgColor
                
                cell.imgViewSticker.backgroundColor = .clear
                cell.imgViewSticker.layer.cornerRadius = 8.0
                cell.imgViewSticker.layer.masksToBounds = true
                                
                if message.type == messageType.text.rawValue {
                    
                    cell.lblChat.text = message.message
                    cell.lblChat.enabledTypes = [.url]
                    cell.lblChat.handleURLTap { (URL) in
                      print("Click URL")
                     self.showHyperLinkUrl(url: URL)
                     }

                    cell.cnstStickerWidth.priority = .defaultLow
                    cell.cnstStickerHeight.priority = .defaultLow
                    
                    cell.imgViewSticker.image = nil
                }
                else if message.type == messageType.gift.rawValue {
                    
                    if let photo = message.message {
                        
                        cell.imgViewSticker.sd_setImage(with: URL(string:photo), placeholderImage: UIImage(named: "sticker_placeholder"), options: .refreshCached, context: nil)
                    }
                    else {
                        
                        cell.imgViewSticker.image = UIImage(named: "sticker_placeholder")
                    }
                                                            
                    cell.cnstStickerWidth.priority = .defaultHigh
                    cell.cnstStickerHeight.priority = .defaultHigh

                    cell.cnstStickerWidth.constant = 100
                    cell.cnstStickerHeight.constant = 100
                                        
                    cell.lblChat.text = ""
                }
                else {
                    
                    if let photo = message.message {
                        
                        cell.imgViewSticker.sd_setImage(with: URL(string:photo), placeholderImage: UIImage(named: "image placeholder"), options: .refreshCached, context: nil)
                    }
                    else {
                        
                        cell.imgViewSticker.image = UIImage(named: "image placeholder")
                    }
                    
                    cell.cnstStickerWidth.priority = .defaultHigh
                    cell.cnstStickerHeight.priority = .defaultHigh
                    
                    cell.cnstStickerWidth.constant = 220
                    cell.cnstStickerHeight.constant = 220
                    
                    cell.lblChat.text = ""
                    
                    cell.imgViewSticker.backgroundColor = .black
                }
                
                let color = BlackThemeColor.dlSenderback
                
                cell.imgViewBubble.backgroundColor = color
                cell.lblChat.textColor = BlackThemeColor.darkBlack
                cell.lblDateTime.textColor = BlackThemeColor.darkBlack
                cell.lblUsername.textColor = BlackThemeColor.darkBlack
                cell.imgViewChoch.tintColor = color
                
                cell.lblDateTime.text = message.date ?? ""
                
                cell.selectionStyle = .none
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.checkIsUserLoggedIn() {

            let message = arrChats[indexPath.row]
            
            if message.system == false && message.type == messageType.photo.rawValue {
                
                if let photo = message.message, let cell = tableView.cellForRow(at: indexPath) as? ChatSenderTableCell {
                    
                    showPhotoPreview(photo: photo, view: cell.imgViewSticker)
                }
            }
        }
    }
}

// MARK: - Web Services Methods
extension DirectLinkViewController {
    
    func fistCellCall() {
        self.commentTableView.reloadData()
     }
    
    func webCreateChatRoom() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            if !self.checkIsUserLoggedIn() {
//                self.showAlert(message: Messages.loginAlertMsg)
                fistCellCall()
                return
            }
                        
            self.showLoader()
            
            ServerManager.sharedInstance().postRequest(postData: nil, apiName: Constants.createRoom, extraHeader: nil) { (result) in
                
                self.stopLoader()

                switch result {
                case .success(let data):
                    print(data)
                    
                   if (data["error"].bool == true) {
                        
                        if let error_messages = data["error_messages"].arrayObject as? [String], error_messages.count != 0 {
                            
                            self.showToast(message: error_messages[0])
                        }
                        else {
                            
                            self.showToast(message: "Something went wrong. Please try again!")
                        }
                        
                        return
                    } else {

                        if let directline_room_id = data["data"]["directline_room_id"].string {
                           
                            if  let customer : Customer =  CustomerDetails.customerData {
                                customer.directline_room_id = directline_room_id
                                CustomerDetails.directline_room_id = directline_room_id
                                self.updateDataToDatabase(cust: customer)
                            }
                        }
                        
                        self.webGetChatRoomHistory()
                    }
                case .failure(let error):
                    
                    print(error)
                    
                    //                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                }
            }
        }
        else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    @objc func loadMoreTrigerred() {
        
        if apiCallStatus.isLoadMore {
         
            webGetChatRoomHistory(isRefresh: false)
        }
        else {
            
            stopAllRefreshControl()
//            self.showToast(message: "No more data.")
        }
    }
    
    func webGetChatRoomHistory(isRefresh: Bool = true) {
        
        if Reachability.isConnectedToNetwork() == true {
            
            var page = 1
            
            if !isRefresh {
                
                page = apiCallStatus.page + 1
            }
            else {
                
                self.showLoader()
            }
            
            
            let apiName = Constants.roomChatHistory + CustomerDetails.directline_room_id! + "?page=\(page)&v=\(Constants.VERSION)&platform=\(Constants.PLATFORM_TYPE)"
            
            
            ServerManager.sharedInstance().getRequest(postData: nil, apiName: apiName, extraHeader: nil) { (result) in
                
                self.apiCallStatus.isLoadMore = false
                self.apiCallStatus.isCalling = false
                self.apiCallStatus.shouldShowNotFound = true
                self.stopAllRefreshControl()
                    
                self.stopLoader()
                
                switch result {
                case .success(let data):
                    
                    print(data)
                    
                   if (data["error"].bool == true) {
                        
                        if let error_messages = data["error_messages"].arrayObject as? [String], error_messages.count != 0 {
                            
                            self.showToast(message: error_messages[0])
                        }
                        else {
                            
                            self.showToast(message: "Something went wrong. Please try again!")
                        }
                        
                        return
                    }
                    else
                    {
                        guard let dictData = data["data"].dictionary else {
                            
                            self.showToast(message: "Something went wrong. Please try again!")
                            
                            return
                        }
                        
                        if let paginate_data = dictData["paginate"]?.dictionaryObject {
                            
                            if let pagination = PaginationStats.object(paginate_data) {
                                
                                if let last_page = pagination.last_page, let current_page = pagination.current_page {
                                    
                                    if last_page > current_page {
                                        
                                        self.apiCallStatus.isLoadMore = true
                                        
                                        self.addAllRefreshControl()
                                    }
                                    else {
                                        
                                        self.removeAllRefreshControl()
                                    }
                                }
                            }
                        }
                                                
                        guard let arrList = dictData["list"]?.arrayObject as? [[String:Any]] else {
                            
                            self.showToast(message: "Something went wrong. Please try again!")
                            
                            return
                        }
                        
                        guard let arrMsg = ChatMessageModel.object(arrList) else {
                            
                            self.showToast(message: "Something went wrong. Please try again!")
                            
                            return
                        }
                        
                        guard let dictRoom = dictData["message_room"]?.dictionaryObject, let chatRoom = ChatRoomMessageModel.object(dictRoom) else {
                            
                            self.showToast(message: "Something went wrong. Please try again!")
                            
                            return
                        }
                        
                        self.chatRoom = chatRoom
                        
                        self.updateChatRoomState()
                        
                        if arrMsg.count > 0 {
                            
                            if isRefresh {
                                
                                self.arrChats.removeAll()
                                self.arrChats.append(contentsOf: arrMsg)
                                
                                self.commentTableView.reloadData()
                                
                                self.apiCallStatus.page = 1
                                
                                self.scrollToBottom()
                            }
                            else {
                                
                                self.arrChats.insert(contentsOf: arrMsg, at: 0)
                                
                                self.addCells(arr: arrMsg)
                                
                                self.apiCallStatus.page = self.apiCallStatus.page + 1
                            }
                        }
                        else {
                            
                            if isRefresh {
                                
                                self.apiCallStatus.page = 1
                                
                                self.arrChats.removeAll()
                                self.commentTableView.reloadData()
                            }
                        }
                    }
                case .failure(let error):
                    
                    print(error)
                    
                    self.showToast(message: "Something went wrong. Please try again!")

                    //                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                }
            }
            
        }
        else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    func addCells(arr: [ChatMessageModel]) {
        
        var indexes = [IndexPath]()
        
        for i in 0..<arr.count {
            
            let index = IndexPath.init(row: i, section: 0)
            indexes.append(index)
        }
        
        commentTableView.beginUpdates()
                
        commentTableView.insertRows(at: indexes, with: UITableView.RowAnimation.automatic)
        
        commentTableView.endUpdates()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            self.commentTableView.reloadData()
        }
    }
    
    func webSendChatMessage(msg: String? = nil, sticker: CommentSticker? = nil) {
        
        if !self.checkIsUserLoggedIn() {
            
            self.loginPopPop()

            return
        }
        
        if artistConfig.directLine?.coins == nil, artistConfig.directLine?.coins == 0 {

            self.showToast(message: "Direct Line is not configured on server, Please try again latter")
            
            return
        }

        guard let directline_room_id =  CustomerDetails.directline_room_id, directline_room_id.count != 0 else {

            self.showToast(message: "You are not connected to direct line, Please try after some time.")

            return
        }
        
        var price = 0
        
        if let gift = sticker {
            
            price = Int(gift.coins ?? 0)
        }
        else {
            
            price = msgCoins
        }
        
        if !isBalanceAvailable(price) {
            
            rechargeCoinsPopPop()
            return
        }

            //            self.showToast(message: "Not Enough coins please recharge")
        
        if Reachability.isConnectedToNetwork() == true {
            
            var dictParams = [String: Any]()
            
            if let message = msg {
                
                dictParams["message"] = message
                dictParams["type"] = messageType.text.rawValue
            }
            
            if let gift = sticker {
                
                dictParams["gift_id"] = gift._id!
                dictParams["type"] = messageType.gift.rawValue
            }
            
            dictParams["directline_room_id"] = directline_room_id
            
            dictParams["message_by"] = "customer"
            
            self.showLoader()
            
            self.view.isUserInteractionEnabled = false
            
            ServerManager.sharedInstance().postRequest(postData: dictParams, apiName: Constants.sendChatMessage , extraHeader: nil) { (result) in

                self.view.isUserInteractionEnabled = true

                self.apiCallStatus.isLoadMore = false

                self.apiCallStatus.isCalling = false

                self.apiCallStatus.shouldShowNotFound = true

                self.stopAllRefreshControl()

                self.stopLoader()
                
                switch result {

                case .success(let data):

                    print(data)

                    if (data["error"].bool == true) {

                        if let error_messages = data["error_messages"].arrayObject as? [String], error_messages.count != 0 {

                            self.showToast(message: error_messages[0])
                        }
                        else {

                            self.showToast(message: "Something went wrong. Please try again!")
                        }

                        return
                    }
                    else
                    {
                        guard let dictData = data["data"].dictionary else {

                            self.showToast(message: "Something went wrong. Please try again!")
                            return
                        }

                        if let dictMsg = dictData["chat_message"]?.dictionaryObject {

                            if let message = ChatMessageModel.object(dictMsg)  {

                                self.arrChats.append(message)
                            }
                        }

                        if let dictSystem = dictData["system_message"]?.dictionaryObject  {

                            if let system = ChatMessageModel.object(dictSystem)  {

                                self.arrChats.append(system)
                            }
                        }

                        self.commentTableView.reloadData()

                        var isSendMessage = true

                        if let send_message = dictData["send_message"] {

                            if let sendmessage = send_message.bool {

                                isSendMessage = sendmessage

                            }
                        }

                        self.chatRoom?.send_message = isSendMessage

                        self.updateChatRoomState()
                        
                        DispatchQueue.main.async {

//                            self.commentTextView.text = ""
//                            self.commentTextView.textViewDidChange(self.commentTextView);
                        }

                        self.scrollToBottom()
                        
                        self.updateBalanceAfterMessage(sticker: sticker, isPhoto: false)
                    }

                case .failure(let error):

                    print(error)

                    self.showToast(message: "Something went wrong. Please try again!")

                    //                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                }
            }
        }
        else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    func webSendChatPhoto(data: Data) {
            
            if !self.checkIsUserLoggedIn() {
                
                self.loginPopPop()

                return
            }
            
            if artistConfig.directLine?.coins == nil, artistConfig.directLine?.coins == 0 {

                self.showToast(message: "Direct Line is not configured on server, Please try again latter")
                
                return
            }

            guard let directline_room_id =  CustomerDetails.directline_room_id, directline_room_id.count != 0 else {

                self.showToast(message: "You are not connected to direct line, Please try after some time.")

                return
            }
            
        let price = msgCoins
        
        if !isBalanceAvailable(price) {
            
            rechargeCoinsPopPop()
            return
        }
            
            if Reachability.isConnectedToNetwork() == true {
                
                var dictParams = [String: Any]()
                    
                dictParams["photo"] = data
                dictParams["type"] = messageType.photo.rawValue
                
                dictParams["directline_room_id"] = directline_room_id

                dictParams["message_by"] = "customer"

                self.showLoader()
                
                self.view.isUserInteractionEnabled = false

                ServerManager.sharedInstance().multipart(params: dictParams, apiName: Constants.sendChatMessage, extraHeader: nil) { (status, msg, dict) in
                    
                    self.view.isUserInteractionEnabled = true

                    self.apiCallStatus.isLoadMore = false
                    
                    self.apiCallStatus.isCalling = false
                    
                    self.apiCallStatus.shouldShowNotFound = true
                    
                    self.stopAllRefreshControl()
                    
                    self.stopLoader()
                    
                    if status {
                        
                        guard let data = dict else {
                            
                            utility.alert(title: stringConstants.error, message: stringConstants.somethingWentWrong, delegate: self, buttons: nil, cancel: stringConstants.ok, completion: nil)
                            
                            return
                        }
                        
                        print(data)
                        
                        if (data["error"] as? Bool == true) {
                            
                            if let error_messages = data["error_messages"] as? [String], error_messages.count != 0 {
                                
                                self.showToast(message: error_messages[0])
                            }
                            else {
                                
                                self.showToast(message: "Something went wrong. Please try again!")
                            }
                            
                            return
                        }
                        else
                        {
                            guard let dictData = data["data"] as? [String:Any] else {
                                
                                self.showToast(message: "Something went wrong. Please try again!")
                                return
                            }
                            
                            if let dictMsg = dictData["chat_message"] as? [String:Any] {
                                
                                if let message = ChatMessageModel.object(dictMsg)  {
                                    
                                    self.arrChats.append(message)
                                }
                            }
                            
                            if let dictSystem = dictData["system_message"] as? [String:Any]  {
                                
                                if let system = ChatMessageModel.object(dictSystem)  {
                                    
                                    self.arrChats.append(system)
                                }
                            }
                            
                            self.commentTableView.reloadData()
                            
                            var isSendMessage = true
                            
                            if let sendmessage = dictData["send_message"] as? Bool {
                                
                                isSendMessage = sendmessage
                            }
                            
                            self.chatRoom?.send_message = isSendMessage
                            
                            self.updateChatRoomState()
                            
                            DispatchQueue.main.async {
                                
                                //                            self.commentTextView.text = ""
                                //                            self.commentTextView.textViewDidChange(self.commentTextView);
                            }
                            
                            self.scrollToBottom()
                            
                            self.updateBalanceAfterMessage(isPhoto: true)
                        }
                    }
                    else {
                        
                        if let message = msg {
                            
                            self.showToast(message: message)
                        }
                        else {
                            
                            self.showToast(message: "Something went wrong. Please try again!")
                        }
                    }
                }
            }
            else
            {
                self.showToast(message: Constants.NO_Internet_MSG)
            }
        }
    
//    func webSendChatMessage(_ msg: String) {
//
//        if !self.checkIsUserLoggedIn() {
//            self.showAlert(message: Messages.loginAlertMsg)
//          return
//        }
//        if artistConfig.directLine?.coins == nil, artistConfig.directLine?.coins == 0 {
//
//            self.showToast(message: "Direct Line is not configured on server, Please try again latter")
//
//            return
//        }
//
//        guard let directline_room_id =  CustomerDetails.directline_room_id, directline_room_id.count != 0 else {
//
//            self.showToast(message: "You are not connected to direct line, Please try after some time.")
//
//            return
//        }
//
//            if !isBalanceAvailable() {
//                    if CustomerDetails.coins == msgCoins {
//
//
//                    } else {
//
//                        rechargeCoinsPopPop()
//                        return
//                    }
//        //            self.showToast(message: "Not Enough coins please recharge")
//
//                }
//
//        if Reachability.isConnectedToNetwork() == true {
//
//            var dictParams = [String:String]()
//
//            dictParams["message"] = msg
//            dictParams["type"] = "text"
//            dictParams["directline_room_id"] = directline_room_id
//
//            self.showLoader()
//
//            ServerManager.sharedInstance().postRequest(postData: dictParams, apiName: Constants.sendChatMessage , extraHeader: nil) { (result) in
//
//                self.apiCallStatus.isLoadMore = false
//                self.apiCallStatus.isCalling = false
//                self.apiCallStatus.shouldShowNotFound = true
//                self.stopAllRefreshControl()
//
//                self.stopLoader()
//
//                switch result {
//                case .success(let data):
//
//                    print(data)
//
//                    if (data["error"].bool == true) {
//
//                        if let error_messages = data["error_messages"].arrayObject as? [String], error_messages.count != 0 {
//
//                            self.showToast(message: error_messages[0])
//                        }
//                        else {
//
//                            self.showToast(message: "Something went wrong. Please try again!")
//                        }
//
//                        return
//                    }
//                    else
//                    {
//                        guard let dictData = data["data"].dictionary else {
//
//                            self.showToast(message: "Something went wrong. Please try again!")
//
//                            return
//                        }
//
//                        guard let dictMsg = dictData["chat_message"]?.dictionaryObject else {
//
//                            self.showToast(message: "Something went wrong. Please try again!")
//
//                            return
//                        }
//
//                        guard let message = ChatMessageModel.object(dictMsg) else {
//
//                            self.showToast(message: "Something went wrong. Please try again!")
//
//                            return
//                        }
//
//                        guard let dictSystem = dictData["system_message"]?.dictionaryObject else {
//
//                            self.showToast(message: "Something went wrong. Please try again!")
//
//                            return
//                        }
//
//                        guard let system = ChatMessageModel.object(dictSystem) else {
//
//                            self.showToast(message: "Something went wrong. Please try again!")
//
//                            return
//                        }
//
//                        self.arrChats.append(message)
//                        self.arrChats.append(system)
//                        self.commentTableView.reloadData()
//
//                        self.chatRoom?.send_message = false
//                        self.updateChatRoomState()
//
//                        DispatchQueue.main.async {
//
//                        self.commentTextView.text = ""
//
//
//                    self.commentTextView.textViewDidChange(self.commentTextView);
//                        }
//
//                        self.scrollToBottom()
//
//                        self.updateBalanceAfterMessage()
//                    }
//                case .failure(let error):
//
//                    print(error)
//
//                    self.showToast(message: "Something went wrong. Please try again!")
//
//                    //                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
//                }
//            }
//        }
//        else
//        {
//            self.showToast(message: Constants.NO_Internet_MSG)
//        }
//    }
}

// MARK: - PHCommentTextView Delegate Methods
extension DirectLinkViewController: PHCommentTextViewDelegate {
  
    func didReply(onComment: Any, comment: Any, indexPath: IndexPath) {
        
//        var parentId = ""
//
//        if let comment = onComment as? ContentComment {
//
//            parentId = comment._id ?? ""
//        }
//
//        if let comment = onComment as? ContentSubComment {
//
//            parentId = comment.parent_id ?? ""
//        }
//
//        var commentStr = ""
//        var type = ContentCommentType.text
//
//        if let str = comment as? String {
//
//            commentStr = str
//            type = ContentCommentType.text
//        }
//
//        if let sticker = comment as? CommentSticker, let photo = sticker.photo?.thumb {
//
//            commentStr = photo
//            type = ContentCommentType.sticker
//        }
        
//        webPostSubCommment(parentId: parentId, comment: commentStr, type: type, indexPath: indexPath)
    }
  
    func didChangedHeight() {
        
        UIView.animate(withDuration: 0.3) {
                   
            self.commentTableView.layoutIfNeeded()
        }
    }
    
    func didBeginEditing() {
        
        UIView.animate(withDuration: 0.3) {
            
            self.commentTableView.layoutIfNeeded()
        }
    }
    
    func didEndEditing() {
        
        UIView.animate(withDuration: 0.3) {
                   
            self.commentTableView.layoutIfNeeded()
        }
    }
    
    func didPostComment(str: String) {
        
        webSendChatMessage(msg: str)
        
//        webPostComment(comment: str, type: ContentCommentType.text)
    }
    
    func didPostSticker(sticker: CommentSticker) {

        if let photo = sticker.photo?.thumb {
            
            webSendChatMessage(sticker: sticker)
//            webPostComment(comment: photo, type: ContentCommentType.sticker)
        }
    }
    
    func didTapPhotoAttachment() {
        
        self.showPhotoLibrary()
        
//        utility.sheet(delegate: self, buttons: [stringConstants.camera, stringConstants.library], cancel: stringConstants.cancel) { (btn) in
//
//            if btn == stringConstants.camera {
//
//                self.showCamera()
//            }
//
//            if btn == stringConstants.library {
//
//                self.showPhotoLibrary()
//            }
//        }
    }
}

extension DirectLinkViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            var compressedImage = utility.resizeImage(image: capturedImage, targetSize: CGSize(width: 1000, height: 1000))
            
            if picker.sourceType == .camera {
                
                if picker.cameraDevice == .front {
                    
                    compressedImage = UIImage(cgImage: compressedImage.cgImage!, scale: 1.0, orientation: .upMirrored)
                }
            }
            
            DispatchQueue.main.async {
                
                self.showPhotoPreviewBeforeSending(image: capturedImage)
            }
        }
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Direct Line Photo Preview Delegate Method
extension DirectLinkViewController: DirectLinePhotoDelegate {
    
    func didSelectSend(image: UIImage) {
        
        sendPhoto(image: image)
    }
    func showHyperLinkUrl(url: URL) {
        let pathString = url.path
      if pathString.isValidURL {
        print("URL Not Valid")
        }else{
        let HyperLinkUrl = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
        HyperLinkUrl.openUrl = "\(url)"
        HyperLinkUrl.hideRightBarButtons = true
       // self.navigationController?.pushViewController(HyperLinkUrl, animated: true)
        self.present(HyperLinkUrl, animated: true, completion: nil)
         }
    }

}


extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
