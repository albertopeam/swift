//
//  AnalyticsStreamMiddleware.swift
//  Redux
//
//  Created by Alberto Penas Amor on 17/7/22.
//

import Foundation

struct AsyncSteamAnalyticsMiddleware: Middleware {
    func callAsFunction(action: AsyncStreamAction) async {
        switch action {
        case .add:
            print("AsyncSteamAnalyticsMiddleware add")
        case .subtract:
            print("AsyncSteamAnalyticsMiddleware subtract")
        case .reset:
            print("AsyncSteamAnalyticsMiddleware reset")
        }
    }
}
