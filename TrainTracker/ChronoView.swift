//
//  ChronoView.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 13/05/2024.
//

import SwiftUI

class ChronoViewModel: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    
    private var timer: Timer?
    private let userDefaults = UserDefaults.standard
    
    init() {
        let savedTime = userDefaults.double(forKey: "savedTime")
        if savedTime > 0 {
            elapsedTime = savedTime
        }
        
        let isRunning = userDefaults.bool(forKey: "isRunning")
        if isRunning {
            start()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func start() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.elapsedTime += 0.01
            self?.saveTime()
        }
        isRunning = true
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        saveTime()
    }
    
    func reset() {
        stop()
        elapsedTime = 0
        saveTime()
    }
    
    private func saveTime() {
        userDefaults.set(elapsedTime, forKey: "savedTime")
        userDefaults.set(isRunning, forKey: "isRunning")
    }
    
    @objc private func applicationDidEnterBackground() {
        saveTime() // Sauvegarder le temps lorsque l'application entre en arrière-plan
    }
}


struct ChronoView: View {
    @ObservedObject var viewModel = ChronoViewModel()
    @Binding var isTimerActive: Bool
    
    var body: some View {
        VStack {
            Text(String(format: "%02d:%02d:%02d",
                        Int(viewModel.elapsedTime) % 3600 / 60,
                        Int(viewModel.elapsedTime) % 60,
                        Int(viewModel.elapsedTime.truncatingRemainder(dividingBy: 1) * 100)))
            .font(Font.system(size: 60, design: .monospaced))
            .fixedSize(horizontal: true, vertical: true)
            
            HStack {
                Button(action: {
                    if viewModel.isRunning {
                        viewModel.stop()
                    } else {
                        viewModel.start()
                    }
                }) {
                    Text(viewModel.isRunning ? "Stop" : "Start")
                }
                
                Button(action: {
                    viewModel.reset()
                    viewModel.stop()
                    self.isTimerActive = false
                    
                }) {
                    Text("Continuer l'entraînement")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .onAppear(){
            viewModel.elapsedTime = 0
            viewModel.start()
        }
        .onDisappear {
            // Mettre à jour isTimerActive pour fermer la vue modale
            isTimerActive = false
        }
    }
}

#Preview {
    ChronoView(isTimerActive: .constant(true))
}
