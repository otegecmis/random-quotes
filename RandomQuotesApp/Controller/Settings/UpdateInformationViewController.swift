import UIKit
import WebKit

// MARK: - Supporting Models
struct UpdateInformationItem {
    let title: String
    let detail: String?
    let accessoryView: UIImage?
    let push: UIViewController
}

// MARK: - SettingsViewController
final class UpdateInformationViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let sections: [String] = ["Information"]
    
    private lazy var items: [[UpdateInformationItem]] = [
        [
            UpdateInformationItem(title: "Name Surname", detail: nil, accessoryView: UIImage(systemName: "pencil.and.list.clipboard"), push: UpdateNameSurnameViewController()),
            UpdateInformationItem(title: "Password", detail: nil, accessoryView: UIImage(systemName: "key"), push: UpdatePasswordViewController()),
            UpdateInformationItem(title: "E-Mail", detail: nil, accessoryView: UIImage(systemName: "mail"), push: UpdateEMailViewController()),
            UpdateInformationItem(title: "Deactivate", detail: nil, accessoryView: UIImage(systemName: "person.slash"), push: DeactivateAccountViewController())
        ]
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Update Information"
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
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
                
        if item.accessoryView == nil {
            cell.accessoryType = .disclosureIndicator
        }
        
        cell.accessoryView = UIImageView(image: item.accessoryView)
        cell.tintColor = .label
        
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
        
        let selectedItem = items[indexPath.section][indexPath.row]
        
        navigationController?.pushViewController(selectedItem.push, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    UpdateInformationViewController()
}
