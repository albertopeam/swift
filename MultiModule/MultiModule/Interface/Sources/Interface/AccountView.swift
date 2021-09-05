import SwiftUI

public struct AccountView: View {
    public let name: String
    public let email: String

    public init(name: String, email: String) {
        self.name = name
        self.email = email
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            BigLabel(text: name)
            Text(email)
                .foregroundColor(.gray)
        })
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(name: "Alberto", email: "albertopeam@gmail.com")
    }
}
