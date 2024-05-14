//
//  ExercisesView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import SwiftUI
import SwiftData

struct ExerciseCard: View {
    let exercise: Exercise // L'exercice à afficher
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(exercise.name)
                    .font(.title) // Augmenter la taille de la police du titre
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Groupe musculaire: \(exercise.muscleGroup)")
                    .font(.headline) // Augmenter la taille de la police des détails
                    .foregroundColor(.secondary)
                
            }
           
        }
        .padding(.vertical, 16) // Ajouter un remplissage horizontal
    }
}




struct ExercisesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Exercise.muscleGroup) private var exercises: [Exercise]
    @State private var createNewExercise = false
    var body: some View{
        NavigationStack{
            if exercises.isEmpty {
                ContentUnavailableView("Entrez votre premier exercice", systemImage: "dumbbell.fill")
            }
            List{
                ForEach(exercises) { exercise in
                    ExerciseCard(exercise: exercise)
                        .background(NavigationLink("",destination: EditExerciseView(exercise: exercise)).opacity(0.0))
                    
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let exercise = exercises[index]
                        context.delete(exercise)
                    }
                }
            }
            .listRowSpacing(20)
            .navigationTitle("Exercises")
            .toolbar{
                Button{
                    createNewExercise = true
                }label : {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
            .sheet(isPresented: $createNewExercise){
                NewExerciseView()
            }
        }
    }
}

   
#Preview {
    ExercisesView()
        .modelContainer(for: Exercise.self, inMemory: true)
}
