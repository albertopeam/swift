//
//  Client.swift
//  CosmosHubGetBalance
//
//  Created by Alberto Penas Amor on 10/8/22.
//

import Foundation
import GRPC
import NIO

protocol BankClientType {
    func allBalances(for address: String) async throws -> [Cosmos_Base_V1beta1_Coin]
}

final class BankClient: BankClientType {
    private let host: String = "cosmoshub.strange.love"
    private let port: Int = 9090
    private let group: EventLoopGroup
    private let client: Cosmos_Bank_V1beta1_QueryAsyncClient

    init() {
        do {
            group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
            let channel = try GRPCChannelPool.with(
                target: .host(host, port: port),
                transportSecurity: .plaintext,
                eventLoopGroup: group
            )
            client = .init(channel: channel)
        }catch {
            fatalError("Can not create Bank Client")
        }
    }

    deinit {
        try? group.syncShutdownGracefully()
    }

    func allBalances(for address: String) async throws -> [Cosmos_Base_V1beta1_Coin] {
        var request = Cosmos_Bank_V1beta1_QueryAllBalancesRequest()
        request.address = address
        let response = try await client.allBalances(request)
        return response.balances
    }
}
