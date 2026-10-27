//
//  SessionManager.swift
//  Paper-Stock
//
//  Created by Szymon on 20/08/2026.
//

import Foundation
import Combine

@MainActor
final class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool

    init() {
        isLoggedIn = TokenStore.shared.accessToken != nil
    }

    func markLoggedIn() {
        isLoggedIn = true
    }

    func markLoggedOut() {
        isLoggedIn = false
    }
}
