//
//  WhoAmIViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 11/08/2026.
//

import Foundation
import Combine

@MainActor
class WhoAmIViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authService: AuthService

       nonisolated init(authService: AuthService = AuthService.shared) {
           self.authService = authService
       }

       func fetchCurrentUser() async {
           isLoading = true
           errorMessage = nil

           do {
               let response = try await authService.whoAmI()
               displayName = response.displayName
           } catch {
               print("Błąd pobierania użytkownika:", error)
               errorMessage = "Nie udało się pobrać danych użytkownika."
           }

           isLoading = false
       }
   }
