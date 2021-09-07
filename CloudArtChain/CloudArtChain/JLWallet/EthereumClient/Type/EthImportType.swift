//
//  EthImportType.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import TrustCore

enum EthImportType {
    case keystore(string: String, password: String)
    case privateKey(privateKey: String)
    case mnemonic(words: [String], password: String, derivationPath: DerivationPath)
    case address(address: EthereumAddress)
}
