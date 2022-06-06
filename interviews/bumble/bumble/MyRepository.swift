//
//  MyRepository.swift
//  bumble
//
//  Created by Alberto Penas Amor on 26/5/22.
//

import Foundation

struct MyRepositoryInput {
    let forceRefresh: Bool
}

enum MyRepositoryError: Error {
    case empty
    case error
}

protocol MyRepository {
    func get(input: MyRepositoryInput, callback: @escaping (_ result: Result<[String], MyRepositoryError>) -> Void)
}

class MyRepositoryImpl: MyRepository {
    private let remoteDataSource: MyRemoteDataSource
    private let localDataSource: MyLocalDataSource

    init(remoteDataSource: MyRemoteDataSource, localDataSource: MyLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func get(input: MyRepositoryInput, callback: @escaping (_ result: Result<[String], MyRepositoryError>) -> Void) {
        if input.forceRefresh {
            remoteDataSource.fetch { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case let .success(data):
                        self.localDataSource.store(data)
                        callback(.success(data))
                    case .failure:
                        //TODO: callback(result)
                        break
                }
            }
        } else {
            let items = localDataSource.fetch()
            if items.isEmpty {
                callback(.failure(.empty)) //TODO: network?
            } else {
                callback(.success(items))
            }
        }
    }
}

protocol MyRemoteDataSource {
    func fetch(callback: @escaping (_ result: Result<[String], Error>) -> Void)
}

protocol MyLocalDataSource {
    func fetch() -> [String]
    func store(_ items: [String])
}


