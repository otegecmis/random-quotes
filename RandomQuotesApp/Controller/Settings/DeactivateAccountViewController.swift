import UIKit

class DeactivateAccountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Deactivate Account"
    }
}
