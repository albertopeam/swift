import SwiftUI
import Interface
import Auth

public struct SettingsView: View {
    private let account: Account = Account()

    public init() {}

    public var body: some View {
        AccountView(name: account.name, email: account.email)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
