//
//  RegisterViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import Foundation
import Combine

@MainActor

class RegisterViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isRegistered: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let authService: AuthService
    
    nonisolated init(authService: AuthService = AuthService.shared){
        self.authService = authService
    }
    
    func register() async{
        
        guard !email.isEmpty, !password.isEmpty, !displayName.isEmpty else {
            errorMessage = "Podaj wszystkie dane"
            return
        }
        errorMessage = nil
        isLoading = true
        do {
            _ = try await authService.register(
                displayName: displayName,
                email: email,
                password: password
            )
            isRegistered = true
        } catch {
            print("Błąd rejestracji:", error)
            errorMessage = "Błąd logowania. Sprawdź dane."
        }
        isLoading = false
    }
}
 
