//
//  ImagesView.swift
//  mvp
//
//  Created by Alberto Penas Amor on 19/4/21.
//

import UIKit
import SwiftUI

//TODO: snackBar multiple errors with animations, when hidden after timeout we can not see it
//TODO: end page + loading -> nextPage

class ImagesView: UIView {
    private let presenter: ImagesPresenter
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let activityIndicatorView: UIActivityIndicatorView = .init(style: .large)
    private let snackBarView: SnackBarView = .init(frame: .zero)
    private let numColumns: Int = 2
    private var images: [Image] = .init()

    init(presenter: ImagesPresenter) {
        self.presenter = presenter
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didLoad() {
        presenter.fetch()
    }
}

private extension ImagesView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        snackBarView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.flowLayout.numberOfColumns(numColumns, heightRatio: 1.5)
        collectionView.backgroundColor = .white
        activityIndicatorView.color = .gray
        activityIndicatorView.hidesWhenStopped = true
        snackBarView.button.addTarget(self, action: #selector(retry), for: .touchUpInside)
        addSubview(collectionView)
        addSubview(activityIndicatorView)
        addSubview(snackBarView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),

            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),

            snackBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            snackBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            snackBarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc func retry() {
        presenter.retry()
    }
}

extension ImagesView: ImagesPresenterOutput {
    func new(state: ImagesState) {
        switch state {
        case .loading:
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        case let .error(message):
            activityIndicatorView.isHidden = true
            snackBarView.show(message: message, buttonText: "Retry")
        case let .data(imgs):
            activityIndicatorView.isHidden = true
            images = imgs
            collectionView.reloadData()
        }
    }
}

extension ImagesView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.imageView.kf.setImage(with: images[indexPath.row].url, options: [.transition(.fade(0.3)), .cacheOriginalImage])
        return cell
    }
}
/*

typealias ImageModel = Image
@available(iOS 13, *)
struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview {
                let view = ImagesView(presenter: )
                let items: [ImageModel] = [
                    .init(id: 1, url: URL(string: "https://nrs.harvard.edu/urn-3:HUAM:COIN09238_dlvr")!)
                ]
                view.new(state: .data(items))
                return view
            }
            .frame(width: 375, height: 875)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Data")
        }
        Group {
            UIViewPreview {
                let view = ImagesView()
                view.new(state: .loading)
                return view
            }
            .frame(width: 375, height: 875)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Loading")
        }
        Group {
            UIViewPreview {
                let view = ImagesView()
                view.new(state: .error("Something went wrong, try again"))
                return view
            }
            .frame(width: 375, height: 875)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Error")
        }
    }
}*/
