//
//  PerfilHeaderViewModel.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/22/24.
//

import UIKit

enum PerfilFilterOptions: Int, CaseIterable {
    case post
    case replies
    case likes
    
    var description: String {
        switch self {
        case .post: return "Posts"
        case .replies: return "Media"
        case .likes: return "Likes"
        }
    }
}

struct PerfilHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followerString: NSAttributedString? {
        return attributedText(withValue: 2, text: "Seguidores")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 2, text: "Siguiendo")
    }
    
    var actionBuuttonTittle: String{
        if user.isCurrentUser {
            return "Editar Perfil"
        } else {
            return "Seguir"
        }
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: " \(value)",
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(text)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        return attributedText
        
        }
}
