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
    
    private lazy var quotesCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var createQuoteButton: RQButton = {
        let button = RQButton()
        button.setTitle("Create Quote", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        return button
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
    private lazy var refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
        getUser()
    }
    
    // MARK: - Helpers
    private func configureViewController() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        createQuoteButton.addTarget(self, action: #selector(createQuoteButtonTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshGetUser), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(namesurnameLabel)
        view.addSubview(quotesCountLabel)
        view.addSubview(createQuoteButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            namesurnameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            namesurnameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            createQuoteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            createQuoteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createQuoteButton.heightAnchor.constraint(equalToConstant: 44),
            createQuoteButton.widthAnchor.constraint(equalToConstant: 120),
            
            quotesCountLabel.topAnchor.constraint(equalTo: namesurnameLabel.bottomAnchor, constant: 5),
            quotesCountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: quotesCountLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Network
    private func getUser() {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {
            presentAlertOnMainThread(title: "Error", message: "Something wrong with your user ID.", buttonTitle: "Done")
            return
        }
        
        UsersService().getUser(userID: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.namesurnameLabel.text = "\(user.name) \(user.surname)"
                    self?.quotesCountLabel.text = "\(user.quotes.count) Quotes"
                    self?.quotes = user.quotes
                    
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Done")
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func createQuoteButtonTapped() {
        let createQuoteViewController = CreateQuoteViewController()
        let navigationController = UINavigationController(rootViewController: createQuoteViewController)
        
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func refreshGetUser() {
        getUser()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
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
        cell.textLabel?.numberOfLines = 0
        
        cell.detailTextLabel?.text = quote.author
        cell.detailTextLabel?.textColor = .lightGray
        
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
