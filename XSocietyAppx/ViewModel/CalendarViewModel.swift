//
//  CalendarViewModel.swift
//  XSocietyAppx
//
//  Created by Administrador on 5/20/24.
//

import Foundation
import FirebaseFirestore

class CalendarViewModel {
    var activities = [Activity]()

    func fetchActivities(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("activities").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching activities: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.activities = documents.compactMap { document -> Activity? in
                return Activity(document: document.data())
            }
            completion()
        }
    }

    func addActivity(title: String, date: Date) {
        let db = Firestore.firestore()
        let newActivity = Activity(id: UUID().uuidString, title: title, date: date)
        db.collection("activities").document(newActivity.id).setData([
            "id": newActivity.id,
            "title": newActivity.title,
            "date": Timestamp(date: newActivity.date)
        ]) { error in
            if let error = error {
                print("Error adding activity: \(error.localizedDescription)")
            }
        }
    }
}
