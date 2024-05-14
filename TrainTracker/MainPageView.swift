//
//  MainPageView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 30/04/2024.
//

import SwiftUI
import SwiftData
import Foundation

@MainActor
final class MainPageViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var FirestoreFriendsSessions: [FirestoreSession] = []
    @Published private(set) var userFriends: [DBUser] = []
    @Published private(set) var lastTraining: FirestoreSession? = nil
    
    func loadCurrentUser() async throws{
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        self.lastTraining = try await UserManager.shared.getLastTrainingSession(userId: authDataResult.uid)
    }
    
    func getUserFriend() async throws {
        guard let user else { return }
        
        Task{
            let userFriends = try await UserManager.shared.getUserFriends(userId: user.userId)
            self.userFriends = userFriends
        }
    }
    
    func getLastTrainingSession(userId: String) async throws{
    
        let userSessions = try await UserManager.shared.getLastTrainingSession(userId: userId)
        if let userSessions = userSessions{
            self.FirestoreFriendsSessions += [userSessions]
        }
    }
    
    func clearFirestoreFriendsSessions(){
        self.FirestoreFriendsSessions = []
    }
    
    func getLastTraining() async throws{
        guard let user = user else { return }
        
        _ = try AuthenticationManager.shared.getAuthenticatedUser()
        let userSessions = try await UserManager.shared.getAllTrainingSessions(userId: user.userId)
        if userSessions.isEmpty {
            self.lastTraining = nil
        }else{
            self.lastTraining = userSessions[0]
        }
        
    }
}


struct MainPageView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var sessions: [TrainingSession]
    @State private var showSignInView: Bool = false
    @StateObject private var viewModel = MainPageViewModel()
    @StateObject private var historyViewModel = HistorySessionViewModel()
    let today = Calendar.current.startOfDay(for: Date())
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("TrainTracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                if viewModel.user != nil {
                    // Afficher la date de la dernière session d'entraînement de l'utilisateur
                    if viewModel.lastTraining != nil {
                        let calendar = Calendar.current
                        let date1 = today
                        let date2 = viewModel.lastTraining?.date ?? Date()
                        let difference = calendar.dateComponents([.day], from: date2, to: date1)
                        if difference.day == 0 {
                            Text("Votre derniere session d'entraînement date d'aujourd'hui")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, 20)
                        }
                        else{
                            Text("Votre dernière session d'entraînement date de \(difference.day ?? 0) jours")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, 20)
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                    if viewModel.FirestoreFriendsSessions.isEmpty {
                        Text("Aucun entraînement trouvé pour vos amis")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                    }else{
                        // Section "Derniers entraînements de vos amis"
                        Section("Derniers entraînements de vos amis") {
                            List {
                                ForEach(viewModel.FirestoreFriendsSessions.indices, id: \.self) { index in
                                    let session = viewModel.FirestoreFriendsSessions[index]
                                    let friendIndex = min(index, viewModel.userFriends.count - 1)
                                    let friend = viewModel.userFriends[friendIndex]
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(friend.pseudo ?? "Inconnu")
                                        SessionCard(session: session)
                                    }
                                }
                            }
                            .listRowSpacing(20)
                            .textCase(.none)
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    }
                }
                Spacer()
            }
            .toolbar {
                NavigationLink(destination: SettingsView(showSignInView: $showSignInView)) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                }
                NavigationLink(destination: AddFriendsView()) {
                    Image(systemName: "person.fill.badge.plus")
                        .imageScale(.large)
                }
            }
            .onAppear() {
                Task{
                    do{
                        viewModel.clearFirestoreFriendsSessions()
                        try await viewModel.loadCurrentUser()
                        try await viewModel.getUserFriend()
                        for friend in viewModel.userFriends {
                            try await viewModel.getLastTrainingSession(userId: friend.userId)
                        }
                        try await viewModel.getLastTraining()
                    }
                }
            }
        }
    }
}








#Preview {
    MainPageView()
}
