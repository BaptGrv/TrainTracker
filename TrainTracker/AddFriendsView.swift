//
//  AddFriendsView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 08/05/2024.
//

import SwiftUI

@MainActor
final class AddFriendsViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var userFriends: [DBUser] = []
    
    func loadCurrentUser() async throws{
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func getAllUsers() async throws {
        guard user != nil else { return }
        
        let userFriends = try await UserManager.shared.getAllUsers()
        self.userFriends = userFriends
    }
    
    func addUserFriend(friendId: String){
        guard let user else { return }
        
        Task{
            try await UserManager.shared.addUserFriend(userId:user.userId, friendId: friendId)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func removeUserFriend(friendId: String){
        guard let user else { return }
        
        Task{
            try await UserManager.shared.removeUserFriend(userId:user.userId, friendId: friendId)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
}


struct AddFriendsView: View {
    @StateObject private var viewModel = AddFriendsViewModel()
    
    private func friendIsSelected(friendId: String) -> Bool{
        viewModel.user?.friends?.contains(friendId) == true
    }
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(viewModel.userFriends, id: \.userId) { friend in
                    if friend.userId != viewModel.user?.userId {
                        HStack {
                            Text(friend.pseudo ?? "")
                            
                            Spacer() // Pour pousser le bouton à droite
                            
                            Button(action: {
                                if friendIsSelected(friendId: friend.userId) {
                                    viewModel.removeUserFriend(friendId: friend.userId)
                                } else {
                                    viewModel.addUserFriend(friendId: friend.userId)
                                }
                            }) {
                                Image(systemName: friendIsSelected(friendId: friend.userId) ? "minus.circle.fill" : "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(friendIsSelected(friendId: friend.userId) ? .green : .red)
                            }
                            .padding(.trailing)
                        }
                        .padding(.horizontal) // Ajoutez un remplissage horizontal pour l'espacement
                    }
                }
            }
            .listRowSpacing(2)
            .navigationTitle("Suivre des amis")
        }
        .task{
            do {
                try await viewModel.loadCurrentUser()
                try await viewModel.getAllUsers()
            } catch {
                print(error)
            }
        }
    }
        
}

#Preview {
    AddFriendsView()
}
