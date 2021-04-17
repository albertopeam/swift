//
//  ImagePresenterImpl.swift
//  mvp
//
//  Created by Alberto Penas Amor on 19/4/21.
//

import Foundation

class ImagesPresenterImpl: ImagesPresenter {
    weak var output: ImagesPresenterOutput?
    private let repository: ImagesRepository
    private var page: Int = 0
    private var images: [Image] = .init()

    init(repository: ImagesRepository) {
        self.repository = repository
    }

    func fetch() {
        output?.new(state: ImagesState.loading)
        repository.fetch(page: page)
    }

    func next() {
        page += 1
        repository.fetch(page: page)
    }

    func retry() {
        repository.fetch(page: page)
    }
}

extension ImagesPresenterImpl: ImagesRepositoryOutput {
    func fetched(result: Result<[Image], ImagesRepositoryError>) {
        switch result {
        case let .success(images):
            self.images = images
            output?.new(state: ImagesState.data(images))
        case let .failure(error):
            switch error {
                case .error:
                    output?.new(state: ImagesState.error("Something went wrong"))
            }

        }
    }
}
