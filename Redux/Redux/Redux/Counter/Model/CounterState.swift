//
//  CounterState.swift
//  Redux
//
//  Created by Alberto Penas Amor on 13/7/22.
//

import Foundation

struct CounterState: State, Equatable {
    let count: Int

    init(count: Int) {
        self.count = count
    }

    init() {
        count = 0
    }
}
