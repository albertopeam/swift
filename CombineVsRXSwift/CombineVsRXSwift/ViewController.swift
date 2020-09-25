//
//  ViewController.swift
//  CombineVsRXSwift
//
//  Created by Alberto Penas Amor on 25/09/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import UIKit
import Combine
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let coldPublish = ColdPublishSubject()
    private let hotPublish = HotPublishSubject()
    private let justPublisher = JustPublisher()
    private let emptyPublisher = EmptyPublisher()
    private let failurePublisher = FailurePublisher()
    private let futurePublisher = FuturePublisher()
    private let cancelables = Cancelables()
    private let replayPublisher = ReplayPublisher()
    private let foundationPublisher = FoundationClass()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

enum Error: Swift.Error {
    case any
}

/// same behaviour between PassthroughSubject and PublishSubject.
/// note that combine has typed errors while rxswift not
class ColdPublishSubject {
    private var subscriptions = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()
    private let err = Error.any

    func emit() {
        let passhtroughSubject = PassthroughSubject<Int, Never>()
        passhtroughSubject.send(1)
        passhtroughSubject
            .print("Combine")
            .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
            .store(in: &subscriptions)
        passhtroughSubject.send(1)
        passhtroughSubject.send(completion: .finished)
        passhtroughSubject.send(2)

        let publishSubject = PublishSubject<Int>()
        publishSubject.onNext(1)
        publishSubject
            .debug("RXSwift")
            .subscribe(onNext: { print("RXSwift \($0)") }, onCompleted: { print("RXSwift completed") })
            .disposed(by: disposeBag)
        publishSubject.onNext(1)
        publishSubject.onCompleted()
        publishSubject.onNext(2)
    }

    func error() {
        let passhtroughSubject = PassthroughSubject<Int, Error>()
        passhtroughSubject
            .print("Combine")
            .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
            .store(in: &subscriptions)
        passhtroughSubject.send(completion: .failure(err))
        passhtroughSubject.send(1)
        passhtroughSubject.send(completion: .finished)

        let publishSubject = PublishSubject<Int>()
        publishSubject
            .debug("RXSwift")
            .subscribe(onNext: { print("RXSwift \($0)") }, onError: { error in print("RXSwift \(error)") }, onCompleted: { print("RXSwift completed") })
            .disposed(by: disposeBag)
        publishSubject.onError(err)
        publishSubject.onNext(1)
        publishSubject.onCompleted()
    }
}

/// same behaviour between CurrentValueSubject and BehaviorSubject.
/// note that combine has typed errors while rxswift not
class HotPublishSubject {
    private var subscriptions = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()
    private let err = Error.any

    func emit() {
        let currentValueSubject = CurrentValueSubject<Int, Never>(0)
        currentValueSubject.send(1)
        currentValueSubject
            .print("Combine")
            .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
            .store(in: &subscriptions)
        currentValueSubject.send(2)
        currentValueSubject.send(completion: .finished)
        currentValueSubject.send(3)

        let behaviourSubject = BehaviorSubject<Int>(value: 0)
        behaviourSubject.onNext(1)
        behaviourSubject
            .debug("RXSwift")
            .subscribe(onNext: { print("RXSwift \($0)") }, onCompleted: { print("RXSwift completed") })
            .disposed(by: disposeBag)
        behaviourSubject.onNext(2)
        behaviourSubject.onCompleted()
        behaviourSubject.onNext(3)
    }

    func error() {
        let currentValueSubject = CurrentValueSubject<Int, Error>(0)
        currentValueSubject
            .print("Combine")
            .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
            .store(in: &subscriptions)
        currentValueSubject.send(completion: .failure(err))
        currentValueSubject.send(1)
        currentValueSubject.send(completion: .finished)

        let behaviourSubject = BehaviorSubject<Int>(value: 0)
        behaviourSubject
            .debug("RXSwift")
            .subscribe(onNext: { print("RXSwift \($0)") }, onError: { error in print("RXSwift \(error)") }, onCompleted: { print("RXSwift completed") })
            .disposed(by: disposeBag)
        behaviourSubject.onError(err)
        behaviourSubject.onNext(1)
        behaviourSubject.onCompleted()
    }
}

