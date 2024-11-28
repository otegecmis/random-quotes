import UIKit

final class SignInViewController: UIViewController {
    
    // MARK: - Properties
    public let authHeaderView = AuthHeaderView(title: "Sign In", icon: "person")
    
    private let emailTextField = RQTextField(placeholder: "Email")
    private let passwordTextField = RQTextField(placeholder: "Password", isSecureTextEntry: true)
    private let signInButton = RQButton(title: "Sign In", fontColor: .systemBackground, bgColor: .label)
    private let forgotPasswordButton = RQButton(title: "Forgot Password?", fontColor: .label, bgColor: .systemBackground)
    private let createAccountButton = RQButton(title: "Create Account", fontColor: .label, bgColor: .systemBackground)
        
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authHeaderView, emailTextField, passwordTextField, signInButton, forgotPasswordButton])
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
    
    // Deinitializer
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        view.addSubview(createAccountButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            createAccountButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            createAccountButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
        ])
        
        passwordTextField.tintColor = UIColor.clear
        forgotPasswordButton.layer.borderWidth = 0
        signInButton.isEnabled = false
        signInButton.alpha = 0.8
        configureTextFields()
    }
    
    private func configureTextFields() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func updateSignInButtonState() {
        let isEmailEmpty = emailTextField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.isEmpty ?? true
        
        signInButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
        signInButton.alpha = signInButton.isEnabled ? 1 : 0.8
    }
    
    // MARK: - Actions
    @objc private func signInTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        let credentials = ["email": email, "password": password]
        
        if credentials["email"] == "" || credentials["password"] == "" {
            self.presentAlertOnMainThread(title: "Login Error", message: "Please don't leave any fields blank.", buttonTitle: "Done")
            return
        }
        
        AuthService.signIn(credentials: credentials) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    let mainTabController = MainTabController()
                    mainTabController.modalPresentationStyle = .fullScreen
                    
                    self.present(mainTabController, animated: true, completion: nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlertOnMainThread(title: "Login Error", message: error.localizedDescription, buttonTitle: "Done")
                }
            }
        }
    }
    
    @objc private func textFieldDidChange() {
        updateSignInButtonState()
    }
    
    @objc private func forgotPasswordTapped() {
        navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }
    
    @objc private func createAccountTapped() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    return SignInViewController()
}
