//
//  ContentView.swift
//  Protobuf
//
//  Created by albertopeam on 19/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text(data())
        }
        .padding()
    }
}

private extension ContentView {
    func data() -> String {
        let book = BookInfo.with {
            $0.title = "Angels & Demons"
            $0.id = 1416524797
            $0.author = "Dan Brown"
        }
        if let protobufBinary = try? book.serializedData() {
            print("Serialize to binary protobuf format")
            print(protobufBinary)
            if let originalFromBinary = try? BookInfo(serializedData: protobufBinary) {
                print("Deserialize a received Data object from `binaryData`")
                print(originalFromBinary)
            }
        }
        if let jsonUTF8Data = try? book.jsonUTF8Data() {
            print("Serialize to JSON format as a Data object")
            print(jsonUTF8Data)
            if let originalFromJson = try? BookInfo(jsonUTF8Data: jsonUTF8Data) {
                print("Deserialize from JSON format from `jsonData`")
                print(originalFromJson)
            }
        }
        if let jsonString = try? book.jsonString() {
            print("Serialize to JSON format as a String object")
            print(jsonString)
            if let originalFromJson = try? BookInfo(jsonString: jsonString) {
                print("Deserialize from JSON format from `jsonString`")
                print(originalFromJson)
            }
        }
        return book.debugDescription
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
