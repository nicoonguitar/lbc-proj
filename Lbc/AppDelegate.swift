import Data
import Domain
import Foundation
import ServiceLocator
import UIKit

@UIApplicationMain
final class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?

    var coordinator: MainCoordinator?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // DI setup
        DataAssembly.register(serviceLocator: .shared)
        DomainAssembly.register(serviceLocator: .shared)
        AppAssembly.register(serviceLocator: .shared)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return true }
        coordinator = ServiceLocator.shared.get() as MainCoordinator
        coordinator?.start()
        window.rootViewController = coordinator?.navigationController
        window.makeKeyAndVisible()
        // Disables dark mode
        window.overrideUserInterfaceStyle = .light
        return true
    }
}
