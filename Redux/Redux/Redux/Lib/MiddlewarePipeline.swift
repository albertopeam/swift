//
//  MiddlewarePipeline.swift
//  Redux
//
//  Created by Alberto Penas Amor on 13/7/22.
//

import Foundation

struct MiddlewarePipeline<Action>: Middleware {
    private let middleware: [AnyMiddleware<Action>]

    init<M: Middleware>(_ middleware: M...) where M.Action == Action {
        self.middleware = middleware.map { AnyMiddleware<Action>($0) }
    }

    init(_ middleware: AnyMiddleware<Action>...) {
        self.middleware = middleware
    }

    init(_ middleware: [AnyMiddleware<Action>]) {
        self.middleware = middleware
    }

    func callAsFunction(action: Action) async -> Action? {
        var currentAction: Action = action
        for m in middleware {
            guard let newAction = await m(action: currentAction) else {
                return nil
            }

            currentAction = newAction
        }

        return currentAction
    }
}
