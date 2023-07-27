import Coordinator
import Foundation
import ServiceLocator
import UIKit

final class MainCoordinator: Coordinator {
    enum NavigationAction {
        case showClassifiedAdDetail(id: Int64)
        case showCategories
        case dismissCategories
    }
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController = UINavigationController()
    
    private let serviceLocator: ServiceLocator
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        navigationController.navigationBar.tintColor = .orange
    }
    
    func start() {
        let viewController: ListingViewController = serviceLocator.get(arg: self)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func onNavigationAction(_ action: NavigationAction, origin: UIViewController) {
        switch action {
        case .showClassifiedAdDetail(let id):
            let detailVC: ClassifiedAdDetailViewController = serviceLocator.get(arg: id)
            navigationController.pushViewController(detailVC, animated: true)
            
        case .showCategories:
            /*
             CategoriesViewController only has a back action already handled by UIKit so I did not define a child Coordinator
             to keep things simple and keep what UIKit provides for free.
             */
            let categoriesVC: CategoriesViewController = serviceLocator.get(arg: self)
            let navController = UINavigationController(rootViewController: categoriesVC)
            navController.modalPresentationStyle = .formSheet
            navController.isModalInPresentation = true
            origin.present(navController, animated: true)
            
        case .dismissCategories:
            guard origin is CategoriesViewController else { return }
            origin.dismiss(animated: true)
        }
    }
}
