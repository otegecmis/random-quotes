import UIKit

final class MainTabController: UITabBarController {
    
    // MARK: - Lifecycle
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
        
        let randomQuoteVC = tabController(title: "Random Quote", image: UIImage(systemName: "quote.bubble"), rootViewController: RandomQuoteVC())
        let profileVC = tabController(title: "Profile", image: UIImage(systemName: "person.bubble"), rootViewController: ProfileVC())
        
        viewControllers = [randomQuoteVC, profileVC]
    }
    
    private func showSignInScreen() {
        let signInVC = SignInVC()
        let navController = UINavigationController(rootViewController: signInVC)
        
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
