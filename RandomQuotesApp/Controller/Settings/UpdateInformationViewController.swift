import UIKit
import WebKit

// MARK: - Supporting Types
struct UpdateInformationItem {
    let title: String
    let detail: String?
    let accessoryView: UIImage?
    let push: UIViewController
}

// MARK: - UpdateInformationViewController
final class UpdateInformationViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let sections: [String] = ["Information"]
    
    private lazy var items: [[UpdateInformationItem]] = [
        [
            UpdateInformationItem(title: "Name Surname", detail: nil, accessoryView: UIImage(systemName: "pencil.and.list.clipboard"), push: UpdateNameSurnameViewController()),
            UpdateInformationItem(title: "Password", detail: nil, accessoryView: UIImage(systemName: "key"), push: UpdatePasswordViewController()),
            UpdateInformationItem(title: "Mail", detail: nil, accessoryView: UIImage(systemName: "mail"), push: UpdateMailViewController()),
            UpdateInformationItem(title: "Deactivate", detail: nil, accessoryView: UIImage(systemName: "person.slash"), push: DeactivateAccountViewController())
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
        title = "Update Information"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension UpdateInformationViewController: UITableViewDataSource {
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
        
        cell.selectionStyle = .none
        cell.tintColor = .label
        
        if item.accessoryView == nil {
            cell.accessoryType = .disclosureIndicator
        }
        
        cell.accessoryView = UIImageView(image: item.accessoryView)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UpdateInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(items[indexPath.section][indexPath.row].push, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    UpdateInformationViewController()
}
