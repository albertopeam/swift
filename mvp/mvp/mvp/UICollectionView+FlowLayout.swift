//
//  UICollectionView+FlowLayout.swift
//  mvp
//
//  Created by Alberto Penas Amor on 20/4/21.
//

import UIKit.UICollectionView
import UIKit.UICollectionViewLayout

extension UICollectionView {

    var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }

}
