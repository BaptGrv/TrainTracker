//
//  NewTrainingView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 18/04/2024.
//

import SwiftUI

struct NewTrainingView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var muscleGroup = ""
    var body: some View {
        NavigationStack{
            Form{
                TextField("Nom", text: $name)
                Button("Créer"){
                    let newTraining = Training(name: name, date: Date())
                    context.insert(newTraining)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(name.isEmpty)
                .navigationTitle("Nouvel entrainement")
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
    NewTrainingView()
}
