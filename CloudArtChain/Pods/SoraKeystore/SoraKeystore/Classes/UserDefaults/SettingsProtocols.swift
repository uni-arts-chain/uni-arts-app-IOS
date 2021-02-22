/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

public protocol SettingsManagerProtocol {
    func set(value: Bool, for key: String)
    func set(value: Int, for key: String)
    func set(value: Double, for key: String)
    func set(value: String, for key: String)
    func set(value: Data, for key: String)
    func bool(for key: String) -> Bool?
    func integer(for key: String) -> Int?
    func double(for key: String) -> Double?
    func string(for key: String) -> String?
    func data(for key: String) -> Data?
    func removeValue(for key: String)
    func removeAll()
}

extension SettingsManagerProtocol {
    @discardableResult
    public func set<T: Encodable>(value: T, for key: String) -> Bool {
        guard let data = try? JSONEncoder().encode(value) else {
            return false
        }

        set(value: data, for: key)

        return true
    }

    public func value<T>(of type: T.Type, for key: String) -> T? where T: Decodable {
        guard let data = data(for: key) else {
            return nil
        }

        return try? JSONDecoder().decode(type, from: data)
    }
}
