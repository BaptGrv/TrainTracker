//
//  SelectExerciseView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import SwiftUI
import SwiftData

struct SelectExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var exercises: [Exercise]
    @State private var isShowingSelectionView = false
    let training: Training
    @Binding var selectedWeight: Double
    @Binding var selectedReps: Int
    @Binding var selectedSets: Int
    @Binding var selectedExercise: Exercise?
    
    let defaultExercise = Exercise(name: "test", muscleGroup: "test")
    
    var body: some View {
        VStack(spacing: 20) {
            List {
                ForEach(exercises) { exercise in
                    if !training.exercises.contains(where: { $0.exercise == exercise }) {
                        Button(action: {
                            selectedExercise = exercise
                            isShowingSelectionView.toggle()
                        }) {
                            Text(exercise.name)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle()) // Style de liste simple sans séparateurs
            
            Spacer()
        }
        .sheet(isPresented: $isShowingSelectionView) {
            
            VStack {
                Section(header: Text("Poids (kg)").padding(.leading)) {
                    TextField("Poids (kg)", value: $selectedWeight, formatter: NumberFormatter())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke())
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Répétitions").padding(.leading)) {
                    TextField("Répétitions", value: $selectedReps, formatter: NumberFormatter())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke())
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Séries").padding(.leading)) {
                    TextField("Séries", value: $selectedSets, formatter: NumberFormatter())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke())
                        .keyboardType(.numberPad)
                }
                
                Button("Ajouter l'exercice") {
                    let newEx = TrainingExercise(weight: selectedWeight, reps: selectedReps, sets: selectedSets, exercise: selectedExercise ?? defaultExercise)
                    modelContext.insert(newEx)
                    training.exercises.append(newEx)
                    isShowingSelectionView.toggle()
                    dismiss()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.vertical)
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Sélectionner un exercice", displayMode: .inline)
    }
}



//
//#Preview {
//    SelectExerciseView()
//}
