import Foundation
import IrohaCrypto

extension ConnectionItem {
    static var defaultConnection: ConnectionItem {
        return ConnectionItem(title: "Uni-Arts, Parity node",
                              url: URL(string: "wss://testnet.uniarts.me")!,
                              type: SNAddressType.genericSubstrate)
    }

    static var supportedConnections: [ConnectionItem] {
        [
            ConnectionItem(title: "Kusama, Parity node",
                           url: URL(string: "wss://testnet.uniarts.me")!,
                           type: SNAddressType.kusamaMain),
            ConnectionItem(title: "Kusama, Web3 Foundation node",
                           url: URL(string: "wss://testnet.uniarts.me")!,
                           type: SNAddressType.kusamaMain),
            ConnectionItem(title: "Uni-Arts, Parity node",
                           url: URL(string: "wss://testnet.uniarts.me")!,
                           type: SNAddressType.genericSubstrate),
//            ConnectionItem(title: "Polkadot, Parity node",
//                           url: URL(string: "wss://rpc.polkadot.io")!,
//                           type: SNAddressType.genericSubstrate),
            ConnectionItem(title: "Polkadot, Web3 Foundation node",
                           url: URL(string: "wss://testnet.uniarts.me")!,
                           type: SNAddressType.genericSubstrate),
            ConnectionItem(title: "Westend, Parity node",
                           url: URL(string: "wss://testnet.uniarts.me")!,
                           type: SNAddressType.genericSubstrate),
            ConnectionItem(title: "Westend, Soramitsu node",
                           url: URL(string: "wss://testnet.uniarts.me")!,
                           type: SNAddressType.genericSubstrate)
        ]
    }
}
