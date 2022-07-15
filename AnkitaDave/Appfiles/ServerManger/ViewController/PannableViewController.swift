//
//  PannableViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 30/05/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

class PannableViewController: UIViewController {

    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    var isPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
        
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: translation.x,
                y: translation.y
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if (panGesture.view?.frame.origin.y)! > CGFloat(50) {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        let transition = CATransition()
                        transition.duration = 0.5
                        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                        transition.type = .fade//CATransitionType.push
//                        transition.subtype = CATransitionSubtype.fromRight
                        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
                        
                        if self.isPresented {
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        else {
                         
                            _ = self.navigationController?.popViewController(animated: false)
                        }
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }

}
