//
//  ImageRepositoryImpl.swift
//  mvp
//
//  Created by Alberto Penas Amor on 19/4/21.
//

import Foundation

class ImagesRepositoryImpl: ImagesRepository {
    weak var output: ImagesRepositoryOutput?
    private let remoteDataSource: ImagesDataSource

    init(remoteDataSource: ImagesDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetch(page: Int) {
        remoteDataSource.fetch(page: page) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .success(images):
                self.output?.fetched(result: Result.success(images))
            case .failure(_):
                self.output?.fetched(result: Result.failure(.error))
            }
        }
    }
}
