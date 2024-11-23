import UIKit

final class RandomQuoteVC: UIViewController {
    
    // MARK: - Properties
    private lazy var quoteLabel = QuoteLabel(color: .label, fontSize: 24)
    private lazy var authorLabel = QuoteLabel(color: .secondaryLabel, fontSize: 18)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
        getRandomQuote()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRandomQuote()
    }
    
    // MARK: - Helpers
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Random Quote"
    }
    
    func configureUI() {
        view.addSubview(quoteLabel)
        view.addSubview(authorLabel)
        
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            quoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            authorLabel.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 10),
            authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func getRandomQuote() {
        quoteLabel.text = "The only way to do great work is to love what you do."
        authorLabel.text = "Steve Jobs"
    }
}

@available(iOS 17.0, *)
#Preview {
    return RandomQuoteVC()
}
