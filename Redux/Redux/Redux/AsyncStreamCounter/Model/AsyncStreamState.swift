//
//  AsyncStreamState.swift
//  Redux
//
//  Created by Alberto Penas Amor on 17/7/22.
//

import Foundation

struct AsyncStreamState: State, Equatable {
    let count: Int
    let isLoading: Bool

    init(count: Int, isLoading: Bool) {
        self.count = count
        self.isLoading = isLoading
    }

    init() {
        self.init(count: 0, isLoading: false)
    }
}
