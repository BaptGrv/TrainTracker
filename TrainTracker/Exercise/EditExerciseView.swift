//
//  EditExerciseView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import SwiftUI

struct EditExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    let exercise: Exercise
    @State private var name = ""
    @State private var muscleGroup = ""
    @State private var weight = 0.0
    @State private var firstView = true
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Modifier l'exercice")
                .font(.title)
                .fontWeight(.bold)
                .padding()
         
            TextField("Nom de l'exercice", text: $name)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 10).stroke())
                .padding(.horizontal, 40)
            
            TextField("Groupe musculaire", text: $muscleGroup)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 10).stroke())
                .padding(.horizontal, 40)
            
            
            Spacer()
            
        }
        .navigationBarTitle("Modifier l'exercice", displayMode: .inline)
        .toolbar{
            if changed{
                Button("Mettre à jour"){
                    exercise.name = name
                    exercise.muscleGroup = muscleGroup
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear() {
            name = exercise.name
            muscleGroup = exercise.muscleGroup
            weight = exercise.weight ?? 0.0
        }
        
        var changed : Bool{
            name != exercise.name
            || muscleGroup != exercise.muscleGroup
        }
    }
}


//#Preview {
//    NavigationStack {
//        EditExerciseView()
//    }
//}
