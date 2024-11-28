import UIKit

class UpdateNameSurnameViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        title = "Update Name Surname"
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

@available(iOS 17.0, *)
#Preview {
    UpdateNameSurnameViewController()
}
