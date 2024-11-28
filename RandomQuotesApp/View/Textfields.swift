import UIKit

class RQTextField: UITextField {
    
    // MARK: - Initializers
    init(placeholder: String, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        
        if isSecureTextEntry {
            self.isSecureTextEntry = true
        }
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        borderStyle = .roundedRect
        autocapitalizationType = .none
        clearButtonMode = .always
    }
}
