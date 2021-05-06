import Foundation

extension Chain {
    var genesisHash: String {
        switch self {
        case .uniarts:
            if let tempGenesisHash = UserDefaults.standard.value(forKey: "JLGenisisHash") as? String {
                return tempGenesisHash
            } else {
                return "55940785b92be6342ba1007488a3f46fdbef213cd1b412d35236b03528079aaa"
            }
//            return "91b171bb158e2d3848fa23a9f1c25182fb8e20313b2c1eb49219da7a70ce90c3"
        case .kusama:
            return "b0a8d493285c2df73290dfb7e61f870f17b41801197a149ca93654499ea3dafe"
        case .westend:
            return "e143f23803ac50e8f6f8e62695d1ce9e4e1d68aa36c1cd2cfd15340213f3423e"
        }
    }

    var existentialDeposit: Decimal {
        switch self {
        case .uniarts:
//            return Decimal(string: "1")!
            return Decimal(string: "0")!
        case .kusama:
            return Decimal(string: "0.001666666666")!
        case .westend:
            return Decimal(string: "0.01")!
        }
    }

    func polkascanExtrinsicURL(_ hash: String) -> URL? {
        switch self {
        case .uniarts:
            return URL(string: "https://polkascan.io/polkadot/extrinsic/\(hash)")
        case .kusama:
            return URL(string: "https://polkascan.io/kusama/extrinsic/\(hash)")
        case .westend:
            return nil
        }
    }

    func polkascanAddressURL(_ address: String) -> URL? {
        switch self {
        case .uniarts:
            return URL(string: "https://polkascan.io/polkadot/account/\(address)")
        case .kusama:
            return URL(string: "https://polkascan.io/kusama/account/\(address)")
        case .westend:
            return nil
        }
    }

    func subscanExtrinsicURL(_ hash: String) -> URL? {
        switch self {
        case .uniarts:
            return URL(string: "https://polkadot.subscan.io/extrinsic/\(hash)")
        case .kusama:
            return URL(string: "https://kusama.subscan.io/extrinsic/\(hash)")
        case .westend:
            return URL(string: "https://westend.subscan.io/extrinsic/\(hash)")
        }
    }

    func subscanAddressURL(_ address: String) -> URL? {
        switch self {
        case .uniarts:
            return URL(string: "https://polkadot.subscan.io/account/\(address)")
        case .kusama:
            return URL(string: "https://kusama.subscan.io/account/\(address)")
        case .westend:
            return URL(string: "https://westend.subscan.io/account/\(address)")
        }
    }
}
