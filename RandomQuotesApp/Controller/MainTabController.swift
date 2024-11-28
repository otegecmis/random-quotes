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
            showSignIn()
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
    
    private func showSignIn() {
        let signInViewController = SignInViewController()
        let navigationController = UINavigationController(rootViewController: signInViewController)
        
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    private func isUserLoggedIn() -> Bool {
        if let accessToken = UserDefaults.standard.string(forKey: "access_token"), !accessToken.isEmpty {
            return true
        }
        
        return false
    }
}

@available(iOS 17.0, *)
#Preview {
    return MainTabController()
}
