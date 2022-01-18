//
//  EditProfileController.swift
//  GearHeads
//
//  Created by Brandon Dowless on 12/17/21.
//

import UIKit

protocol EditProfileControllerDelegate: AnyObject {
    
}

class EditProfileController: UIViewController {
    
    private let user: User
    
    var delegate: EditProfileControllerDelegate?
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
