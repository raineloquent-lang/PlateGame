import SwiftUI

@main
struct PlateGameApp: App {
    @StateObject private var state = GameState()
    
    var body: some Scene {
        WindowGroup {
            MainGameView()
                .environmentObject(state)
                .preferredColorScheme(.dark)
                .statusBarHidden(true)                  // ← скрыть статус-бар
                .persistentSystemOverlays(.hidden)      // ← скрыть индикатор home
                .onAppear { state.load() }
        }
    }
}
