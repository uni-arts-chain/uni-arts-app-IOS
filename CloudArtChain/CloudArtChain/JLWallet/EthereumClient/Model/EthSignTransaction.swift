//
//  EthSignTransaction.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt
import TrustCore
import TrustKeystore

public struct EthSignTransaction {
    let value: BigInt
    let account: Account
    let to: EthereumAddress?
    let nonce: BigInt
    let data: Data
    let gasPrice: BigInt
    let gasLimit: BigInt
    let chainID: Int

    // additinalData
    let localizedObject: EthLocalizedOperationObject?
}
