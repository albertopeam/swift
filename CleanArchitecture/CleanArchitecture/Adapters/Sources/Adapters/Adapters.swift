import Application

public struct Adapter {
    let useCase: UseCase = .init()
    public init() {}

    public var text: String {
        return useCase.entity.text
    }
}
