//
//  Store.swift
//  Redux
//
//  Created by Alberto Penas Amor on 18/7/22.
//

import Foundation

import Foundation

actor Store<S: State, Action, R: AsyncSequence>: ObservableObject where R.Element == S {
    typealias Input = (state: S, action: Action)
    typealias Output = R
    typealias Reducer = (Input) -> Output

    @MainActor @Published private(set) var state: S = .init()
    private let beforeMiddleware: AnyMiddleware<Action>?
    private let afterMiddleware: AnyMiddleware<Action>?
    private let reducer: Reducer

    init<M: Middleware>(reducer: @escaping Reducer,
                        @MiddlewareBuilder<Action> beforeMiddleware: () -> M,
                        @MiddlewareBuilder<Action> afterMiddleware: () -> M) where M.Action == Action {
        self.reducer = reducer
        self.beforeMiddleware = beforeMiddleware().eraseToAnyMiddleware()
        self.afterMiddleware = afterMiddleware().eraseToAnyMiddleware()
    }

    init<M: Middleware>(reducer: @escaping Reducer,
                        @MiddlewareBuilder<Action> beforeMiddleware: () -> M) where M.Action == Action {
        self.reducer = reducer
        self.beforeMiddleware = beforeMiddleware().eraseToAnyMiddleware()
        self.afterMiddleware = nil
    }

    init<M: Middleware>(reducer: @escaping Reducer,
                        @MiddlewareBuilder<Action> afterMiddleware: () -> M) where M.Action == Action {
        self.reducer = reducer
        self.beforeMiddleware = nil
        self.afterMiddleware = afterMiddleware().eraseToAnyMiddleware()
    }

    convenience init(reducer: @escaping Reducer) {
        self.init(reducer: reducer,
                  beforeMiddleware: { EmptyMiddleware<Action>() },
                  afterMiddleware: { EmptyMiddleware<Action>() })
    }


    func dispatch(action: Action) async {
        do {
            await beforeMiddleware?(action: action)

            let stream = await reducer((state, action))
            for try await newState in stream {
                await postState(newState)
            }

            await afterMiddleware?(action: action)
        } catch {
            print("Store has thrown: \(error)")
        }
    }

    @MainActor private func postState(_ newState: S) async {
        state = newState
    }
}
