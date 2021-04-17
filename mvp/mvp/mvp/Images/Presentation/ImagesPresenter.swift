//
//  ImagePresenter.swift
//  mvp
//
//  Created by Alberto Penas Amor on 19/4/21.
//

import Foundation

protocol ImagesPresenter {
    var output: ImagesPresenterOutput? { get set }
    func fetch()
    func next()
    func retry()
}

protocol ImagesPresenterOutput: class {
    func new(state: ImagesState)
}

enum ImagesState {
    case loading
    case error(_ message: String)
    case data(_ images: [Image])
}
