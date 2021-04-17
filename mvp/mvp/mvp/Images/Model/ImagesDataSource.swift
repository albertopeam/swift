//
//  ImageDataSource.swift
//  mvp
//
//  Created by Alberto Penas Amor on 19/4/21.
//

import Foundation

protocol ImagesDataSource {
    func fetch(page: Int, callback: @escaping (_ result: Result<[Image], ImagesDataSourceError>) -> Void)
}

enum ImagesDataSourceError: Swift.Error, Equatable {
    case error
}
