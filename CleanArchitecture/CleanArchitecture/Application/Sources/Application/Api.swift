import Foundation
import Combine
import Entities

public protocol Api {
    func songs(for artistId: String) -> AnyPublisher<[Song], Error>
}
