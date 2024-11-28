import UIKit

final class RandomQuoteViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var quoteLabel = QuoteLabel(color: .label, fontSize: 24)
    private lazy var authorLabel = QuoteLabel(color: .secondaryLabel, fontSize: 18)
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var scrollView = UIScrollView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
        getRandomQuote()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        getRandomQuote()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        title = "Random Quote"
        
        refreshControl.addTarget(self, action: #selector(refreshQuote), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(quoteLabel)
        scrollView.addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            quoteLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            quoteLabel.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            authorLabel.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 10),
            authorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    // MARK: - Network
    private func getRandomQuote() {
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
    
    // MARK: - Actions
    @objc private func refreshQuote() {
        getRandomQuote()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    return RandomQuoteViewController()
}
