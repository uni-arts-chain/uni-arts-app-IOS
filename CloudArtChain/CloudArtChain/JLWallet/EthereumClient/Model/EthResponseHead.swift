//
//  EthResponseHead.swift
//  CloudArtChain
//
//  Created by jielian on 2021/10/12.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

final class EthResponseHead: Decodable {
    static let successCode: String = "1000"
    
    var code: String = ""
    var msg: String = ""

    convenience init(
        code: String = "",
        msg: String = ""
    ) {
        self.init()
        self.code = code
        self.msg = msg
    }

    enum CodingKeys: String, CodingKey {
        case code
        case msg
    }
}
