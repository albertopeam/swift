//
//  SongViewModel.swift
//  CleanArchitecture
//
//  Created by Alberto Penas Amor on 08/11/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation

struct SongViewModel: Identifiable {
    let id: UUID = .init()
    let title: String
    let image: URL
    let artist: String
}
