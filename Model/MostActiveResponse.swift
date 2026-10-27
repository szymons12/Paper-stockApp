//
//  MostActiveRequest.swift
//  Paper-Stock
//
//  Created by Szymon on 18/08/2026.
//

import Foundation

struct MostActiveResponse: Codable, Identifiable {
    let id: String
    let exchange: String
    let symbol: String
    let name: String
    let price: Double
    let percentageChange: Double
    let logoUrl: String
}
