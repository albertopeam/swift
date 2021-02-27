
import Foundation
import Combine

protocol Repository {
    func process() -> AnyPublisher<Void, Error>
}

protocol DataSource {
    func process() -> AnyPublisher<Void, Error>
}

enum NetworkDataError: Error {
    case client(code: Int, message: String)
    case server
}

enum StorageDataError: Error {
    case empty
}

struct NetworkDataSource: DataSource {
    func process() -> AnyPublisher<Void, Error> {
        Fail(error: NetworkDataError.client(code: 404, message: "not found")).eraseToAnyPublisher()
    }
}

struct LocalDataSource: DataSource {
    func process() -> AnyPublisher<Void, Error> {
        Fail(error: StorageDataError.empty).eraseToAnyPublisher()
    }
}

struct UseCase {
    let networkDataSource: DataSource
    let localDataSource: DataSource

    func process() -> AnyPublisher<Void, UseCaseError> {
        if Bool.random() {
            return Fail(error: UseCaseError.notAvailable).eraseToAnyPublisher()
        }
        let publisher = Bool.random() ? networkDataSource.process() : localDataSource.process()
        return publisher.mapError { error -> UseCaseError in
            switch error {
            case is NetworkDataError: return .noData
            case is StorageDataError: return .noData
            default: return .notAvailable
            }
        }.eraseToAnyPublisher()
    }
}

enum UseCaseError: Swift.Error {
    case noData
    case notAvailable
}

var subscriptions = Set<AnyCancellable>()
let useCase = UseCase(networkDataSource: NetworkDataSource(), localDataSource: LocalDataSource())
useCase.process()
    .sink(receiveCompletion: { completion in
        switch completion {
            case .finished: break
            case let .failure(error): print(error)
        }
        }, receiveValue: { print($0) })
    .store(in: &subscriptions)




