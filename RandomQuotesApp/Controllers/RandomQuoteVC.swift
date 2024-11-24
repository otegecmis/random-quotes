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
        QuotesService().fetchRandomQuote { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quote):
                DispatchQueue.main.async {
                    self.quoteLabel.text = quote.quote
                    self.authorLabel.text = quote.author
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
                }
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    return RandomQuoteVC()
}
