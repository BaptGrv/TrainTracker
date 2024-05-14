//
//  TrainingDetailView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import SwiftUI
import SwiftData

struct TrainingExerciseCard: View {
    let trainingExercise: TrainingExercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(trainingExercise.exercise.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Poids (kg)" )
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text("\(trainingExercise.weight, specifier: "%.2f")")
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Répétitions")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text("\(trainingExercise.reps)")
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Séries")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text("\(trainingExercise.sets)")
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.vertical, 16) // Ajouter un remplissage horizontal
    }
}


struct TrainingDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let training: Training
    @State private var exercises: [Exercise] = []
    @State private var isShowingSelectExerciseView = false
    @Query private var allExercises: [Exercise]
    @State private var selectedExercise: Exercise?
    @State private var selectedWeight: Double = 0
    @State private var selectedReps: Int = 0
    @State private var selectedSets: Int = 0
    @Query private var trainingExercises: [TrainingExercise]
    
    var body: some View {
        NavigationStack {
            VStack{
                if trainingExercises.isEmpty {
                    ContentUnavailableView("Ajouter un exercice à votre entraînement", systemImage: "dumbbell.fill")
                } else {
                    List {
                        let exercises = training.exercises
                        ForEach(exercises) { exercise in
                            TrainingExerciseCard(trainingExercise: exercise)
                                .background(NavigationLink("",destination: EditTrainingExerciseView(trainingExercise: exercise)).opacity(0.0))
                            
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let trainingExercise = trainingExercises[index]
                                modelContext.delete(trainingExercise)
                            }
                        }
                    }
                }
            }
            .listRowSpacing(20)
            .navigationTitle("Exercises")
            .toolbar{
                if !trainingExercises.isEmpty {
                    NavigationLink(destination: TrainingSessionView(training: training)){
                        Text("Lancer l'entrainement")
                    }
                }
    
                Button{
                    isShowingSelectExerciseView = true
                    selectedReps = 0
                    selectedSets = 0
                    selectedWeight = 0
                }label : {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
            
            .sheet(isPresented: $isShowingSelectExerciseView) {
                SelectExerciseView(
                    training: training,
                    selectedWeight: $selectedWeight,
                    selectedReps: $selectedReps,
                    selectedSets: $selectedSets,
                    selectedExercise: $selectedExercise
                )
            }
        }
    }
}




//#Preview {
//    TrainingDetailView()
//}
