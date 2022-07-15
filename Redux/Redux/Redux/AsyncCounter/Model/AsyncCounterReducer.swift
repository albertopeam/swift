//
//  AsyncCounterReducer.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation
import _Concurrency

extension Reducers {
    private static let oneSecondNanos: UInt64 = 2_000_000_000

    static func asyncCounterReducer(state: AsyncCounterState, action: AsyncCounterAction) async -> AsyncCounterState {
        switch action {
            case .add:
                try? await Task.sleep(nanoseconds: oneSecondNanos)
                return .init(count: state.count + 1, isLoading: false)
            case .subtract:
                try? await Task.sleep(nanoseconds: oneSecondNanos)
                return .init(count: state.count - 1, isLoading: false)
            case .reset:
                return .init()
        }
    }
}
