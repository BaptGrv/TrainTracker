//
//  Training.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import Foundation
import SwiftData

@Model
final class Training {
    @Attribute(.unique)
    var id: UUID = UUID()  // Identifiant unique de l'entraînement
    var name: String      // Nom de l'entraînement
    var date: Date         // Date de l'entraînement
   /* @Relationship(deleteRule: .cascade)*/ var exercises = [TrainingExercise]() // Exercices réalisés pendant l'entraînement
 

    init(name: String,
            date: Date) {
        
           self.name = name
           self.date = date
           
       }
}




