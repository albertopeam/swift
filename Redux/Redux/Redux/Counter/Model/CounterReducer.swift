//
//  CounterReducer.swift
//  Redux
//
//  Created by Alberto Penas Amor on 13/7/22.
//

import Foundation

extension Reducers {
    static func counterReducer(state: CounterState, action: CounterAction) async -> CounterState {
        switch action {
            case .add:
                return .init(count: state.count + 1)
            case .subtract:
                return .init(count: state.count - 1)
        }
    }
}
