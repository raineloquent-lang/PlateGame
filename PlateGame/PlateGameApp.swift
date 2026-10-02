import SwiftUI
import UIKit

@main
struct PlateGameApp: App {
    // Подключаем наш AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            // Заглушка, потому что всё делает AppDelegate
            EmptyView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var state = GameState() // Создаём состояние здесь
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 1. Создаём SwiftUI-представление и передаём в него состояние
        let content = MainGameView()
            .environmentObject(state)
            .preferredColorScheme(.dark)
        
        // 2. Оборачиваем в UIKit-контроллер
        let hosting = UIHostingController(rootView: content)
        
        // 3. Настраиваем фон (чтобы не было чёрных полос, если градиент не долетит)
        hosting.view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
        
        // 4. ⚡️ КЛЮЧЕВОЙ МОМЕНТ: Создаём окно с точными размерами экрана
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = hosting
        window.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}
