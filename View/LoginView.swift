//
//  LoginView.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: LoginViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Text("Zaloguj się")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(spacing: 12) {
                    TextField("E-mail", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    SecureField("Hasło", text: $viewModel.password)
                        .textContentType(.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button {
                    viewModel.login()
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Zaloguj się")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(viewModel.isLoading)
                .padding(.horizontal)

                NavigationLink("Nie masz konta? Zarejestruj się") {
                    RegisterView()
                }
                .font(.footnote)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
