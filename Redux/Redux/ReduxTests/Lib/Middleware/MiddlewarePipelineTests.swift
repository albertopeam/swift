//
//  MiddlewarePipelineTests.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 20/7/22.
//

import XCTest
@testable import Redux

final class MiddlewarePipelineTests: XCTestCase {
    private let spyMiddleware1: SpyMiddleware = .init()
    private let spyMiddleware2: SpyMiddleware = .init()
    private lazy var sut: MiddlewarePipeline = .init(spyMiddleware1, spyMiddleware2)

    func testGivenTwoSpiesWhenInvokeThenCheckActionsHasBeenForwardedToBoth() async throws {
        let action = TestAction.run
        spyMiddleware1.returnAction = action
        spyMiddleware2.returnAction = action

        _ = await sut.callAsFunction(action: action)

        XCTAssertEqual(spyMiddleware1.capturedAction, action)
        XCTAssertEqual(spyMiddleware2.capturedAction, action)
    }
}
