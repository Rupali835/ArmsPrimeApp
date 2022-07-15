//
//  CongratulationPopupViewController.swift
//  HotShot
//
//  Created by Rohit Mac Book on 29/08/19.
//  Copyright © 2019 com.armsprime.hotshot. All rights reserved.
//

import UIKit

class CongratulationPopupViewController: UIViewController {

    @IBOutlet weak var rewardMessageLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    var message = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         showAnimate()
       
        showAnimation()
        rewardMessageLabel.text = message
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(CongratulationPopupViewController.sayHello), userInfo: nil, repeats: false)

        self.popupView.layer.cornerRadius = 4
        self.popupView.clipsToBounds = true
        self.popupView.layer.borderWidth = 1
        self.popupView.layer.borderColor = UIColor.red.cgColor
        self.dismissButton.layer.cornerRadius = 4
        self.dismissButton.clipsToBounds = true
        
    }
    
    @objc func sayHello() {
        removeAnimate()
        goToMainVC()
        timer.invalidate()
    }
    
    func showAnimation() {
        let cheerView = CheerView()
        cheerView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        cheerView.frame = view.bounds
        view.addSubview(cheerView)
        cheerView.start(duration: 0.5)
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        removeAnimate()
        goToMainVC()
    }
    
    func goToMainVC() {
        
        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        
        print("notifications are enabled")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : CustomTabViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabViewController") as! CustomTabViewController
        vc.isCommingFromRewardView = true
//        self.stopLoader()
//        self.pushAnimation()
        
        let currentNav: UINavigationController =  UIApplication.shared.delegate?.window??.rootViewController as!  UINavigationController
        currentNav.pushViewController(vc, animated: false)
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
