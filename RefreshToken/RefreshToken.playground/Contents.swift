import Foundation
import Combine
import PlaygroundSupport

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true

protocol NetworkSession {
    func publisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

/// URLSession replacement to be able to bypass network requests and mock its responses
class MockNetworkSession: NetworkSession {
    var responses: [AnyPublisher<(data: Data, response: URLResponse), URLError>] = []

    func publisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        guard let response = responses.first else {
            fatalError("Empty response in responses(NetworkSession) for \(request)")
        }
        responses = Array(responses.dropFirst())
        return response
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

class MockHTTPURLResponseOk: HTTPURLResponse {
    init() {
        super.init(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MockHTTPURLResponseUnauthorized: HTTPURLResponse {
    init() {
        super.init(url: URL(string: "http")!, statusCode: 401, httpVersion: nil, headerFields: nil)!
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct RefreshTokenCodable: Codable {
    let refreshToken: String
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

struct GreetCodable: Codable {
    let data: String
}

enum ApiError: Error {
    case error(code: Int)
    var code: Int {
        switch self {
        case let .error(code):
            return code
        }
    }
}

var subscriptions = Set<AnyCancellable>()
let resourceUrl = URL(string: "http://endpoint/path/resource")!
let refreshTokenUrl = URL(string: "http://endpoint/auth/refresh_token")!

let mock = MockNetworkSession()
let refreshData = try JSONSerialization.data(withJSONObject: ["refresh_token":"01"], options: .prettyPrinted)
let resourceData = try JSONSerialization.data(withJSONObject: ["data":"hello"], options: .prettyPrinted)
mock.responses = [
    Just((Data(), MockHTTPURLResponseUnauthorized())).setFailureType(to: URLError.self).eraseToAnyPublisher(),
    Just((Data(), MockHTTPURLResponseUnauthorized())).setFailureType(to: URLError.self).eraseToAnyPublisher(),
    Just((refreshData, MockHTTPURLResponseOk())).setFailureType(to: URLError.self).eraseToAnyPublisher(),
    Just((resourceData, MockHTTPURLResponseOk())).setFailureType(to: URLError.self).eraseToAnyPublisher(),
    Just((resourceData, MockHTTPURLResponseOk())).setFailureType(to: URLError.self).eraseToAnyPublisher()
]

let network: NetworkSession = mock
let lock: NSRecursiveLock = .init()
func refreshToken() -> AnyPublisher<Bool, URLError> {
    print("REFRESH")
    //TODO: all goes down the same refrehs_token
    //TODO: block threads, handle events. be carefull with threading
    lock.lock()
    return network.publisher(for: .init(url: refreshTokenUrl))
        .map({ response -> Bool in
            print("MAP-REFRESH")
            do {
                let result = try JSONDecoder().decode(RefreshTokenCodable.self, from: response.data)
                //TODO: write to disk or something...
                lock.unlock()
                return !result.refreshToken.isEmpty
            } catch {
                lock.unlock()
                return false
            }
        }).mapError({
            lock.unlock()
            return $0
        })
        //.print("refresh")
        .eraseToAnyPublisher()
}

func fetch() -> AnyPublisher<GreetCodable, Error> {
    return network.publisher(for: .init(url: resourceUrl))
        .tryMap({ (data, result) in
            print("tryMAP")
            guard let urlResponse = result as? HTTPURLResponse else {
                fatalError("No http response")
            }
            guard (200...299).contains(urlResponse.statusCode) else {
                throw ApiError.error(code: urlResponse.statusCode)
            }
            return try JSONDecoder().decode(GreetCodable.self, from: data)
        })
        .tryCatch({ (error) -> AnyPublisher<GreetCodable, Error> in
            print("tryCATCH")
            if let err = error as? ApiError, err.code == 401 {
                return refreshToken()
                    .tryMap({ renewed -> AnyPublisher<GreetCodable, Error> in
                        guard renewed else { throw error}
                        return fetch()
                    }).switchToLatest().eraseToAnyPublisher()
            }
            throw error
        })
        //.print("fetch")
        .eraseToAnyPublisher()
}

for _ in 0...1 {
    Thread {
        fetch()
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
            .store(in: &subscriptions)
    }.start()
}
