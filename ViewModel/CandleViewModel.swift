//
//  CandleViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 21/10/2026.
//

import Foundation
import Combine

@MainActor
class CandleViewModel: ObservableObject {
    @Published var candles: [CandleModel] = []
    @Published var selectedTimeframe: Timeframe = .day1
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let symbol: String
    private let service = CandleService()
    
    init(symbol: String){
        self.symbol = symbol
    }
    
    func loadCandles() async {
        isLoading = true
        errorMessage = nil
        defer {
            if !Task.isCancelled {isLoading = false}
        }
        
        do {
            let resault = try await service.getCandle(symbol: symbol, timeframe: selectedTimeframe)
            candles = resault.sorted { $0.t < $1.t}
        } catch is CancellationError {
            return
        } catch let urlError as URLError where urlError.code == .cancelled {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
