import UIKit

class MainTabController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

@available(iOS 17.0, *)
#Preview {
    return MainTabController()
}
