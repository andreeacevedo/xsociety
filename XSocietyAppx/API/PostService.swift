//
//  PostService.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/13/24.
//

import Firebase
import UIKit

struct PostService {
    static let shared = PostService()
    
    func subirPost(caption: String, image: UIImage?, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String : Any]
        
        if let image = image {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            let filename = NSUUID().uuidString
            let ref = Storage.storage().reference(withPath: "/post_images/\(filename)")
            
            ref.putData(imageData, metadata: nil) { (meta, error) in
                if let error = error {
                    completion(error, DatabaseReference())
                    return
                }
                
                ref.downloadURL { (url, error) in
                    guard let imageUrl = url?.absoluteString else { return }
                    values["imageUrl"] = imageUrl
                    
                    let ref = REF_POSTS.childByAutoId()
                    ref.updateChildValues(values) { (error, ref) in
                        guard let postID = ref.key else { return }
                        REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
                    }
                }
            }
        } else {
            let ref = REF_POSTS.childByAutoId()
            ref.updateChildValues(values) { (error, ref) in
                guard let postID = ref.key else { return }
                REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }
    }
    
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        REF_POSTS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let postID = snapshot.key

            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    func fetchPosts(forUser user: User, completion: @escaping([Post]) -> Void) {
        var posts = [Post]()

        REF_USER_POSTS.child(user.uid).observe(.childAdded) { snapshot in
            let postID = snapshot.key
            
            REF_POSTS.child(postID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let postID = snapshot.key

                UserService.shared.fetchUser(uid: uid) { user in
                    let post = Post(user: user, postID: postID, dictionary: dictionary)
                    posts.append(post)
                    completion(posts)
                }
            }
        }
    }
}
