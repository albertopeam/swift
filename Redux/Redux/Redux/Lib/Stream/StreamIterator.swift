//
//  StreamIterator.swift
//  Redux
//
//  Created by Alberto Penas Amor on 17/7/22.
//

import Foundation

struct StreamIterator<T>: AsyncIteratorProtocol {
    typealias Element = T

    private var items: [Stream<T>.Next]

    init(items: [Stream<T>.Next]) {
        self.items = items
    }

    mutating func next() async -> Element? {
        guard !Task.isCancelled else {
            return nil
        }
        if items.isEmpty {
            return nil
        }
        let item = items.removeFirst()
        return await item()
    }
}
