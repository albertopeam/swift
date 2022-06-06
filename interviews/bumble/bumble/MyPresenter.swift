//
//  MyPresenter.swift
//  bumble
//
//  Created by Alberto Penas Amor on 25/5/22.
//

import Foundation

protocol MyPresenterInput {
    var myState: MyState { get }
    func loadData()
    func refreshData(isInitialLoadData: Bool)
}

protocol MyPresenterOutput: AnyObject {
    func stateChanged()
}

protocol MyState {
    var loading: Bool { get }
    var items: [String] { get }
    var error: String? { get }
}

final class MyPresenterImpl: MyPresenterInput {
    private var _state: MyPresenterState
    weak var output: MyPresenterOutput?
    var myState: MyState {
        return _state
    }


    init() {
        _state = MyPresenterState.loading()
    }

    func loadData() {
        output?.stateChanged()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            let items = ["Random", "Swift", "Strings", "Produced", "Here"]
            self._state = self._state.toSuccess(items: items)
            self.output?.stateChanged()
        }
    }

    func refreshData(isInitialLoadData: Bool) {
        if isInitialLoadData {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            let items = ["Random", "Swift", "Strings", "Produced", "Here", "one more", "item", "during", "refresh"]
            self._state = self._state.toSuccess(items: items)
            self.output?.stateChanged()
        }
    }
}

struct MyPresenterState: MyState {
    let loading: Bool
    let items: [String]
    let error: String?

    static func loading() -> MyPresenterState {
        MyPresenterState(loading: true, items: [], error: nil)
    }

    func toSuccess(items: [String]) -> MyPresenterState {
        MyPresenterState(loading: false, items: items, error: nil)
    }

    func toError(error: String) -> MyPresenterState {
        MyPresenterState(loading: false, items: items, error: error)
    }
}
