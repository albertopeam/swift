//
//  StoreV4.swift
//  Redux
//
//  Created by Alberto Penas Amor on 18/7/22.
//

import Foundation

import Foundation

actor StoreV4<S: State, Action, R: AsyncSequence>: ObservableObject where R.Element == S {
    typealias Input = (state: S, action: Action)
    typealias Output = R
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
        do {
            guard let newAction = await middleware(action: action) else {
                return
            }

            let stream = await reducer((state, newAction))
            for try await newState in stream {
                print(newState)
                await postState(newState)
            }
        } catch {
            print("Store has thrown: \(error)")
        }
    }

    @MainActor private func postState(_ newState: S) async {
        state = newState
    }
}
