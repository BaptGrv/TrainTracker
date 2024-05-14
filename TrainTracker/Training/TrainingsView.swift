//
//  TrainingView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import SwiftUI
import SwiftData

struct TrainingCard: View {
    let training: Training
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(training.name)
                    .font(.title) // Augmenter la taille de la police du titre
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Nombre d'exercices: \(training.exercises.count)")
                    .font(.headline) // Augmenter la taille de la police des détails
                    .foregroundColor(.secondary)
                
            }
           
        }
        .padding(.vertical, 16) // Ajouter un remplissage horizontal
    }
}
    

struct TrainingsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Training.name) private var trainings: [Training]
    @State private var createNewTraining = false
    
    var body: some View{
        NavigationStack {
            if trainings.isEmpty {
                ContentUnavailableView("Entrez votre premier entrainement", systemImage: "figure.run.square.stack.fill")
            }
            List{
                ForEach(trainings) { training in
                        TrainingCard(training: training)
                            .background(NavigationLink("",destination: TrainingDetailView(training: training)).opacity(0.0))
                }
                .onDelete { indexSet in
                    withAnimation {
                        indexSet.forEach { index in
                            let training = trainings[index]
                            context.delete(training)
                        }
                    }
                }
            }
            .listRowSpacing(20)
            .navigationTitle("Entrainements")
            .toolbar{
                Button(action: {
                    createNewTraining = true
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
            .sheet(isPresented: $createNewTraining){
                NewTrainingView()
            }
        }
    }
}


#Preview {
    TrainingsView()
        .modelContainer(for: Training.self, inMemory: true)
}
