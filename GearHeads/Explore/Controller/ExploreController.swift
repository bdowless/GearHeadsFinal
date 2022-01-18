//
//  ExploreController.swift
//  GearHeads
//
//  Created by Brandon Dowless on 6/12/21.
//

import UIKit

class ExploreController: UITableViewController {

    //MARK: Properties
    
    private let reuseIdentifier = "Cell"
    
    private var users = [User]()
    
    //MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }
    
    //MARK: API
    
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    //MARK: Helpers
    
    func configureUI() {
        tableView.rowHeight = 64
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Explore"
    }
}

extension ExploreController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
