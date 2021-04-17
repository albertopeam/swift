//
//  ImageCollectionViewCell.swift
//  mvp
//
//  Created by Alberto Penas Amor on 20/4/21.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: ImageCollectionViewCell.self)
    let imageView: UIImageView = .init(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }

}

private extension ImageCollectionViewCell {
    func setup() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
