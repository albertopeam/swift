//
//  ReduxTests.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 10/7/22.
//

import XCTest
@testable import Redux

final class CounterReducerTests: XCTestCase {
    let sut = Reducers.counterReducer

    func testGivenInitialStateWhenInvokeAddThenExpectCounterToBeOne() async throws {
        let result = await sut(.init(), .add)
        XCTAssertEqual(result.count, 1)
    }
}
