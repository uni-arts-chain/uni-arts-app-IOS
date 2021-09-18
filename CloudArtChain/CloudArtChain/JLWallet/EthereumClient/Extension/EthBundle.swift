//
//  EthBundle.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/15.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

extension Bundle {
    var versionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }

    var buildNumberInt: Int {
        Int(Bundle.main.buildNumber ?? "-1") ?? -1
    }

    var fullVersion: String {
        "\(Bundle.main.versionNumber ?? "") (\(Bundle.main.buildNumber ?? ""))"
    }
    
    var appName: String {
        infoDictionary?["CFBundleDisplayName"] as? String ?? "--"
    }
}

var isDebug: Bool {
    #if DEBUG
        return true
    #else
        return false
    #endif
}
