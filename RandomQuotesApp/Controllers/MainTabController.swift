import UIKit

final class MainTabController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    // MARK: - Helpers
    private func configureViewControllers() {
        view.backgroundColor = .systemBackground
        
        let randomQuoteVC = tabController(title: "Random Quote", image: UIImage(systemName: "quote.bubble"), rootViewController: RandomQuoteVC())
        viewControllers = [randomQuoteVC]
    }
}

// MARK: - UITabBarController+Extension
extension UITabBarController {
    
    // MARK: - Helpers
    func tabController(title: String, image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        
        nav.view.backgroundColor = .systemBackground
        nav.tabBarItem.image = image
        nav.title = title
        
        UITabBar.appearance().tintColor = .label
        
        return nav
    }
}

@available(iOS 17.0, *)
#Preview {
    return MainTabController()
}
