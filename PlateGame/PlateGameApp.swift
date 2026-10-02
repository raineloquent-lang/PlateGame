import SwiftUI

@main
struct PlateGameApp: App {
    @StateObject private var state = GameState()
    
    var body: some Scene {
        WindowGroup {
            MainGameView()
                .environmentObject(state)
                .preferredColorScheme(.dark)
                .onAppear { state.load() }
        }
    }
}
