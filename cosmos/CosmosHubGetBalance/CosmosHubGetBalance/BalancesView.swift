//
//  ContentView.swift
//  CosmosHubGetBalance
//
//  Created by Alberto Penas Amor on 8/8/22.
//

import SwiftUI

struct BalancesView: View {
    private let bankClientType: BankClientType = BankClient()
    let address: String
    @State var coins: [Cosmos_Base_V1beta1_Coin] = .init()
    @State var error: String?

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(address)
            ForEach(coins, id: \.self) {
                Text("Balance \($0.amount) \($0.denom)")
            }
        }.task {
            do {
                coins = try await bankClientType.allBalances(for: address)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BalancesView(address: "cosmos196ax4vc0lwpxndu9dyhvca7jhxp70rmcfhxsrt")
    }
}
