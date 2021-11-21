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
        tableView.separatorColor = .lightGray
//        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
//        tableView.register(SearchResultsHeaderView.self, forHeaderFooterViewReuseIdentifier: headerViewReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private var people = [Person]()
    
    override init() {
        let api = JSONAPI(filename: "mock")
        self.dataManager = PeopleDataManager(api: api)
        
        super.init()
        configureLayout()
        title = "People You Might Know"
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
        dataManager.getPeople { result in
            switch result {
            case .success(let people):
                self.show(people)
            case .failure(let error):
                self.show(error)
            }
        }
    }
    
    // MARK: Public Interface
    
    func show(_ error: APIError) {
        tableView.isHidden = true
        activityIndicator.stopAnimating()
        
        // TODO: Show error dialog
    }
    
    func show(_ people: [Person]) {
        self.people = people
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
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
        activityIndicator.color = StyleGuide.Colors.alamoYellow
    }
}
    
// MARK: UITableViewDataSource

extension PYMKViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: SearchResultCell = tableView.dequeueReusableCell(for: indexPath)
//        let result = results[indexPath.row]
//        cell.configure(with: result)
//
        let person = people[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = person.name
        return cell
    }
}

// MARK: UITableViewDelegate

extension PYMKViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard !people.isEmpty else {
            return 0
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView? {
        guard !people.isEmpty else {
            return nil
        }
        
//        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewReuseIdentifier) as? SearchResultsHeaderView
        return nil
    }
}