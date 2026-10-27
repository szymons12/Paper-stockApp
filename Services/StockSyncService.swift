//
//  StockSyncService.swift
//  Paper-Stock
//
//  Created by Szymon on 15/08/2026.
//

import Foundation

enum StockSyncError: Error {
    case syncFailed
}

class StockSyncService {
    static let shared = StockSyncService()
    private init() {}

    func syncStocks() async throws {
        guard let url = URL(string: "\(Constants.baseUrl)/admin/stocks/sync") else {
            throw URLError(.badURL)
        }

        let token = try await AuthService.shared.validAccessToken()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw StockSyncError.syncFailed
        }
    }
    
    func FetchMostActive(top: Int = 10, logoSize: Int = 64) async throws -> [MostActiveResponse]{
        guard let url = URL(string: "\(Constants.baseUrl)/stocks/most-actives?top=\(top)&logoSize=\(logoSize)") else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        if let token = try? await AuthService.shared.validAccessToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print("Odpowiedź serwera (most-actives):", String(data: data, encoding: .utf8) ?? "brak")
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([MostActiveResponse].self, from: data)
    }
    
    func fetchTopMovers(top: Int = 10, logoSize: Int = 64) async throws -> TopMoversPageResponse {
        guard let url = URL(string: "\(Constants.baseUrl)/stocks/top-movers?top=\(top)&logoSize=\(logoSize)") else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        if let token = try? await AuthService.shared.validAccessToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        print("Odpowiedź serwera (top-movers):", String(data: data, encoding: .utf8) ?? "brak")
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(TopMoversPageResponse.self, from: data)
    }
}
