//
//  EthCurrency.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/3.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import UIKit

enum EthCurrency: String {
//    case AUD
//    case BRL
//    case CAD
//    case CHF
//    case CLP
    case CNY
//    case CZK
//    case DKK
//    case EUR
//    case GBP
//    case HKD
//    case HUF
//    case IDR
//    case ILS
//    case INR
//    case JPY
//    case KRW
//    case MXN
//    case MYR
//    case NOK
//    case NZD
//    case PHP
//    case PKR
//    case PLN
//    case RUB
//    case SEK
//    case SGD
//    case THB
//    case TRY
//    case TWD
//    case ZAR
    case USD

    static let allValues = [
        CNY,
        USD,
//        EUR,
//        GBP,
//        AUD,
//        RUB,
//        BRL,
//        CAD,
//        CHF,
//        CLP,
//        CNY,
//        CZK,
//        DKK,
//        HKD,
//        HUF,
//        IDR,
//        ILS,
//        INR,
//        JPY,
//        KRW,
//        MXN,
//        MYR,
//        NOK,
//        NZD,
//        PHP,
//        PKR,
//        PLN,
//        SEK,
//        SGD,
//        THB,
//        TRY,
//        TWD,
//        ZAR,
    ]

    var show: String {
        switch self {
        case .CNY:
            return "¥"
        case .USD:
            return "$"
        default:
            return "¥"
        }
    }

    init(value: String) {
        self =  EthCurrency(rawValue: value) ?? .CNY
    }
}

class CurrencyManager {
}

extension CurrencyManager {
    static func getSymbolForCurrencyCode(code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.identifier, value: code)
    }
}
