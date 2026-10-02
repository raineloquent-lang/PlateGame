import SwiftUI

@main
struct PlateGameApp: App {
    @StateObject private var state = GameState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
                .preferredColorScheme(.dark)
                .onAppear { state.load() }
        }
    }
}

/// UIKit-обёртка для полного игнора safe area
struct RootView: UIViewControllerRepresentable {
    @EnvironmentObject var state: GameState
    
    func makeUIViewController(context: Context) -> UIHostingController<AnyView> {
        let hosting = UIHostingController(
            rootView: AnyView(
                MainGameView().environmentObject(state)
            )
        )
        hosting.view.backgroundColor = .black
        return hosting
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<AnyView>,
                                context: Context) {
        // Принудительно убираем safe area
        uiViewController.additionalSafeAreaInsets = .zero
        uiViewController.view.insetsLayoutMarginsFromSafeArea = false
        uiViewController.viewRespectsSystemMinimumLayoutMargins = false
    }
}
