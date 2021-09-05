//
//  File.swift
//  
//
//  Created by Alberto Penas Amor on 4/9/21.
//

import SwiftUI

public struct BigLabel: View {
    public let text: String

    public var body: some View {
        Text(text)
            .font(.system(size: 30))
    }
}

struct BigLabel_Previews: PreviewProvider {
    static var previews: some View {
        BigLabel(text: "Alberto")
    }
}
