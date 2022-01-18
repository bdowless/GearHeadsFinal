//
//  ProfileHeaderViewModel.swift
//  GearHeads
//
//  Created by Brandon Dowless on 8/19/21.
//

import UIKit

struct ProfileHeaderViewModel {
    
    // MARK: - Properties
    
    private let user: User
    
    let usernameText: String
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading"
    }
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        
        self.usernameText = "@" + user.username
    }
    
    // MARK: - Helpers
    
    func followersString(valueColor: UIColor, textColor: UIColor) -> NSAttributedString {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers",
                              valueColor: valueColor, textColor: textColor)

    }
    
    func followingString(valueColor: UIColor, textColor: UIColor) -> NSAttributedString {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following",
                              valueColor: valueColor, textColor: textColor)
    }
    
    fileprivate func attributedText(withValue value: Int, text: String,
                                    valueColor: UIColor, textColor: UIColor) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
            attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor: valueColor])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                               .foregroundColor: textColor]))
        return attributedTitle
    }
}
