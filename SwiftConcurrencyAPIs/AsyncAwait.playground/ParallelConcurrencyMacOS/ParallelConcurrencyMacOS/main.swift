//
//  main.swift
//  ParallelConcurrencyMacOS
//
//  Created by Alberto Penas Amor on 26/6/22.
//

// more info on https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html

import Foundation
import _Concurrency

/*
shared code
*/

let oneSecNanos: UInt64 = 1_000_000_000
let twoSecNanos: UInt64 = 2_000_000_000

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

func work(_ delayNanos: UInt64 = oneSecNanos) async throws -> Int {
    let start = Date()
    try await Task.sleep(nanoseconds: delayNanos)
    let end = Date()
    let diff = end - start
    print("sleep time \(diff)")
    Thread.printCurrent()
    return Int.random(in: 0...100)
}

extension Thread {
    static func printCurrent() {
        print("⚡️: \(Thread.current)" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")")
    }
}


/*
parallel async
*/

Task { // uses a thread
    async let work1 = work(oneSecNanos)
    async let work2 = work(twoSecNanos)

    let results = try await [work1, work2]
    print("tasks results \(results)")
    Thread.printCurrent()
}

sleep(3)

/*
parallel fibonacci
*/

func fibonacci(for number: Int) async -> Int {
    guard number >= 0 else { preconditionFailure("Negative number not valid input") }
    if number == 0 || number == 1{
        return number
    } else {
        async let a = fibonacci(for: number - 1)
        async let b = fibonacci(for: number - 2)
        return await a + b
    }
}

Task {
    let result = await fibonacci(for: 9)
    print("fibonacci \(result)")
    Thread.printCurrent()
}

sleep(1)
