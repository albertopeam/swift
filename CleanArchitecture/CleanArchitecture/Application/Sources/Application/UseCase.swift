import Entities
import Combine

public protocol UseCase {
    func get(for artistId: String) -> AnyPublisher<[Song], Error>
}
