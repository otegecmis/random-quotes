import UIKit

class UpdatePasswordViewController: UIViewController {
    
    // MARK: - Properties
    private let passwordTextField = RQTextField(placeholder: "Password", isSecureTextEntry: true)
    private let newPasswordTextField = RQTextField(placeholder: "New Password", isSecureTextEntry: true)
    private let actionButton = RQButton(title: "Update", fontColor: .systemBackground, bgColor: .label)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordTextField, newPasswordTextField, actionButton])
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
        title = "Password"
        
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
        guard let password = passwordTextField.text, !password.isEmpty else {
            presentAlertOnMainThread(title: "Empty Password", message: "Please enter your password.", buttonTitle: "Ok")
            return
        }
        
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            presentAlertOnMainThread(title: "Empty New Password", message: "Please enter your new password.", buttonTitle: "Ok")
            return
        }
        
        debugPrint("DEBUG: actionTapped()")
    }
}

@available(iOS 17.0, *)
#Preview {
    UpdatePasswordViewController()
}
