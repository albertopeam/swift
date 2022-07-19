//
//  AsyncSequenceReducer.swift
//  Redux
//
//  Created by Alberto Penas Amor on 19/7/22.
//
import Foundation

enum AsyncSequenceReducer {
    // MARK: - reducer

    static func reducer(state: AsyncSequenceState, action: AsyncSequenceAction) -> Stream<AsyncSequenceState> {
        switch action {
            case .add: return add(state: state)
            case .subtract: return subtract(state: state)
            case .reset: return reset()
        }
    }

    // MARK: - iterator

    typealias IteratorFunction = () async -> AsyncSequenceState?

    static func loading(state: AsyncSequenceState) -> IteratorFunction {
        {
            AsyncSequenceState(count: state.count, isLoading: true)
        }
    }

    static func add(state: AsyncSequenceState) -> IteratorFunction {
        {
            let delaySecondNanos: UInt64 = 1_000_000_000
            try? await Task.sleep(nanoseconds: delaySecondNanos)
            return AsyncSequenceState(count: state.count + 1, isLoading: false)
        }
    }

    static func subtract(state: AsyncSequenceState) -> IteratorFunction {
        {
            let delaySecondNanos: UInt64 = 1_000_000_000
            try? await Task.sleep(nanoseconds: delaySecondNanos)
            return AsyncSequenceState(count: state.count - 1, isLoading: false)
        }
    }

    static func reset() -> IteratorFunction {
        {
            return AsyncSequenceState(count: 0, isLoading: false)
        }
    }

    // MARK: - streams

    static func add(state: AsyncSequenceState) -> Stream<AsyncSequenceState> {
        return .init(items: [
            loading(state: state),
            add(state: state)
        ])
    }

    static func subtract(state: AsyncSequenceState) -> Stream<AsyncSequenceState> {
        return .init(items: [
            loading(state: state),
            subtract(state: state)
        ])
    }

    static func reset() -> Stream<AsyncSequenceState> {
        return .init(item: reset())
    }
}
