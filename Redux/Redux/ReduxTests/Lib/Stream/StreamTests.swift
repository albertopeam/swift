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
}
