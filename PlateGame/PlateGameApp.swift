import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let state = GameState()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let content = MainGameView()
            .environmentObject(state)
            .preferredColorScheme(.dark)
        
        let hosting = UIHostingController(rootView: content)
        hosting.view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = hosting
        window.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
        window.makeKeyAndVisible()
        
        self.window = window
        state.load()
        
        return true
    }
}
