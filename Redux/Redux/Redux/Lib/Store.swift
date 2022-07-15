//
//  Store.swift
//  Redux
//
//  Created by Alberto Penas Amor on 13/7/22.
//

import Foundation
import _Concurrency

actor Store<S: State, Action>: ObservableObject {
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
                  middleware: { EchoMiddleware<Action>() })
    }

    func dispatch(action: Action) async {
        guard let newAction = await middleware(action: action) else {
            return
        }

        await dispatchOnMain(action: newAction)
    }

    @MainActor private func dispatchOnMain(action: Action) async {
        let newState = await reducer(state, action)
        state = newState
    }
}
