//
//  MockReducer.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 18/7/22.
//

import Foundation
@testable import Redux

final class MockReducer<R: AsyncSequence> where R.Element == TestState {
    var stream: R?

    func reduce(state: TestState, action: TestAction) -> R {
        stream!
    }
}
