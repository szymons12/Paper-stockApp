//
//  CandleService.swift
//  Paper-Stock
//
//  Created by Szymon on 21/10/2026.
//

import Foundation
import Combine

class CandleService {
    
    func getCandle(symbol: String, timeframe: Timeframe) async throws -> [CandleModel] {
        guard let url = URL(string: "\(Constants.baseUrl)/candles/\(symbol)?timeframe=\(timeframe.rawValue)") else {
            throw URLError(.badURL)
        }
        let token = try await AuthService.shared.validAccessToken()
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print("URL:", url)
        if let http = response as? HTTPURLResponse {
            print("Status:", http.statusCode)
        }
        print("Body:", String(data: data, encoding: .utf8) ?? "brak")
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode([CandleModel].self,from: data)
        } catch {
            throw URLError(.cannotParseResponse)
        }
    }
}
