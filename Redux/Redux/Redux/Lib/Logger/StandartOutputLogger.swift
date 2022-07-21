//
//  StandartOutputLogger.swift
//  Redux
//
//  Created by Alberto Penas Amor on 20/7/22.
//

import Foundation

struct StandartOutputLogger: Logger {
    func print(_ message: String) {
        Swift.print(message)
    }
}
