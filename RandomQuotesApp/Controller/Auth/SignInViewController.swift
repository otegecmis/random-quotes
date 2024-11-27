import UIKit

final class SignInViewController: UIViewController {
    
    // MARK: - Properties
    private let emailTextField = RQTextField(placeholder: "Email")
    private let passwordTextField = RQTextField(placeholder: "Password", isSecureTextEntry: true)
    
    private let signInButton = RQButton(title: "Sign In", fontColor: .systemBackground, bgColor: .label)
    private let forgotPasswordButton = RQButton(title: "Forgot Password", fontColor: .label, bgColor: .systemBackground)
    private let createAccountButton = RQButton(title: "Create Account", fontColor: .label, bgColor: .systemBackground)
    
    private let headerIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.bubble"))
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let headerMessage: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerIcon)
        view.addSubview(headerMessage)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(createAccountButton)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        NSLayoutConstraint.activate([
            headerIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            headerIcon.widthAnchor.constraint(equalToConstant: 80),
            headerIcon.heightAnchor.constraint(equalToConstant: 80),
            
            headerMessage.topAnchor.constraint(equalTo: headerIcon.bottomAnchor, constant: 10),
            headerMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: headerMessage.bottomAnchor, constant: 25),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50),
            
            createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            createAccountButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            createAccountButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
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
    
    @objc private func forgotPasswordTapped() {
        self.presentAlertOnMainThread(title: "Forgot Password", message: "This feature is not yet implemented.", buttonTitle: "Done")
    }
    
    @objc private func createAccountTapped() {
        self.presentAlertOnMainThread(title: "Create Account", message: "This feature is not yet implemented.", buttonTitle: "Done")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

@available(iOS 17.0, *)
#Preview {
    return SignInViewController()
}
