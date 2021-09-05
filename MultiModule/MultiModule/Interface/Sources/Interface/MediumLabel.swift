//
//  File.swift
//
//
//  Created by Alberto Penas Amor on 4/9/21.
//

import SwiftUI

public struct MediumLabel: View {
    public let text: String

    public var body: some View {
        Text(text)
            .font(.system(size: 20))
    }
}

struct MediumLabel_Previews: PreviewProvider {
    static var previews: some View {
        MediumLabel(text: "Alberto")
    }
}
