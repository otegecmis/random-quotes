import UIKit

final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    public let authHeaderView = AuthHeaderView(title: "Sign Up", icon: "person.badge.plus")
    
    private let nameTextField = RQTextField(placeholder: "Name")
    private let surnameTextField = RQTextField(placeholder: "Surname")
    private let emailTextField = RQTextField(placeholder: "Email")
    private let passwordTextField = RQTextField(placeholder: "Password", isSecureTextEntry: true)
    
    private let signUpButton = RQButton(title: "Sign Up", fontColor: .systemBackground, bgColor: .label)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authHeaderView, nameTextField, surnameTextField, emailTextField, passwordTextField, signUpButton])
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
        
        navigationController?.navigationBar.tintColor = .label
        
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
        ])
        
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.8
        configureTextFields()
    }
    
    private func configureTextFields() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func updateSignUpButtonState() {
        let isNameEmpty = nameTextField.text?.isEmpty ?? true
        let isSurnameEmpty = surnameTextField.text?.isEmpty ?? true
        let isEmailEmpty = emailTextField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.isEmpty ?? true
        
        signUpButton.isEnabled = !isNameEmpty && !isSurnameEmpty && !isEmailEmpty && !isPasswordEmpty
        signUpButton.alpha = signUpButton.isEnabled ? 1 : 0.8
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        updateSignUpButtonState()
    }
    
    @objc private func signUpTapped() {
        debugPrint("DEBUG: signUpTapped()")
    }
}
