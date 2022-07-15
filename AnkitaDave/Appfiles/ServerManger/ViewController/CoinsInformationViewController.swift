//
//  CoinsInformationViewController.swift
//  Poonam Pandey
//
//  Created by RazrTech2 on 29/11/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit

class CoinsInformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showAnimate()
    }
    
    @IBAction func Cancel(_ sender: Any) {
        
        removeAnimate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
