//
//  main.swift
//  ParallelConcurrencyMacOS
//
//  Created by Alberto Penas Amor on 26/6/22.
//

// more info on https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html

import Foundation
import _Concurrency

/*
shared code
*/

let oneSecNanos: UInt64 = 1_000_000_000
let twoSecNanos: UInt64 = 2_000_000_000
let fiveSecNanos: UInt64 = 5_000_000_000
let httpSuccess: Int = 200

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

enum CastError: Error, Hashable {
    case casting
}

extension NSObject {
    func cast<T>(to: T.Type) throws -> T {
        if let casted = self as? T {
            return casted
        }
        throw CastError.casting
    }
}

enum HTTPURLResponseError: Error, Hashable {
    case notSuccess
}

extension HTTPURLResponse {
    func successOrThrow() throws {
        if statusCode != httpSuccess {
            throw HTTPURLResponseError.notSuccess
        }
    }
}

func work(_ delayNanos: UInt64 = oneSecNanos) async throws -> Int {
    let start = Date()
    try await Task.sleep(nanoseconds: delayNanos)
    let end = Date()
    let diff = end - start
    print("sleep time \(diff)")
    return Int.random(in: 0...100)
}

extension Thread {
    static func printCurrent() {
        print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}

/*
async - await
*/

Task.init(priority: .userInitiated) {
    let result = try await work()
    print("task result \(result)")
    Thread.printCurrent()
}


/*
parallel async
*/

Task {
    async let work1 = work(oneSecNanos)
    async let work2 = work(twoSecNanos)

    let results = try await [work1, work2]
    print("tasks results \(results)")
    Thread.printCurrent()
}


/*
parallel fibonacci
*/

func fibonacci(for number: Int) async -> Int {
    guard number >= 0 else { preconditionFailure("Negative number not valid input") }
    if number == 0 || number == 1{
        return number
    } else {
        async let a = fibonacci(for: number - 1)
        async let b = fibonacci(for: number - 2)
        return await a + b
    }
}

Task {
    let result = await fibonacci(for: 9)
    print("fibonacci \(result)")
    Thread.printCurrent()
}

/*
async sequence
*/

// FileManager
Task {
    let fileManager = FileManager.default
    let dataFileName = "data", dataExtension = "txt"
    let currentDirectoryURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Data.bundle", relativeTo: currentDirectoryURL)
    if let bundle = Bundle(url: bundleURL), let dataTxt = bundle.url(forResource: dataFileName, withExtension: dataExtension) {
        do {
            for try await line in dataTxt.lines {
                print(line)
            }
        } catch {
            print("error reading data.txt")
        }
    }
    Thread.printCurrent()
}

// URLSession https://developer.apple.com/documentation/foundation/urlsession/3767351-bytes

struct GithubStatusResponse: Decodable {
    let status: GithubStatus
    let page: GithubPage

    struct GithubStatus: Decodable {
        let description: String
        let indicator: String
    }
    struct GithubPage: Decodable {
        let id: String
        let name: String
        let url: URL
        let updated_at: String
    }
}

Task {
    let urlSession = URLSession.shared
    if let githubStatusUrl = URL(string: "https://www.githubstatus.com/api/v2/status.json") {
        do {
            let response = try await urlSession.data(from: githubStatusUrl, delegate: nil)
            let urlResponse = response.1
            let httpUrlResponse = try urlResponse.cast(to: HTTPURLResponse.self)
            try httpUrlResponse.successOrThrow()
            let data = response.0
            let githubStatusResponse = try JSONDecoder().decode(GithubStatusResponse.self, from: data)
            print("Github status: \(githubStatusResponse.status.description)")

        } catch {
            print("error fetching github status from \(githubStatusUrl)")
        }
    }
    Thread.printCurrent()
}

/*
cancellation https://developer.apple.com/documentation/swift/task
*/

let longRunningTask = Task<Int, Error> {
    try await Task.sleep(nanoseconds: fiveSecNanos)
    return 1
}
print("LongRunningTask isCancelled \(longRunningTask.isCancelled)")

Task {
    print("Waiting Task result \(await longRunningTask.result)")
    longRunningTask.cancel()
    print("LongRunningTask cancel")
    print("LongRunningTask isCancelled \(longRunningTask.isCancelled)")
    Thread.printCurrent()
}

/*
tasks and tasks groups https://developer.apple.com/documentation/swift/taskgroup
*/
enum DownloadError: Error, Equatable {
    case download
}

func photosDirectory() -> URL {
    let fm = FileManager.default
    let tmpDir = fm.temporaryDirectory
    return tmpDir
}

func photos() async throws -> [String: String] {
    try await Task.sleep(nanoseconds: oneSecNanos)
    return [
        "swift-og.png": "https://developer.apple.com/swift/images/swift-og.png",
        "swift-playgrounds-og.jpg": "https://developer.apple.com/news/images/og/swift-playgrounds-og.jpg"
    ]
}

func downloadPhoto(_ photo: String) async throws -> URL? {
    let urlSession = URLSession.shared
    if let url = URL(string: photo) {
        let response = try await urlSession.download(from: url)
        let urlResponse = response.1
        let httpUrlResponse = try urlResponse.cast(to: HTTPURLResponse.self)
        try httpUrlResponse.successOrThrow()
        let downloadUrl = response.0
        print("downloadPhoto \(downloadUrl)")
        return downloadUrl
    }
    throw DownloadError.download
}

func listDownloadPhotos(_ photos: [String]) throws {
    let url = photosDirectory()
    let fm = FileManager.default
    let contents = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    let urls = contents.map { $0.lastPathComponent }
    let photoSet = Set<String>(photos)
    let urlSet = Set<String>(urls)
    let intersection = photoSet.intersection(urlSet)
    print("listDownloadPhotos: \(intersection)")
}

func renamePhoto(from url: URL, to name: String) throws {
    let fm = FileManager.default
    let dir = photosDirectory()
    if let nameUrl = URL(string: name, relativeTo: dir) {
        try fm.moveItem(at: url, to: nameUrl)
        print("renamePhoto: \(nameUrl)")
    }
}

func removePhotos(_ photos: [String]) {
    let fm = FileManager.default
    let dir = photosDirectory()
    photos.forEach { name in
        if let url = URL(string: name, relativeTo: dir) {
            do {
                try fm.removeItem(at: url)
                print("removePhoto: \(url)")
            } catch {
                print("NOT removePhoto: \(url)")
            }
        }
    }
}

Task {
    await withTaskGroup(of: Void.self) { taskGroup in
        do {
            let photos = try await photos()
            let names = Array(photos.keys)
            removePhotos(names)
            for photo in photos {
                if let downloadUrl = try await downloadPhoto(photo.value) {
                    try renamePhoto(from: downloadUrl, to: photo.key)
                }
            }
            try listDownloadPhotos(names)
        } catch DownloadError.download {
            print("error downloading photos")
        } catch {
            print("unknown error \(error)")
        }
    }
}

/*
core data
*/

/*
actors
*/

/*
switch to main thread
*/

/*
usage in mvvm
*/

/*
tests
*/

sleep(10)
