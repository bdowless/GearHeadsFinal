//
//  ConversationsController.swift
//  GearHeads
//
//  Created by Brandon Dowless on 6/12/21.
//

import UIKit

class ConversationsController: UIViewController {

    //MARK: Properties
    
    //MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}

