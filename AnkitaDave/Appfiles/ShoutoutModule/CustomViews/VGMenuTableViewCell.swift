//
//  VGMenuTableViewCell.swift
//  AnveshiJain
//
//  Created by Apple on 10/10/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit

class VGMenuTableViewCell: UITableViewCell {

    var reloadHandler: ((Bool) -> ())?
    var greetingTitle: String? {
        didSet {
            vgTitleButton.setTitle(greetingTitle, for: .normal)
            vgTitleButton.setTitle(greetingTitle, for: .selected)
        }
    }

    @IBOutlet weak var mybookingsButton: UIButton!
    @IBOutlet weak var requestGreetingButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var vgTitleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vgTitleButton.titleLabel?.font = ShoutoutFont.light.withSize(size: .small)
        requestGreetingButton.titleLabel?.font = ShoutoutFont.light.withSize(size: .small)
        mybookingsButton.titleLabel?.font = ShoutoutFont.light.withSize(size: .small)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapVideoGreetingsTitle(_ sender: UIButton) {
        if ShoutoutConfig.UserDefaultsManager.shouldShowWelcomeScreen(), let viewController = viewContainingController() {
            let shoutoutWelcome = Storyboard.videoGreetings.instantiateViewController(viewController: ShoutoutWelcomeViewController.self)
            shoutoutWelcome.greetingTitle = greetingTitle
            viewController.navigationController?.pushViewController(shoutoutWelcome, animated: true)
        } else if ShoutoutConfig.isUserLoggedIn() {
            sender.isSelected = !sender.isSelected
            arrowImageView.image = !sender.isSelected ? #imageLiteral(resourceName: "dropdown") : #imageLiteral(resourceName: "dropDownDown")
        } else if !ShoutoutConfig.isUserLoggedIn() {
            viewContainingController()?.showAlert(message: Messages.loginAlertMsg)
        }
        reloadHandler?(sender.isSelected)
    }
    
    @IBAction func didTapRequestGreeting(_ sender: UIButton) {
        if let viewController = viewContainingController() {
            let shoutoutWelcome = Storyboard.videoGreetings.instantiateViewController(viewController: ShoutoutWelcomeViewController.self)
            shoutoutWelcome.navigateTo = .toRequestGreeting
            shoutoutWelcome.greetingTitle = greetingTitle
            let vgHome = Storyboard.videoGreetings.instantiateViewController(viewController: VideoGreetingsViewController.self)
            vgHome.greetingTitle = greetingTitle
            let landingPage = ShoutoutConfig.UserDefaultsManager.shouldShowWelcomeScreen() ? shoutoutWelcome : vgHome
            viewController.navigationController?.pushViewController(landingPage, animated: true)
        }
    }
    
    @IBAction func didTapMyBookings(_ sender: UIButton) {
        if let viewController = viewContainingController() {
            let greetings = Storyboard.videoGreetings.instantiateViewController(viewController: MyGreetingsViewController.self)
            let shoutoutWelcome = Storyboard.videoGreetings.instantiateViewController(viewController: ShoutoutWelcomeViewController.self)
            shoutoutWelcome.navigateTo = .toMyGreetings
            shoutoutWelcome.greetingTitle = greetingTitle
            let landingPage = ShoutoutConfig.UserDefaultsManager.shouldShowWelcomeScreen() ? shoutoutWelcome : greetings
            viewController.navigationController?.pushViewController(landingPage, animated: true)
        }
    }
}
