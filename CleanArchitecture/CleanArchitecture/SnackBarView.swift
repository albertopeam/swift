//
//  SnackBarView.swift
//  CleanArchitecture
//
//  Created by Alberto Penas Amor on 09/09/2020.
//  Copyright © 2020 com.github.albertopeam. All rights reserved.
//

import UIKit

final class SnackBarView: UIView {

    private let view: UIView = .init(frame: .zero)
    private let label: UILabel = .init(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1)
        label.numberOfLines = 1
        label.textColor = .white

        addSubview(view)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(message: String) {
        label.text = message
        self.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 0
                    self.isHidden = true
                })
            })
        })
    }
}
