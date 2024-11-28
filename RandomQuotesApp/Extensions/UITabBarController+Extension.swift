import UIKit

extension UITabBarController {
    
    // MARK: - Helpers
    func tabController(title: String, image: String, viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        
        nav.view.backgroundColor = .systemBackground
        nav.tabBarItem.image = UIImage(systemName: image)
        nav.title = title
        
        UITabBar.appearance().tintColor = .label
        
        return nav
    }
}
