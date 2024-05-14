//
//  TrainingExercise.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 19/04/2024.
//

import Foundation
import SwiftData

@Model
final class TrainingExercise {
    @Attribute(.unique)
    var id = UUID()
    var weight: Double
    var reps: Int
    var sets: Int
    /*@Relationship(deleteRule: .cascade)*/ var exercise: Exercise
    
    init(weight: Double, reps: Int, sets: Int , exercise: Exercise) {  // Changer le type du paramètre à Exercise
        self.weight = weight
        self.reps = reps
        self.exercise = exercise  // Affecter directement l'Exercise fourni
        self.sets = sets
    }
}

