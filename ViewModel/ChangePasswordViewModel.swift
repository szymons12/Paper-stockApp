//
//  ChangePasswordViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 20/08/2026.
//

import Foundation
import Combine

@MainActor
final class ChangePasswordViewModel: ObservableObject {
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSucceed = false

    private let authService = AuthService.shared

    func changePassword() {
        guard !oldPassword.isEmpty, !newPassword.isEmpty else {
            errorMessage = "Uzupełnij oba pola hasła"
            return
        }
        guard newPassword == confirmPassword else {
            errorMessage = "Nowe hasła nie są identyczne"
            return
        }

        errorMessage = nil
        isLoading = true

        Task {
            defer { isLoading = false }
            do {
                try await authService.changePassword(oldPassword: oldPassword, newPassword: newPassword)
                didSucceed = true
                oldPassword = ""
                newPassword = ""
                confirmPassword = ""
            } catch AuthError.invalidCredentials {
                errorMessage = "Nieprawidłowe stare hasło"
            } catch {
                print("Błąd zmiany hasła:", error)
                errorMessage = "Coś poszło nie tak, spróbuj ponownie"
            }
        }
    }
}
