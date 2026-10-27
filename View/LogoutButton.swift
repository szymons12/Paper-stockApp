//
//  LogoutButton.swift
//  Paper-Stock
//
//  Created by Szymon on 20/08/2026.
//

import SwiftUI

struct LogoutButton: View {
    @EnvironmentObject private var viewModel: LoginViewModel

    var body: some View {
        Button("Wyloguj", role: .destructive) {
            viewModel.logout()
        }
    }
}
#Preview {
    LogoutButton()
}
