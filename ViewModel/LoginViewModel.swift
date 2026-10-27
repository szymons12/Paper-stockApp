//
//  LoginViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    private let authService = AuthService.shared
    private var refreshTimer: Timer?

    init() {
        
        isAuthenticated = TokenStore.shared.isRefreshTokenValid
        if isAuthenticated {
            scheduleProactiveRefresh()
        }
    }

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Podaj e-mail i hasło"
            return
        }

        errorMessage = nil
        isLoading = true

        Task {
            defer { isLoading = false }
            do {
                _ = try await authService.login(email: email, password: password)
                isAuthenticated = true
                scheduleProactiveRefresh()
            } catch AuthError.invalidCredentials {
                errorMessage = "Nieprawidłowy e-mail lub hasło"
            } catch {
                print("Błąd logowania:", error)
                errorMessage = "Coś poszło nie tak, spróbuj ponownie"
            }
        }
    }

    func logout() {
        refreshTimer?.invalidate()
        refreshTimer = nil
        Task {
            await authService.logout()
            isAuthenticated = false
        }
    }

    private func scheduleProactiveRefresh() {
        refreshTimer?.invalidate()

        guard let expiry = TokenStore.shared.accessTokenExpiry else { return }
        let fireIn = max(expiry.timeIntervalSinceNow - 30, 5)

        refreshTimer = Timer.scheduledTimer(withTimeInterval: fireIn, repeats: false) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                do {
                    try await self.authService.refreshAccessToken()
                    self.scheduleProactiveRefresh()
                } catch {
                    print("Nie udało się odświeżyć tokena:", error)
                    self.refreshTimer?.invalidate()
                    self.isAuthenticated = false
                }
            }
        }
    }
}
