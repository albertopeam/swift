//
//  CardView.swift
//  CleanArchitecture
//
//  Created by Alberto Penas Amor on 08/11/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import Foundation
import SwiftUI

struct CardView: View {
    let anyView: AnyView
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(radius: 2)
            anyView
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(anyView: AnyView(/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/))
    }
}
