//
//  LogMiddleware.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation

struct LogMiddleware<Action>: Middleware {
    func callAsFunction(action: Action) async -> Action? {
        print("Log \(action)")
        return action
    }
}
