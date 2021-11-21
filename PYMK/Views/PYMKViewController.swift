//
//  ViewController.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import UIKit

// MARK: PYMKViewController

final class PYMKViewController: NiblessViewController {
    
    private let dataManager: PeopleDataManager
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorColor = .lightGray
        tableView.register(PYMKCell.self, forCellReuseIdentifier: PYMKCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        return tableView
    }()
    
    private var people = [Person]()
    
    override init() {
        let api = JSONAPI(filename: "mock")
        self.dataManager = PeopleDataManager(api: api)
        
        super.init()
        configureLayout()
        title = "People You May Know"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        updateColors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.isHidden = true
        activityIndicator.startAnimating()
        dataManager.getPeopleYouMayKnow { result in
            switch result {
            case .success(let people):
                self.show(people)
            case .failure(let error):
                self.show(error)
            }
        }
    }
    
    // MARK: Public Interface
    
    func show(_ people: [Person]) {
        self.people = people
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func show(_ error: APIError) {
        tableView.isHidden = true
        activityIndicator.stopAnimating()
        
        let alert = UIAlertController(title: "Whoops!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Private
    
    private func configureLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func updateColors() {
        view.backgroundColor = .black
        activityIndicator.color = StyleGuide.Colors.yellow
    }
}
    
// MARK: UITableViewDataSource

extension PYMKViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell: PYMKCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: person)
        return cell
    }
}
