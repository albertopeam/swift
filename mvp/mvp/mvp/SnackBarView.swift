//
//  SnackBarView.swift
//  mvp
//
//  Created by Alberto Penas Amor on 20/4/21.
//

import UIKit

final class SnackBarView: UIView {

    private let view: UIView = .init(frame: .zero)
    private let label: UILabel = .init(frame: .zero)
    let button: UIButton = .init(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1)
        label.numberOfLines = 1
        label.textColor = .white

        addSubview(view)
        view.addSubview(label)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -16),

            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(message: String, buttonText: String) {
        label.text = message
        button.setTitle(buttonText, for: .normal)
        button.setTitle(buttonText, for: .selected)
        self.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 0
                    self.isHidden = true
                }, completion: { _ in
                    self.label.text = nil
                    self.button.setTitle(nil, for: .normal)
                    self.button.setTitle(nil, for: .selected)
                })
            })
        })
    }
}
