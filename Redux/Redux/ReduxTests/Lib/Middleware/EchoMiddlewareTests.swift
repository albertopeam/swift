//
//  EchoMiddlewareTests.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 20/7/22.
//

import XCTest
@testable import Redux

final class EchoMiddlewareTests: XCTestCase {
    private let sut: EchoMiddleware<TestAction> = .init()

    func testGivenActionWhenInvokeActThenReturnSameInputAction() async throws {
        let input: TestAction = .run

        let output = await sut.callAsFunction(action: input)

        XCTAssertEqual(output, input)
    }
}
