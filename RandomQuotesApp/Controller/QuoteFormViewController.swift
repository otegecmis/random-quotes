import UIKit

enum QuoteFormType {
    case create
    case update(existingQuote: String, existingAuthor: String)
}

class QuoteFormViewController: UIViewController {
    
    // MARK: - Properties
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let quoteTextField = RQTextField(placeholder: "Enter Quote")
    let authorTextField = RQTextField(placeholder: "Enter Author")
    
    let actionButton = RQButton(title: "Save", fontColor: .systemBackground, bgColor: .label)
    let cancelButton = RQButton(title: "Cancel", fontColor: .label, bgColor: .systemBackground)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, quoteTextField, authorTextField, actionButton, cancelButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var formTitle: String?
    var actionButtonTitle: String?
    var completion: ((_ quote: String, _ author: String) -> Void)?
    var formType: QuoteFormType
    var padding: CGFloat = 20
    
    // MARK: - Initializers
    init(title: String, actionButtonTitle: String, formType: QuoteFormType, completion: @escaping (_ quote: String, _ author: String) -> Void) {
        self.formTitle = title
        self.actionButtonTitle = actionButtonTitle
        self.formType = formType
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        configureUI()
        configureFormForUpdate()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        
        titleLabel.text = formTitle
        
        NSLayoutConstraint.activate([
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding)
        ])
        
        actionButton.addTarget(self, action: #selector(saveQuote), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        actionButton.layer.borderWidth = 0
        actionButton.setTitle(actionButtonTitle, for: .normal)
        cancelButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func configureFormForUpdate() {
        if case let .update(existingQuote, existingAuthor) = formType {
            quoteTextField.text = existingQuote
            authorTextField.text = existingAuthor
        }
    }
    
    // MARK: - Actions
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc private func saveQuote() {
        guard let quote = quoteTextField.text, !quote.isEmpty,
              let author = authorTextField.text, !author.isEmpty else {
            return
        }
        
        completion?(quote, author)
        dismiss(animated: true)
    }
}

// MARK: - Extensions
extension UIViewController {
    func presentQuoteFormAlert(
        title: String,
        actionButtonTitle: String,
        formType: QuoteFormType,
        completion: @escaping (_ quote: String, _ author: String) -> Void
    ) {
        DispatchQueue.main.async {
            let alertVC = QuoteFormViewController(title: title, actionButtonTitle: actionButtonTitle, formType: formType, completion: completion)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    QuoteFormViewController(
        title: "Update Quote",
        actionButtonTitle: "Update",
        formType: .update(existingQuote: "This is an existing quote.", existingAuthor: "Existing Author")
    ) { quote, author in
        print("Updated Quote: \(quote), Author: \(author)")
    }
}
