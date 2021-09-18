//
//  EthCastError.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

struct EthCastError<ExpectedType>: Error {
    let actualValue: Any
    let expectedType: ExpectedType.Type
}
