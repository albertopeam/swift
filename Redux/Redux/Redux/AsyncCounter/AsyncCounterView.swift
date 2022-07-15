//
//  CollectionView.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation
import SwiftUI

struct AsyncCounterView: View {
    @StateObject private var store: AsyncCounterStore =
        .init(reducer: Reducers.asyncCounterReducer(state:action:),
              middleware: {
            LogMiddleware<AsyncCounterAction>()
            AnalyticsMiddleware()
        })

    var body: some View {
        VStack {
            HStack {
                ProgressView()
                    .isShown(store.state.isLoading)
                    .progressViewStyle(CircularProgressViewStyle())
                Text("Async counter \(store.state.count)")
            }
            HStack {
                Button("-") {
                    Task {
                        await store.dispatch(action: .subtract)
                    }
                }
                Button("+") {
                    Task {
                        await store.dispatch(action: .add)
                    }
                }
            }
        }.padding()
    }
}


