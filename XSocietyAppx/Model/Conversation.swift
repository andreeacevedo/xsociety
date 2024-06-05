//  Conversation.swift
//  XSocietyAppx
//
//  Created by Administrador on 4/30/24.
//

import Foundation
import Firebase

struct Conversation {
    let id: String
    let participants: [String]
    let lastMessage: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.participants = dictionary["participants"] as? [String] ?? []
        self.lastMessage = dictionary["lastMessage"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

