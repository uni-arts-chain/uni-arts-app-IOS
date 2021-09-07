//
//  EthConstants.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

public struct EthConstants {
    public static let keychainKeyPrefix = "JLGammaRayWallet"
    public static let keychainTestsKeyPrefix = "JLGammaRayWallet-tests"

    // social
    public static let website = "https://trustwalletapp.com"
    public static let twitterUsername = "trustwalletapp"
    public static let defaultTelegramUsername = "JLGammaRayWallet"
    public static let facebookUsername = "JLGammaRayWalletapp"

    public static var localizedTelegramUsernames = ["ru": "JLGammaRayWallet_ru", "vi": "JLGammaRayWallet_vn", "es": "JLGammaRayWallet_es", "zh": "JLGammaRayWallet_cn", "ja": "JLGammaRayWallet_jp", "de": "JLGammaRayWallet_de", "fr": "JLGammaRayWallet_fr"]

    // support
    public static let supportEmail = "support@trustwalletapp.com"

    public static let dappsBrowserURL = "https://dapps.trustwalletapp.com/"
    public static let dappsOpenSea = "https://opensea.io"
    public static let dappsRinkebyOpenSea = "https://rinkeby.opensea.io"

    public static let images = "https://trustwalletapp.com/images"

//    public static let trustAPI = URL(string: "https://public.trustwalletapp.com")!
    #if DEBUG
        public static let QTSAPI = URL(string: "https://thhcmall.top")!
        public static let QTSOTCAPI = URL(string: "https://otc.thhcmall.top")!
        public static let BitPriceAPI = "https://tatmas.vip/api/v2/quotes?"
    #else
        public static let QTSAPI = URL(string: "https://JLGammaRayWallet.cn")!
        public static let QTSOTCAPI = URL(string: "https://otc.thhcmall.top")!
        public static let BitPriceAPI = "https://tatmas.vip/api/v2/quotes?"
    #endif
}

public struct UnitConfiguration {
    public static let gasPriceUnit: EthereumUnit = .gwei
    public static let gasFeeUnit: EthereumUnit = .ether
}

public struct URLSchemes {
    public static let trust = "app://"
    public static let browser = trust + "browser"
}
