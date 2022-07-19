//
//  Stream+Values.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 19/7/22.
//

import Foundation
@testable import Redux

extension Redux.Stream {
    func values() async -> [Element] {
        var output: [Element] = .init()
        for await newState in self {
            output.append(newState)
        }
        return output
    }
}
