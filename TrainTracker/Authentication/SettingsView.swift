//
//  SettingsView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 02/05/2024.
//

import SwiftUI

final class SettingsViewModel: ObservableObject{
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
        print("sign out")
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard authUser.email != nil else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword()
    }
    
    func updateEmail() async throws {
        let email = "newEmail@gmail.com"
        try await AuthenticationManager.shared.updateEmail(newEmail: email)
    }
    
    func updatePassword() async throws {
        let password = "newPassword"
        try await AuthenticationManager.shared.updatePassword(newPassword: password)
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List{
            NavigationStack{
                NavigationLink{
                    RootView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Se déconnecter")
                }
                .onTapGesture {
                    Task{
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                        } catch {
                            print("Error : \(error)")
                        }
                    }
                    
                }
            }
        }
        .navigationTitle("Paramètres")
    }
}
            
            
            
            
//            Button("Reset password"){
//                Task{
//                    do {
//                        try await viewModel.resetPassword()
//                        print("Passowrd reset")
//                    } catch {
//                        print("Error : \(error)")
//                    }
//                }
//            }
//            
//            Button("Update password"){
//                Task{
//                    do {
//                        try await viewModel.updatePassword()
//                        print("Passowrd reset")
//                    } catch {
//                        print("Error : \(error)")
//                    }
//                }
//            }
//            
//            Button("Update email"){
//                Task{
//                    do {
//                        try await viewModel.updateEmail()
//                        print("Passowrd reset")
//                    } catch {
//                        print("Error : \(error)")
//                    }
//                }
//            }
            
            
//        }
//    
//}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
