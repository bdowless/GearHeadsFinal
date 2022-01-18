//
//  TweetService.swift
//  GearHeads
//
//  Created by Brandon Dowless on 8/28/21.
//

import Firebase

struct RevService {
    static let shared = RevService()
    
    func uploadRev(caption: String, type: UploadRevConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [KEY_CAPTION: caption,
                      KEY_TIMESTAMP: Int(NSDate().timeIntervalSince1970),
                      KEY_LIKES: 0,
                      KEY_UID: uid,
                      KEY_RETWEET_COUNT: 0] as [String : Any]
                
        switch type {
        case .reply(let rev):
            REF_REVS_REPLIES.child(rev.revID).childByAutoId().updateChildValues(values) { (err, ref) in
                guard let replyKey = ref.key else { return }
                REF_USER_REPLIES.child(uid).updateChildValues([rev.revID: replyKey], withCompletionBlock: completion)
            }
        case .rev:
            REF_REVS.childByAutoId().updateChildValues(values) { (err, ref) in
                guard let key = ref.key else { return }
                REF_USER_REVS.child(uid).updateChildValues([key: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func fetchRevs(completion: @escaping([Rev]) -> Void) {
        var revs = [Rev]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        REF_USER_FOLLOWING.child(currentUid).observe(.childAdded) { snapshot in
            let followingUid = snapshot.key

            REF_USER_REVS.child(followingUid).observe(.childAdded) { snapshot in
                let revID = snapshot.key

                self.fetchRevs(withrevID: revID) { rev in
                    revs.append(rev)
                    revs.sort(by: { $0.timestamp > $1.timestamp })
                    completion(revs)
                }
            }
        }

        REF_USER_REVS.child(currentUid).observe(.childAdded) { snapshot in
            let revID = snapshot.key

            self.fetchRevs(withrevID: revID) { rev in
                revs.append(rev)
                completion(revs)
            }
        }
    }
    
    func fetchRevs(withUid uid: String, completion: @escaping([Rev]) -> Void) {
        var revs = [Rev]()

        REF_USER_REVS.child(uid).observe(.childAdded) { snapshot in
            self.fetchRevs(withrevID: snapshot.key) { rev in
                revs.append(rev)
                completion(revs)
            }
        }
    }
    
    func fetchRevs(withrevID revID: String, completion: @escaping(Rev) -> Void) {
        REF_REVS.child(revID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let rev = Rev(user: user, revID: revID, dictionary: dictionary)
                completion(rev)
            }
        }
    }
    
    func fetchReplies(forUser user: User, completion: @escaping([Rev]) -> Void) {
        var replies = [Rev]()
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            let revKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            
            REF_REVS_REPLIES.child(revKey).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let replyID = snapshot.key
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let reply = Rev(user: user, revID: replyID, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    func fetchReplies(forRev tweet: Rev, completion: @escaping([Rev]) -> Void) {
        var revs = [Rev]()
        
        REF_REVS_REPLIES.child(tweet.revID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let revID = snapshot.key
                        
            UserService.shared.fetchUser(uid: uid) { user in
                let rev = Rev(user: user, revID: revID, dictionary: dictionary)
                revs.append(rev)
                completion(revs)
            }
        }
    }
    
    func fetchLikes(forUser user: User, completion: @escaping([Rev]) -> Void) {
        var revs = [Rev]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            let revID = snapshot.key
            self.fetchRevs(withrevID: revID) { likedRev in
                var rev = likedRev
                rev.didLike = true
                
                revs.append(rev)
                completion(revs)
            }
        }
    }
    
    func likeRev(rev: Rev, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = rev.didLike ? rev.likes - 1 : rev.likes + 1
        REF_REVS.child(rev.revID).child("likes").setValue(likes)
        
        if rev.didLike {
            // unlike tweet
            REF_USER_LIKES.child(uid).child(rev.revID).removeValue { (err, ref) in
                REF_REV_LIKES.child(rev.revID).removeValue(completionBlock: completion)
            }
        } else {
            // like tweet
            REF_USER_LIKES.child(uid).updateChildValues([rev.revID: 1]) { (err, ref) in
                REF_REV_LIKES.child(rev.revID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedRev(_ rev: Rev, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(rev.revID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}
