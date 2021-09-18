//
//  EthSigner.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import BigInt
import CryptoSwift
import TrustCore

protocol EthSigner {
    func hash(transaction: EthSignTransaction) -> Data
    func values(transaction: EthSignTransaction, signature: Data) -> (r: BigInt, s: BigInt, v: BigInt)
}

struct EIP155Signer: EthSigner {
    let chainId: BigInt

    init(chainId: BigInt) {
        self.chainId = chainId
    }

    func hash(transaction: EthSignTransaction) -> Data {
        return rlpHash([
            transaction.nonce,
            transaction.gasPrice,
            transaction.gasLimit,
            transaction.to?.data ?? Data(),
            transaction.value,
            transaction.data,
            transaction.chainID, 0, 0,
        ] as [Any])!
    }

    func values(transaction: EthSignTransaction, signature: Data) -> (r: BigInt, s: BigInt, v: BigInt) {
        let (r, s, v) = HomesteadSigner().values(transaction: transaction, signature: signature)
        let newV: BigInt
        if chainId != 0 {
            newV = BigInt(signature[64]) + 35 + chainId + chainId
        } else {
            newV = v
        }
        return (r, s, newV)
    }
}

struct HomesteadSigner: EthSigner {
    func hash(transaction: EthSignTransaction) -> Data {
        return rlpHash([
            transaction.nonce,
            transaction.gasPrice,
            transaction.gasLimit,
            transaction.to?.data ?? Data(),
            transaction.value,
            transaction.data,
        ])!
    }

    func values(transaction: EthSignTransaction, signature: Data) -> (r: BigInt, s: BigInt, v: BigInt) {
        precondition(signature.count == 65, "Wrong size for signature")
        let r = BigInt(sign: .plus, magnitude: BigUInt(Data(signature[..<32])))
        let s = BigInt(sign: .plus, magnitude: BigUInt(Data(signature[32..<64])))
        let v = BigInt(sign: .plus, magnitude: BigUInt(Data([signature[64] + 27])))
        return (r, s, v)
    }
}

func rlpHash(_ element: Any) -> Data? {
    let sha3 = SHA3(variant: .keccak256)
    guard let data = RLP.encode(element) else {
        return nil
    }
    return Data(sha3.calculate(for: data.bytes))
}
