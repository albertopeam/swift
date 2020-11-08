//
//  ContentView.swift
//  CleanArchitecture
//
//  Created by Alberto Penas Amor on 07/09/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import SwiftUI
import Combine
import Adapters

struct SongsView: View {
    @ObservedObject private(set) var viewModel: SongsViewModel = .init()
    let artistId: String

    var body: some View {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        if viewModel.state.isLoading {
            return AnyView(ProgressView().onAppear(perform: { self.viewModel.songs(for: self.artistId) }))
        } else if let error = viewModel.state.error {
            let errorView = VStack {
                Text(error).font(.system(size: 24)).padding(.bottom)
                Button(viewModel.state.retry, action: { self.viewModel.songs(for: self.artistId) })
            }
            return AnyView(errorView)
        } else if !viewModel.state.songs.isEmpty {
            return AnyView(
                NavigationView {
                    List(viewModel.state.songs) {
                        CardView(anyView: AnyView(SongView(songViewModel: $0)))
                    }
                    .listStyle(PlainListStyle())
                    .listRowInsets(EdgeInsets())
                    .navigationBarTitle("Top Songs")
                    .navigationBarItems(trailing: Button.init(action: {
                        self.viewModel.songs(for: self.artistId)
                    }, label: {
                        Image(systemName: "goforward")
                    }))
                }
            )
        } else {
            return AnyView(Text("No songs"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SongsView(artistId: "6sqqGHyJ1Dnt1qKKe9iGAi")
    }
}
