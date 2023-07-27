import Data
import Domain
import Foundation
import ServiceLocator
import UIKit

@UIApplicationMain
final class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?

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
        let listingViewController: ListingViewController = ServiceLocator.shared.get()
        let navController = UINavigationController(rootViewController: listingViewController)
        navController.navigationBar.tintColor = .orange
        window.rootViewController = navController
        window.makeKeyAndVisible()
        return true
    }
}
