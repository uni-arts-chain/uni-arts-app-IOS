//
//  EthProviderFactory.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import Alamofire
import Moya

struct EthProviderFactory {
    static func makeProvider() -> MoyaProvider<EthServiceAPI> {
        return MoyaProvider<EthServiceAPI>()
    }
}

