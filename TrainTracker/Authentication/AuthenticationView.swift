//
//  AuthenticationView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 02/05/2024.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        VStack{
            Spacer()
            NavigationLink{
                SignInView(showSignInView: $showSignInView)
                
            }label:{
                Text("Se Connecter")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Connexion")
    }
            
   
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
