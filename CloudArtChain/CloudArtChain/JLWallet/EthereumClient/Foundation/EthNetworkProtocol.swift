//
//  EthNetworkProtocol.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import Moya
import TrustCore

protocol EthNetworkProtocol {
    var provider: MoyaProvider<EthServiceAPI> { get }
}
