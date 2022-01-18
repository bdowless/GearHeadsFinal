//
//  NotificationsController.swift
//  GearHeads
//
//  Created by Brandon Dowless on 12/16/21.
//

import UIKit

class NotificationsController: UITableViewController {

    //MARK: Properties
    
    var notifications = [Notification]()
    let service = NotificationService()
    
    //MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    //MARK: Helpers
    
    func configureUI() {
        tableView.register(notificationCell.self, forCellReuseIdentifier: "Cell")
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }
}

// MARK: - API

extension NotificationsController {
    func fetchNotifications() {
        service.fetchNotifications { notifications in
            self.notifications = notifications
            self.tableView.reloadData()
        }
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!  notificationCell
        cell.notifications = notifications[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
}
