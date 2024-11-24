import UIKit

class AuthButton: UIButton {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, fontColor: UIColor, bgColor: UIColor) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(fontColor, for: .normal)
        backgroundColor = bgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
