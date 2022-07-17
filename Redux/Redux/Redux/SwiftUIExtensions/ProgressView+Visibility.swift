//
//  ProgressView+ConditionalVisibility.swift
//  Redux
//
//  Created by Alberto Penas Amor on 15/7/22.
//

import SwiftUI

extension ProgressView {
    @ViewBuilder func isHidden(_ hide: Bool) -> some View {
        if hide {
            self.hidden()
        } else {
            self
        }
    }

    @ViewBuilder func isShown(_ show: Bool) -> some View {
        if show {
            self
        } else {
            self.hidden()
        }
    }
}
