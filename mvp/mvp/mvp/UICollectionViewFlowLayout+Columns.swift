//
//  UICollectionViewFlowLayout+Columns.swift
//  mvp
//
//  Created by Alberto Penas Amor on 20/4/21.
//

import Foundation

import UIKit

extension UICollectionViewFlowLayout {
    func numberOfColumns(_ columns: Int, heightRatio: Float) {
        let size = (UIScreen.main.bounds.width - minimumInteritemSpacing - sectionInset.left - sectionInset.right) / CGFloat(columns)
        itemSize = CGSize(width: size, height: size * CGFloat(heightRatio))
    }
}