/// same behaviour between Just and Observable<Int>.just
class JustPublisher {
    private var subscriptions = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()

    func emit() {
        Combine.Just(0)
            .print("Combine")
            .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
            .store(in: &subscriptions)

        Observable<Int>.just(0)
            .debug("RXSwift")
            .subscribe(onNext: { print("RXSwift \($0)") }, onCompleted: { print("RXSwift completed") })
            .disposed(by: disposeBag)
    }
}

/// same behaviour between Empty and Observable<Int>.empty()
class EmptyPublisher {
    private var subscriptions = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()

    func emit() {
        Combine.Empty<Int, Error>()
            .print("Combine")
            .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
            .store(in: &subscriptions)

        Observable<Int>.empty()
            .debug("RXSwift")
            .subscribe(onNext: { print("RXSwift \($0)") }, onCompleted: { print("RXSwift completed") })
            .disposed(by: disposeBag)
    }
}

/// same behaviour between Fail and Observable<Int>.error(Error.any)
/// note that combine has typed errors while rxswift not
class FailurePublisher {
    private var subscriptions = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()

    func emit() {
        Combine.Fail<Int, Error>(error: .any)
            .print("Combine")
            .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
            .store(in: &subscriptions)

        Observable<Int>.error(Error.any)
            .debug("RXSwift")
            .subscribe(onNext: { print("RXSwift \($0)") }, onError: { error in print("RXSwift \(error)") }, onCompleted: { print("RXSwift completed") })
            .disposed(by: disposeBag)
    }
}

class FuturePublisher {
    private var subscriptions = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()

    func emit() {
        let noSubscribedCombineFuture = Combine.Future<Int, Error> { promise in
            print("Combine Future started")
            promise(.success(0))
        }
        let noSubscribedRXSwiftFuture = RxSwift.Single<Int>.create { (observer) -> Disposable in
            print("RXSwift Future started")
            let disposable = Disposables.create()
            observer(.success(0))
            return disposable
        }


        Combine.Future<Int, Error> { promise in
            promise(.success(0))
        }
        .print("Combine")
        .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
        .store(in: &subscriptions)

        RxSwift.Single<Int>.create { (observer) -> Disposable in
            let disposable = Disposables.create()
            observer(.success(0))
            return disposable
        }
        .debug("RXSwift")
        .subscribe(onSuccess: { print("RXSwift \($0)") }, onError: { print("RXSwift \($0)") } )
        .disposed(by: disposeBag)
    }
}

class Cancelables {
    private var rxswift: RXSwiftClass? = RXSwiftClass()
    private var combine: CombineClass? = CombineClass()

    func emit() {
        rxswift!.single()
            .debug("RXSwift")
            .subscribe(onSuccess: { print("RXSwift \($0)") }, onError: { print("RXSwift \($0)") } )
            .disposed(by: rxswift!.disposeBag)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.rxswift = nil
        })

        combine!.future()
            .print("Combine")
            .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
            .store(in: &combine!.cancellable)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.combine = nil
        })
    }

    class RXSwiftClass {

        var disposeBag = DisposeBag()

        deinit {
            print("RXSwift deinit")
        }

        func single() -> RxSwift.Single<Int> {
            RxSwift.Single<Int>.create { (observer) -> Disposable in
                let disposable = Disposables.create {
                    print("RXSwift canceled")
                }
                return disposable
            }
        }
    }

    class CombineClass {
        var cancellable: Set<AnyCancellable> = .init()

        deinit {
            print("Combine deinit")
        }

        func future() -> Future<Int, Error> {
            return Combine.Future<Int, Error> { promise in }
        }
    }

}

class ReplayPublisher {
    private var subscriptions = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()

