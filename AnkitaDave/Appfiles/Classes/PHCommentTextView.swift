//
//  PHTextView.swift
//  Producer
//
//  Created by developer2 on 15/11/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol PHCommentTextViewDelegate {
    
    func didChangedHeight()
    func didBeginEditing()
    func didEndEditing()
    func didPostComment(str: String)
    func didPostSticker(sticker: CommentSticker)
    func didReply(onComment: Any, comment:Any, indexPath: IndexPath)
    func didTapPhotoAttachment()
}

class PHCommentSendView: UIView {
    
    @IBOutlet weak var imgViewSendIcon: UIImageView!
    @IBOutlet weak var imgViewCoinIcon: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnSend: UIButton!
}

class PHCommentCharCountView: UIView {
    
    @IBOutlet weak var lblCharCount: UILabel!
}

class PHCommentTextView: UIView {

    @IBOutlet weak var imgViewProfilePic: UIImageView!
    @IBOutlet weak var btnStickers: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var viewInnerContainer: UIView!
    @IBOutlet weak var textView: PHGrowingTextView!
    @IBOutlet weak var cnstTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewStickerUpper: PHStickersView!
    @IBOutlet weak var cnstStickerUpperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewStickerBottom: PHStickersView!
    @IBOutlet weak var viewSend: PHCommentSendView!
    @IBOutlet weak var viewCharCount: PHCommentCharCountView!
    @IBOutlet weak var cnstStickerBottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewReply: UIView!
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var cnstViewReplyHeight: NSLayoutConstraint!
    
    var delegate: PHCommentTextViewDelegate? = nil
    
    var tapGes: UITapGestureRecognizer? = nil
    
    let upperStickerViewHeight: CGFloat = 70
    var bottomStickerViewHeight: CGFloat = 271
    var keyboardAnimDuration:Double = 0.27
    
    var tabbarHeight: CGFloat = 0.0 {
        
        didSet {
            
            bottomStickerViewHeight = 271 + macros.safeArea.bottom - tabbarHeight
        }
    }

    
    var tapView: UIView? = nil {
        
        didSet{
            
            self.addTapGesture()
        }
    }
    
    var replyOnComment: Any? = nil
    var replyViewHeight: CGFloat = 40
    var replyIndexPath: IndexPath? = nil
    
    // MARK: - IBActions
    @IBAction func btnStickerClicked() {
        
        if viewStickerBottom.isHidden {
            
            self.btnStickers.tintColor = appearences.redColor
            
            showBottomSticker()
            hideUpperSticker()
        }
        else {
            
            if textView.isEditing {
                
                self.endEditing(true)
                self.btnStickers.tintColor = appearences.redColor
                
                showBottomSticker()
                hideUpperSticker()
            }
            else {
                
                showUpperSticker()
                hideBottomSticker()
            }
        }
    }
    
    @IBAction func btnPostClicked() {
                
        let text = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if text.count > 0 {
                                    
            postText(text, indexPath: self.replyIndexPath)
            
            clearAndDismiss()
        }
    }
    
    @IBAction func btnCloseReplyClicked() {
        
        resetReplyDetails()
    }
    
    @IBAction func btnPhotoClicked() {
        
        self.delegate?.didTapPhotoAttachment()
    }
    
    // MARK: - Utility Methods
    override func awakeFromNib() {
        
        setlayoutAndDesign()
    }
    
    func setlayoutAndDesign() {
        
//        self.backgroundColor = .white
                
        viewSend.makeCirculaer = true
        if RCValues.sharedInstance.bool(forKey: .DLPhotoShow) == true {
            btnPhoto.isHidden = false
        }else{
            btnPhoto.isHidden = true
        }
        viewInnerContainer.cornerRadius = viewInnerContainer.frame.size.height/2
        viewInnerContainer.borderWidth = 0.5
        viewInnerContainer.borderColor = appearences.placeholderColor
        
        textView.placeholderColor = appearences.placeholderColor
        textView.placeholderTextView.placeholder = stringConstants.typeComment
        
        imgViewProfilePic.backgroundColor = appearences.placeholderColor
        imgViewProfilePic.makeCirculaer = true
        imgViewProfilePic.borderWidth = 0.5
        imgViewProfilePic.borderColor = appearences.placeholderColor
        
//        if let userProfilePic = User.getLoggedInUser()?.photo?.thumb {
//
//            imgViewProfilePic.sd_imageTransition = .fade
//            imgViewProfilePic.sd_setImage(with: URL(string: userProfilePic), completed: nil)
//        }
        
        textView.font = fonts.regular(size: 14)
        textView.keyboardDistanceFromTextField = 20
        textView.maxHeight = 100
//        textView.btnSend = btnPost
        textView.delegateGrowing = self
        textView.keyboardDismissMode = .interactive
        setCharCount(0)
        setCoins()
        
        btnPost.isHidden = false
        
        viewStickerBottom.backgroundColor = .red
        
        cnstStickerUpperViewHeight.constant = 0
        cnstStickerBottomViewHeight.constant = 0
        
        viewStickerUpper.isHidden = true
        viewStickerBottom.isHidden = true
        
        viewStickerUpper.alpha = 0.0
        
        viewStickerUpper.delegate = self
        viewStickerBottom.delegate = self
        
        viewStickerUpper.isFirstPageOnly = true
        
        if macros.appDel!.shouldShowSticker {
            
            showUpperSticker()
        }
        
        addKeyboardObserver()
        
        cnstViewReplyHeight.constant = 0
        viewReply.isHidden = true
        viewReply.alpha = 0.0
        
//        self.textView.becomeFirstResponder()
    }
    
