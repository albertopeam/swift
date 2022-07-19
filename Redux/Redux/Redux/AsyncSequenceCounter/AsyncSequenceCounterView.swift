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
              middleware: {
            LogMiddleware<AsyncSequenceAction>()
        })
    @SwiftUI.State private var addTask: Task<Void, Never>?
    @SwiftUI.State private var subtractTask: Task<Void, Never>?
    @SwiftUI.State private var resetTask: Task<Void, Never>?

    var body: some View {
        VStack {
            HStack {
                ProgressView()
                    .isShown(store.state.isLoading)
                    .progressViewStyle(CircularProgressViewStyle())
                Text("Async sequence counter \(store.state.count)")
            }
            HStack {
                Button("-") {
                    addTask?.cancel()
                    addTask = Task {
                        await store.dispatch(action: .subtract)
                    }
                }
                .disabled(store.state.isLoading)
                Button("+") {
                    subtractTask?.cancel()
                    subtractTask = Task {
                        await store.dispatch(action: .add)
                    }
                }
                .disabled(store.state.isLoading)
                Button("reset") {
                    resetTask?.cancel()
                    resetTask = Task {
                        await store.dispatch(action: .reset)
                    }
                }
                .disabled(store.state.isLoading)
            }
        }
    }
}
