import Foundation

protocol RepositoryType {
    associatedtype Input
    associatedtype Output
    func process(input: Input) -> Output
}

struct Repository: RepositoryType {
    typealias Input = Int
    typealias Output = String

    func process(input: Int) -> String {
        return input.description
    }
}

struct Repo<I>: RepositoryType where I: CustomStringConvertible {
    typealias Input = I
    typealias Output = String

    func process(input: I) -> String {
        return input.description
    }
}

struct Controller<T: RepositoryType> where T.Input == Int, T.Output == String {
    private let repository: T

    init(repository: T) {
        self.repository = repository
    }

    func handle(_ input: Int) -> String {
        repository.process(input: input)
    }
}

let controller = Controller(repository: Repository())
let result = controller.handle(1)
print("result \(result)")

let repo: Repo<Int> = Repo()
let res = repo.process(input: 2)
print("res \(res)")

// Some

func repositoryFactory() -> some RepositoryType {
    Repository()
}
let repository = repositoryFactory()

// Generics

struct Stack<Element> {
    private var items: [Element] = []

    var top: Element? {
        items.last
    }

    mutating func push(_ element: Element) {
        items.append(element)
    }

    mutating func pop() -> Element? {
        items.count > 0 ? items.removeLast() : nil
    }
}

var stack: Stack<Int> = Stack()
stack.push(1)
stack.push(2)
stack.push(3)
let popped = stack.pop()
print("pop \(popped)")
print("top \(stack.top)")


// Mutating

func mutate(_ stack: inout Stack<Int>) {
    stack.push(4)
}

mutate(&stack)
print("top \(stack.top)")

// Non mutating

func notMutate(_ stack: Stack<Int>) {
    var param = stack
    param.push(5)
}

notMutate(stack)
print("top \(stack.top)")


// Generic Func

func isEqual<T>(_ a: T, _ b: T) -> Bool where T: Equatable {
    a == b
}

print("isEqual(1, 1) \(isEqual(1, 1))")
print("isEqual(1, 2) \(isEqual(1, 3))")

// Protocols

protocol Writer {
    func write()
}

protocol Reader {
    func read()
}

struct MyType: Writer, Reader {
    func write() {}
    func read() {}
}

struct Client {
    let writer: Writer
}

let client = Client(writer: MyType())


