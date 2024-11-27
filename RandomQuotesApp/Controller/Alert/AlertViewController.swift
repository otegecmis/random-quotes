import UIKit

class AlertViewController: UIViewController {
    
    // MARK: - Properties
    let containerView = UIView()
    let alertTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.minimumScaleFactor = 0.9
        label.lineBreakMode = .byTruncatingTail
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let alertBodyLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let alertButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .label
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 10
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    var completion: (() -> Void)?
    
    var padding: CGFloat = 20
    
    // MARK: - Initializers
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        
        configureContainerView()
        configureAlertTitleLabel()
        configureAlertButton()
        configureAlertBodyLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
    }
    
    // MARK: - Helpers
    func configureContainerView() -> Void {
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func configureAlertTitleLabel() -> Void {
        containerView.addSubview(alertTitleLabel)
        alertTitleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            alertTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            alertTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            alertTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            alertTitleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureAlertButton() -> Void {
        containerView.addSubview(alertButton)
        
        alertButton.setTitle(buttonTitle ?? "Done", for: .normal)
        alertButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            alertButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            alertButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            alertButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            alertButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureAlertBodyLabel() -> Void {
        containerView.addSubview(alertBodyLabel)
        
        alertBodyLabel.text = message ?? "We are sorry, but we cannot complete your request at this time."
        alertBodyLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            alertBodyLabel.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 8),
            alertBodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            alertBodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            alertBodyLabel.bottomAnchor.constraint(equalTo: alertButton.topAnchor, constant: -12)
        ])
    }
    
    // MARK: - Actions
    @objc func dismissVC() {
        dismiss(animated: true) {
            self.completion?()
        }
    }
}

// MARK: - Extensions
extension UIViewController {
    
    // MARK: - Helpers
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertViewController = AlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.completion = completion
            self.present(alertViewController, animated: true)
        }
    }
}
