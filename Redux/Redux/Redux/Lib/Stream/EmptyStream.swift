//
//  EmptyStream.swift
//  Redux
//
//  Created by Alberto Penas Amor on 18/7/22.
//

import Foundation

struct EmptyStream<T>: AsyncSequence {
    typealias AsyncIterator = EmptyStreamIterator<T>
    typealias Element = T

    struct EmptyStreamIterator<T>: AsyncIteratorProtocol {
        mutating func next() async throws -> T? {
            return nil
        }
    }

    func makeAsyncIterator() -> EmptyStreamIterator<T> {
        return EmptyStreamIterator()
    }
}
