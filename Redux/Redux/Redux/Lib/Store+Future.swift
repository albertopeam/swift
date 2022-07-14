//
//  Store+Future.swift
//  Redux
//
//  Created by Alberto Penas Amor on 14/7/22.
//

import Foundation
import Combine

extension Store {
    func dispatch(future: Future<Action?, Never>) {
        var subscription: AnyCancellable?
        subscription = future.sink { _ in
            if subscription != nil {
                subscription = nil
            }
        } receiveValue: { action in
            guard let action = action else {
                return
            }

            Task {
                await self.dispatch(action: action)
            }
        }
    }
}
