//
//  ContentView.swift
//  CleanArchitecture
//
//  Created by Alberto Penas Amor on 07/09/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import SwiftUI
import Adapters

struct ContentView: View {
    let adapter: Adapter = .init()
    var body: some View {
        Text(adapter.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
