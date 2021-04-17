//
//  ImagesAssembler.swift
//  mvp
//
//  Created by Alberto Penas Amor on 19/4/21.
//

import UIKit

struct ImagesAssembler {
    static func assemble() -> UIViewController {
        return ImagesViewController(sceneFactory: ImagesFactory())
    }
}
