//
//  ChangePasswordView.swift
//  Paper-Stock
//
//  Created by Szymon on 20/08/2026.
//

import SwiftUI

struct ChangePasswordView: View {
    @StateObject private var viewModel = ChangePasswordViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Zmień hasło")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 12) {
                SecureField("Stare hasło", text: $viewModel.oldPassword)
                    .textContentType(.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                SecureField("Nowe hasło", text: $viewModel.newPassword)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                SecureField("Powtórz nowe hasło", text: $viewModel.confirmPassword)
                    .textContentType(.newPassword)
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

            if viewModel.didSucceed {
                Text("Hasło zostało zmienione")
                    .foregroundColor(.green)
                    .font(.footnote)
            }

            Button {
                viewModel.changePassword()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Zmień hasło")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.isLoading)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ChangePasswordView()
}
