//
//  TestStateBuilder.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 19/7/22.
//

import Foundation

@testable import Redux

final class TestStateBuilder {
    private var count: Int = 0

    func count(_ param: Int) -> Self {
        count = param
        return self
    }

    func build() -> TestState {
        return .init(count: count)
    }
}
