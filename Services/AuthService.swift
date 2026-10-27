//
//  AuthService.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import Foundation
import Combine

enum AuthError: Error {
    case invalidCredentials
    case sessionExpired
}

class AuthService {
    static let shared = AuthService()
    private init() {}

    private let store = TokenStore.shared

    private var refreshTask: Task<String, Error>?

    // MARK: - Register (bez zmian)

    func register(displayName: String, email: String, password: String) async throws -> RegisterResponse {
        guard let url = URL(string: "\(Constants.baseUrl)/auth/register") else {
            throw URLError(.badURL)
        }

        let body = RegisterRequest(displayName: displayName, email: email, password: password)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print("Odpowiedź serwera:", String(data: data, encoding: .utf8) ?? "brak")

        if let httpResponse = response as? HTTPURLResponse {
            print("Status code:", httpResponse.statusCode)
        }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(RegisterResponse.self, from: data)
    }

    // MARK: - Login

    func login(email: String, password: String) async throws -> LoginReponse {
        guard let url = URL(string: "\(Constants.baseUrl)/auth/login") else {
            throw URLError(.badURL)
        }

        let body = LoginRequest(email: email, password: password)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print("Odpowiedź serwera:", String(data: data, encoding: .utf8) ?? "brak")

        if let httpResponse = response as? HTTPURLResponse {
            print("Status code:", httpResponse.statusCode)
            if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                throw AuthError.invalidCredentials
            }
        }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(LoginReponse.self, from: data)
        store.save(response: decoded)

       
        Task {
            do {
                try await StockSyncService.shared.syncStocks()
            } catch {
                print("Post-login sync failed: \(error)")
            }
        }

        return decoded
    }

    // MARK: - Refresh

    @discardableResult
    func refreshAccessToken() async throws -> String {
        if let existing = refreshTask {
            return try await existing.value
        }

        let task = Task<String, Error> {
            guard let refreshToken = store.refreshToken, store.isRefreshTokenValid else {
                store.clear()
                throw AuthError.sessionExpired
            }

            guard let url = URL(string: "\(Constants.baseUrl)/auth/refresh") else {
                throw URLError(.badURL)
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(RefreshRequest(refreshToken: refreshToken))

            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            print("Odpowiedź serwera (refresh):", String(data: data, encoding: .utf8) ?? "brak")

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                store.clear()
                throw AuthError.sessionExpired
            }

            let decoded = try JSONDecoder().decode(LoginReponse.self, from: data)
            store.save(response: decoded)
            return decoded.accessToken
        }

        refreshTask = task
        defer { refreshTask = nil }
        return try await task.value
    }

    func validAccessToken() async throws -> String {
        if store.isAccessTokenValid, let token = store.accessToken {
            return token
        }
        return try await refreshAccessToken()
    }

    func logout() async {
        guard let refreshToken = store.refreshToken else {
            store.clear()
            return
        }

        if let url = URL(string: "\(Constants.baseUrl)/auth/logout") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONEncoder().encode(RefreshRequest(refreshToken: refreshToken))

            do {
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                print("Odpowiedź serwera (logout):", String(data: data, encoding: .utf8) ?? "brak")
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code:", httpResponse.statusCode)
                }
            } catch {
                print("Logout request failed: \(error)")
            }
        }

        store.clear()
    }
    
    func whoAmI() async throws -> WhoAmIResponse {
        guard let url = URL(string: "\(Constants.baseUrl)/auth/whoami") else {
            throw URLError(.badURL)
        }

        let token = try await validAccessToken()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print("Odpowiedź serwera (whoAmI):", String(data: data, encoding: .utf8) ?? "brak")

        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(WhoAmIResponse.self, from: data)
    }
    
    func changePassword(oldPassword: String, newPassword: String) async throws {
        guard let url = URL(string: "\(Constants.baseUrl)/auth/change-password") else {
            throw URLError(.badURL)
        }

        let token = try await validAccessToken()

        let body = ChangePasswordRequest(oldPassword: oldPassword, newPassword: newPassword)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print("Odpowiedź serwera (change-password):", String(data: data, encoding: .utf8) ?? "brak")

        if let httpResponse = response as? HTTPURLResponse {
            print("Status code:", httpResponse.statusCode)
            if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                throw AuthError.invalidCredentials
            }
        }
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
