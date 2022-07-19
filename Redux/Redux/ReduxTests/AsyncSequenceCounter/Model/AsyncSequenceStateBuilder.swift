//
//  AsyncSequenceState+Init.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 19/7/22.
//

import Foundation
@testable import Redux

final class AsyncSequenceStateBuilder {
    private var count: Int = 0
    private var isLoading: Bool = false

    func isLoading(_ param: Bool) -> Self {
        isLoading = param
        return self
    }

    func count(_ param: Int) -> Self {
        count = param
        return self
    }

    func build() -> AsyncSequenceState {
        return .init(count: count, isLoading: isLoading)
    }
}
