import Combine

enum Error: Swift.Error {
    case any
}
var subscriptions = Set<AnyCancellable>()

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


