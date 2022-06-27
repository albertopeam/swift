import _Concurrency
import Foundation

extension Thread {
    static func printCurrent() {
        print("⚡️: \(Thread.current)" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")")
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

let oneSecNanos: UInt64 = 1_000_000_000

func work(_ delayNanos: UInt64 = oneSecNanos) async throws -> Int {
    let start = Date()
    try await Task.sleep(nanoseconds: delayNanos)
    let end = Date()
    let diff = end - start
    print("sleep time \(diff)")
    return Int.random(in: 0...100)
}

Task.init(priority: .userInitiated) {
    let result = try await work()
    print("task result \(result)")
    Thread.printCurrent()
}
