import Foundation
import _Concurrency
import PlaygroundSupport
import SwiftUI

PlaygroundPage.current.needsIndefiniteExecution = true

extension View {
    @ViewBuilder func isShown(_ isShown: Bool) -> some View {
        if isShown {
            self
        } else {
            self.hidden()
        }
    }
}

extension View {
    @ViewBuilder func color(_ isError: Bool) -> some View {
        if isError {
            self.foregroundColor(.red)
        } else {
            self.foregroundColor(.black)
        }
    }
}

struct ContentView: View {
    @ObservedObject var model: ViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Text(model.text)
                    .color(model.hasError)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .isShown(model.isLoading)
            }
            .navigationTitle("Tasks in mvvm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button.init {
                        Task {
                            await model.load()
                        }
                    } label: {
                        Image(systemName: "goforward")
                    }.disabled(model.isLoading)
                }
            }
        }
        .task {
            await model.load()
        }
    }
}

final class ViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var isLoading: Bool = true
    @Published var hasError: Bool = false

    func load() async {
        do {
            await toReloadingState()
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let random = Int.random(in: 0...100)
            if random % 2 == 0 {
                await toSuccessState(random)
            } else {
                await toErrorState(random)
            }
        } catch {
            await toErrorState(-1)
        }
    }

    @MainActor private func toSuccessState(_ num: Int) {
        text = "even \(num)"
        isLoading = false
        hasError = false
    }

    @MainActor private func toErrorState(_ num: Int) {
        if num == -1 {
            text = "something went wrong"
            hasError = true
        } else {
            text = "odd \(num)"
            hasError = false
        }
        isLoading = false
    }

    @MainActor private func toReloadingState() {
        text = ""
        isLoading = true
        hasError = false
    }
}

let viewModel = ViewModel()
let view = ContentView(model: viewModel)
PlaygroundPage.current.setLiveView(ContentView(model: viewModel))
