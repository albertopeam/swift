//
//  SpyMiddleware.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 18/7/22.
//

import Foundation
@testable import Redux

final class SpyMiddleware<T>: Middleware {
    var capturedAction: T?

    func callAsFunction(action: T) async  {
        capturedAction = action
    }
}
