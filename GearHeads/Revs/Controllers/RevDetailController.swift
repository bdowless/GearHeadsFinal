//
//  TweetController.swift
//  GearHeads
//
//  Created by Brandon Dowless on 12/17/21.
//

import UIKit

private let reuseIdentifier = "RevCell"
private let headerIdentifier = "RevHeader"

class RevDetailController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let rev: Rev
    private var actionSheetLauncher: ActionSheetLauncher!
    private var replies = [Rev]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    init(rev: Rev) {
        self.rev = rev
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - API
    
    func fetchReplies() {
        RevService.shared.fetchReplies(forRev: rev) { replies in
            self.replies = replies
        }
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = "Rev"
        
        collectionView.backgroundColor = .white
        
        collectionView.register(RevCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
}

// MARK: - UICollectionViewDataSource

extension RevDetailController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RevCell
        cell.rev = replies[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension RevDetailController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
        header.rev = rev
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RevDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = RevViewModel(rev: rev)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - TweetHeaderDelegate

extension RevDetailController: RevHeaderDelegate {
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(uid: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showActionSheet() {
        if rev.user.isCurrentUser {
            showActionSheet(forUser: rev.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: rev.user.uid) { isFollowed in
                var user = self.rev.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
    }
}

// MARK: - ActionSheetLauncherDelegate

extension RevDetailController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                print("DEBUG: Did follow user \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                print("DEBUG: Did unfollow user \(user.username)")
            }
        case .report:
            print("DEBUG: Report tweet")
        case .delete:
            print("DEBUG: Delete tweet..")
        }
    }
}
