//
//  CosmosHubGetBalanceApp.swift
//  CosmosHubGetBalance
//
//  Created by Alberto Penas Amor on 8/8/22.
//

import SwiftUI

@main
struct CosmosHubGetBalanceApp: App {
    var body: some Scene {
        WindowGroup {
            BalancesView(address: "cosmos196ax4vc0lwpxndu9dyhvca7jhxp70rmcfhxsrt")
        }
    }
}
