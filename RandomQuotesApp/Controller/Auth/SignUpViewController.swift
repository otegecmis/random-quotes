import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        title = "Sign Up"
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
}
