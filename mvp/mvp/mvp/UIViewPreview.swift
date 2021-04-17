//
//  UIViewPreview.swift
//  mvp
//
//  Created by Alberto Penas Amor on 20/4/21.
//

import UIKit
import SwiftUI

@available(iOS 13, *)
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context _: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context _: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

