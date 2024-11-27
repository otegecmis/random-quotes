import UIKit

class RQTextField: UITextField {
    
    // MARK: - Initializers
    init(placeholder: String, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.autocapitalizationType = .none
        self.clearButtonMode = .always
        
        if isSecureTextEntry {
            self.isSecureTextEntry = true
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
