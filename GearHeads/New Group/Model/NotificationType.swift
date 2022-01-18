//
//  NotificationType.swift
//  GearHeads
//
//  Created by Stephen Dowless on 12/20/21.
//

import Foundation

enum NotificationType: Int {
    case like
    case follow
    case reply
    
    var notificationMessage: String {
        switch self {
        case .like:
            return " liked one of your revs"
        case .follow:
            return " started following you"
        case .reply:
            return " replied to one of your revs"
        }
    }
}
