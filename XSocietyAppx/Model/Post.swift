//
//  Post.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/20/24.
//

import Foundation

struct Post {
    let caption: String
    let postID: String
    let uid: String
    let likes: Int
    var timestamp: Date!
    let retweetCount: Int
    let user: User
    let imageUrl: String?
    
    init(user:User, postID: String,  dictionary: [String: Any]) {
        self.postID = postID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""

        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
