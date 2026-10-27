//
//  RegisterView.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            Form{
                Section("Dane konta") {
                    TextField("Nazwa użytkownika", text: $viewModel.displayName)
                    
                    TextField("Email", text: $viewModel.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    SecureField("Hasło", text: $viewModel.password)
                }
                
                
                Section {
                    Button {
                        Task { await viewModel.register() }
                    } label: {
                        if  viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Zarejestruj się")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                if viewModel.isRegistered {
                    Section {
                        Label("Rejestracja udana!", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
                if let error = viewModel.errorMessage{
                    Section {
                        Label(error, systemImage: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                    
                }
                
            }.navigationTitle("Rejestracja")
        }
    }
}
