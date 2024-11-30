import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    public let authHeaderView = AuthHeaderView(title: "Forgot Password", icon: "person.badge.key")
    
    private let emailTextField = RQTextField(placeholder: "Email")
    private let sendCodeButton = RQButton(title: "Send Code", fontColor: .systemBackground, bgColor: .label)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authHeaderView, emailTextField, sendCodeButton])
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
        
        sendCodeButton.addTarget(self, action: #selector(sendCodeTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
        ])
        
        sendCodeButton.isEnabled = false
        sendCodeButton.alpha = 0.8
        configureTextFields()
    }
    
    private func configureTextFields() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func updateSendCodeButtonState() {
        let isEmailEmpty = emailTextField.text?.isEmpty ?? true
        
        sendCodeButton.isEnabled = !isEmailEmpty
        sendCodeButton.alpha = sendCodeButton.isEnabled ? 1 : 0.8
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        updateSendCodeButtonState()
    }
    
    @objc private func sendCodeTapped() {
        debugPrint("DEBUG: sendCodeTapped()")
    }
}

