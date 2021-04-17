//
//  ViewController.swift
//  mvp
//
//  Created by Alberto Penas Amor on 17/4/21.
//

import UIKit

class ImagesViewController: UIViewController {

    private let imagesView: ImagesView

    init(sceneFactory: ImagesFactory) {
        var presenter = sceneFactory.presenter
        imagesView = .init(presenter: presenter)
        presenter.output = imagesView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imagesView)
        NSLayoutConstraint.activate([
            imagesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imagesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imagesView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        imagesView.didLoad()
    }
}
