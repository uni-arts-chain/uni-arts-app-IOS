//
//  EthSubscribable.swift
//  CloudArtChain
//
//  Created by jielian on 2021/9/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

import Foundation

class EthSubscribable<T> {
    private var _value: T?
    private var _subscribers: [(T?) -> Void] = []
    open var value: T? {
        get {
            return _value
        }
        set {
            _value = newValue
            for f in _subscribers {
                f(value)
            }
        }
    }

    public init(_ value: T?) {
        _value = value
    }

    open func subscribe(_ subscribe: @escaping (T?) -> Void) {
        if let value = _value {
            subscribe(value)
        }
        _subscribers.append(subscribe)
    }
}
