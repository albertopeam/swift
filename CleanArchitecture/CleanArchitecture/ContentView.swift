//
//  ContentView.swift
//  CleanArchitecture
//
//  Created by Alberto Penas Amor on 07/09/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import SwiftUI
import Adapters

struct ContentView: View {
    let adapter: Adapter = .init()
    var body: some View {
        Text(adapter.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
// MARK: - view
class ViewController: UIViewController, Subscriber {
    typealias Input = ViewState
    typealias Failure = Never

    let spinner: UIActivityIndicatorView = .init(frame: .zero)
    let tableView: UITableView = .init(frame: .zero)
    let snackBar: SnackBar = .init(frame: .zero)
    let dataSource: SongsDataSource = .init()
    var lifecycle: CurrentValueSubject<Void, Never> = .init(())

    init() {
        super.init(nibName: nil, bundle: nil)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .gray
        spinner.hidesWhenStopped = true
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        snackBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(spinner)
        view.addSubview(tableView)
        view.addSubview(snackBar)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            snackBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            snackBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            snackBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)

        ])

        spinner.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(_ input: ViewState) -> Subscribers.Demand {
        input.isLoading ? spinner.startAnimating() : spinner.stopAnimating()
        dataSource.songs = input.songs
        tableView.reloadData()
        if let error = input.error {
            snackBar.show(message: error, action: input.retry)
        }
        return .unlimited
    }

    func receive(completion: Subscribers.Completion<Never>) {}
}

// MARK: - datasource
class SongsDataSource: NSObject, UITableViewDataSource {
    var songs: [Song]

    init(songs: [Song] = .init()) {
        self.songs = songs
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = songs[indexPath.row].title
        cell.textLabel?.textColor = .black
        return cell
    }
}

// MARK: - states
protocol ViewState {
    var isLoading: Bool { get }
    var songs: [Song] { get }
    var error: String? { get }
    var retry: String { get }
}

extension ViewState {
    var retry: String { "Retry" }
}

struct LoadingViewState: ViewState {
    let isLoading: Bool = true
    let songs: [Song] = .init()
    let error: String? = nil
}

struct ErrorViewSate: ViewState {
    let isLoading: Bool = false
    let songs: [Song] = .init()
    let error: String?
}

struct SuccessViewState: ViewState {
    let isLoading: Bool = false
    let songs: [Song]
    let error: String? = nil
}

// MARK: - view model
class ViewModel: Subscriber {
    typealias Input = Void
    typealias Failure = Never

    // MARK: - public
    @Published var state: ViewState
    // MARK: - private
    private let favourites: Favourites
    private var subscriptions: Set<AnyCancellable> = .init()

    init(state: ViewState = LoadingViewState(), favourites: Favourites = FavouritesRepository()) {
        self.state = state
        self.favourites = favourites
    }

    func receive(subscription: Subscription) {
        subscription.request(.max(1))
    }

    func receive(_ input: Void) -> Subscribers.Demand {
        favourites
            .songs()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] in
                switch $0 {
                case .finished:
                    break
                case .failure(_):
                    self?.state = ErrorViewSate(error: "Something went wrong")
                }
            }, receiveValue: { [weak self] in self?.state = SuccessViewState(songs: $0) })
            .store(in: &subscriptions)
        return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {}
}

// MARK: - model
struct Song {
    let title: String
    let band: String
    let genre: String
    let url: URL
}

enum SongsError: Swift.Error {
    case notAvailable
}

// MARK: repository
protocol Favourites {
    func songs() -> AnyPublisher<[Song], SongsError>
}

class FavouritesRepository: Favourites {
    private let favouritesUrl = "https://raw.githubusercontent.com/albertopeam/combine-playgrounds/master/Freestyle/View_ViewModel.playground/Resources/songs.json"
    private let urlSession: URLSession
    private struct SongCodable: Codable {
        let band: String
        let song: String
        let genre: String
        let link: String
    }

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func songs() -> AnyPublisher<[Song], SongsError> {
        guard let url = URL(string: favouritesUrl) else { fatalError("URL cannot be built") }
        return urlSession
            .dataTaskPublisher(for: url)
            .print("networking")
            .map(\.data)
            .decode(type: [SongCodable].self, decoder: JSONDecoder())
            .map({ songs in
                songs.compactMap({ song in
                    guard let url = URL(string: song.link) else { return nil }
                    return Song(title: song.song,
                                band: song.band,
                                genre: song.genre,
                                url: url)
                })
            }).mapError({ _ in
                return .notAvailable
            })
            .eraseToAnyPublisher()
    }
}
*/
