//
//  StoreTests.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 18/7/22.
//

import XCTest
import Combine
@testable import Redux

final class StoreTests: XCTestCase {

    // MARK: - action

    func testGivenInitialStateWhenDispatchActionButReducerHasAnEmptyStreamThenStateHasntChanged() async throws {
        let sut = Store<TestState, TestAction, EmptyStream>(reducer: { _ in return EmptyStream<TestState>() })

        let previousState = await sut.state
        await sut.dispatch(action: .run)
        let currentState = await sut.state

        XCTAssertEqual(currentState, previousState)
    }

    func testGivenInitialStateWhenDispatchActionAndReducerHasOneItemStreamThenStateChangedOnce() async throws {
        let mockReducer = MockReducer<SingleStream>()
        let nextState = TestStateBuilder().count(1).build()
        mockReducer.stream = SingleStream(item: nextState)
        let sut = Store(reducer: mockReducer.reduce(state:action:))

        await sut.dispatch(action: .run)
        let result = await sut.state

        XCTAssertEqual(result, nextState)
    }

    //MARK: - middleware

    func testGivenSomeStateWhenDispatchActionThenInvokeBeforeMiddlewareOnlyWithThatAction() async throws {
        let spy = SpyMiddleware<TestAction>()
        let action: TestAction = .run
        let sut = Store<TestState, TestAction, EmptyStream>(reducer: { _ in return EmptyStream<TestState>() },
                                                            beforeMiddleware: { spy })

        await sut.dispatch(action: action)

        XCTAssertEqual(spy.capturedAction, action)
    }

    func testGivenSomeStateWhenDispatchActionThenInvokeAfterMiddlewareOnlyWithThatAction() async throws {
        let spy = SpyMiddleware<TestAction>()
        let action: TestAction = .run
        let sut = Store<TestState, TestAction, EmptyStream>(reducer: { _ in return EmptyStream<TestState>() },
                                                            afterMiddleware: { spy })

        await sut.dispatch(action: action)

        XCTAssertEqual(spy.capturedAction, action)
    }

    func testGivenSomeStateWhenDispatchActionThenInvokeBeforeAndAfterMiddlewareOnlyWithThatAction() async throws {
        let beforeSpy = SpyMiddleware<TestAction>()
        let afterSpy = SpyMiddleware<TestAction>()
        let action: TestAction = .run
        let sut = Store<TestState, TestAction, EmptyStream>(reducer: { _ in return EmptyStream<TestState>() },
                                                            beforeMiddleware: { beforeSpy },
                                                            afterMiddleware: { afterSpy })

        await sut.dispatch(action: action)

        XCTAssertEqual(beforeSpy.capturedAction, action)
        XCTAssertEqual(afterSpy.capturedAction, action)
    }
}
