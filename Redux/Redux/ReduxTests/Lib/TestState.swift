//
//  TestState.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 18/7/22.
//

import Foundation
@testable import Redux

struct TestState: State, Equatable {
    let count: Int

    init() {
        self.count = 0
    }
    
    init(count: Int) {
        self.count = count
    }
}
