//
//  AnalyticsMiddleware.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation

struct AnalyticsMiddleware: Middleware {
    func callAsFunction(action: AsyncCounterAction) async -> AsyncCounterAction? {
        switch action {
        case .add:
            print("Analytics AsyncCounterAction add")
        case .subtract:
            print("Analytics AsyncCounterAction subtract")
        case .reset:
            print("Analytics AsyncCounterAction reset")
        case ._add:
            print("Analytics AsyncCounterAction add result")
        case ._subtract:
            print("Analytics AsyncCounterAction subtract result")
        }
        return action
    }
}
