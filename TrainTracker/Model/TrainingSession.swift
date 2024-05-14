//
//  TrainingSession.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 25/04/2024.
//

import Foundation
import SwiftData

@Model
final class TrainingSession {
    @Attribute(.unique)
    var id: UUID = UUID()  // Identifiant unique de la séance
    var date: Date        // Date de la séance
    var duration: Double?     // Durée de la séance
    /*@Relationship(deleteRule: .cascade)*/ var training: Training?
    
    init(date: Date, training: Training, duration: Double) {
        self.date = date
        self.training = training
        self.duration = duration
    }
}
