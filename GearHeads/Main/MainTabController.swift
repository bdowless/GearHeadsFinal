//
//  MainTabController.swift
//  GearHeads
//
//  Created by Brandon Dowless on 6/12/21.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    //MARK: Properties
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers()
            print("DEBUG:\(user)")
        }
    }

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.setImage(#imageLiteral(resourceName: "new_tweet"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 56/2
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.tintColor = .systemRed
        configureActionButton()
        authenticateUserAndConfigureUI()
    }
    
    //MARK: -API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { (user) in
            print("DEBUG: user has been fetched")
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureActionButton()
            fetchUser()
        }
    }
    
    //MARK: Selectors
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: UploadRevController(user: user, config: .rev))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: Helpers

    func configureViewControllers() {
        
        guard let user = self.user else { return }
    
//        let feed = templateController(image: #imageLiteral(resourceName: "home_unselected-1"), rootViewController: FeedController(user: user))
        
        let feed = templateController(image: UIImage(systemName: "house"), rootViewController: FeedController(user: user))
        
        let explore = UINavigationController(rootViewController: ExploreController())
        explore.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let notifications = UINavigationController(rootViewController: NotificationsController())
        notifications.tabBarItem.image = UIImage(systemName: "bell")
        
        let profile = UINavigationController(rootViewController: ProfileController(user: user))
        profile.tabBarItem.image = UIImage(systemName: "person")
        
        viewControllers = [feed, explore, notifications, profile]
        
    }
    
    func templateController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        return nav
    }
    
    func configureActionButton() {
        view.addSubview(actionButton)
        actionButton.heightAnchor.constraint(equalToConstant: 56) .isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 56) .isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64) .isActive = true
        actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16) .isActive = true
    }
}
