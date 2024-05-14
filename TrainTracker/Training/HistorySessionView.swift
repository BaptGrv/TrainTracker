//
//  TrainingSessionView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 25/04/2024.
//

import SwiftUI
import SwiftData

@MainActor
final class HistorySessionViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var FirestoreSessions: [FirestoreSession] = []
    
    
    func loadCurrentUser() async throws{
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    
    func getTrainingSessions() async throws{
        guard let user = user else { return }
        
        _ = try AuthenticationManager.shared.getAuthenticatedUser()
        let userSessions = try await UserManager.shared.getAllTrainingSessions(userId: user.userId)
        self.FirestoreSessions = userSessions
    }
}

struct SessionCard: View {
    let session: FirestoreSession
    @State private var isExpanded: Bool = false
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "EEEE d MMMM yyyy"
        return dateFormatter.string(from: session.date)
    }
        
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(session.name)
                    .font(.title) // Augmenter la taille de la police du titre
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Date: \(formattedDate)")
                    .font(.headline) // Augmenter la taille de la police des détails
                    .foregroundColor(.secondary)
                
                if isExpanded {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(session.exercises, id: \.id){ exercise in
                            HStack {
                                Text(exercise.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text("\(exercise.sets) x \(exercise.reps) | \(exercise.weight) kg")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        let trainingTime = Double(session.duration)
                        let hours = Int(trainingTime / 3600)
                        let minutes = Int((trainingTime.truncatingRemainder(dividingBy: 3600)) / 60)
                        
                        Text("Durée de l'entrainement")
                        Text("\(hours)h \(minutes)min")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            .onTapGesture {
                withAnimation{
                    isExpanded.toggle()
                }
            }
            .padding()
            
           
        }
        .padding(.vertical, 16) // Ajouter un remplissage horizontal
    }
}


struct HistorySessionView: View {
    @Environment(\.modelContext) private var context
    @State private var createNewTraining = false
    @StateObject private var viewModel = HistorySessionViewModel()
    
    
    var body: some View{
        NavigationStack {
            if viewModel.FirestoreSessions.isEmpty {
                ContentUnavailableView("Commencez votre premier entrainement", systemImage: "figure.run.square.stack.fill")
            }
            
            
            List{
                ForEach(viewModel.FirestoreSessions, id: \.id){ session in
                    SessionCard(session: session)
                }
            }
            .listRowSpacing(20)
            .navigationTitle("Entrainements réalisés")
            .onAppear(){
                Task {
                    do {
                        try await viewModel.loadCurrentUser()
                        try await viewModel.getTrainingSessions()
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}


#Preview {
    HistorySessionView()
        .modelContainer(for: TrainingSession.self, inMemory: true)
}
