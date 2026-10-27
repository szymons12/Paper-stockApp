//
//  TokenStore.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import Foundation
import Security

final class TokenStore {
    static let shared = TokenStore()
    private init() {}

    private let accessTokenKey  = "auth.accessToken"
    private let refreshTokenKey = "auth.refreshToken"
    private let accessExpiryKey  = "auth.accessExpiry"
    private let refreshExpiryKey = "auth.refreshExpiry"

    static let accessTokenLifetime: TimeInterval  = 15 * 60
    static let refreshTokenLifetime: TimeInterval = 7 * 24 * 60 * 60

    var accessToken: String?  { readKeychain(accessTokenKey) }
    var refreshToken: String? { readKeychain(refreshTokenKey) }

    var accessTokenExpiry: Date? {
        UserDefaults.standard.object(forKey: accessExpiryKey) as? Date
    }
    var refreshTokenExpiry: Date? {
        UserDefaults.standard.object(forKey: refreshExpiryKey) as? Date
    }

    var isAccessTokenValid: Bool {
        guard let expiry = accessTokenExpiry else { return false }
        return Date() < expiry.addingTimeInterval(-5)
    }

    var isRefreshTokenValid: Bool {
        guard let expiry = refreshTokenExpiry else { return false }
        return Date() < expiry
    }

    func save(response: LoginReponse) {
        writeKeychain(accessTokenKey, value: response.accessToken)
        writeKeychain(refreshTokenKey, value: response.refreshToken)
        let now = Date()
        UserDefaults.standard.set(now.addingTimeInterval(Self.accessTokenLifetime), forKey: accessExpiryKey)
        UserDefaults.standard.set(now.addingTimeInterval(Self.refreshTokenLifetime), forKey: refreshExpiryKey)
    }

    func updateAccessToken(_ token: String) {
        writeKeychain(accessTokenKey, value: token)
        UserDefaults.standard.set(Date().addingTimeInterval(Self.accessTokenLifetime), forKey: accessExpiryKey)
    }

    func clear() {
        deleteKeychain(accessTokenKey)
        deleteKeychain(refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: accessExpiryKey)
        UserDefaults.standard.removeObject(forKey: refreshExpiryKey)
    }

    // MARK: - Keychain helpers

    private func writeKeychain(_ key: String, value: String) {
        let data = Data(value.utf8)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrAccount as String: key]
        SecItemDelete(query as CFDictionary)
        var attributes = query
        attributes[kSecValueData as String] = data
        SecItemAdd(attributes as CFDictionary, nil)
    }

    private func readKeychain(_ key: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrAccount as String: key,
                                     kSecReturnData as String: true,
                                     kSecMatchLimit as String: kSecMatchLimitOne]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func deleteKeychain(_ key: String) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrAccount as String: key]
        SecItemDelete(query as CFDictionary)
    }
}
