//
//  SongsViewState.swift
//  CleanArchitecture
//
//  Created by Alberto Penas Amor on 08/11/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation

protocol ViewState {
    var isLoading: Bool { get }
    var songs: [SongViewModel] { get }
    var error: String? { get }
    var retry: String { get }
}

extension ViewState {
    var retry: String { "Retry" }
}

struct LoadingViewState: ViewState {
    let isLoading: Bool = true
    let songs: [SongViewModel] = .init()
    let error: String? = nil
}

struct ErrorViewSate: ViewState {
    let isLoading: Bool = false
    let songs: [SongViewModel] = .init()
    let error: String?
}

struct SuccessViewState: ViewState {
    let isLoading: Bool = false
    let songs: [SongViewModel]
    let error: String? = nil
}

