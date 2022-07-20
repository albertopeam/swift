//
//  StoreV4Tests.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 18/7/22.
//

import XCTest
import Combine
@testable import Redux

final class StoreV4Tests: XCTestCase {

    // MARK: - action

    func testGivenInitialStateWhenDispatchActionButReducerHasAnEmptyStreamThenStateHasntChanged() async throws {
        let sut = StoreV4<TestState, TestAction, EmptyStream>(reducer: { _ in return EmptyStream<TestState>() })

        let previousState = await sut.state
        await sut.dispatch(action: .run)
        let currentState = await sut.state

        XCTAssertEqual(currentState, previousState)
    }

    func testGivenInitialStateWhenDispatchActionAndReducerHasOneItemStreamThenStateChangedOnce() async throws {
        let mockReducer = MockReducer<SingleStream>()
        let nextState = TestStateBuilder().count(1).build()
        mockReducer.stream = SingleStream(item: nextState)
        let sut = StoreV4(reducer: mockReducer.reduce(state:action:))

        await sut.dispatch(action: .run)
        let result = await sut.state

        XCTAssertEqual(result, nextState)
    }

    //MARK: - middleware

    func testGivenSomeStateWhenDispatchActionThenInvokeMiddlewareWithThatAction() async throws {
        let spy = SpyMiddleware()
        let action: TestAction = .run
        let sut = StoreV4<TestState, TestAction, EmptyStream>(reducer: { _ in return EmptyStream<TestState>() },
                                                              middleware: { spy })

        await sut.dispatch(action: action)

        XCTAssertEqual(spy.capturedAction, action)
    }
}