    func addTapGesture() {
        
        removeTapGesture()
        
        tapGes = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGes?.numberOfTouchesRequired = 1
        tapView?.addGestureRecognizer(tapGes!)
    }
    
    func removeTapGesture() {
        
        if tapGes != nil {
            
            self.tapView?.removeGestureRecognizer(tapGes!)
        }
    }
    
    @objc func handleTap() {
        
        self.endEditing(true)
        
        hideBottomSticker()
        
        showUpperSticker()
    }
    
    func showAllSticker() {
        
        self.viewStickerUpper.isHidden = false
        self.viewStickerBottom.isHidden = false

        self.cnstStickerUpperViewHeight.constant = upperStickerViewHeight
        self.cnstStickerBottomViewHeight.constant = bottomStickerViewHeight

        UIView.animate(withDuration: keyboardAnimDuration) {
            
            self.layoutIfNeeded()
        }
    }
    
    func showUpperSticker() {
        
        if viewStickerUpper.isHidden && macros.appDel!.shouldShowSticker {
            
            self.viewStickerUpper.isHidden = false
            
            self.cnstStickerUpperViewHeight.constant = upperStickerViewHeight
            
            UIView.animate(withDuration: keyboardAnimDuration, animations: {
                
                self.viewStickerUpper.alpha = 1.0
                
            }) { (finshed) in

            }
        }
    }
    
    func hideUpperSticker() {
        
        UIView.animate(withDuration: keyboardAnimDuration, animations: {
            
            self.viewStickerUpper.alpha = 0.0
            
        }) { (finshed) in
            
            self.cnstStickerUpperViewHeight.constant = 0

            self.viewStickerUpper.isHidden = true
        }
    }
    
    func showBottomSticker() {
        
        addTapGesture()
        
        if viewStickerBottom.isHidden {
            
            self.viewStickerBottom.isHidden = false
            
            self.cnstStickerBottomViewHeight.constant = bottomStickerViewHeight
            
            UIView.animate(withDuration: keyboardAnimDuration) {
                
                self.layoutIfNeeded()
            }
        }
    }
    
    func hideBottomSticker() {
        
        removeTapGesture()

        self.btnStickers.tintColor = appearences.placeholderColor

        self.btnStickers.tintColor = .black

        self.cnstStickerBottomViewHeight.constant = 0
        
        UIView.animate(withDuration: keyboardAnimDuration, animations: {
            
            self.layoutIfNeeded()
            
        }) { (finshed) in
            
            self.viewStickerBottom.isHidden = true
        }
    }
    
    func addKeyboardObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Do something with size

            if keyboardFrame.size.height > 0 {
                
                bottomStickerViewHeight = keyboardFrame.size.height - tabbarHeight
            }
            
            print("keyboardFrameEndUserInfoKey = \(keyboardFrame)")
        }
        
        if let animDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            
