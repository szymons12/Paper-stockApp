//
//  MostActiveViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 18/08/2026.
//

import Foundation
import Combine
@MainActor

final class MostActiveViewModel: ObservableObject{
    @Published var stocks: [MostActiveResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: StockSyncService
    
    init(service: StockSyncService = .shared){
        self.service = service
    }
    func loadMostActives() async {
        isLoading = true
        errorMessage = nil
        
        do {
            stocks = try await service.FetchMostActive(top: 10, logoSize: 64)
        } catch {
            errorMessage = "NIe udało się pobrać danych"
        }
        isLoading = false
    }
}
