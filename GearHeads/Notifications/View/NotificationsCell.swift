//
//  NotificationsCell.swift
//  GearHeads
//
//  Created by Brandon Dowless on 12/16/21.
//

import UIKit

class notificationCell: UITableViewCell {
    
    var notifications: Notification? {
        didSet{configureCell()}
    }
    
    
    // MARK: - Properties
    
    var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .RevRed
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.widthAnchor.constraint(equalToConstant: 40) .isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40) .isActive = true
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        return profileImageView
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "spiderman"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textLabelType: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "spiderman"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10) .isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor) .isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15) .isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor) .isActive = true
        
        addSubview(textLabelType)
        textLabelType.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 2) .isActive = true
        textLabelType.centerYAnchor.constraint(equalTo: centerYAnchor) .isActive = true
    }
    
    func configureCell() {
        guard let notification = notifications else { return }
        profileImageView.sd_setImage(with: notification.user.profileImageUrl)
        usernameLabel.text = notification.user.username
        textLabelType.text = notification.type.notificationMessage
    }
}

