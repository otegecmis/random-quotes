import UIKit

extension ForgotPasswordViewController {
    
    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 3
                self.authHeaderView.hideIconImageView()
                self.navigationController?.navigationBar.isHidden = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            self.authHeaderView.showIconImageView()
            self.navigationController?.navigationBar.isHidden = false
        }
    }
}
