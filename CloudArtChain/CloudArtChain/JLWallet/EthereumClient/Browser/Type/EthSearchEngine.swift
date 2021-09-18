//
//  EthSearchEngine.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

enum EthSearchEngine: Int {
    case google = 0
    case duckDuckGo

    static var `default`: EthSearchEngine {
        return .google
    }

    var title: String {
        switch self {
        case .google:
            return "google"
        case .duckDuckGo:
            return "duckDuckGo"
        }
    }

    var host: String {
        switch self {
        case .google:
            return "google.com"
        case .duckDuckGo:
            return "duckduckgo.com"
        }
    }

    func path(for query: String) -> String {
        switch self {
        case .google:
            return "/search"
        case .duckDuckGo:
            return "/\(query)"
        }
    }

    func queryItems(for query: String) -> [URLQueryItem] {
        switch self {
        case .google: return [URLQueryItem(name: "q", value: query)]
        case .duckDuckGo: return []
        }
    }
}
