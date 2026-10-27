//
//  SearchResponse.swift
//  Paper-Stock
//
//  Created by Szymon on 27/10/2026.
//

import Foundation

struct SearchResponse: Decodable {
    let id: String
    let stockClass: String
    let exchange: String
    let symbol: String
    let name: String
    let status: String
    let tradable: Bool
    let logoUrl: String
}
