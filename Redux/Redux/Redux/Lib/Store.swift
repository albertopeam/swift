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
    private let reducer: Reducer

    @MainActor init(state: S, reducer: @escaping Reducer) {
        self.state = state
        self.reducer = reducer
    }

    init(reducer: @escaping Reducer) {
        self.reducer = reducer
    }

    func dispatch(action: Action) async {
        let newState = await reducer(state, action)
        await dispatch(newState: newState)
    }

    @MainActor private func dispatch(newState: S) async {
        state = newState
    }
}
