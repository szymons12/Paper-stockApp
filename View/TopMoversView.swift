//
//  TopMoversView.swift
//  Paper-Stock
//
//  Created by Szymon on 18/08/2026.
//

import SwiftUI

struct TopMoversView: View {
    @StateObject private var viewModel = TopMoversViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                VStack(spacing: 0) {
                    Picker("", selection: $viewModel.mode) {
                        Text("Gainers").tag(TopMoversMode.gainers)
                        Text("Losers").tag(TopMoversMode.losers)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 8)

                    List(viewModel.stocks) { stock in
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
                                Text("\(stock.percentChange, specifier: "%.2f")%")
                                    .foregroundColor(stock.percentChange >= 0 ? .green : .red)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .frame(width: 300, height: 340)
        .task {
            await viewModel.loadTopMovers()
        }
    }
}

#Preview {
    TopMoversView()
}

