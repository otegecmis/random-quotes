import UIKit

class QuoteLabel: UILabel {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor, fontSize: CGFloat) {
        super.init(frame: .zero)
        
        textColor = color
        font = UIFont(name: "AmericanTypewriter", size: fontSize)
        
        configure()
    }
    
    // MARK: - Helpers
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        textAlignment = .center
        numberOfLines = 0
    }
}
