//
//  Store+Publisher.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation
import Combine

extension StoreV1 {
    func dispatch<P: Publisher>(publisher: P) where P.Output == Action, P.Failure == Never {
        var subscription: AnyCancellable?
        subscription = publisher.sink { _ in
            if subscription != nil {
                subscription = nil
            }
        } receiveValue: { action in
            Task {
                await self.dispatch(action: action)
            }
        }
    }
}
