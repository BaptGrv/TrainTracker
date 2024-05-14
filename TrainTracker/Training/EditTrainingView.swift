//
//  EditTrainingView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import SwiftUI

struct EditTrainingView: View {
    @Bindable var training: Training
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $training.name)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal, 40)
                
                DatePicker("Date", selection: $training.date)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    .padding(.horizontal, 40)
                
            }
            
        }
        .navigationTitle("Edit Training")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    EditTrainingView()
//}
