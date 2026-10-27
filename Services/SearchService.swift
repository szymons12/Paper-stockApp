//
//  SearchService.swift
//  Paper-Stock
//
//  Created by Szymon on 27/10/2026.
//

import Foundation

class SearchService {
    
    func getSearch(q: String, logoSize: Int = 64) async throws -> [SearchResponse] {
        guard var components = URLComponents(string: "\(Constants.baseUrl)/stocks/search/") else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "logoSize", value: String(logoSize))
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
                
        let token = try await AuthService.shared.validAccessToken()
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpReponse = response as? HTTPURLResponse,
              (200...299).contains(httpReponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        do {
            return try JSONDecoder().decode([SearchResponse].self, from: data)
        } catch {
            print(error)
            throw URLError(.cannotParseResponse)
        }
    }
}
