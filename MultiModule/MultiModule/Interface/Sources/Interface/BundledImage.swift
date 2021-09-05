//
//  File.swift
//  
//
//  Created by Alberto Penas Amor on 4/9/21.
//

import SwiftUI
import UIKit

/*
public extension Image {
    public init(packageResource name: String, ofType type: String, in bundle: Bundle) {
        #if canImport(UIKit)
        guard let path = bundle.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
        #else
        self.init(name)
        #endif
    }
}*/

//public struct ImageFactory {
//    public static func make(packageResource name: String, ofType type: String, in bundle: Bundle) -> Image {
//        #if canImport(UIKit)
//        guard let path = bundle.path(forResource: name, ofType: type),
//              let image = UIImage(contentsOfFile: path) else {
//            return Image(name)
//        }
//        return Image(uiImage: image)
//        #else
//        return Image(name)
//        #endif
//    }
//}

public struct BundledImage: View {
    public let packageResource: String
    public let type: String
    public let bundle: Bundle

    public init(packageResource: String, type: String, bundle: Bundle) {
        self.packageResource = packageResource
        self.type = type
        self.bundle = bundle
    }

    public var body: some View {
        guard let path = bundle.path(forResource: packageResource, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            return Image(packageResource)
        }
        return Image(uiImage: image)
    }
}
