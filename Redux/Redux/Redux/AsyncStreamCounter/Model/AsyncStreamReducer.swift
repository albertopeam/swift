//
//  AsyncStreamReducer.swift
//  Redux
//
//  Created by Alberto Penas Amor on 16/7/22.
//

import Foundation

enum AsyncStreamReducer {
    // MARK: - reducer

    static func reducer(state: AsyncStreamState, action: AsyncStreamAction) -> Stream<AsyncStreamState> {
        switch action {
            case .add: return add(state: state)
            case .subtract: return subtract(state: state)
            case .reset: return reset()
        }
    }

    // MARK: - iterator

    typealias IteratorFunction = () async -> AsyncStreamState?

    static func loading(state: AsyncStreamState) -> IteratorFunction {
        {
            AsyncStreamState(count: state.count, isLoading: true)
        }
    }

    static func add(state: AsyncStreamState) -> IteratorFunction {
        {
            let delaySecondNanos: UInt64 = 1_000_000_000
            try? await Task.sleep(nanoseconds: delaySecondNanos)
            return AsyncStreamState(count: state.count + 1, isLoading: false)
        }
    }

    static func subtract(state: AsyncStreamState) -> IteratorFunction {
        {
            let delaySecondNanos: UInt64 = 1_000_000_000
            try? await Task.sleep(nanoseconds: delaySecondNanos)
            return AsyncStreamState(count: state.count - 1, isLoading: false)
        }
    }

    static func reset() -> IteratorFunction {
        {
            return AsyncStreamState(count: 0, isLoading: false)
        }
    }

    // MARK: - streams

    static func add(state: AsyncStreamState) -> Stream<AsyncStreamState> {
        return .init(items: [
            loading(state: state),
            add(state: state)
        ])
    }

    static func subtract(state: AsyncStreamState) -> Stream<AsyncStreamState> {
        return .init(items: [
            loading(state: state),
            subtract(state: state)
        ])
    }

    static func reset() -> Stream<AsyncStreamState> {
        return .init(item: reset())
    }

}
