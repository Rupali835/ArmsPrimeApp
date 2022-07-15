//
//  LoginPopPopViewController.swift
//  Shweta Pal
//
//  Created by Rohit Mac Book on 12/02/20.
//  Copyright © 2020 ArmsprimeMedia. All rights reserved.
//

import UIKit

class LoginPopPopViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var coinsView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var celbProfileImageView: UIImageView!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var commingFromNotLogin = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coinsView.isHidden = true
         showAnimate()
        if  textLabel.text == "Hey there! log in right now to connect with me" {
            
        } else {
            self.textLabel.text = "Hey there! log in right now to connect with me"
            self.coinsView.isHidden = true
        }

//
//        self.backgroundView.layer.borderColor =
//            hexStringToUIColor(hex: MyColors.casual).cgColor
        self.backgroundView.layer.borderWidth = 2
        self.backgroundView.layer.cornerRadius = 5
        backgroundView.clipsToBounds = true
        
        self.cancleButton.layer.cornerRadius = 5
             cancleButton.clipsToBounds = true
        self.loginButton.layer.cornerRadius = 5
             loginButton.clipsToBounds = true
        
        self.celbProfileImageView.layer.cornerRadius = celbProfileImageView.frame.size.width / 2
        self.celbProfileImageView.layer.masksToBounds = false
        self.celbProfileImageView.clipsToBounds = true
        self.celbProfileImageView.backgroundColor = UIColor.clear
        self.celbProfileImageView.image = UIImage(named: "celebrityProfileDP")
        self.celbProfileImageView.layer.borderColor = UIColor.black.cgColor
        self.celbProfileImageView.layer.borderWidth = 1
       
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
        
        removeAnimate()
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
    
}
