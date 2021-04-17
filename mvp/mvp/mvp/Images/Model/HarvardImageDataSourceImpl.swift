//
//  HarvardImageDataSourceImpl.swift
//  mvp
//
//  Created by Alberto Penas Amor on 19/4/21.
//

import Foundation
import Alamofire

struct HarvardImagesDataSourceImplementation: ImagesDataSource {
    private let url = "https://api.harvardartmuseums.org"
    private let path = "image"
    private let apiKeyParam = "apikey=85bd9402-c6a6-4312-8075-f1126de21ee8"
    private let sizeParam = "size=100"
    private let baseUrl: String = ""

    func fetch(page: Int, callback: @escaping (_ result: Result<[Image], ImagesDataSourceError>) -> Void) {
        let pageParam = "page=\(page)"
        let targetURL = "\(url)/\(path)?\(sizeParam)&\(pageParam)&\(apiKeyParam)"
        AF.request(targetURL)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: ResponseDecodable.self) { response in
                switch response.result {
                case let .success(data):
                    let images = map(data)
                    callback(Result.success(images))
                case let .failure(err):
                    print(err)
                    callback(Result.failure(.error))
                }
            }
    }
}

private extension HarvardImagesDataSourceImplementation {
    struct ResponseDecodable: Decodable {
        let records: [ImageDecodable]
    }
    struct ImageDecodable: Decodable {
        let id: Int
        let baseimageurl: String
    }

    func map(_ response: ResponseDecodable) -> [Image] {
        return response.records.compactMap { record -> Image? in
            guard let url = URL(string: record.baseimageurl) else { return nil }
            return Image(id: record.id, url: url)
        }
    }
}
