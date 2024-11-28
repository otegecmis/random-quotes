import UIKit

final class CreateQuoteViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var quoteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "AmericanTypewriter", size: 20)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.cornerRadius = 5
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var authorTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.cornerRadius = 5
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var createQuoteButton: RQButton = {
        let button = RQButton()
        button.setTitle("Create Quote", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .label
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        title = "Quote"
        createQuoteButton.addTarget(self, action: #selector(saveQuote), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(quoteTextView)
        view.addSubview(authorTextView)
        view.addSubview(createQuoteButton)
        
        NSLayoutConstraint.activate([
            quoteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            quoteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quoteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            quoteTextView.bottomAnchor.constraint(equalTo: authorTextView.topAnchor, constant: -10),
            
            authorTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            authorTextView.bottomAnchor.constraint(equalTo: createQuoteButton.topAnchor, constant: -10),
            authorTextView.heightAnchor.constraint(equalToConstant: 40),
            
            createQuoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createQuoteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createQuoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            createQuoteButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    // MARK: - Actions
    @objc private func saveQuote() {
        let quoteText = quoteTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let author = authorTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !quoteText.isEmpty else {
            presentAlertOnMainThread(title: "Error", message: "Quote cannot be empty.", buttonTitle: "Ok")
            return
        }
        
        guard !author.isEmpty else {
            presentAlertOnMainThread(title: "Error", message: "Author cannot be empty.", buttonTitle: "Ok")
            return
        }
        
        createQuoteButton.isEnabled = false
        createQuoteButton.setTitle("Saving...", for: .normal)
        
        QuotesService().createQuote(quoteText: quoteText, author: author) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.createQuoteButton.isEnabled = true
                self.createQuoteButton.setTitle("Create Quote", for: .normal)
                
                switch result {
                case .success(_):
                    self.presentAlertOnMainThread(title: "Ok", message: "Quote has been created successfully.", buttonTitle: "Ok") {
                        self.quoteTextView.text = ""
                        self.authorTextView.text = ""
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    self.presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
                }
            }
        }
    }
    
}

@available(iOS 17.0, *)
#Preview {
    CreateQuoteViewController()
}
