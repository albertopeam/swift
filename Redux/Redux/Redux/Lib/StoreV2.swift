//
//  StoreV2.swift
//  Redux
//
//  Created by Alberto Penas Amor on 17/7/22.
//

import Foundation

actor StoreV2<S: State, Action>: ObservableObject {
    typealias Input = (state: S, action: Action)
    typealias Output = (state: S, action: Action?)
    typealias Reducer = (Input) async -> Output

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
        var output: (S, Action?)
        var currentAction: Action = action
        repeat {
            guard let newAction = await middleware(action: currentAction) else {
                return
            }
            let currentState = await state
            output = await reducer((currentState, newAction))
            await postState(output.0)
            if let action = output.1 {
                currentAction = action
            }
        } while output.1 != nil
    }

    @MainActor private func postState(_ newState: S) async {
        state = newState
    }

    @MainActor private func getState() -> S {
        return state //main
    }
}

