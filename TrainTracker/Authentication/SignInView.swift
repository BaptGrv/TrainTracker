//
//  SignInView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 02/05/2024.
//

import SwiftUI



final class SignInViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var pseudo = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email and password are required")
            return
        }
        
     
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult, pseudo: pseudo)
        
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email and password are required")
            return
        }
        
        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        } catch {
            print("Error : \(error)")
        }
    }
}

struct SignInView: View {
    
    @StateObject private var viewModel = SignInViewModel()
    @Environment(\.dismiss) private var dismiss
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            
            TextField("pseudo...", text: $viewModel.pseudo)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .padding(.horizontal)
            
            SecureField("mot de passe...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button{
                Task{
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print("Error : \(error)")
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print("Error : \(error)")
                    }
                }
            }label: {
                Text("Se Connecter")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
                
        }
        .padding()
        .navigationTitle("Connexion")
    }
}

#Preview {
    NavigationStack {
        SignInView(showSignInView: .constant(false))
    }
}
