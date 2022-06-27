import _Concurrency
import Foundation

extension Thread {
    static func printCurrent() {
        print("⚡️: \(Thread.current)" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")")
    }
}

let oneSecNanos: UInt64 = 500_000_000

func work(_ delayNanos: UInt64 = oneSecNanos) async throws -> Int {
    Thread.printCurrent()
    try await Task.sleep(nanoseconds: delayNanos)
    return Int.random(in: 0...100)
}

@MainActor func publish(result: Int) {
    Thread.printCurrent()
    print(result)
}

Task.init(priority: .userInitiated) {
    let result = try await work()
    // option 1
    await publish(result: result)
    // option 2
    await MainActor.run {
        publish(result: result)
    }
}
