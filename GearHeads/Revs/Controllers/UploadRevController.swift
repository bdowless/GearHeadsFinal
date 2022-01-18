//
//  UploadTweetController.swift
//  GearHeads
//
//  Created by Brandon Dowless on 9/24/21.
//

import UIKit
import ActiveLabel

class UploadRevController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User
    private let config: UploadRevConfiguration
    private lazy var viewModel = UploadRevViewModel(config: config)
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Post", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemRed, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadRev), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        return iv
    }()
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .RevRed
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: - Lifecycle
    
    init(user: User, config: UploadRevConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMentionHandler()
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadRev() {
        guard let caption = captionTextView.text else { return }
            
        RevService.shared.uploadRev(caption: caption, type: config) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload tweet with error \(error.localizedDescription)")
                return
            }

            if case .reply(let tweet) = self.config {
//                NotificationService.shared.uploadNotification(toUser: tweet.user,
//                                                              type: .reply,
//                                                              revID: tweet.revID)
            }
            
            self.uploadMentionNotification(forCaption: caption, revID: ref.key)

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - API
    
    fileprivate func uploadMentionNotification(forCaption caption: String, revID: String?) {
        guard caption.contains("@") else { return }
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        
        words.forEach { word in
            guard word.hasPrefix("@") else { return }
            
            var username = word.trimmingCharacters(in: .symbols)
            username = username.trimmingCharacters(in: .punctuationCharacters)
            
            UserService.shared.fetchUser(uid: username) { mentionedUser in
//                NotificationService.shared.uploadNotification(toUser: mentionedUser,
//                                                              type: .mention,
//                                                              revID: revID)
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 16, paddingLeft: 16,
                     paddingRight: 16)
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholder.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .systemRed
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func configureMentionHandler() {
        replyLabel.handleMentionTap { mention in
            print("DEBUG: Mentioned user is \(mention)")
        }
    }
}
