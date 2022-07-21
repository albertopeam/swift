//
//  MiddlewarePipelineTests.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 20/7/22.
//

import XCTest
@testable import Redux

final class MiddlewarePipelineTests: XCTestCase {
    private let spyMiddleware1: SpyMiddleware<TestAction> = .init()
    private let spyMiddleware2: SpyMiddleware<TestAction> = .init()
    private lazy var sut: MiddlewarePipeline<TestAction> = .init(spyMiddleware1, spyMiddleware2)

    func testGivenTwoSpiesWhenInvokeThenCheckActionsHasBeenForwardedToBoth() async throws {
        let action = TestAction.run

        _ = await sut.callAsFunction(action: action)

        XCTAssertEqual(spyMiddleware1.capturedAction, action)
        XCTAssertEqual(spyMiddleware2.capturedAction, action)
    }
}
