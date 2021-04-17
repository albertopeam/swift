//
//  SceneFactory.swift
//  mvp
//
//  Created by Alberto Penas Amor on 20/4/21.
//

import Foundation

protocol SceneFactory {
    associatedtype Presenter
    var presenter: Presenter { get }
}
