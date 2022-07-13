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

    //TODO: not needed now. maybe let it open to inject the state? maybe not to force initial state in State protocol
//    @MainActor init<M: Middleware>(state: S, reducer: @escaping Reducer, middleware: M) where M.Action == Action {
//        self.state = state
//        self.reducer = reducer
//        self.middleware = AnyMiddleware(middleware)
//    }

    init<M: Middleware>(reducer: @escaping Reducer, middleware: M) where M.Action == Action {
        self.reducer = reducer
        self.middleware = AnyMiddleware(middleware)
    }

    convenience init(reducer: @escaping Reducer) {
        self.init(reducer: reducer, middleware: EchoMiddleware<Action>())
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
