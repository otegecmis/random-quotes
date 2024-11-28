import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        title = "Forgot Password"
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

