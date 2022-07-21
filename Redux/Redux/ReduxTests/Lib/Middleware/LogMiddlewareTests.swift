//
//  LogMiddlewareTests.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 21/7/22.
//

import XCTest
@testable import Redux

final class LogMiddlewareTests: XCTestCase {
    func testGivenContextAndActionWhenCallAsFunctionThenCaptureMessage() async throws {
        let context = "testLogger"
        let spy = SpyLogger()
        let sut = LogMiddleware<TestAction>(context: context, logger: spy)

        await sut.callAsFunction(action: .run)

        let expectedMessage = "\(context)-run"
        XCTAssertEqual(spy.capturedMessage, expectedMessage)
    }

}
