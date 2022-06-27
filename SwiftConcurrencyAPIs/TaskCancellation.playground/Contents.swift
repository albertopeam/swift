import Foundation
import _Concurrency


extension Thread {
    static func printCurrent() {
        print("⚡️: \(Thread.current)" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")")
    }
}

let fiveSecNanos: UInt64 = 5_000_000_000

let longRunningTask = Task<Int, Error> {
    try await Task.sleep(nanoseconds: fiveSecNanos)
    return 1
}
print("LongRunningTask isCancelled \(longRunningTask.isCancelled)")

Task {
    print("Waiting Task result \(await longRunningTask.result)")
    longRunningTask.cancel()
    print("LongRunningTask cancel")
    print("LongRunningTask isCancelled \(longRunningTask.isCancelled)")
    Thread.printCurrent()
}
