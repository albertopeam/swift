//
//  AppDelegate.swift
//  OpenCombineUsage
//
//  Created by Alberto Penas Amor on 18/09/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import UIKit
import OpenCombine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var subscriptions = Set<AnyCancellable>()
    @OpenCombine.Published var data: String = "works!"
    //@Published var data: String = "works!" //IT DOESN'T COMPILE

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let subject = PassthroughSubject<Int, Never>()
        subject.eraseToAnyPublisher()
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { print($0) })
            .store(in: &subscriptions)
        subject.send(1)
        subject.send(2)
        subject.send(3)
        subject.send(completion: .finished)

        $data.sink(receiveValue: { print($0)})
            .store(in: &subscriptions)

        return true
    }
}

