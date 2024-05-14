//
//  RootView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 02/05/2024.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        
        ZStack{
            ContentView(showSigningView: $showSignInView)
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
           
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

//#Preview {
//    RootView()
//}
