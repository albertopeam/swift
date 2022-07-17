//
//  AsyncCounterReducer.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation
import _Concurrency

extension Reducers {
    private static let delaySecondNanos: UInt64 = 2_000_000_000

    static func acrv2(state: AsyncCounterState, action: AsyncCounterAction)
        async -> (state: AsyncCounterState, action: AsyncCounterAction?) {
            switch action {
                case .add:
                    return (AsyncCounterState(count: state.count, isLoading: true), AsyncCounterAction._add)
                case ._add:
                    try? await Task.sleep(nanoseconds: delaySecondNanos)
                    return (AsyncCounterState(count: state.count + 1 , isLoading: false), nil)
                case .subtract:
                    return (.init(count: state.count, isLoading: true), AsyncCounterAction._subtract)
                case ._subtract:
                    try? await Task.sleep(nanoseconds: delaySecondNanos)
                    return (AsyncCounterState(count: state.count - 1 , isLoading: false), nil)
                case .reset:
                    return (.init(), nil)
            }
    }
}
