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
        .init(reducer: Reducers.acrv2(state:action:),
              middleware: {
            LogMiddleware<AsyncCounterAction>(context: String(describing: Self.self))
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
                .disabled(store.state.isLoading)
                Button("+") {
                    Task {
                        await store.dispatch(action: .add)
                    }
                }
                .disabled(store.state.isLoading)
            }
        }.padding()
    }
}


