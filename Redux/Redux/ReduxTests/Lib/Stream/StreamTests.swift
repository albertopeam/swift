//
//  StreamTests.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 19/7/22.
//

import XCTest
@testable import Redux

final class StreamTests: XCTestCase {
    func testGivenEmptyWhenIterateThenReceiveEmpty() async throws {
        let sut = Redux.Stream<TestState>()

        let result = await sut.values()

        XCTAssertEqual(result, [])
    }

    func testGivenOneItemWhenIterateThenReceiveIt() async throws {
        let sut = Redux.Stream<TestState>(item: { TestState(count: 2) })

        let result = await sut.values()

        XCTAssertEqual(result, [TestState(count: 2)])
    }

    func testGivenTwoItemsWhenIterateThenReceiveBothAndInExpectedOrder() async throws {
        let sut = Redux.Stream<TestState>(items: [{ TestState(count: 1) }, { TestState(count: 2) }])

        let result = await sut.values()

        XCTAssertEqual(result, [TestState(count: 1), TestState(count: 2)])
    }

    func testGivenOneItemWhenCancelTaskBeforeExecutingThenNotReceiveItems() async throws {
        let task = Task<[TestState], Never> {
            let sut = Redux.Stream<TestState>(item: { TestState(count: 1) })

            return await sut.values()
        }
        task.cancel()
        let result = await task.value
        XCTAssertEqual(result, [])
    }
}
