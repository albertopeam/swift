//
//  SingleStream.swift
//  Redux
//
//  Created by Alberto Penas Amor on 19/7/22.
//

import Foundation

struct SingleStream<T>: AsyncSequence, AsyncIteratorProtocol {
    typealias AsyncIterator = Self
    typealias Element = T
    private var item: T?

    init(item: T) {
        self.item = item
    }

    mutating func next() async throws -> T? {
        defer { item = nil }
        return item
    }

    func makeAsyncIterator() -> SingleStream<T> {
        return self
    }
}
