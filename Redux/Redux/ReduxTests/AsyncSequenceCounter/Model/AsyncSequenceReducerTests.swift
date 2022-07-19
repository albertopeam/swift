//
//  AsyncSequenceReducerTests.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 19/7/22.
//

import XCTest
@testable import Redux

final class AsyncSequenceReducerTests: XCTestCase {
    private let sut = AsyncSequenceReducer.reducer(state:action:)

    func testGivenInitialStateWhenTriggerAddThenReturnLoadingAndSum() async throws {
        let initialState = AsyncSequenceState()
        let action = AsyncSequenceAction.add

        let stream = sut(initialState, action)
        let values = await stream.values()

        let expected = [
            AsyncSequenceStateBuilder().isLoading(true).build(),
            AsyncSequenceStateBuilder().isLoading(false).count(1).build()
        ]
        XCTAssertEqual(values, expected)
    }
}


