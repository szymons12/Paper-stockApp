//
//  TopMoversResponse.swift
//  Paper-Stock
//
//  Created by Szymon on 18/08/2026.
//

import Foundation

struct TopMoversResponse: Codable, Identifiable {

    var id: String { symbol }

    let exchange: String
    let symbol: String
    let name: String
    let price: Double
    let percentChange: Double
    let change: Double
    let logoUrl: String
}

struct TopMoversPageResponse: Codable {
    let gainers: [TopMoversResponse]
    let losers: [TopMoversResponse]
}
