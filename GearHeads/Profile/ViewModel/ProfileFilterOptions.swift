//
//  ProfileFilterOptions.swift
//  GearHeads
//
//  Created by Stephen Dowless on 12/20/21.
//

import Foundation

enum ProfileFilterOptions: Int, CaseIterable {
    case revs
    case replies
    case likes
    
    var description: String {
        switch self {
        case .revs: return "Revs"
        case .replies: return "Revs & Replies"
        case .likes: return "Likes"
        }
    }
}
