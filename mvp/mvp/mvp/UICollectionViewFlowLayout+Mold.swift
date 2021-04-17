//
//  UICollectionViewFlowLayout+Mold.swift
//  mvp
//
//  Created by Alberto Penas Amor on 20/4/21.
//

import UIKit

extension UICollectionViewFlowLayout {
    static func mold(inset: CGFloat = 8,
                     minLineSpacing: CGFloat = 8,
                     minInterItemSpacing: CGFloat = 8) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        flowLayout.minimumLineSpacing = minLineSpacing
        flowLayout.minimumInteritemSpacing = minInterItemSpacing
        return flowLayout
    }
}
