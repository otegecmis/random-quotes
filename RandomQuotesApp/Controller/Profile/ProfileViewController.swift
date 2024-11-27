import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var namesurnameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuoteCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var quotes: [Quote] = [Quote]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureViewController()
        configureUI()
        getData()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureUI() {
        view.addSubview(namesurnameLabel)
        view.addSubview(emailLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            namesurnameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            namesurnameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            emailLabel.topAnchor.constraint(equalTo: namesurnameLabel.bottomAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getData() {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {
            presentAlertOnMainThread(title: "Error", message: "User ID not found. Please log in again.", buttonTitle: "Done")
            return
        }
        
        UsersService().getUser(userID: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.updateUI(with: user)
                case .failure(let error):
                    self?.presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Done")
                }
            }
        }
    }
    
    private func updateUI(with user: User) {
        namesurnameLabel.text = "\(user.name) \(user.surname)"
        emailLabel.text = "\(user.quotes.count) Quotes"
        quotes = user.quotes
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "QuoteCell")
        }
        
        let quote = quotes[indexPath.row]
        
        cell.textLabel?.text = quote.quote
        cell.detailTextLabel?.text = quote.author
        cell.detailTextLabel?.textColor = .lightGray
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    return ProfileViewController()
}
