//
//  Middleware.swift
//  Redux
//
//  Created by Alberto Penas Amor on 13/7/22.
//

import Foundation

protocol Middleware {
    associatedtype Action
    func callAsFunction(action: Action) async
}

extension Middleware {
    func eraseToAnyMiddleware() -> AnyMiddleware<Action> {
        return self as? AnyMiddleware<Action> ?? AnyMiddleware(self)
    }
}
