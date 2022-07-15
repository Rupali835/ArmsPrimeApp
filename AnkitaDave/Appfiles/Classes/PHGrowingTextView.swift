//
//  PHGrowingTextView.swift
//  Producer
//
//  Created by developer2 on 16/11/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import UIKit

protocol PHGrowingTextViewDelegate {
    
    func didBeginEditing(textView:PHGrowingTextView)
    func didEndEditing(textView:PHGrowingTextView)
    func didChangeEmptyState(textView:PHGrowingTextView, isEmpty: Bool)
    func didChangeHeight(textView:PHGrowingTextView, height: CGFloat)
    func didChangeCount(textView:PHGrowingTextView, count: Int)
}

class PHGrowingTextView: UITextView {
    
    var delegateGrowing: PHGrowingTextViewDelegate? = nil
    var maxHeight: CGFloat = 0
    var minHeight: CGFloat = 0
    var btnSend: UIButton? = nil
    var isEmptyState = true
    var maxCharCount = 500
    var isEditing = false
    
    var isEmpty: Bool {
        
        let str = self.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if str.count == 0 {
            
            return true
        }
        
        return false
    }
    
    override func awakeFromNib() {
        
        self.delegate = self
        
        self.textContainerInset = UIEdgeInsets.init(top: 3.5, left: 2, bottom: 3.5, right: 2)
        
        self.minHeight = self.frame.size.height
    }
    
    func changedEmptyState() {
        
        if isEmptyState {
            
            self.btnSend?.isHidden = false
            self.btnSend?.isEnabled = false
            
            UIView.animate(withDuration: 0.3) {
                
                self.btnSend?.alpha = 1.0
            }
        }
        else {
                        
            self.btnSend?.isHidden = false
            self.btnSend?.isEnabled = true
        }
        
        self.delegateGrowing?.didChangeEmptyState(textView: self, isEmpty: isEmptyState)
    }

    func reset() {
        
        self.text = ""
        self.delegateGrowing?.didChangeHeight(textView: self, height: minHeight)
    }
}

// MARK: - TextView Delegate Methods
extension PHGrowingTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.isEmpty {
            
            btnSend?.isHidden = false
            btnSend?.isEnabled = false
            
            self.btnSend?.alpha = 0.0
            
            UIView.animate(withDuration: 0.3) {
                
                self.btnSend?.alpha = 1.0
            }
        }
        else {
            
            btnSend?.isHidden = false
            btnSend?.isEnabled = true
            self.btnSend?.alpha = 1.0
        }
        
        isEditing = true
        
        self.delegateGrowing?.didBeginEditing(textView: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.isEmpty {
            
            btnSend?.isEnabled = false
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.btnSend?.alpha = 0.0

            }) { (finished) in
                
                self.btnSend?.isHidden = true
            }
            
            isEmptyState = true
        }
        else {
            
            isEmptyState = false
        }

        isEditing = false
        
        self.delegateGrowing?.didEndEditing(textView: self)
        
        self.textViewDidChange(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let str = (self.text as NSString).replacingCharacters(in: range, with: text)
        
        let strTrimmed = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if strTrimmed.count == 0 {
            
            if !isEmptyState {
                
                isEmptyState = true
                
                changedEmptyState()
            }
        }
        else {
            
            if isEmptyState {
                
                isEmptyState = false
                
                changedEmptyState()
            }
        }
        
        if strTrimmed.count == 0 && text != "" {
            
            return false
        }
        
        if str.count > maxCharCount {
            
            return false
        }
   
//        self.delegateGrowing?.didChangeCount(textView: self, count:str.count)
        
        textViewDidChange(textView)
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let height = textView.contentSize.height
        
        var finalHeight = maxHeight
        
        if height < maxHeight {
            
            finalHeight = height
            
            self.setContentOffset(CGPoint.zero, animated: false)
        }
        
        self.delegateGrowing?.didChangeHeight(textView: self, height: finalHeight)
        
        self.delegateGrowing?.didChangeCount(textView: self, count:self.text.count)
    }
}

