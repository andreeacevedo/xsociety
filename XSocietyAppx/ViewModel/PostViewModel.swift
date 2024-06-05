//
//  PostViewModel.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/20/24.
//

import UIKit

struct PostViewModel {
    let post: Post
    let user: User
    
    var profileImageUrl: URL?{
        return user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: post.timestamp, to: now) ?? "2m"
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " ∙ \(timestamp)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    init(post: Post) {
        self.post = post
        self.user = post.user
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let medidaLabel = UILabel()
        medidaLabel.text = post.caption
        medidaLabel.numberOfLines = 0
        medidaLabel.lineBreakMode = .byWordWrapping
        medidaLabel.translatesAutoresizingMaskIntoConstraints = false
        medidaLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return medidaLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
