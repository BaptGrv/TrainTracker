//
//  EditTrainingExerciseView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 20/04/2024.
//

import SwiftUI

struct EditTrainingExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    let trainingExercise: TrainingExercise
    @State private var weight = 0.0
    @State private var reps = 0
    @State private var sets = 0
    @State private var firstView = true
    var body: some View {
        
        VStack{
            LabeledContent{
                TextField("", value: $weight, formatter: NumberFormatter())
            } label: {
                Text("Poids : ").foregroundStyle(.secondary)
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(RoundedRectangle(cornerRadius: 10).stroke())
            .padding(.horizontal, 40)
            
            LabeledContent{
                TextField("", value: $reps, formatter: NumberFormatter())
            } label: {
                Text("Répétitions : ").foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(RoundedRectangle(cornerRadius: 10).stroke())
            .padding(.horizontal, 40)
            
            LabeledContent{
                TextField("", value: $sets, formatter: NumberFormatter())
            } label: {
                Text("Séries : ").foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(RoundedRectangle(cornerRadius: 10).stroke())
            .padding(.horizontal, 40)
        }
        .navigationTitle("Modifier l'exercice")
        .toolbar{
            if changed{
                Button("Mettre à jour"){
                    trainingExercise.weight = weight
                    trainingExercise.reps = reps
                    trainingExercise.sets = sets
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear(){
            weight = trainingExercise.weight
            reps = trainingExercise.reps
            sets = trainingExercise.sets
            
        }
    }
    
    var changed : Bool{
        weight != trainingExercise.weight
        || reps != trainingExercise.reps
        || sets != trainingExercise.sets
    }
}

//#Preview {
//    EditTrainingExerciseView()
//}
