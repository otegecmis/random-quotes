import UIKit
import WebKit

// MARK: - Supporting Types
struct WebPageURLs {
    static let privacyPolicy = "https://www.example.com/privacy"
    static let termOfService = "https://www.example.com/terms"
}

struct SettingItem {
    let title: String
    let detail: String?
    let action: SettingAction
}

enum SettingAction {
    case push(viewController: UIViewController)
    case openWeb(url: URL)
    case selector(action: () -> Void)
    case none
}

// MARK: - SettingsViewController
final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let sections: [String] = ["Account", "Support"]
    
    private lazy var items: [[SettingItem]] = [
        [
            SettingItem(title: "Update Information", detail: nil, action: .push(viewController: UpdateInformationViewController())),
            SettingItem(title: "Logout", detail: nil, action: .selector(action: { [weak self] in
                self?.logout()
            }))
        ],
        [
            SettingItem(title: "Privacy Policy", detail: nil, action: .openWeb(url: URL(string: WebPageURLs.privacyPolicy)!)),
            SettingItem(title: "Terms of Service", detail: nil, action: .openWeb(url: URL(string: WebPageURLs.termOfService)!)),
            SettingItem(title: "Contact", detail: "support@example.com", action: .none),
        ]
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        title = "Settings"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func logout() {
        AuthManager.shared.logout { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let window = UIApplication.shared.windows.first {
                        let signInViewController = SignInViewController()
                        let navigationController = UINavigationController(rootViewController: signInViewController)
                        navigationController.modalPresentationStyle = .fullScreen
                        
                        window.rootViewController = navigationController
                        window.makeKeyAndVisible()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "OK")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let item = items[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        cell.detailTextLabel?.textColor = .gray
        
        switch item.action {
        case .push:
            cell.accessoryType = .disclosureIndicator
        case .openWeb:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "safari"))
            cell.tintColor = .label
        case .selector:
            cell.accessoryType = .none
        case .none:
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = items[indexPath.section][indexPath.row]
        
        switch selectedItem.action {
        case .push(let viewController):
            navigationController?.pushViewController(viewController, animated: true)
        case .openWeb(let url):
            let webViewController = UIViewController()
            let webView = WKWebView(frame: .zero)
            
            webView.load(URLRequest(url: url))
            webViewController.view = webView
            
            navigationController?.pushViewController(webViewController, animated: true)
        case .selector(let action):
            action()
        case .none:
            break
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SettingsViewController()
}
