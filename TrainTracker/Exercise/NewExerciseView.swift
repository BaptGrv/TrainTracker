//
//  NewExerciseView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 18/04/2024.
//

import SwiftUI

struct NewExerciseView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var muscleGroup = ""
    var body: some View {
        NavigationStack{
            Form{
                TextField("Nom", text: $name)
                TextField("Groupe musculaire", text: $muscleGroup)
                Button("Créer"){
                    let newExercise = Exercise(name: name, muscleGroup: muscleGroup)
                    context.insert(newExercise)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(name.isEmpty || muscleGroup.isEmpty)
                .navigationTitle("Nouvel exercice")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .cancellationAction){
                        Button("Annuler"){
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewExerciseView()
}
