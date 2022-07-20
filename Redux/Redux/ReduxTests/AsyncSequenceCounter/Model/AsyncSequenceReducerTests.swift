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

    func testGivenInitialStateWhenTriggerSubtractThenReturnLoadingAndSubtract() async throws {
        let initialState = AsyncSequenceState()
        let action = AsyncSequenceAction.subtract

        let stream = sut(initialState, action)
        let values = await stream.values()

        let expected = [
            AsyncSequenceStateBuilder().isLoading(true).build(),
            AsyncSequenceStateBuilder().isLoading(false).count(-1).build()
        ]
        XCTAssertEqual(values, expected)
    }

    func testGivenAddStateOnceWhenTriggerResetThenReturnLoadingAndSumAndResetToZero() async throws {
        let initialState = AsyncSequenceState()
        var values: [AsyncSequenceState] = .init()

        let addStream = sut(initialState, .add)
        values.append(contentsOf: await addStream.values())
        let resetStream = sut(try XCTUnwrap(values.last), .reset)
        values.append(contentsOf: await resetStream.values())

        let expected = [
            AsyncSequenceStateBuilder().isLoading(true).build(),
            AsyncSequenceStateBuilder().isLoading(false).count(1).build(),
            AsyncSequenceStateBuilder().isLoading(false).count(0).build()
        ]
        XCTAssertEqual(values, expected)
    }
}


