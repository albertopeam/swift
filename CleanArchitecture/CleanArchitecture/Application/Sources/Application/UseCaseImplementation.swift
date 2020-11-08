import Entities
import Combine

public struct UseCaseImplementation: UseCase {

    private let api: Api

    public init(api: Api) {
        self.api = api
    }

    public func get(for artistId: String) -> AnyPublisher<[Song], Error> {
        return api.songs(for: artistId)
    }
}
