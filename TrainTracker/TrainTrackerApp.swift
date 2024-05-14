//
//  TrainTrackerApp.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 16/04/2024.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct TrainTrackerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Training.self,
            TrainingExercise.self,
            Exercise.self,
            TrainingSession.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {

//                ContentView()
                RootView()
            
        }
        .modelContainer(sharedModelContainer)
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
      func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
      }
    }
}
