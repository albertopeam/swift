//
//  AsyncSequenceCounterView.swift
//  Redux
//
//  Created by Alberto Penas Amor on 19/7/22.
//

import Foundation
import SwiftUI

struct AsyncSequenceCounterView: View {
    @StateObject private var store: AsyncSequenceStore =
        .init(reducer: AsyncSequenceReducer.reducer,
              beforeMiddleware: { LogMiddleware(context: "Before") },
              afterMiddleware: { LogMiddleware(context: "After") })

    var body: some View {
        VStack {
            HStack {
                ProgressView()
                    .isShown(store.state.isLoading)
                    .progressViewStyle(CircularProgressViewStyle())
                HStack {
                    Text("Async sequence counter")
                        .accessibilityIdentifier("counter")
                    Text(store.state.count.description)
                        .accessibilityIdentifier("count")
                }
            }
            HStack {
                Button("-") {
                    Task {
                        await store.dispatch(action: .subtract)
                    }
                }
                .accessibilityIdentifier("subtract")
                .disabled(store.state.isLoading)
                Button("+") {
                    Task {
                        await store.dispatch(action: .add)
                    }
                }
                .accessibilityIdentifier("add")
                .disabled(store.state.isLoading)
                Button("reset") {
                    Task {
                        await store.dispatch(action: .reset)
                    }
                }
                .accessibilityIdentifier("reset")
                .disabled(store.state.isLoading)
            }
        }
    }
}
