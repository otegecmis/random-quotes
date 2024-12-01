import UIKit

extension UIViewController {

    // MARK: - Actions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
