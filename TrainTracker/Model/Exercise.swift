//
//  Exercise.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import Foundation
import SwiftData
import _SwiftData_SwiftUI

@Model
final class Exercise {
    @Attribute(.unique)
    var id: UUID = UUID()  // Identifiant unique de l'exercice
    var name: String      // Nom de l'exercice
    var muscleGroup: String // Groupe musculaire ciblé par l'exercice
    var duration: Int?     // Durée de l'exercice en minutes ou secondes
    var sets: Int?        // Nombre de séries (optionnel)
    var reps: Int?        // Nombre de répétitions par série (optionnel)
    var weight: Double?   // Poids utilisé pour l'exercice (optionnel)
    var notes: String?    // Notes ou commentaires sur l'exercice (optionnel)
    var isDone: Bool
    /*@Relationship(deleteRule: .cascade)*/ var owner: TrainingExercise?
    
    @Attribute(.externalStorage)
    var image: Data?      // Image associée à l'exercice (optionnel)
    
    init(name: String,
         muscleGroup: String,
         duration: Int? = nil,
         sets: Int? = nil,
         reps: Int? = nil,
         weight: Double? = nil,
         notes: String? = nil,
         owner: TrainingExercise? = nil) {
        
        self.name = name
        self.muscleGroup = muscleGroup
        self.duration = duration
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.notes = notes
        self.isDone = false
        self.owner = owner
    }
}
