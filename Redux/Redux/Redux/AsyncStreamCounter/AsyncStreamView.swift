//
//  AsyncStream.swift
//  Redux
//
//  Created by Alberto Penas Amor on 16/7/22.
//

import SwiftUI

struct AsyncStreamView: View {
    @StateObject private var store: AsyncStreamStore =
        .init(reducer: AsyncStreamReducer.reducer,
              middleware: {
            LogMiddleware<AsyncStreamAction>()
            AsyncSteamAnalyticsMiddleware()
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
                Text("Async Stream counter \(store.state.count)")
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
