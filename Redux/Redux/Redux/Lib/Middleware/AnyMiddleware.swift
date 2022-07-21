//
//  AnyMiddleware.swift
//  Redux
//
//  Created by Alberto Penas Amor on 13/7/22.
//

import Foundation

struct AnyMiddleware<Action>: Middleware {
    private let wrappedMiddleware: (Action) async -> Void

    init<M: Middleware>(_ middleware: M) where M.Action == Action {
        self.wrappedMiddleware = middleware.callAsFunction(action:)
    }

    func callAsFunction(action: Action) async {
        return await wrappedMiddleware(action)
    }
}
