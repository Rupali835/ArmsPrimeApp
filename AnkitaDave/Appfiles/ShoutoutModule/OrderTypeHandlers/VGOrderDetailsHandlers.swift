//
//  OrderDetailsHandlers.swift
//  VideoGreetings
//
//  Created by Apple on 24/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation
import UIKit

enum GreetingRequestOrderStatus {
    case paymentSuccessful
    case pending
    case greetingReceived
    case denied
    
    func totalCells() -> Int {
        switch self {
        case .paymentSuccessful:
            return 2
        case .pending:
            return 3
        case .greetingReceived:
            return 4
        case .denied:
            return 4
        }
    }
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath, cellData: GreetingList? = nil, greetingType: GreetingOrderType, greetingData: GreetingList?) -> UITableViewCell? {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withCell: VGRequestDetailsTableViewCell.self)
            cell?.configureCell(greetingData: greetingData)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withCell: VGPaymentSuccessfulTableViewCell.self)
            cell?.configureCell(greetingData: greetingData)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withCell: VGPendingTableViewCell.self)
            cell?.configureCell(greetingData: greetingData)
            return cell
        case 3:
            
            if self == .greetingReceived {
                let cell = tableView.dequeueReusableCell(withCell: VGReceivedTableViewCell.self)
                cell?.configureCell(greetingData: greetingData)
                return cell
            } else if self == .denied {
                let cell = tableView.dequeueReusableCell(withCell: VGDeclinedTableViewCell.self)
                cell?.configureCell(greetingData: greetingData)
                return cell
            } else {
                return nil
            }
        default: return nil
        }
    }
}

enum GreetingSendOrderStatus {
    case paymentSuccessful
    case pending
    case sent
    case receivedReply
    case declined
    
    func totalCells() -> Int {
        switch self {
        case .paymentSuccessful:
            return 2
        case .pending:
            return 3
        case .sent:
            return 4
        case .receivedReply:
            return 5
        case .declined:
            return 4
        }
    }
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath, cellData: GreetingList? = nil, greetingType: GreetingOrderType, greetingData: GreetingList?) -> UITableViewCell? {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withCell: VGSendDetailsTableViewCell.self)
            cell?.configureCell(greetingData: greetingData)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withCell: VGPaymentSuccessfulTableViewCell.self)
            cell?.configureCell(greetingData: greetingData)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withCell: VGPendingTableViewCell.self)
            cell?.configureCell(greetingData: greetingData)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withCell: self == .sent ? VGApprovedTableViewCell.self : VGDeclinedTableViewCell.self)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withCell: VGFeedbackTableViewCell.self)
            return cell
            
        default: return nil
        }
    }
}

indirect enum GreetingOrderType {
    case request(status: GreetingRequestOrderStatus, greetingData: GreetingList?)
    case send(status: GreetingSendOrderStatus, greetingData: GreetingList?)
    
    func totalCells() -> Int {
        switch self {
        case .request(let status, _):
            return status.totalCells()
            
        case . send(let status, _):
            return status.totalCells()
        }
    }
    
    func getCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        switch self {
        case .request(let status, let greetingData):
            return status.dequeueCell(tableView: tableView, indexPath: indexPath, greetingType: self, greetingData: greetingData)
            
        case . send(let status, let greetingData):
            return status.dequeueCell(tableView: tableView, indexPath: indexPath, greetingType: self, greetingData: greetingData)
        }
    }
    
    static func getOrderFromStatusKey(status: String?, greetingData: GreetingList) -> GreetingOrderType? {
        
        if let orderStatus = status {
            switch orderStatus {
            case OrderStatusKeys.pending, OrderStatusKeys.processing, OrderStatusKeys.submitted:
                return GreetingOrderType.request(status: .pending, greetingData: greetingData)
            case OrderStatusKeys.completed:
                return GreetingOrderType.request(status: .greetingReceived, greetingData: greetingData)
            case OrderStatusKeys.denied:
                return GreetingOrderType.request(status: .denied, greetingData: greetingData)
                
            default: return nil
            }
        } else { return nil }
    }
}

// From Backend.
struct OrderStatusKeys {
    static let pending = "pending"
    static let received = "received"
    static let processing = "processing"
    static let submitted = "submitted"
    static let completed = "completed"
    static let denied = "rejected"
}
