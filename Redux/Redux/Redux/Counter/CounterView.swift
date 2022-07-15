//
//  ContentView.swift
//  Redux
//
//  Created by Alberto Penas Amor on 10/7/22.
//

import SwiftUI
import _Concurrency

struct CounterView: View {
    @StateObject private var store: CounterStore = .init(reducer: Reducers.counterReducer,
                                                          middleware: { LogMiddleware() })

    var body: some View {
        VStack {
            Text("Sync counter \(store.state.count)")
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

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        return CounterView()
    }
}
