import UIKit

class UpdateMailViewController: UIViewController {
    
    // MARK: - Properties
    private let emailTextField = RQTextField(placeholder: "Email")
    private let newEmailTextField = RQTextField(placeholder: "New Email")
    private let actionButton = RQButton(title: "Update", fontColor: .systemBackground, bgColor: .label)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, newEmailTextField, actionButton])
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        title = "Email"
        
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Actions
    @objc func actionTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            presentAlertOnMainThread(title: "Empty Email", message: "Please enter your email.", buttonTitle: "Ok")
            return
        }
        
        guard let newEmail = newEmailTextField.text, !newEmail.isEmpty else {
            presentAlertOnMainThread(title: "Empty New Email", message: "Please enter your new email.", buttonTitle: "Ok")
            return
        }
        
        debugPrint("DEBUG: actionTappped()")
    }
}

@available(iOS 17.0, *)
#Preview {
    UpdateMailViewController()
}
