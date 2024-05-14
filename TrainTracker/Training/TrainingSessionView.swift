//
//  TrainingSessionView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 26/04/2024.
//

import SwiftUI
import SwiftData

@MainActor
final class TrainingSessionViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func addTrainingSession(session: TrainingSession){
        
        Task{
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addTrainingSession(userId:authDataResult.uid, session: session)
        }
    }
}

struct ExerciseCardView: View {
    let exercise: Exercise
    let setsRemaining: Int
    let weight: Double
    let reps: Int
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(exercise.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Poids (kg)" )
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text("\(weight, specifier: "%.2f")")
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Répétitions")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text("\(reps)")
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Séries restantes")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text("\(setsRemaining)")
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.vertical, 16) // Ajouter un remplissage horizontal
    }
}


struct NextExerciseCardView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(exercise.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Groupe musculaire : \(exercise.muscleGroup)")
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 16) // Ajouter un remplissage horizontal
    }
}

struct TrainingSessionView: View {
    @Environment(\.modelContext) private var modelContext
    let training: Training
    @State private var currentExerciseIndex: Int = 0
    @State private var setsRemaining: Int = 0
    @StateObject private var viewModel = TrainingSessionViewModel()
    @State private var isTimerActive: Bool = false
    @State private var start = Date()
    @State private var stop = Date()
    
    var body: some View {
        
        
        VStack(spacing: 20) {
            
            if !isTimerActive{
                
                if currentExerciseIndex != training.exercises.count-1 || setsRemaining != 0{
                    
                    Text("Séance \(training.name)")
                        .font(.largeTitle)
                    
                    Text("Nombre d'exercices : \(training.exercises.count)")
                        .font(.headline)
                    
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Exercice actuel : ")
                                .font(.title3)
                                .padding(.bottom, 8)
                            
                            ExerciseCardView(exercise: training.exercises[currentExerciseIndex].exercise,
                                             setsRemaining:  setsRemaining,
                                             weight: training.exercises[currentExerciseIndex].weight,
                                             reps: training.exercises[currentExerciseIndex].reps)
                            .padding()
                            .frame(maxWidth: 350, alignment: .leading)
                            
                        }
                    }
                    
                    Button(action: {
                        if setsRemaining > 0 {
                            setsRemaining -= 1
                            isTimerActive = true
                        }
                        if currentExerciseIndex < training.exercises.count - 1 && setsRemaining == 0{
                            currentExerciseIndex += 1
                            setsRemaining = training.exercises[currentExerciseIndex].sets
                        }
                    }) {
                        Text ("Valider la série")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    
                    if currentExerciseIndex < training.exercises.count - 1 {
                        Section(){
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Exercice à venir : ")
                                    .font(.title3)
                                    .padding(.bottom, 8)
                                
                                NextExerciseCardView(exercise: training.exercises[currentExerciseIndex + 1].exercise)
                                    .padding()
                                    .frame(maxWidth: 350, alignment: .leading)
                            }
                        }
                    }
                }
                
                if currentExerciseIndex == training.exercises.count-1 && setsRemaining == 0{
                    Text("Félicitations, vous avez terminé votre séance \(training.name)!")
                        .font(.title)
                        .padding()
                        .foregroundColor(.green)
                    Button("Ajouter la séance à l'historique") {
                        stop = Date()
                        let diff = stop.timeIntervalSince(start)
                        let trainingSession = TrainingSession(date: Date(), training: training, duration: diff)
                        viewModel.addTrainingSession(session: trainingSession)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
        }
        .onAppear(){
            setsRemaining = training.exercises[currentExerciseIndex].sets
            start = Date()
        }
        .padding()
        .fullScreenCover(isPresented: $isTimerActive) {
            NavigationStack{
                ChronoView(isTimerActive: $isTimerActive)
                
            }
        }
    }
}


//#Preview {
//    TrainingSessionView()
//}


