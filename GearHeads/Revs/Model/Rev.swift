//
//  Rev.swift
//  GearHeads
//
//  Created by Brandon Dowless on 9/24/21.
//

import Foundation

struct Rev {
    let caption: String
    let revID: String
    let uid: String
    var likes: Int
    var timestamp: Date!
    var didLike = false
    let user: User
    var replyingTo: String?
    
    var isReply: Bool { return replyingTo != nil }
    
    init(user: User, revID: String, dictionary: [String: Any]) {
        self.revID = revID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
        
    }
}
