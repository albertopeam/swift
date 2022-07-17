//
//  Button+Enabled.swift
//  Redux
//
//  Created by Alberto Penas Amor on 15/7/22.
//

import SwiftUI

extension Button {
    @ViewBuilder func enabled(_ enabled: Bool) -> some View {
        if enabled {
            self.disabled(false)
        } else {
            self.disabled(true)
        }
    }
}
