/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation

public final class InMemorySettingsManager: SettingsManagerProtocol {
    private var settings: [String: Any] = [:]

    public init() {}

    public func set(value: Bool, for key: String) {
        settings[key] = value
    }

    public func bool(for key: String) -> Bool? {
        return settings[key] as? Bool
    }

    public func set(value: Int, for key: String) {
        settings[key] = value
    }

    public func integer(for key: String) -> Int? {
        return settings[key] as? Int
    }

    public func set(value: Double, for key: String) {
        settings[key] = value
    }

    public func double(for key: String) -> Double? {
        return settings[key] as? Double
    }

    public func set(value: String, for key: String) {
        settings[key] = value
    }

    public func string(for key: String) -> String? {
        return settings[key] as? String
    }

    public func set(value: Data, for key: String) {
        settings[key] = value
    }

    public func data(for key: String) -> Data? {
        return settings[key] as? Data
    }

    public func removeValue(for key: String) {
        settings[key] = nil
    }

    public func removeAll() {
        settings.removeAll()
    }
}
