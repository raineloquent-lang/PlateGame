import SwiftUI

@main
struct PlateGameApp: App {
    @StateObject private var state = GameState()
    
    var body: some Scene {
        WindowGroup {
            MainGameView()
                .environmentObject(state)
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
                .ignoresSafeArea(.all)   // ← ВОТ ЭТА СТРОЧКА!
                .onAppear { state.load() }
        }
    }
}
