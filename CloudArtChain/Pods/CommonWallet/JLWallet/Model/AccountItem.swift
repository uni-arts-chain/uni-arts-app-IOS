import Foundation

@objc enum CryptoType: UInt8, Codable, CaseIterable {
    case sr25519
    case ed25519
    case ecdsa
}

struct JLWalletAccountItem: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case address
        case cryptoType
        case username
        case publicKeyData
    }

    let address: String
    let cryptoType: CryptoType
    let username: String
    let publicKeyData: Data
    
    func getHiddenAddress() -> String {
        return "0x" + address.prefix(9) + "..." + address.suffix(9)
    }
}

@objc class JLWalletCustomAccountItem: NSObject {
    @objc let address: String
    @objc let cryptoType: CryptoType
    @objc let username: String
    @objc let publicKeyData: Data
    
    @objc init(address: String, cryptoType: CryptoType, username: String, publicKeyData: Data) {
        self.address = address
        self.cryptoType = cryptoType
        self.username = username
        self.publicKeyData = publicKeyData
        super.init()
    }
    
    @objc func getHiddenAddress() -> String {
        return "0x" + address.prefix(9) + "..." + address.suffix(9)
    }
}
