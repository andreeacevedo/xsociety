//  Message.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/12/24.
//

import Foundation
import Firebase

struct Message {
    let text: String
    let fromId: String
    let toId: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
