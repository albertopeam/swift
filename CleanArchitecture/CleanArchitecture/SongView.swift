//
//  SongView.swift
//  CleanArchitecture
//
//  Created by Alberto Penas Amor on 08/11/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
import SwiftUI
import KingfisherSwiftUI

struct SongView: View {
    let songViewModel: SongViewModel
    var body: some View {
        HStack {
            KFImage(songViewModel.image)
                .resizable()
                .frame(width: 175,height: 175)
                .scaledToFit()
            VStack {
                Text(songViewModel.title).padding(.bottom).foregroundColor(.white)
                Text(songViewModel.artist).foregroundColor(.gray)
            }
        }
    }
}
