//
//  DirectLinePhotoViewController.swift
//  AnveshiJain
//
//  Created by developer2 on 02/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import ActiveLabel

protocol DirectLinePhotoDelegate: NSObject {
    
    func didSelectSend(image: UIImage)
}

class DirectLinePhotoViewController: PannableViewController {

    @IBOutlet weak var imgViewPic: UIImageView!
    @IBOutlet weak var lblTerms: ActiveLabel!
    @IBOutlet weak var viewSend: PHCommentSendView!
    
    weak var delegate:DirectLinePhotoDelegate? = nil
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLayoutAndDesign()
    }
    
    // MARK: - IBActions
    @IBAction func btnSendClicked() {
                
        self.dismiss(animated: true) {
            
            self.delegate?.didSelectSend(image: self.image)
        }
    }
    
    @IBAction func btnCloseClicked() {
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Utility Methods
extension DirectLinePhotoViewController {
    
    func setLayoutAndDesign() {
        
        setCoins()
        
        
        setTermLabel()
        
        imgViewPic.image = image
        
        imgViewPic.cornerRadius = 10
        
        self.isPresented = true
        
        imgViewPic.borderColor = UIColor.lightGray
        imgViewPic.borderWidth = 0.5
        
        viewSend.borderColor = UIColor.lightGray
        viewSend.borderWidth = 0.5
        viewSend.makeCirculaer = true
    }
    
    func setCoins() {
        
        let artistConfig = ArtistConfiguration.sharedInstance()
        
        let coins = artistConfig.directLine?.coins ?? 199
        
        self.viewSend.lblPrice.text = "\(coins)"
    }
    
    func setTermLabel() {
        
        let terms = "Terms & Conditions"
        let privacy = "Privacy Policy"
        
        let msg = "By clicking send button you are agreeing to\n\(terms) and \(privacy)."
        
        lblTerms.customize { (lbl) in
           
            lblTerms.text = msg
            
            let termsType = ActiveType.custom(pattern: "\\s\(terms)\\b")
            
            let privacyType = ActiveType.custom(pattern: "\\s\(privacy)\\b")
            
            lblTerms.enabledTypes = [termsType, privacyType]

            lblTerms.customColor[termsType] = UIColor.white
            lblTerms.customSelectedColor[termsType] = UIColor.gray
            lblTerms.customColor[privacyType] = UIColor.white
            lblTerms.customSelectedColor[privacyType] = UIColor.gray
                
            self.lblTerms.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                
                if type == termsType {
                    
                    atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
                }
                
                if type == privacyType {
                    
                    atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
                }
                
                return atts
            }
                        
            lblTerms.handleCustomTap(for: termsType) { element in
                
                print("Custom type tapped: \(element)")
                self.showTermsOrPrivacy(isTerms: true)
            }
            
            lblTerms.handleCustomTap(for: privacyType) { element in
                
                print("Custom type tapped: \(element)")
                self.showTermsOrPrivacy(isTerms: false)
            }
        }
    }
    
    func showTermsOrPrivacy(isTerms: Bool) {
        
        let termeAndCond = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
        
        if isTerms {
            
            termeAndCond.navigationTitle = "Terms & Conditions"

            termeAndCond.openUrl = "http://www.armsprime.com/terms-conditions.html"
        }
        else {
            
            termeAndCond.navigationTitle = "Privacy Policy"

            termeAndCond.openUrl = "http://www.armsprime.com/arms-prime-privacy-policy.html"
        }
        
        termeAndCond.hideRightBarButtons = true
        
        let navVC = UINavigationController(rootViewController: termeAndCond)
        
        self.present(navVC, animated: true, completion: nil)
    }
}
