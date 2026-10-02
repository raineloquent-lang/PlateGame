import SwiftUI
import UIKit

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

struct RootView: UIViewControllerRepresentable {
    @EnvironmentObject var state: GameState
    
    func makeUIViewController(context: Context) -> UIViewController {
        let hosting = UIHostingController(
            rootView: AnyView(
                MainGameView().environmentObject(state)
            )
        )
        hosting.view.backgroundColor = UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 1.0)
        
        // ═══ ЯДЕРНЫЙ ФИКС — растягиваем view на весь экран ═══
        hosting.view.insetsLayoutMarginsFromSafeArea = false
        hosting.viewRespectsSystemMinimumLayoutMargins = false
        hosting.additionalSafeAreaInsets = .zero
        
        // Отключаем safe area на уровне navigation
        hosting.view.overrideUserInterfaceStyle = .dark
        
        return hosting
    }
    
    func updateUIViewController(_ uiViewController: UIViewController,
                                context: Context) {
        // Принудительно каждый раз
        uiViewController.view.insetsLayoutMarginsFromSafeArea = false
        uiViewController.additionalSafeAreaInsets = .zero
        
        // Растянуть фрейм на весь window
        if let window = uiViewController.view.window {
            uiViewController.view.frame = window.bounds
            uiViewController.view.setNeedsLayout()
            uiViewController.view.layoutIfNeeded()
        }
    }
}
