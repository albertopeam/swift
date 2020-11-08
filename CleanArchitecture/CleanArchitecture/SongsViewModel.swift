//
//  SongsViewModel.swift
//  CleanArchitecture
//
//  Created by Alberto Penas Amor on 08/11/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
import Combine
import Application
import Entities
import Adapters

class SongsViewModel: ObservableObject {

    // MARK: - public
    @Published private(set) var state: ViewState
    private let useCase: UseCase
    private var subscriptions = Set<AnyCancellable>()

    init(state: ViewState = LoadingViewState(),
         useCase: UseCase = UseCaseImplementation(api: ApiImplementation())) {
        self.state = state
        self.useCase = useCase
    }

    func songs(for artistId: String) {
        state = LoadingViewState()
        useCase.get(for: artistId)
            .map({ SongsViewModelMapper().map($0) })
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] in
                switch $0 {
                case .finished:
                    break
                case .failure(_):
                    self?.state = ErrorViewSate(error: "Something went wrong")
                }
            }, receiveValue: { [weak self] in self?.state = SuccessViewState(songs: $0) })
            .store(in: &subscriptions)
    }
}

struct SongsViewModelMapper {
    func map(_ songs: [Song]) -> [SongViewModel] {
        songs.map({ SongViewModel(title: $0.name, image: $0.imageUrl, artist: $0.artists.first ?? "") })
    }
}
