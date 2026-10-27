//
//  WhoAmIView.swift
//  Paper-Stock
//
//  Created by Szymon on 11/08/2026.
//

import SwiftUI

struct WhoAmIView: View {
    @StateObject private var viewModel = WhoAmIViewModel()
    var body: some View {
        Text(viewModel.displayName)
            .foregroundColor(.black)
            .task {
               await viewModel.fetchCurrentUser()
            }}
}

#Preview {
    WhoAmIView()
}
