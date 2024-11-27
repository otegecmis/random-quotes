import UIKit

final class MainTabController: UITabBarController {
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUserLoggedIn() {
            configureViewControllers()
        } else {
            view.backgroundColor = .systemBackground
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isUserLoggedIn() {
            showSignInScreen()
        }
    }
    
    // MARK: - Helpers
    private func configureViewControllers() {
        view.backgroundColor = .systemBackground
       
        let profileViewController = tabController(title: "Profile", image: "person", viewController: ProfileViewController())
        let randomQuoteViewController = tabController(title: "Random Quote", image: "quote.bubble", viewController: RandomQuoteViewController())
        let settingsViewController = tabController(title: "Settings", image: "gearshape", viewController: SettingsViewController())
        
        viewControllers = [profileViewController, randomQuoteViewController, settingsViewController]
        selectedIndex = 1
    }
    
    private func showSignInScreen() {
        let signInViewController = SignInViewController()
        let navController = UINavigationController(rootViewController: signInViewController)
        
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    private func isUserLoggedIn() -> Bool {
        if let accessToken = UserDefaults.standard.string(forKey: "access_token"), !accessToken.isEmpty {
            return true
        }
        
        return false
    }
}

// MARK: - Extension
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

@available(iOS 17.0, *)
#Preview {
    return MainTabController()
}
