//
//  SpyMiddleware.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 18/7/22.
//

import Foundation
@testable import Redux

final class SpyMiddleware: Middleware {
    var capturedAction: TestAction?

    func callAsFunction(action: TestAction) async -> TestAction? {
        capturedAction = action
        return nil
    }
}
