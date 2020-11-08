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
                .frame(width: 150,height: 150)
                .scaledToFit()
            VStack {
                Text(songViewModel.title).padding(.bottom).foregroundColor(.black)
                Text(songViewModel.artist).foregroundColor(.gray)
            }
        }
    }
}

struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SongViewModel(title: "Misunderstood - Stripped & Salty Vocal", image: URL(string: "https://i.scdn.co/image/ab67616d0000b2733360e389ec476b22236efc3b")!, artist: "Miguel Migs")
        return SongView(songViewModel: viewModel)
    }
}
