//
//  ImagesFactory.swift
//  mvp
//
//  Created by Alberto Penas Amor on 20/4/21.
//

import Foundation

struct ImagesFactory: SceneFactory {
    typealias Presenter = ImagesPresenter
    let presenter: ImagesPresenter

    init() {
        let remoteDataSource = HarvardImagesDataSourceImplementation()
        let repository = ImagesRepositoryImpl(remoteDataSource: remoteDataSource)
        let presenter = ImagesPresenterImpl(repository: repository)
        repository.output = presenter
        self.presenter = presenter
    }
}
