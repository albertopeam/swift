//
//  MyViewController.swift
//  bumble
//
//  Created by Alberto Penas Amor on 25/5/22.
//

import UIKit

//MARK: - MyViewController

private enum MyViewTraits {
    static let padding: CGFloat = 16
}

final class MyViewController: UIViewController {
    private let refreshControl = UIRefreshControl()
    private let errorLabel: ErrorLabel = .init(frame: .zero)
    private let activityIndicator: UIActivityIndicatorView = .init(style: .large)
    private let tableView: UITableView = .init(frame: .zero, style: .plain)
    private let presenter: MyPresenterInput

    init(presenter: MyPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        [tableView, activityIndicator, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        activityIndicator.hidesWhenStopped = true
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        errorLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: MyViewTraits.padding),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -MyViewTraits.padding)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        presenter.loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.refreshData(isInitialLoadData: isBeingPresented || isMovingToParent)
    }

    private func setupNavBar() {
        navigationItem.title = "Bumble interview"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Demo", style: .plain, target: self, action: #selector(goToDemo))
    }

    @objc private func goToDemo() {
        navigationController?.pushViewController(ViewController(), animated: true)
    }

    @objc private func pullToRefresh() {
        presenter.refreshData(isInitialLoadData: false)
    }
}

// MARK: - MyPresenterOutput

extension MyViewController: MyPresenterOutput {
    func stateChanged() {
        tableView.reloadData()
        activityIndicator.loading(presenter.myState.loading)
        errorLabel.setError(presenter.myState.error)
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension MyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.myState.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = presenter.myState.items[indexPath.row]
        return cell
    }
}

// MARK: - UIActivityIndicatorView

extension UIActivityIndicatorView {
    func loading(_ loading: Bool) {
        if loading {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}

// MARK: - ErrorLabel

final class ErrorLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setError(_ message: String?) {
        text = message
        isHidden = message == nil
    }
}
