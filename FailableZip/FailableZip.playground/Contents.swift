import Combine
import Foundation

enum Error: Swift.Error {
    case any
}
var subscriptions = Set<AnyCancellable>()

//OPTION one
let publisher1 = PassthroughSubject<Int, Error>()
let toZip1 = publisher1
    .map({ Result<Int, Error>.success($0) })
    .catch({ Just(Result<Int, Error>.failure($0)) })

let publisher2 = PassthroughSubject<Int, Error>()
let toZip2 = publisher2
    .map({ Result<Int, Error>.success($0) })
    .catch({ Just(Result<Int, Error>.failure($0)) })

Publishers.Zip(toZip1, toZip2)
    .print("zip")
    .sink(receiveCompletion: { print($0) }, receiveValue: { print($0.0); print($0.1) })
    .store(in: &subscriptions)

//publisher1.send(1) //both success
publisher2.send(2)
publisher1.send(completion: .failure(.any))


//OPTION two WIP
let publisher3 = PassthroughSubject<Int, Error>()
let publisher4 = PassthroughSubject<Int, Error>()
//let fzip = Publishers.failableZip(publisher3, publisher4)
//    .print("failableZip")
    //.sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
    //.store(in: &subscriptions)

//TODO: use shortcut
let fzip: Publishers.FailableZip = Publishers.FailableZip(publisher3, publisher4)
fzip.print("fzip")
    .eraseToAnyPublisher()
    .sink(receiveCompletion: { print($0) }, receiveValue: { result in
        switch result {
        case let (.failure(e1), .failure(e2)): print("2x failure: \(e1), \(e2)")
        case let (.failure(e1), .success(o2)): print("1x failure 1x success: \(e1), \(o2)")
        case let (.success(o1), .failure(e2)): print("1x success 1x failure: \(o1), \(e2)")
        case let (.success(o1), .success(o2)): print("2x success: \(o1), \(o2)")
        }

    })
    .store(in: &subscriptions)

publisher3.send(1)
//publisher4.send(2)
publisher4.send(completion: .failure(.any))
//publisher3.send(completion: .finished)

//TODO: add shortcut
extension Publishers {
//    static func failableZip<A: Publisher, B: Publisher>(_ a: A, _ b: B) -> Publishers.FailableZip<A, B> {
//        return FailableZip(a, b)
//    }
//
//    func failableZip<A: Publisher>(_ a: A) -> Publishers.FailableZip<A, Upstrea> {
//        return FailableZip(a, self)
//    }
}

extension Publishers {
    public struct FailableZip<A: Publisher, B: Publisher>: Publisher where A.Failure == B.Failure {
        public typealias Output = (Result<A.Output, A.Failure>, Result<B.Output, B.Failure>)
        public typealias Failure = Never

        public let a: A
        public let b: B

        public init(_ a: A, _ b: B) {
            self.a = a
            self.b = b
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            print("FailableZip receive")
            let subscription = FailableZipSubscription(subscriber: subscriber, a, b)
            subscriber.receive(subscription: subscription)
        }
    }

    //TODO: fix cancellation or use subscriber
    //TODO: add unit tests
    private struct FailableZipSubscription<S: Subscriber, A: Publisher, B: Publisher>: Subscription where S.Input == (Result<A.Output, A.Failure>, Result<B.Output, B.Failure>), S.Failure == Never, A.Failure == B.Failure {

        let combineIdentifier: CombineIdentifier = .init()

        private var subscriber: S?
        private var subscription: Cancellable?

        init(subscriber: S, _ a: A, _ b: B) {
            self.subscriber = subscriber
            start(a: a, b: b)
        }

        func request(_ demand: Subscribers.Demand) {
            //TODO: - implement
            print("FailableZipSubscription request \(demand)")
        }

        func cancel() {
            print("FailableZipSubscription cancel")
            subscription?.cancel()
        }

        private mutating func start(a: A, b: B) {
            print("FailableZipSubscription start")
            guard let subscriber = subscriber else { return }
            print("FailableZipSubscription start 2")
            let notFailableA = a
                .map({
                    print("FailableZipSubscription a map")
                    return Result<A.Output, A.Failure>.success($0)
                })
                .catch({ Just(Result<A.Output, A.Failure>.failure($0)) })
            let notFailableB = b
                .map({ Result<B.Output, B.Failure>.success($0) })
                .catch({ Just(Result<B.Output, B.Failure>.failure($0)) })
            subscription = Publishers.Zip(notFailableA, notFailableB)
                .sink(receiveCompletion: { _ in
                    print("FailableZipSubscription zip completion")
                    //self.cancel()
                }, receiveValue: { result in
                    print("FailableZipSubscription zip receive")
                    _ = subscriber.receive(result)
                })
        }
    }
}
