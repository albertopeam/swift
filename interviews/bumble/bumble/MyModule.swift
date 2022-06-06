//
//  MyModule.swift
//  bumble
//
//  Created by Alberto Penas Amor on 25/5/22.
//

import Foundation
import UIKit

enum MyModule {
    static func assemble() -> UIViewController {
        let presenter = MyPresenterImpl()
        let viewController = MyViewController.init(presenter: presenter)
        presenter.output = viewController
        return viewController
    }
}
