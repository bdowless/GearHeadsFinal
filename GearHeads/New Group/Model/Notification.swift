//
//  Notification.swift
//  GearHeads
//
//  Created by Brandon Dowless on 12/16/21.
//

import Firebase

struct Notification {
    let uid: String
    let notificationID: String
    let timestamp: Int
    let type: NotificationType
    let user: User
    
    init(notificationID: String, user: User, dictionary: [String: AnyObject]) {
        self.notificationID = notificationID
        self.user = user
        
        self.timestamp = dictionary["timestamp"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type) ?? .like
        } else {
            self.type = .like
        }
    }
    
}

