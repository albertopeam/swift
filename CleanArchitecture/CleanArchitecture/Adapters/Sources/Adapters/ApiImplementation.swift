import Application
import Entities
import Foundation
import Combine

public struct ApiImplementation: Api {
    private let urlSession: URLSession

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public func songs(for artistId: String) -> AnyPublisher<[Song], Error> {
        guard let url = URL(string: "https://raw.githubusercontent.com/albertopeam/swift/master/CleanArchitecture/CleanArchitecture/Adapters/Sources/Adapters/items.json") else { fatalError("Invalid url") }
        return urlSession
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [SongApiModel].self, decoder: JSONDecoder())
            .map({ $0.compactMap({ $0.map() }) })
            .eraseToAnyPublisher()
    }
}

private struct SongApiModel: Decodable {
    let name: String
    let img: String
    let artists: [String]
    let url: String

    func map() -> Song? {
        guard let imgUrl = URL(string: img) else { return nil }
        guard let trackUrl = URL(string: url) else { return nil }
        return Song(name: name, artists: artists, imageUrl: imgUrl, trackUrl: trackUrl)
    }
}
