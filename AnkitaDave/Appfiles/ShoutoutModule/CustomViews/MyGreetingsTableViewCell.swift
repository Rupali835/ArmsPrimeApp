//
//  MyGreetingsTableViewCell.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit
import AVKit

class MyGreetingsTableViewCell: UITableViewCell {

    // MARK: - Constants.
    
    // MARK: - Properties.
    fileprivate var tapGesture: UITapGestureRecognizer!
    var greetingData: GreetingList? {
        didSet {
            setupGreetingStatus()
        }
    }
    
    // MARK: - IBOutlets.
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var videoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        videoImageView.contentMode = .scaleAspectFill
        [orderIdLabel, greetingsLabel].forEach { (label) in
            label?.font = ShoutoutFont.light.withSize(size: .small)
        }
        currentStatusLabel.font = ShoutoutFont.regular.withSize(size: .small)
        timestampLabel.font = ShoutoutFont.light.withSize(size: .smaller)
        orderIdLabel.adjustsFontSizeToFitWidth = true
        timestampLabel.adjustsFontSizeToFitWidth = true
        
        videoImageView.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapVideoThumbnail))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc fileprivate func didTapVideoThumbnail(_ sender: UIGestureRecognizer) {
        switch greetingData?.order {
        case .request(let status, _)?:
            if status == .greetingReceived {
                ShoutoutUtilities.playVideoInAVPlayerController(videoUrl: greetingData?.video?.url, delegate: self)
            }
            
        default: break
        }
    }
    
    fileprivate func setupGreetingStatus() {
        videoImageView.removeGestureRecognizer(tapGesture)
        guard let greeting = greetingData?.order else { return }
        
        switch greeting {
        case .request(let status, let data):
            
            orderIdLabel.text = "Order ID - " + (data?.passbook_id ?? "")
            
            timestampLabel.text = data?.created_at?.toDateString(fromFormat: .yyyyMMddHHmmss, toFormat: .ddMMMYYYYhhmm)
            greetingsLabel.text = #""\#(data?.message ?? "")""#
            
            switch status {
            case .greetingReceived:
                currentStatusLabel.text = "RECEIVED"
                currentStatusLabel.textColor = #colorLiteral(red: 0.1278283894, green: 0.5185144544, blue: 0.1342647076, alpha: 1)
                
                if let thumbnail = data?.video?.cover, let url = URL(string: thumbnail) {
                    videoImageView.sd_setImage(with: url, completed: nil)
                } else {
                    videoImageView.image = nil
                }
                
                videoImageView.addGestureRecognizer(tapGesture)
                
            case .pending:
                currentStatusLabel.text = "PENDING"
                currentStatusLabel.textColor = #colorLiteral(red: 0.9926999211, green: 0.7809402943, blue: 0, alpha: 1)
                videoImageView.image = nil
                
            case .paymentSuccessful:
                currentStatusLabel.text = "PAYMENT SUCCESSFUL"
                currentStatusLabel.textColor = #colorLiteral(red: 0.1278283894, green: 0.5185144544, blue: 0.1342647076, alpha: 1)
                videoImageView.image = nil
                
            case .denied:
                currentStatusLabel.text = "DECLINED"
                currentStatusLabel.textColor = #colorLiteral(red: 0.9109638929, green: 0.05280861259, blue: 0, alpha: 1)
                videoImageView.image = nil
            }
            
        case .send(_, _): break
        }
    }
}

// MARK: - AVPlayerViewController Delegate.
extension MyGreetingsTableViewCell: AVPlayerViewControllerDelegate {
}

