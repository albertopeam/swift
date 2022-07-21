//
//  LogMiddleware.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation

struct LogMiddleware<Action>: Middleware {
    private let context: String
    private let logger: Logger

    init(context: String, logger: Logger) {
        self.context = context
        self.logger = logger
    }

    init(context: String) {
        self.init(context: context, logger: StandartOutputLogger())
    }

    func callAsFunction(action: Action) async {
        logger.print("\(context)-\(action)")
    }
}
