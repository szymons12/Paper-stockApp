//
//  MostActiveView.swift
//  Paper-Stock
//
//  Created by Szymon on 18/08/2026.
//

import SwiftUI

struct MostActiveView: View {
    @StateObject private var viewModel = MostActiveViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                List(viewModel.stocks.prefix(10)) { stock in
                    HStack {
                        AsyncImage(url: URL(string: stock.logoUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 32, height: 32)

                        VStack(alignment: .leading) {
                            Text(stock.symbol).bold()
                            Text(stock.name)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(stock.price, specifier: "%.2f")")
                            Text("\(stock.percentageChange, specifier: "%.2f")%")
                                .foregroundColor(stock.percentageChange >= 0 ? .green : .red)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .frame(width: 300, height: 300)
        .task {
            await viewModel.loadMostActives()
        }
    }
    
}

#Preview {
    MostActiveView()
}
