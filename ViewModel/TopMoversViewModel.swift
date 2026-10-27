//
//  TopMoversViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 18/08/2026.
//

import Foundation
import Combine

enum TopMoversMode {
    case gainers
    case losers
}

@MainActor
final class TopMoversViewModel: ObservableObject {
    @Published var mode: TopMoversMode = .gainers
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var gainers: [TopMoversResponse] = []
    private var losers: [TopMoversResponse] = []

    var stocks: [TopMoversResponse] {
        switch mode {
        case .gainers: return gainers
        case .losers: return losers
        }
    }

    private let service: StockSyncService

    init(service: StockSyncService = .shared) {
        self.service = service
    }

    func loadTopMovers() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await service.fetchTopMovers(top: 10, logoSize: 64)
            gainers = Array(result.gainers.prefix(10))
            losers = Array(result.losers.prefix(10))
        } catch {
            errorMessage = "Nie udało się pobrać danych."
        }
        isLoading = false
    }
}
