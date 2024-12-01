import UIKit

final class DeactivateAccountViewController: UIViewController {
    
    // MARK: - Properties
    private let actionButton = RQButton(title: "Deactivate Account", fontColor: .systemBackground, bgColor: .systemRed)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [actionButton])
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
        title = "Account"
        
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        actionButton.layer.borderWidth = 0
    }
    
    // MARK: - Actions
    @objc func actionTapped() {
        debugPrint("DEBUG: actionTapped()")
    }
}

@available(iOS 17.0, *)
#Preview {
    DeactivateAccountViewController()
}
