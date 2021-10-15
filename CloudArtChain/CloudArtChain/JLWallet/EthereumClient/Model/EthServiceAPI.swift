//
//  EthServiceAPI.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation
import Moya

enum EthServiceAPI {
    case getBalance(address: String)
    case getTokenPrice(EthTokenPrice)
//    case getTransactions(server:EthRPCServer, address: String, startBlock: Int, page: Int, contract: String?, token: TokenObject)
//
//    case getAllTransactions(addresses: [String: String])
}

extension EthServiceAPI: TargetType {
    var baseURL: URL {
        return EthConstants.CLOUDARTCHAINAPI
    }
    
    var path: String {
        switch self {
        case .getBalance:
            return "/api/v1/balance"
        case .getTokenPrice:
            return "/api/v1/prices/exchange"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBalance:
            return .get
        case .getTokenPrice:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getBalance(let address):
            return .requestParameters(parameters: ["address": address], encoding: URLEncoding())
        case .getTokenPrice(let tokenPrice):
            return .requestParameters(parameters: ["codes": tokenPrice.symbol.lowercased()], encoding: URLEncoding())
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
//        if AppSingleton.sharedAppSingleton.haveToken() == true {
//            print("======" + self.path + ":" + (AppSingleton.sharedAppSingleton.getToken() ?? ""))
//            return [
//                "Content-type": "application/json",
//                "client": Bundle.main.bundleIdentifier ?? "",
//                "client-build": Bundle.main.buildNumber ?? "",
//                "Authorization": AppSingleton.sharedAppSingleton.getToken() ?? "",
//            ]
//        }
        return [
            "Content-type": "application/json",
            "client": Bundle.main.bundleIdentifier ?? "",
            "client-build": Bundle.main.buildNumber ?? "",
        ]
    }
}