//          self.keyboardAnimDuration = animDuration
        }
    }
    
    func beginEditing() {
        
        textView.becomeFirstResponder()
    }
    
    func endEditing() {
        
        textView.resignFirstResponder()
        hideBottomSticker()
    }
    
    func setReplyDetails(replyOn: Any, indexPath: IndexPath) {
        
//        self.replyIndexPath = indexPath
//        self.replyOnComment = replyOn
//
//        var userName = ""
//
//        if let comment = self.replyOnComment as? ContentComment {
//
//            if let fullname = comment.user?.fullName() {
//
//                userName = fullname
//            }
//        }
//
//        if let comment = self.replyOnComment as? ContentSubComment {
//
//            if let fullname = comment.user?.fullName() {
//
//                userName = fullname
//            }
//        }
//
//        lblReply.text = "\(stringConstants.replying) \(stringConstants.to) \(userName.capitalized)"
//
//        showReplyView()
//
//        if viewStickerBottom.isHidden {
//
//            beginEditing()
//        }
    }
    
    func resetReplyDetails() {
        
        self.replyIndexPath = nil
        self.replyOnComment = nil
        
        hideReplyView()
    }
    
    func showReplyView() {
        
        cnstViewReplyHeight.constant = replyViewHeight
        self.viewReply.isHidden = false

        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewReply.layoutIfNeeded()
            self.viewReply.alpha = 1.0
            
        }) { (finished) in
            
        }
    }
    
    func hideReplyView() {
        
        cnstViewReplyHeight.constant = 0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewReply.layoutIfNeeded()
            self.viewReply.alpha = 0.0
            
        }) { (finished) in
            
            self.viewReply.isHidden = true
        }
    }
    
    func clearAndDismiss() {
        
//        resetReplyDetails()

        self.textView.reset()
            
        self.textView.resignFirstResponder()
        
        hideBottomSticker()
        
        removeTapGesture()
    }
    
    func setCharCount(_ count: Int) {
       
        let artistConfig = ArtistConfiguration.sharedInstance()
        
        let maxCharCount = Int(artistConfig.directLine?.message_length ?? 500)
        
        self.viewCharCount.lblCharCount.text = "\(count)/\(maxCharCount)"
        
        textView.maxCharCount = maxCharCount
        
        if count == 0{
             CustomMoEngage.shared.sendEventDirectLinePurchase(coins: Int(artistConfig.directLine?.coins ?? 199), status: "Cancelled", reason: "App has been stopped without User sending Direct Line")
        }
    }
    
    func setCoins() {
        
        let artistConfig = ArtistConfiguration.sharedInstance()
        
        let coins = artistConfig.directLine?.coins ?? 199
        
        self.viewSend.lblPrice.text = "\(coins)"
    }
}

// MARK: - Growing Textview Delegate Methods
extension PHCommentTextView: PHGrowingTextViewDelegate {
    
    func didChangeCount(textView: PHGrowingTextView, count: Int) {
        
        setCharCount(count)
    }
    
    func didBeginEditing(textView: PHGrowingTextView) {
        
        if let scrView = self.superview?.superview as? UIScrollView {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                
                scrView.delegate = self
            }
        }
        
        self.btnStickers.tintColor = .black
        
        if macros.appDel!.shouldShowSticker {
            
            showUpperSticker()
        }
        
        showBottomSticker()
    }
    
    func didEndEditing(textView: PHGrowingTextView) {
        
        if let scrView = self.superview?.superview as? UIScrollView {
            
            scrView.delegate = nil
        }
                
        if !macros.appDel!.shouldShowSticker {
            
            hideUpperSticker()
        }
    }
    
    func didChangeEmptyState(textView: PHGrowingTextView, isEmpty: Bool) {
        
    }
    
    func didChangeHeight(textView: PHGrowingTextView, height: CGFloat) {
                
        self.cnstTextViewHeight.constant = height
        
        UIView.animate(withDuration: 0.3) {
            
            self.textView.layoutIfNeeded()
        }
    }
}

// MARK: - ScrollView Delegate Method
extension PHCommentTextView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.endEditing(true)
    }
}

// MARK: - StickerView Delegate Methods
extension PHCommentTextView: PHStickersViewDelegate {
    
    func didSelectSticker(stickerView: PHStickersView, sticker: CommentSticker) {
        
        postSticker(sticker, indexPath: self.replyIndexPath)
        
        clearAndDismiss()
    }
    
    func didCloseSticker() {
        
        macros.appDel?.shouldShowSticker = false
        hideUpperSticker()
    }
}

// MARK: - Comment Post Methods
extension PHCommentTextView {
    
    func postText(_ str: String, indexPath: IndexPath?) {
        
        if replyOnComment != nil {
        
            self.delegate?.didReply(onComment: replyOnComment!, comment: str, indexPath: indexPath!)
        }
        else {
            
            self.delegate?.didPostComment(str: str)
        }
    }
    
    func postSticker(_ sticker: CommentSticker, indexPath: IndexPath?) {
        
        if replyOnComment != nil {
        
            self.delegate?.didReply(onComment: replyOnComment!, comment: sticker, indexPath: indexPath!)
        }
        else {
            
            self.delegate?.didPostSticker(sticker: sticker)
        }
    }
}
