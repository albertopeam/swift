//
//  Stream.swift
//  Redux
//
//  Created by Alberto Penas Amor on 17/7/22.
//

import Foundation

struct Stream<T>: AsyncSequence {
    typealias Element = T
    typealias Next = () async -> Element?

    private let iterator: StreamIterator<T>

    init(items: [Next]) {
        self.iterator = StreamIterator(items: items)
    }

    init(item: @escaping Next) {
        self.iterator = StreamIterator(items: [item])
    }

    func makeAsyncIterator() -> StreamIterator<T> {
        return iterator
    }
}
