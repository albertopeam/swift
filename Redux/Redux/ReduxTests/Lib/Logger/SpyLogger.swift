//
//  SpyLogger.swift
//  ReduxTests
//
//  Created by Alberto Penas Amor on 21/7/22.
//

import Foundation
@testable import Redux

final class SpyLogger: Logger {
    var capturedMessage: String?

    func print(_ message: String) {
        capturedMessage = message
    }
}
