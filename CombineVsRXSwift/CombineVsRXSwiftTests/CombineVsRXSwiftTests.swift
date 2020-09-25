//
//  CombineVsRXSwiftTests.swift
//  CombineVsRXSwiftTests
//
//  Created by Alberto Penas Amor on 25/09/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import CombineVsRXSwift

class CombineVsRXSwiftTests: XCTestCase {

    func testAsyncBehaviour() throws {
        let disposeBag = DisposeBag()
        let sut = Publisher()
        let expectation = self.expectation(description: #function)

        var output: String?
        sut.get()
            .subscribe(onNext: { output = $0; expectation.fulfill() }, onError: { _ in XCTFail() })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

        XCTAssertNotNil(output)
    }

    func testAsyncByBlocking() throws {
        let sut = Publisher()

        let result = try sut.get().toBlocking().first()

        XCTAssertNotNil(result)
    }

    func testAsyncByBlockingAndMocking() throws {
        let disposeBag = DisposeBag()
        let sut = Mediator(observable: Observable.just("Hi!"))
        let expectation = self.expectation(description: #function)

        var output: String?
        sut.get()
            .subscribe(onNext: { output = $0; expectation.fulfill() }, onError: { _ in XCTFail() })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(output, "Hi!")
    }
}

private class Publisher {
    func get() -> Observable<String> {
        let observable = Observable<String>.create { (observer) -> Disposable in
            let disposable = Disposables.create()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                observer.onNext("Hi")
            })
            return disposable
        }
        return observable
    }
}

private class Mediator {
    private let observable: Observable<String>

    init(observable: Observable<String>) {
        self.observable = observable
    }

    func get() -> Observable<String> {
        return observable
    }

}
