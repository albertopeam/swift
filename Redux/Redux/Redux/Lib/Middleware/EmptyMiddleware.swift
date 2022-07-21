//
//  EmptyMiddleware.swift
//  Redux
//
//  Created by Alberto Penas Amor on 21/7/22.
//

import Foundation

struct EmptyMiddleware<Action>: Middleware {
    func callAsFunction(action: Action) async {}
}
