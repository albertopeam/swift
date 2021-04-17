//
//  ImageRepository.swift
//  mvp
//
//  Created by Alberto Penas Amor on 19/4/21.
//

import Foundation

protocol ImagesRepository {
    func fetch(page: Int)
}

protocol ImagesRepositoryOutput: class {
    func fetched(result: Result<[Image], ImagesRepositoryError>)
}

enum ImagesRepositoryError: Swift.Error, Equatable {
    case error
}
