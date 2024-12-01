import UIKit

class UpdateNameSurnameViewController: UIViewController {
    
    // MARK: - Properties
    private let nameTextField = RQTextField(placeholder: "Name")
    private let surnameTextField = RQTextField(placeholder: "Surname")
    private let actionButton = RQButton(title: "Update", fontColor: .systemBackground, bgColor: .label)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, surnameTextField, actionButton])
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
        title = "Name Surname"
        
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
        guard let name = nameTextField.text, !name.isEmpty else {
            presentAlertOnMainThread(title: "Empty Name", message: "Please enter your name.", buttonTitle: "Ok")
            return
        }
        
        guard let surname = surnameTextField.text, !surname.isEmpty else {
            presentAlertOnMainThread(title: "Empty Surname", message: "Please enter your surname.", buttonTitle: "Ok")
            return
        }
        
        debugPrint("DEBUG: actionTapped()")
    }
}

@available(iOS 17.0, *)
#Preview {
    UpdateNameSurnameViewController()
}