    func emit() {
        let combineReplaySubject = ReplaySubject<Int, Error>(2)
        combineReplaySubject.send(0)
        combineReplaySubject.send(1)
        combineReplaySubject.send(2)
        combineReplaySubject
            .print("Combine")
            .sink(receiveCompletion: { print("Combine \($0)") }, receiveValue: { print("Combine \($0)") })
            .store(in: &subscriptions)
        combineReplaySubject.send(completion: .finished)
        combineReplaySubject.send(2)

        let rxswiftReplaySubject = RxSwift.ReplaySubject<Int>.create(bufferSize: 2)
        rxswiftReplaySubject.onNext(0)
        rxswiftReplaySubject.onNext(1)
        rxswiftReplaySubject.onNext(2)
        rxswiftReplaySubject
            .debug("RXSwift")
            .subscribe(onNext: { print("RXSwift \($0)") }, onError: { error in print("RXSwift \(error)") }, onCompleted: { print("RXSwift completed") })
            .disposed(by: disposeBag)
        rxswiftReplaySubject.onCompleted()
        rxswiftReplaySubject.onNext(2)
    }
}

class FoundationClass {
    private var subscriptions = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()

    func emit() {
        URLSession.shared.rx.response(request: URLRequest(url: URL(string: "https://google.com")!))
            .debug("RXSwift")
            .subscribe(onNext: { print("RXSwift \($0)") }, onError: { error in print("RXSwift \(error)") }, onCompleted: { print("RXSwift completed") })
            .disposed(by: disposeBag)
    }
}

//
// MIT License
//
// https://github.com/sgl0v/OnSwiftWings/tree/master/ShareReplay.playground
//
/// ReplaySubject represents a subject that is able to replay sended values prior to any subscriber is connected
public final class ReplaySubject<Output, Failure: Swift.Error>: Combine.Subject {
    private var buffer = [Output]()
    private let bufferSize: Int
    private var subscriptions = [ReplaySubjectSubscription<Output, Failure>]()
    private var completion: Subscribers.Completion<Failure>?
    private let lock = NSRecursiveLock()

    public init(_ bufferSize: Int = 0) {
        self.bufferSize = bufferSize
    }

    /// Provides this Subject an opportunity to establish demand for any new upstream subscriptions
    public func send(subscription: Subscription) {
        lock.lock(); defer { lock.unlock() }
        subscription.request(.unlimited)
    }

    /// Sends a value to the subscriber.
    public func send(_ value: Output) {
        lock.lock(); defer { lock.unlock() }
        buffer.append(value)
        buffer = buffer.suffix(bufferSize)
        subscriptions.forEach { $0.receive(value) }
    }

    /// Sends a completion signal to the subscriber.
    public func send(completion: Subscribers.Completion<Failure>) {
        lock.lock(); defer { lock.unlock() }
        self.completion = completion
        subscriptions.forEach { subscription in subscription.receive(completion: completion) }
    }

    /// This function is called to attach the specified `Subscriber` to the`Publisher
    public func receive<Downstream: Subscriber>(subscriber: Downstream) where Downstream.Failure == Failure, Downstream.Input == Output {
        lock.lock(); defer { lock.unlock() }
        let subscription = ReplaySubjectSubscription<Output, Failure>(downstream: AnySubscriber(subscriber))
        subscriber.receive(subscription: subscription)
        subscriptions.append(subscription)
        subscription.replay(buffer, completion: completion)
    }
}

/// A class representing the connection of a subscriber to a publisher.
public final class ReplaySubjectSubscription<Output, Failure: Swift.Error>: Subscription {
    private let downstream: AnySubscriber<Output, Failure>
    private var isCompleted = false
    private var demand: Subscribers.Demand = .none

    public init(downstream: AnySubscriber<Output, Failure>) {
        self.downstream = downstream
    }

    // Tells a publisher that it may send more values to the subscriber.
    public func request(_ newDemand: Subscribers.Demand) {
        demand += newDemand
    }

    public func cancel() {
        isCompleted = true
    }

    public func receive(_ value: Output) {
        guard !isCompleted, demand > 0 else { return }

        demand += downstream.receive(value)
        demand -= 1
    }

    public func receive(completion: Subscribers.Completion<Failure>) {
        guard !isCompleted else { return }
        isCompleted = true
        downstream.receive(completion: completion)
    }

    public func replay(_ values: [Output], completion: Subscribers.Completion<Failure>?) {
        guard !isCompleted else { return }
        values.forEach { value in receive(value) }
        if let completion = completion { receive(completion: completion) }
    }
}


