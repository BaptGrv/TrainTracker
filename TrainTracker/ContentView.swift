//
//  ContentView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingTrainingSelection = false
    @Query(sort: \Training.name) private var trainings: [Training]
    @Environment(\.dismiss) var dismiss
    @Binding var showSigningView: Bool
    @State private var createNewExercise = false
    
    
    
    var body: some View {
        
        if showSigningView {
            AuthenticationView(showSignInView: $showSigningView)
        }else{
            TabView(){
                
                MainPageView()
                    .tabItem {
                        Label("Accueil", systemImage: "house")
                    }
                    
                
                ExercisesView()
                    .tabItem {
                        Label("Exercices", systemImage: "dumbbell.fill")
                    }
                    
                
                TrainingsView()
                    .tabItem {
                        Label("Entrainements", systemImage: "figure.strengthtraining.traditional")
                    }
                    
                
                HistorySessionView()
                    .tabItem {
                        Label("Historique", systemImage: "list.clipboard")
                    }
                    
            }
        }
    }
}


#Preview {
    ContentView(showSigningView: .constant(false))
}
