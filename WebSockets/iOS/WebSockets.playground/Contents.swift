import Foundation
import Combine
import UIKit
import PlaygroundSupport

//https://developer.apple.com/documentation/foundation/urlsessionwebsockettask
//https://github.com/websockets/ws

final class URLSessionWebSocketDelegateImpl: NSObject, URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("didOpenWithProtocol")
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("didCloseWith")
    }
}

enum Error: Swift.Error, CustomStringConvertible {
    case ping
    case receive

    var description: String {
        switch self {
            case .ping: return "socket ping error"
            case .receive: return "receive error"
        }
    }
}

protocol RepositoryType {
    func listen() -> AnyPublisher<String, Error>
    func send(message: String)
}

final class Repository: RepositoryType {

    private let webSocket: URLSessionWebSocketTask
    private var subject: PassthroughSubject<String, Error> = .init()
    private let queue: DispatchQueue

    init(webSocket: URLSessionWebSocketTask, queue: DispatchQueue) {
        self.webSocket = webSocket
        self.queue = queue
    }

    deinit {
        webSocket.cancel(with: .goingAway, reason: nil)
    }

    func listen() -> AnyPublisher<String, Error> {
        webSocket.resume()
        webSocket.sendPing { [weak self] error in
            guard let self = self else { return }
            if let _ = error {
                self.queue.async { [weak self] in
                    self?.subject.send(completion: .failure(.ping))
                }
            } else {
                self.receive()
            }
        }
        return subject.eraseToAnyPublisher()
    }

    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocket.send(message) { [weak self] error in
            guard let self = self else { return }
            if let _ = error {
                self.queue.async { [weak self] in
                    self?.subject.send(completion: .failure(.ping))
                }
            }
        }
    }

    //MARK : - private

    private func receive() {
        webSocket.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
                case let .success(data):
                switch data {
                    case let .data(data):
                        assertionFailure("Unhandled case \(data)")
                    case let .string(string):
                        self.queue.async { [weak self] in
                            self?.subject.send(string)
                        }
                    @unknown default:
                        assertionFailure("Unhandled case")
                }
                case let .failure(error):
                    print("receive error \(error)")
                    self.queue.async { [weak self] in
                        self?.subject.send(completion: .failure(.receive))
                    }
            }
            self.receive()
        }
    }
}

final class ViewModel {
    private let repository: RepositoryType
    private(set) var items: [String] = .init()
    private(set) var error: String? = nil

    init(repository: RepositoryType) {
        self.repository = repository
    }

    func listen() -> AnyPublisher<Void, Never> {
        repository.listen()
            .handleEvents(receiveOutput: { [weak self] message in
                self?.items.append(message)
            }, receiveCompletion: { [weak self] completion in
                switch completion {
                    case let .failure(err):
                        self?.error = err.description
                    case .finished: break
                }
            })
            .map { _ in Void() }
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }

    func send(message: String?) {
        if let message = message, !message.isEmpty {
            repository.send(message: message)
        }
    }
}

final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Views
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        return label
    }()
    private var textField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Type your message..."
        text.textColor = .white
        return text
    }()
    private var button: UIButton = {
        let but = UIButton()
        let image = UIImage(systemName: "paperplane.circle.fill")
        but.translatesAutoresizingMaskIntoConstraints = false
        but.setImage(image, for: .normal)
        but.addTarget(self, action: #selector(send), for: .touchUpInside)
        return but
    }()
    private lazy var stackView: UIView = {
        let view = UIView(frame: .zero)
        let stack = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.addArrangedSubview(textField)
        stack.spacing = 10
        stack.addArrangedSubview(button)
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
        return view
    }()
    private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // MARK: - model
    private let viewModel: ViewModel
    private var subscriptions: Set<AnyCancellable> = .init()

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.addSubview(tableView)
        view.addSubview(stackView)
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),

            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.listen()
            .sink(receiveValue: { [weak self] _ in self?.reload() })
            .store(in: &subscriptions)
    }

    private func reload() {
        tableView.reloadData()
        errorLabel.text = viewModel.error
        errorLabel.isHidden = viewModel.error.isNil
    }

    @objc private func send() {
        viewModel.send(message: textField.text)
    }

    // MARK: - Datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(frame: .zero)
        cell.textLabel?.text = viewModel.items[indexPath.row]
        return cell
    }

    // MARK: - Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension Optional {
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
}

let urlSession = URLSession(configuration: .default,
                            delegate: URLSessionWebSocketDelegateImpl(),
                            delegateQueue: .init())
let url = URL(string: "ws://localhost:8080")!
let webSocket = urlSession.webSocketTask(with: url)
let repository = Repository(webSocket: webSocket,
                            queue: DispatchQueue.main)
let viewModel = ViewModel(repository: repository)
PlaygroundPage.current.liveView = ViewController(viewModel: viewModel)
