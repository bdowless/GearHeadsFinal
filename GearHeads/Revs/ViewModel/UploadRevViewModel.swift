//
//  UploadTweetViewModel.swift
//  GearHeads
//
//  Created by Brandon Dowless on 12/17/21.
//

import Foundation

import UIKit

enum UploadRevConfiguration {
    case rev
    case reply(Rev)
}

struct UploadRevViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadRevConfiguration) {
        switch config {
        case .rev:
            actionButtonTitle = "Post"
            placeholderText = "What's happening?"
            shouldShowReplyLabel = false
        case .reply(let rev):
            actionButtonTitle = "Reply"
            placeholderText = "Post your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(rev.user.username)"
        }
    }
}

