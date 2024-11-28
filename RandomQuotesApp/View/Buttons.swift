import UIKit

class RQButton: UIButton {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, fontColor: UIColor, bgColor: UIColor, height: CGFloat = 50) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(fontColor, for: .normal)
        backgroundColor = bgColor
        heightAnchor.constraint(equalToConstant: height).isActive = true
        
        configure()
    }
    
    // MARK: - Helpers
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 5
        layer.borderWidth = 1
        
        
    }
}
