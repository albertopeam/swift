//
//  Store.swift
//  Redux
//
//  Created by Alberto Penas Amor on 13/7/22.
//

import Foundation
import _Concurrency

@available(*, deprecated, message: "Use Store instead")
actor StoreV1<S: State, Action>: ObservableObject {
    typealias Reducer = (S, Action) async -> S

    @MainActor @Published private(set) var state: S = .init()
    private let middleware: AnyMiddleware<Action>
    private let reducer: Reducer

    init<M: Middleware>(reducer: @escaping Reducer,
                        @MiddlewareBuilder<Action> middleware: () -> M) where M.Action == Action {
        self.reducer = reducer
        self.middleware = middleware().eraseToAnyMiddleware()
    }

    convenience init(reducer: @escaping Reducer) {
        self.init(reducer: reducer,
                  middleware: { LogMiddleware<Action>(context: String(describing: Self.self)) })
    }

    func dispatch(action: Action) async {
        await middleware(action: action)
        await dispatchOnMain(action: action)
    }

    @MainActor private func dispatchOnMain(action: Action) async {
        let newState = await reducer(state, action)
        state = newState
    }
}
