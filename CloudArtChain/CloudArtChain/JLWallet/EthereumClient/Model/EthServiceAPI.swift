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
    case getTokensPrice(EthTokensPrice)
//    case getTransactions(server:EthRPCServer, address: String, startBlock: Int, page: Int, contract: String?, token: TokenObject)
//
//    case getAllTransactions(addresses: [String: String])
}

extension EthServiceAPI: TargetType {
    var baseURL: URL {
        return EthConstants.QTSAPI
    }
    
    var path: String {
        switch self {
        case .getBalance:
            return "/api/v1/balance"
        case .getTokensPrice:
            return "/api/v1/prices"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBalance:
            return .get
        case .getTokensPrice:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getBalance(let address):
            return .requestParameters(parameters: ["address": address], encoding: URLEncoding())
        case .getTokensPrice(let tokensPrice):
            return .requestParameters(parameters: ["currency": tokensPrice.currency], encoding: URLEncoding())
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
