//
//  Activity.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/20/24.
//

import Foundation
import FirebaseFirestore

struct Activity {
    let id: String
    let title: String
    let date: Date
    
    init(id: String, title: String, date: Date) {
        self.id = id
        self.title = title
        self.date = date
    }
    
    init?(document: [String: Any]) {
        guard let id = document["id"] as? String,
              let title = document["title"] as? String,
              let timestamp = document["date"] as? Timestamp else {
            return nil
        }
        self.id = id
        self.title = title
        self.date = timestamp.dateValue()
    }
}
