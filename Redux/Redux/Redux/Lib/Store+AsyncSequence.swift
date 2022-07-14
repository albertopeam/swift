//
//  Store+AsyncSequence.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation

extension Store {
    func dispatch<Seq: AsyncSequence>(sequence: Seq) async throws where Seq.Element == Action {
        for try await action in sequence {
            await dispatch(action: action)
        }
    }
}
