import UIKit

class ProfileVC: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Profile"
        
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    // MARK: - Actions
    @objc private func logoutTapped() {
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            let signInVC = SignInVC()
            let navController = UINavigationController(rootViewController: signInVC)
            
            navController.modalPresentationStyle = .fullScreen
            
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    return ProfileVC()
}
