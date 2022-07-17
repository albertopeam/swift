//
//  StoreV3.swift
//  Redux
//
//  Created by Alberto Penas Amor on 17/7/22.
//

import Foundation

actor StoreV3<S: State, Action>: ObservableObject {
    typealias Input = (state: S, action: Action)
    typealias Output = Stream<S>
    typealias Reducer = (Input) -> Output

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

        let stream = await reducer((state, newAction))
        for await newState in stream {
            await postState(newState)
        }
    }

    @MainActor private func postState(_ newState: S) async {
        state = newState
    }
}
