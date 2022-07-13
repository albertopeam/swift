//
//  EchoMiddleware.swift
//  Redux
//
//  Created by Alberto Penas Amor on 13/7/22.
//

import Foundation

struct EchoMiddleware<Action>: Middleware {
    func callAsFunction(action: Action) async -> Action? {
        action
    }
}
