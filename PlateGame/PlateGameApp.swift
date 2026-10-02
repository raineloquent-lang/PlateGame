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
        
        let hosting = FullScreenHostingController(rootView: content)
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

class FullScreenHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insetsLayoutMarginsFromSafeArea = false
        viewRespectsSystemMinimumLayoutMargins = false
    }
    
    override var prefersStatusBarHidden: Bool { true }
    override var prefersHomeIndicatorAutoHidden: Bool { true }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        additionalSafeAreaInsets = .zero
    }
}
